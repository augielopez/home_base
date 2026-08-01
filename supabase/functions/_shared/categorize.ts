// @ts-nocheck
// Shared keyword categorization against hb_categorization_rules.

export type CategorizationRule = {
  id: string;
  user_id: string | null;
  rule_name: string;
  rule_type: string;
  rule_conditions: Record<string, unknown> | null;
  category_id: string;
  priority: number | null;
  is_active: boolean;
  created_by?: string | null;
};

export type CategorizeResult = {
  examined: number;
  updated: number;
  skipped: number;
};

function asStringArray(value: unknown): string[] {
  if (!Array.isArray(value)) return [];
  return value.map((item) => String(item || "").trim()).filter(Boolean);
}

function keywordsForRule(rule: CategorizationRule): string[] {
  const conditions = (rule.rule_conditions || {}) as Record<string, unknown>;
  const fromConditions = [
    ...asStringArray(conditions.keywords),
    ...asStringArray(conditions.patterns),
    ...asStringArray(conditions.terms),
  ];

  if (fromConditions.length) return fromConditions;

  // Legacy rows often have empty rule_conditions; fall back to rule_name.
  return rule.rule_name ? [String(rule.rule_name)] : [];
}

function fieldsForRule(rule: CategorizationRule): string[] {
  const conditions = (rule.rule_conditions || {}) as Record<string, unknown>;
  const fields = asStringArray(conditions.fields);
  if (fields.length) return fields.map((field) => field.toLowerCase());
  return ["description", "name", "merchant_name", "payee"];
}

function transactionHaystack(transaction: Record<string, unknown>, fields: string[]): string {
  const parts: string[] = [];
  for (const field of fields) {
    if (field === "payee") {
      parts.push(String(transaction.merchant_name || transaction.payee || ""));
      continue;
    }
    parts.push(String(transaction[field] || ""));
  }
  return parts.join(" ").toUpperCase();
}

function ruleMatches(rule: CategorizationRule, transaction: Record<string, unknown>): boolean {
  if (String(rule.rule_type || "").toLowerCase() !== "keyword") return false;

  const keywords = keywordsForRule(rule);
  if (!keywords.length) return false;

  const haystack = transactionHaystack(transaction, fieldsForRule(rule));
  return keywords.some((keyword) => haystack.includes(keyword.toUpperCase()));
}

function shouldCategorizeTransaction(transaction: Record<string, unknown>): boolean {
  const matchMethod = String(transaction.category_match_method || "unmatched").toLowerCase();
  if (matchMethod === "manual" || matchMethod === "ai") return false;

  const categoryId = transaction.category_id;
  if (!categoryId) return true;
  return matchMethod === "unmatched" || matchMethod === "auto";
}

function ruleAppliesToUser(rule: CategorizationRule, userId: string): boolean {
  if (!rule.is_active) return false;
  if (String(rule.created_by || "").toUpperCase() === "SYSTEM") return true;
  if (!rule.user_id) return true;
  return String(rule.user_id) === String(userId);
}

export async function applyCategorizationRules(supabase: any, userId: string): Promise<CategorizeResult> {
  const { data: rulesData, error: rulesError } = await supabase
    .from("hb_categorization_rules")
    .select("id, user_id, rule_name, rule_type, rule_conditions, category_id, priority, is_active, created_by")
    .eq("is_active", true)
    .order("priority", { ascending: true });

  if (rulesError) throw rulesError;

  const rules = ((rulesData || []) as CategorizationRule[]).filter((rule) => ruleAppliesToUser(rule, userId));
  if (!rules.length) {
    return { examined: 0, updated: 0, skipped: 0 };
  }

  const { data: transactions, error: txError } = await supabase
    .from("hb_transactions")
    .select("id, name, description, merchant_name, category_id, category_match_method")
    .eq("user_id", userId)
    .eq("import_method", "simplefin")
    .order("date", { ascending: false })
    .limit(1000);

  if (txError) throw txError;

  let examined = 0;
  let updated = 0;
  let skipped = 0;

  for (const transaction of transactions || []) {
    examined += 1;
    if (!shouldCategorizeTransaction(transaction)) {
      skipped += 1;
      continue;
    }

    const matched = rules.find((rule) => ruleMatches(rule, transaction));
    if (!matched) {
      skipped += 1;
      continue;
    }

    if (
      String(transaction.category_id || "") === String(matched.category_id) &&
      String(transaction.category_match_method || "") === "auto"
    ) {
      skipped += 1;
      continue;
    }

    const { error: updateError } = await supabase
      .from("hb_transactions")
      .update({
        category_id: matched.category_id,
        category_match_method: "auto",
        category_confidence: 0.9,
      })
      .eq("id", transaction.id)
      .eq("user_id", userId);

    if (updateError) throw updateError;
    updated += 1;
  }

  return { examined, updated, skipped };
}
