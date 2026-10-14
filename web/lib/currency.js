export function formatINR(v) {
  if (v == null || v === 'unavailable') return 'unavailable';
  return new Intl.NumberFormat('en-IN', {
    style: 'currency',
    currency: 'INR',
    maximumFractionDigits: 0
  }).format(Number(v));
}

export function formatNum(v) {
  if (v == null || v === 'unavailable') return 'unavailable';
  return new Intl.NumberFormat('en-IN').format(Number(v));
}
