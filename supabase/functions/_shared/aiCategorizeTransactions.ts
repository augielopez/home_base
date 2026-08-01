// @ts-nocheck
// Apply AI classification to uncategorized SimpleFIN transactions.
import {
  classifyItemsAgainstCatalog,
  passesConfidence,
  DEFAULT_MIN_CONFIDENCE,
  type AiCatalogItem,
  type AiClassifiableItem,
} from "./aiClassify.ts";

export type AiCategorizeResult = {
  examined: number;
  updated: number;
  skipped: number;
  lowConfidence: number;
};

function transactionText(transaction: Record<string, unknown>) {
  return [transaction.description, transaction.name, transaction.merchant_name]
    .map((part) => String(part || "").trim())
    .filter(Boolean)
    .join(" | ");
}

export async function applyAiTransactionCategorization(
  supabase: any,
  userId: string,
  options: { limit?: number; minConfidence?: number } = {}
): Promise<AiCategorizeResult> {
  const limit = options.limit || 60;
  const minConfidence = options.minConfidence ?? DEFAULT_MIN_CONFIDENCE;

  const { data: categories, error: categoryError } = await supabase
    .from("hb_transaction_categories")
    .select("id, name, description")
    .eq("is_active", true)
    .order("name", { ascending: true });

  if (categoryError) throw categoryError;

  const catalog = (categories || []) as AiCatalogItem[];
  if (!catalog.length) {
    return { examined: 0, updated: 0, skipped: 0, lowConfidence: 0 };
  }

  const { data: transactions, error: txError } = await supabase
    .from("hb_transactions")
    .select("id, name, description, merchant_name, amount, category_id, category_match_method")
    .eq("user_id", userId)
    .eq("import_method", "simplefin")
    .is("category_id", null)
    .order("date", { ascending: false })
    .limit(limit);

  if (txError) throw txError;

  const candidates = (transactions || []).filter((row) => {
    const method = String(row.category_match_method || "unmatched").toLowerCase();
    return method !== "manual" && method !== "ai";
  });

  if (!candidates.length) {
    return { examined: 0, updated: 0, skipped: 0, lowConfidence: 0 };
  }

  const items: AiClassifiableItem[] = candidates.map((row) => ({
    id: String(row.id),
    text: transactionText(row),
    amount: row.amount == null ? null : Number(row.amount),
  }));

  const classifications = await classifyItemsAgainstCatalog(items, catalog, {
    domain: "transactions",
    minConfidence,
  });

  const byId = new Map(classifications.map((row) => [row.id, row]));
  let updated = 0;
  let skipped = 0;
  let lowConfidence = 0;

  for (const item of items) {
    const classification = byId.get(item.id);
    if (!classification) {
      skipped += 1;
      continue;
    }

    if (!passesConfidence(classification, minConfidence)) {
      lowConfidence += 1;
      skipped += 1;
      continue;
    }

    const { error: updateError } = await supabase
      .from("hb_transactions")
      .update({
        category_id: classification.categoryId,
        category_match_method: "ai",
        category_confidence: classification.confidence,
      })
      .eq("id", item.id)
      .eq("user_id", userId)
      .is("category_id", null);

    if (updateError) throw updateError;
    updated += 1;
  }

  return {
    examined: items.length,
    updated,
    skipped,
    lowConfidence,
  };
}
