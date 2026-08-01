// @ts-nocheck
// Deterministic bill matching suggestions from description + history.
// AI is intentionally separate and optional.

export type BillCandidate = {
  id: string;
  bill_name: string | null;
  amount_due: number | null;
  due_date: string | null;
  status: string | null;
};

export type TxCandidate = {
  id: string;
  name?: string | null;
  description?: string | null;
  merchant_name?: string | null;
  amount: number;
  date: string;
};

export type HistoryHint = {
  bill_id: string;
  key: string;
  count: number;
};

export type BillMatchSuggestion = {
  bill_id: string;
  bill_name: string;
  confidence: number;
  reasons: string[];
};

const HIGH_CONFIDENCE = 85;
const EXCLUDED_BILL_ID = "00000000-0000-0000-0000-000000000001";

function isExcludedSentinelBill(bill: Record<string, unknown>) {
  const id = String(bill.id || "");
  const name = String(bill.bill_name || "").toLowerCase();
  return id === EXCLUDED_BILL_ID || name.includes("excluded - not a bill");
}

function normalizeText(value: unknown) {
  return String(value || "")
    .toUpperCase()
    .replace(/[^A-Z0-9\s]/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function tokens(value: string) {
  return value
    .split(" ")
    .map((part) => part.trim())
    .filter((part) => part.length >= 3);
}

export function transactionTextKey(tx: TxCandidate) {
  return normalizeText([tx.merchant_name, tx.description, tx.name].filter(Boolean).join(" "));
}

function amountCloseness(txAmount: number, billAmount: number | null) {
  if (billAmount == null || !Number.isFinite(billAmount) || billAmount === 0) return 0;
  const absTx = Math.abs(Number(txAmount) || 0);
  const absBill = Math.abs(Number(billAmount) || 0);
  const diff = Math.abs(absTx - absBill);
  const ratio = diff / absBill;
  if (ratio <= 0.02) return 20;
  if (ratio <= 0.08) return 12;
  if (ratio <= 0.15) return 6;
  return 0;
}

function dueDateBonus(txDate: string, dueDate: string | null) {
  if (!dueDate) return 0;
  const dayMatch = String(dueDate).match(/(\d{1,2})(st|nd|rd|th)?/i);
  if (!dayMatch) return 0;
  const dueDay = Number(dayMatch[1]);
  if (!Number.isFinite(dueDay) || dueDay < 1 || dueDay > 31) return 0;
  const txDay = Number(String(txDate).slice(8, 10));
  if (!Number.isFinite(txDay)) return 0;
  const diff = Math.abs(txDay - dueDay);
  if (diff === 0) return 8;
  if (diff <= 2) return 4;
  if (diff <= 5) return 2;
  return 0;
}

function nameScore(txKey: string, billName: string) {
  const billKey = normalizeText(billName);
  if (!txKey || !billKey) return { score: 0, reasons: [] as string[] };

  if (txKey.includes(billKey) || billKey.includes(txKey)) {
    return { score: 70, reasons: ["description contains bill name"] };
  }

  const txTokens = new Set(tokens(txKey));
  const billTokens = tokens(billKey);
  if (!billTokens.length) return { score: 0, reasons: [] };

  const overlap = billTokens.filter((token) => txTokens.has(token));
  if (!overlap.length) return { score: 0, reasons: [] };

  const ratio = overlap.length / billTokens.length;
  if (ratio >= 0.75) return { score: 55, reasons: [`strong name overlap (${overlap.join(", ")})`] };
  if (ratio >= 0.5) return { score: 40, reasons: [`name overlap (${overlap.join(", ")})`] };
  if (ratio >= 0.3) return { score: 25, reasons: [`partial name overlap (${overlap.join(", ")})`] };
  return { score: 0, reasons: [] };
}

export function scoreBillForTransaction(
  tx: TxCandidate,
  bill: BillCandidate,
  historyHints: HistoryHint[] = []
): BillMatchSuggestion | null {
  const txKey = transactionTextKey(tx);
  const named = nameScore(txKey, String(bill.bill_name || ""));
  let confidence = named.score;
  const reasons = [...named.reasons];

  const amountBonus = amountCloseness(tx.amount, bill.amount_due == null ? null : Number(bill.amount_due));
  if (amountBonus) {
    confidence += amountBonus;
    reasons.push("amount close to bill");
  }

  const dueBonus = dueDateBonus(tx.date, bill.due_date);
  if (dueBonus) {
    confidence += dueBonus;
    reasons.push("due-date proximity");
  }

  const history = historyHints.find((hint) => hint.bill_id === bill.id && hint.key && txKey.includes(hint.key));
  if (history) {
    const boost = Math.min(25, 10 + history.count * 3);
    confidence += boost;
    reasons.push(`prior matches (${history.count})`);
  } else {
    // Also boost when history key matches any significant bill token already scored.
    const exact = historyHints.find((hint) => hint.bill_id === bill.id && hint.key === txKey);
    if (exact) {
      confidence += Math.min(25, 10 + exact.count * 3);
      reasons.push(`exact prior match (${exact.count})`);
    }
  }

  confidence = Math.max(0, Math.min(99, Math.round(confidence)));
  if (confidence < 25 || !reasons.length) return null;

  return {
    bill_id: bill.id,
    bill_name: String(bill.bill_name || "Untitled bill"),
    confidence,
    reasons,
  };
}

export function bestSuggestionForTransaction(
  tx: TxCandidate,
  bills: BillCandidate[],
  historyHints: HistoryHint[] = []
): BillMatchSuggestion | null {
  let best: BillMatchSuggestion | null = null;
  for (const bill of bills) {
    const suggestion = scoreBillForTransaction(tx, bill, historyHints);
    if (!suggestion) continue;
    if (!best || suggestion.confidence > best.confidence) best = suggestion;
  }
  return best;
}

export function buildHistoryHints(rows: Array<{ bill_id: string; name?: string | null; description?: string | null; merchant_name?: string | null }>) {
  const counts = new Map<string, { bill_id: string; key: string; count: number }>();

  for (const row of rows) {
    if (!row.bill_id || row.bill_id === EXCLUDED_BILL_ID) continue;
    const key = transactionTextKey(row as TxCandidate);
    if (!key || key.length < 4) continue;
    // Prefer a compact merchant/payee key when available.
    const merchantKey = normalizeText(row.merchant_name || "");
    const useKey = merchantKey.length >= 4 ? merchantKey : key;
    const mapKey = `${row.bill_id}::${useKey}`;
    const existing = counts.get(mapKey);
    if (existing) existing.count += 1;
    else counts.set(mapKey, { bill_id: row.bill_id, key: useKey, count: 1 });
  }

  return Array.from(counts.values()).filter((row) => row.count >= 1);
}

export { HIGH_CONFIDENCE, EXCLUDED_BILL_ID, isExcludedSentinelBill };
