export function isUUID(v) {
    return /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(
        String(v || '')
    );
}

export function isMoney(v) {
    const n = Number(v);
    return Number.isFinite(n) && n >= 0;
}

export function cleanStr(v, max = 500) {
    return String(v || '')
        .trim()
        .slice(0, max);
}
