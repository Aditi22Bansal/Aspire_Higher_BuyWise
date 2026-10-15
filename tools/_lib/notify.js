export function approvalSubject(c) {
  return `BuyWise approval needed: ${c.requirement || c.procurement_id}`;
}

export function approvalBody(c) {
  return `Case ${c.procurement_id} is ${c.status}. Budget ${c.budget ?? 'unavailable'} ${c.currency ?? ''}. Open the case workspace to decide.`;
}
