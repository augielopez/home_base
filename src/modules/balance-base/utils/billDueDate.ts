import type { Bill, ReconTransaction } from '../types/balanceBase.types';

/** Sentinel bill used to mark excluded transactions — never show in calendar/lists. */
export const EXCLUDED_BILL_ID = '00000000-0000-0000-0000-000000000001';

export function isExcludedSentinelBill(bill: Pick<Bill, 'id' | 'bill_name'> | { id?: string | null; bill_name?: string | null }) {
    const id = String(bill.id || '');
    const name = String(bill.bill_name || '').toLowerCase();
    return id === EXCLUDED_BILL_ID || name.includes('excluded - not a bill');
}

export type BillDuePlacement = {
    month: number | null; // 1-12, or null = every month in the viewed year
    day: number; // 1-31
};

export type CalendarBillStatus = 'paid' | 'amber' | 'unpaid';

export type CalendarBillItem = {
    bill: Bill;
    day: number;
    paid: boolean;
    status: CalendarBillStatus;
    matchedAmount: number;
    warnings: string[];
};

const AMOUNT_TOLERANCE_RATIO = 0.1; // ±10% of amount_due
const DATE_TOLERANCE_DAYS = 5;

const MONTH_NAMES: Record<string, number> = {
    january: 1,
    jan: 1,
    february: 2,
    feb: 2,
    march: 3,
    mar: 3,
    april: 4,
    apr: 4,
    may: 5,
    june: 6,
    jun: 6,
    july: 7,
    jul: 7,
    august: 8,
    aug: 8,
    september: 9,
    sep: 9,
    sept: 9,
    october: 10,
    oct: 10,
    november: 11,
    nov: 11,
    december: 12,
    dec: 12
};

function clampDay(day: number, year: number, month: number) {
    const lastDay = new Date(year, month, 0).getDate();
    return Math.max(1, Math.min(day, lastDay));
}

function parseDayToken(token: string): number | null {
    const cleaned = token.trim().toLowerCase();
    const match = cleaned.match(/^(\d{1,2})(st|nd|rd|th)?$/);
    if (!match) return null;
    const day = Number(match[1]);
    if (!Number.isFinite(day) || day < 1 || day > 31) return null;
    return day;
}

/**
 * Parse free-text due_date values into calendar placements.
 * - "April" / "November" → 1st of that month
 * - "April, December" → 1st of each named month
 * - "29th" / "01" → that day every month
 * - "1st, 15th" → those days every month
 * - "January 1st" / "Feb 25" → that month + day
 * - ISO / slash dates → month + day (year-agnostic for recurring display)
 */
export function parseBillDuePlacements(dueDate: string | null | undefined): BillDuePlacement[] {
    if (!dueDate || !String(dueDate).trim()) return [];

    const raw = String(dueDate).trim();
    const lower = raw.toLowerCase();

    // Skip vague schedules for v1.
    if (/every\s+(monday|tuesday|wednesday|thursday|friday|saturday|sunday)/i.test(lower)) {
        return [];
    }

    // ISO yyyy-mm-dd
    const iso = lower.match(/^(\d{4})-(\d{2})-(\d{2})$/);
    if (iso) {
        return [{ month: Number(iso[2]), day: Number(iso[3]) }];
    }

    // mm/dd/yyyy or m/d/yyyy
    const slash = lower.match(/^(\d{1,2})\/(\d{1,2})\/(\d{2,4})$/);
    if (slash) {
        return [{ month: Number(slash[1]), day: Number(slash[2]) }];
    }

    // Split on commas for multi values: "April, December" or "1st, 15th"
    const parts = raw.split(',').map((part) => part.trim()).filter(Boolean);
    const placements: BillDuePlacement[] = [];

    for (const part of parts) {
        const partLower = part.toLowerCase();

        // "January 1st" / "Feb 25"
        const monthDay = partLower.match(
            /^(january|jan|february|feb|march|mar|april|apr|may|june|jun|july|jul|august|aug|september|sep|sept|october|oct|november|nov|december|dec)\s+(\d{1,2})(st|nd|rd|th)?$/
        );
        if (monthDay) {
            placements.push({ month: MONTH_NAMES[monthDay[1]], day: Number(monthDay[2]) });
            continue;
        }

        // Month name only → 1st of that month
        const monthOnly = partLower.match(
            /^(january|jan|february|feb|march|mar|april|apr|may|june|jun|july|jul|august|aug|september|sep|sept|october|oct|november|nov|december|dec)$/
        );
        if (monthOnly) {
            placements.push({ month: MONTH_NAMES[monthOnly[1]], day: 1 });
            continue;
        }

        // Day only: "29th", "01", "1st"
        const day = parseDayToken(part);
        if (day != null) {
            placements.push({ month: null, day });
        }
    }

    return placements;
}

