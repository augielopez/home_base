// @ts-nocheck
// Reusable AI classification against a category catalog.
// Used by transaction categorization now; Bills Recon can call the same helper later.

export type AiCatalogItem = {
  id: string;
  name: string;
  description?: string | null;
};

export type AiClassifiableItem = {
  id: string;
  text: string;
  amount?: number | null;
  extra?: Record<string, unknown>;
};

export type AiClassification = {
  id: string;
  categoryId: string | null;
  confidence: number;
  reason?: string | null;
};

export type AiClassifyOptions = {
  domain: "transactions" | "bills-recon";
  minConfidence?: number;
  model?: string;
  batchSize?: number;
};

const DEFAULT_MIN_CONFIDENCE = 0.7;
const DEFAULT_BATCH_SIZE = 20;

function domainInstructions(domain: AiClassifyOptions["domain"]) {
  if (domain === "bills-recon") {
    return "Classify each bill-related item into the best matching category from the catalog. Prefer null when unsure.";
  }
  return "Classify each bank transaction into the best matching category from the catalog. Prefer null when unsure.";
}

async function classifyBatch(
  items: AiClassifiableItem[],
  catalog: AiCatalogItem[],
  options: AiClassifyOptions,
  apiKey: string
): Promise<AiClassification[]> {
  const model = options.model || Deno.env.get("OPENAI_MODEL") || "gpt-4o-mini";
  const catalogPayload = catalog.map((item) => ({
    id: item.id,
    name: item.name,
    description: item.description || undefined,
  }));

  const itemPayload = items.map((item) => ({
    id: item.id,
    text: item.text,
    amount: item.amount ?? undefined,
  }));

  const response = await fetch("https://api.openai.com/v1/chat/completions", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${apiKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model,
      temperature: 0,
      response_format: { type: "json_object" },
      messages: [
        {
          role: "system",
          content: [
            "You are a precise financial classifier.",
            domainInstructions(options.domain),
            "Only choose category ids from the provided catalog.",
            "Return JSON: {\"results\":[{\"id\":\"...\",\"categoryId\":\"uuid-or-null\",\"confidence\":0.0,\"reason\":\"short\"}]}",
            "confidence must be between 0 and 1.",
            "If no category fits confidently, set categoryId to null and confidence <= 0.4.",
          ].join(" "),
        },
        {
          role: "user",
          content: JSON.stringify({ catalog: catalogPayload, items: itemPayload }),
        },
      ],
    }),
  });

  if (!response.ok) {
    const body = await response.text();
    throw new Error(`OpenAI request failed (${response.status}): ${body.slice(0, 300)}`);
  }

  const payload = await response.json();
  const content = payload?.choices?.[0]?.message?.content;
  if (!content) throw new Error("OpenAI returned an empty classification response");

  let parsed: Record<string, unknown>;
  try {
    parsed = JSON.parse(content);
  } catch {
    throw new Error("OpenAI returned invalid JSON");
  }

  const results = Array.isArray(parsed.results) ? parsed.results : [];
  const catalogIds = new Set(catalog.map((item) => item.id));

  return results.map((row) => {
    const record = row && typeof row === "object" ? (row as Record<string, unknown>) : {};
    const id = String(record.id || "");
    const rawCategoryId = record.categoryId === null || record.categoryId === "" ? null : String(record.categoryId || "");
    const categoryId = rawCategoryId && catalogIds.has(rawCategoryId) ? rawCategoryId : null;
    const confidence = Number(record.confidence);
    return {
      id,
      categoryId,
      confidence: Number.isFinite(confidence) ? Math.max(0, Math.min(1, confidence)) : 0,
      reason: record.reason ? String(record.reason) : null,
    } as AiClassification;
  }).filter((row) => row.id);
}

export async function classifyItemsAgainstCatalog(
  items: AiClassifiableItem[],
  catalog: AiCatalogItem[],
  options: AiClassifyOptions
): Promise<AiClassification[]> {
  const apiKey = Deno.env.get("OPENAI_API_KEY");
  if (!apiKey) {
    throw new Error("OPENAI_API_KEY is not configured. Set it with: supabase secrets set OPENAI_API_KEY=...");
  }

  if (!items.length || !catalog.length) return [];

  const batchSize = options.batchSize || DEFAULT_BATCH_SIZE;
  const all: AiClassification[] = [];

  for (let i = 0; i < items.length; i += batchSize) {
    const batch = items.slice(i, i + batchSize);
    const classified = await classifyBatch(batch, catalog, options, apiKey);
    all.push(...classified);
  }

  return all;
}

export function passesConfidence(classification: AiClassification, minConfidence = DEFAULT_MIN_CONFIDENCE) {
  return Boolean(classification.categoryId) && classification.confidence >= minConfidence;
}

export { DEFAULT_MIN_CONFIDENCE };
