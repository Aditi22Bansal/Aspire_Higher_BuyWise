export function filterRows(rows, q, keys){ if(!q) return rows; const s=String(q).toLowerCase(); return rows.filter((r)=>keys.some((k)=>String(r[k]??'').toLowerCase().includes(s))); }
export function sortRows(rows, key, dir=1){ return [...rows].sort((a,b)=>{ const x=a[key]??''; const y=b[key]??''; return (x>y?1:x<y?-1:0)*dir; }); }