export function billDaysInMonth(bill: Bill, year: number, month: number): number[] {
    const placements = parseBillDuePlacements(bill.due_date);
    const days = new Set<number>();

    for (const placement of placements) {
        if (placement.month != null && placement.month !== month) continue;
        days.add(clampDay(placement.day, year, month));
    }

    return Array.from(days).sort((a, b) => a - b);
}

function parseTxDay(date: string): number | null {
    if (!date) return null;
    const day = Number(String(date).slice(8, 10));
    return Number.isFinite(day) ? day : null;
}

function amountWithinRange(matchedAmount: number, amountDue: number | null): boolean {
    if (amountDue == null || !Number.isFinite(amountDue) || amountDue === 0) return true;
    const due = Math.abs(Number(amountDue));
    const paid = Math.abs(Number(matchedAmount) || 0);
    const tolerance = Math.max(due * AMOUNT_TOLERANCE_RATIO, 1);
    return Math.abs(paid - due) <= tolerance;
}

function dateWithinTolerance(txDay: number | null, dueDay: number): boolean {
    if (txDay == null) return false;
    return Math.abs(txDay - dueDay) <= DATE_TOLERANCE_DAYS;
}

function evaluateBillStatus(opts: {
    bill: Bill;
    dueDay: number | null;
    matchedRows: ReconTransaction[];
}): Pick<CalendarBillItem, 'paid' | 'status' | 'matchedAmount' | 'warnings'> {
    const matchedAmount = opts.matchedRows.reduce((sum, row) => sum + Math.abs(Number(row.amount) || 0), 0);
    const paid = opts.matchedRows.length > 0;

    if (!paid) {
        return { paid: false, status: 'unpaid', matchedAmount: 0, warnings: [] };
    }

    const warnings: string[] = [];
    const amountOk = amountWithinRange(matchedAmount, opts.bill.amount_due);
    if (!amountOk) {
        warnings.push('amount outside ±10% of bill due');
    }

    let dateOk = true;
    if (opts.dueDay != null && opts.dueDay > 0) {
        dateOk = opts.matchedRows.some((row) => dateWithinTolerance(parseTxDay(row.date), opts.dueDay as number));
        if (!dateOk) {
            warnings.push(`payment date outside ±${DATE_TOLERANCE_DAYS} days of due day`);
        }
    }

    if (amountOk && dateOk) {
        return { paid: true, status: 'paid', matchedAmount, warnings: [] };
    }

    return { paid: true, status: 'amber', matchedAmount, warnings };
}

export function buildCalendarBillItems(
    bills: Bill[],
    matched: ReconTransaction[],
    year: number,
    month: number
): { byDay: Record<number, CalendarBillItem[]>; unscheduled: CalendarBillItem[] } {
    const matchedByBill = new Map<string, ReconTransaction[]>();
    for (const row of matched) {
        if (!row.bill_id) continue;
        const list = matchedByBill.get(row.bill_id) || [];
        list.push(row);
        matchedByBill.set(row.bill_id, list);
    }

    const byDay: Record<number, CalendarBillItem[]> = {};
    const unscheduled: CalendarBillItem[] = [];

    for (const bill of bills) {
        if (isExcludedSentinelBill(bill)) continue;
        if (String(bill.status || '').toLowerCase() !== 'active') continue;

        const matchedRows = matchedByBill.get(bill.id) || [];
        const days = billDaysInMonth(bill, year, month);

        if (!days.length) {
            const placements = parseBillDuePlacements(bill.due_date);
            const onlyOtherMonths = placements.length > 0 && placements.every((p) => p.month != null && p.month !== month);
            if (!onlyOtherMonths) {
                const evaluated = evaluateBillStatus({ bill, dueDay: null, matchedRows });
                unscheduled.push({ bill, day: 0, ...evaluated });
            }
            continue;
        }

        for (const day of days) {
            if (!byDay[day]) byDay[day] = [];
            const evaluated = evaluateBillStatus({ bill, dueDay: day, matchedRows });
            byDay[day].push({ bill, day, ...evaluated });
        }
    }

    for (const day of Object.keys(byDay)) {
        byDay[Number(day)].sort((a, b) => a.bill.bill_name.localeCompare(b.bill.bill_name));
    }
    unscheduled.sort((a, b) => a.bill.bill_name.localeCompare(b.bill.bill_name));

    return { byDay, unscheduled };
}

export function buildMonthGrid(year: number, month: number) {
    const first = new Date(year, month - 1, 1);
    const startWeekday = first.getDay(); // 0 Sun
    const daysInMonth = new Date(year, month, 0).getDate();
    const cells: Array<{ day: number | null }> = [];

    for (let i = 0; i < startWeekday; i += 1) cells.push({ day: null });
    for (let day = 1; day <= daysInMonth; day += 1) cells.push({ day });
    while (cells.length % 7 !== 0) cells.push({ day: null });

    return cells;
}
