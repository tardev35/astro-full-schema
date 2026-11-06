const PATHS: Record<string, string> = {
  cards:
    '<rect x="3" y="5" width="11" height="15" rx="2"/><path d="M14 5l5.5 1.5-3.9 14-5.6-1.5"/><path d="M8.5 11.5l1.3 2.1 1.3-2.1-1.3-2z"/>',
  wheel:
    '<circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="3.2"/><path d="M12 3v5.8M12 15.2V21M3 12h5.8M15.2 12H21M5.6 5.6l4.1 4.1M14.3 14.3l4.1 4.1M18.4 5.6l-4.1 4.1M9.7 14.3l-4.1 4.1"/>',
  flame:
    '<path d="M12 3c1 3 4 4.5 4 8.5a4 4 0 0 1-8 0c0-1.6.6-2.8 1.5-3.8.3 1.3 1 2 1.9 2.3C11 7.6 11 5.3 12 3z"/><path d="M8.5 13.5c0 2 1.6 3.5 3.5 3.5s3.5-1.5 3.5-3.5"/>',
  dice:
    '<rect x="4" y="4" width="16" height="16" rx="3.5"/><circle cx="8.5" cy="8.5" r="1.2" fill="currentColor" stroke="none"/><circle cx="15.5" cy="8.5" r="1.2" fill="currentColor" stroke="none"/><circle cx="12" cy="12" r="1.2" fill="currentColor" stroke="none"/><circle cx="8.5" cy="15.5" r="1.2" fill="currentColor" stroke="none"/><circle cx="15.5" cy="15.5" r="1.2" fill="currentColor" stroke="none"/>',
  fish:
    '<path d="M3 12c3-4.5 7-6.5 11-6.5 2.6 0 4.9 1.4 7 3.5-2.1 2.1-4.4 3.5-7 3.5-4 0-8-2-11-6.5z" transform="translate(0 3)"/><path d="M14 8.5c1.5 1.3 3 2.5 4.5 3.5-1.5 1-3 2.2-4.5 3.5"/><circle cx="7" cy="12" r="1" fill="currentColor" stroke="none"/><path d="M3 12l-1.5-3M3 12l-1.5 3" transform="translate(0 3)"/>',
  dragon:
    '<path d="M4 15c2-6 6-9 11-9 2.5 0 4 1 5 3-2 0-3 .5-4 2 1.5.5 2.5 1.5 3 3-2-.5-4 0-5.5 1.5L12 18c-2-1-4-1-6 0 .5-1.5 1-2.5 2-3.5-1.5 0-3 .2-4 .5z"/><circle cx="14.5" cy="9.5" r=".9" fill="currentColor" stroke="none"/>',
  skull:
    '<path d="M12 3a7.5 7.5 0 0 0-7.5 7.5c0 2.6 1.3 4.3 3 5.5V19h9v-3c1.7-1.2 3-2.9 3-5.5A7.5 7.5 0 0 0 12 3z"/><circle cx="9.3" cy="11" r="1.6"/><circle cx="14.7" cy="11" r="1.6"/><path d="M10.5 19v2M13.5 19v2M11.2 15.2l.8-1.4.8 1.4"/>',
  users:
    '<circle cx="9" cy="8" r="3.2"/><path d="M3.5 19c0-3 2.5-5 5.5-5s5.5 2 5.5 5"/><circle cx="16.5" cy="9.5" r="2.5"/><path d="M16 14.5c2.8 0 4.5 1.8 4.5 4.5"/>',
  target:
    '<circle cx="12" cy="12" r="8.5"/><circle cx="12" cy="12" r="4.5"/><circle cx="12" cy="12" r="1" fill="currentColor" stroke="none"/><path d="M12 1.5v4M12 18.5v4M1.5 12h4M18.5 12h4"/>',
  coins:
    '<ellipse cx="9" cy="7" rx="6" ry="2.5"/><path d="M3 7v5c0 1.4 2.7 2.5 6 2.5s6-1.1 6-2.5V7"/><path d="M3 12v5c0 1.4 2.7 2.5 6 2.5s6-1.1 6-2.5v-5"/><path d="M15 9.5c3 .2 6 1.2 6 2.7v5c0 1.4-2.7 2.5-6 2.5"/>',
  ticket:
    '<path d="M4 8a2 2 0 0 0 2-2V5h12v1a2 2 0 0 0 2 2v3a2 2 0 0 0 0 4v3a2 2 0 0 0-2 2v1H6v-1a2 2 0 0 0-2-2v-3a2 2 0 0 0 0-4z"/><path d="M12 7v10" stroke-dasharray="2 2"/>',
  slot:
    '<rect x="3" y="6" width="18" height="12" rx="2.5"/><path d="M8 6v12M16 6v12M21 9h1.5v5H21"/><path d="M5.5 11l1-1 1 1M11 11l1-1 1 1M16.5 11l1-1 1 1" />',
  crown:
    '<path d="M3 17l1.5-9 4.5 4L12 5l3 7 4.5-4L21 17z"/><path d="M3.5 20h17"/>',
  plus:
    '<circle cx="12" cy="12" r="9"/><path d="M12 8v8M8 12h8"/>',
  stop:
    '<circle cx="12" cy="12" r="9"/><path d="M8 12h8"/>',
  double:
    '<circle cx="12" cy="12" r="9"/><path d="M8.5 9.5c0-1.4 1-2.3 2.3-2.3s2.3.9 2.3 2.2c0 2.3-4.6 3.4-4.6 6.1h4.8"/><path d="M15 12.5l3 3.5M18 12.5l-3 3.5"/>',
  split:
    '<path d="M12 20V11"/><path d="M12 11L6 5M12 11l6-6"/><path d="M6 5h4M6 5v4M18 5h-4M18 5v4"/>',
  chart:
    '<path d="M3 20h18"/><path d="M5 16l4-5 3 3 4-6 3 3"/><path d="M17 8h2v2"/>',
  calendar:
    '<rect x="3" y="5" width="18" height="16" rx="2.5"/><path d="M3 10h18M8 3v4M16 3v4"/><circle cx="8.5" cy="14.5" r="1" fill="currentColor" stroke="none"/><circle cx="12" cy="14.5" r="1" fill="currentColor" stroke="none"/><circle cx="15.5" cy="14.5" r="1" fill="currentColor" stroke="none"/>',
  check:
    '<circle cx="12" cy="12" r="9"/><path d="M8 12.5l2.5 2.5L16 9.5"/>',
  search:
    '<circle cx="11" cy="11" r="6.5"/><path d="M16 16l4.5 4.5"/>',
  shield:
    '<path d="M12 3l7 3v5.5c0 4.5-3 7.8-7 9.5-4-1.7-7-5-7-9.5V6z"/><path d="M9 12l2 2 4-4"/>',
  phone:
    '<rect x="7" y="2.5" width="10" height="19" rx="2.5"/><path d="M10.5 18.5h3"/>',
  number:
    '<rect x="3" y="4" width="18" height="16" rx="3"/><path d="M8 15V9l-1.5 1M12.5 9h3l-2.5 6M18 9v6"/>',
  globe:
    '<circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3c3 3 3 15 0 18M12 3c-3 3-3 15 0 18"/>',
  flag:
    '<path d="M5 21V4"/><path d="M5 4h11l-2 4 2 4H5"/>',
};

export function gameIcon(name: string, size = 22): string {
  const d = PATHS[name] ?? PATHS.crown;
  return `<svg viewBox="0 0 24 24" width="${size}" height="${size}" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">${d}</svg>`;
}
