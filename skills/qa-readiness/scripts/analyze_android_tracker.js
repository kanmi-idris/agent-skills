#!/usr/bin/env node

const fs = require('fs');

const file = process.argv[2];
if (!file) {
  console.error('Usage: node analyze_android_tracker.js <android_ui_tracker_snapshot.json>');
  process.exit(2);
}

const snapshot = JSON.parse(fs.readFileSync(file, 'utf8'));
const records = (snapshot.records || []).filter((row) => row.id && row.qaStatus);
const open = records.filter((row) => /^open$/i.test(row.qaStatus));
const closed = records.filter((row) => /^closed$/i.test(row.qaStatus));

function countBy(rows, field) {
  return rows.reduce((acc, row) => {
    const key = String(row[field] || '(blank)').trim() || '(blank)';
    acc[key] = (acc[key] || 0) + 1;
    return acc;
  }, {});
}

function moduleRows(rows) {
  const modules = new Map();
  for (const row of rows) {
    const key = row.module || '(blank)';
    if (!modules.has(key)) modules.set(key, { module: key, total: 0, Critical: 0, High: 0, Medium: 0, Low: 0 });
    const entry = modules.get(key);
    entry.total += 1;
    if (entry[row.severity] !== undefined) entry[row.severity] += 1;
  }
  return [...modules.values()].sort((a, b) => b.total - a.total || a.module.localeCompare(b.module));
}

const p0 = open.filter((row) => row.priority === 'P0');
const critical = open.filter((row) => row.severity === 'Critical');

console.log(JSON.stringify({
  total: records.length,
  closed: closed.length,
  open: open.length,
  readiness: records.length ? Number(((closed.length / records.length) * 100).toFixed(1)) : 0,
  statusCounts: countBy(records, 'qaStatus'),
  openSeverityCounts: countBy(open, 'severity'),
  openPriorityCounts: countBy(open, 'priority'),
  openModuleRows: moduleRows(open),
  criticalOpen: critical.map((row) => ({ id: row.id, module: row.module, priority: row.priority, summary: row.summary })),
  p0Open: p0.map((row) => ({ id: row.id, module: row.module, severity: row.severity, summary: row.summary })),
}, null, 2));
