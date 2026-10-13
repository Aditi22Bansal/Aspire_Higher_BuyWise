// BuyWise rule: never convert currencies, never guess. Same-currency only.
export function canCompare(aCcy, bCcy) {
  if (!aCcy || !bCcy) return false;
  return String(aCcy).toUpperCase() === String(bCcy).toUpperCase();
}

export function budgetVerdict(price, currency, budget, budgetCcy) {
  if (price === null || price === undefined || budget === null || budget === undefined) return 'unavailable';
  if (!canCompare(currency, budgetCcy)) return 'unavailable';
  return Number(price) <= Number(budget) ? 'IN_BUDGET' : 'OVER_BUDGET';
}
