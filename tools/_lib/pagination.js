
export function paginate(rows, { page = 1, pageSize = 20 } = {}) {
  const p = Math.max(1, Number(page) || 1);
  const ps = Math.min(100, Math.max(1, Number(pageSize) || 20));
  const total = rows.length;
  const start = (p - 1) * ps;

  return {
    page: p,
    pageSize: ps,
    total,
    pages: Math.ceil(total / ps),
    data: rows.slice(start, start + ps)
  };
}
