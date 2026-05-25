#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const root = path.resolve(process.argv[2] || process.cwd());
const trackerPath = path.join(root, 'tmp/android_ui_tracker_snapshot.json');
const runnerPath = path.join(root, 'test_cases/api_run_results/postman-cli-latest.json');
const backlogPath = path.join(root, 'test_cases/NAPTIQCARE_IMPLEMENTATION_BACKLOG.html');
const mainReportPath = path.join(root, 'test_cases/NAPTIQCARE_UPDATED_EXECUTION_REPORT.html');

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

function countRowsBetween(html, startMarker, endMarker, tableIndex) {
  const section = (html.split(startMarker)[1] || '').split(endMarker)[0] || '';
  const tables = section.match(/<table>[\s\S]*?<\/table>/g) || [];
  const table = tables[tableIndex] || '';
  return Math.max(0, (table.match(/<tr>/g) || []).length - 1);
}

const tracker = readJson(trackerPath);
const trackerRecords = (tracker.records || []).filter((row) => row.id && row.qaStatus);
const openAndroid = trackerRecords.filter((row) => /^open$/i.test(row.qaStatus));
const closedAndroid = trackerRecords.filter((row) => /^closed$/i.test(row.qaStatus));

const runner = readJson(runnerPath);
const failedExecutions = (runner.run?.executions || []).filter((execution) => {
  return execution.requestError || (execution.assertions || []).some((assertion) => assertion.error);
});

const backlog = fs.readFileSync(backlogPath, 'utf8');
const mainReport = fs.readFileSync(mainReportPath, 'utf8');

const apiRows = countRowsBetween(backlog, '<h3 id="api-bug-index">', '<h3 id="android-ui-bug-index">', 0);
const androidRows = countRowsBetween(backlog, '<h3 id="android-ui-bug-index">', '</section>', 1);
const expectedAndroidText = `${closedAndroid.length} closed and ${openAndroid.length} open Android UI defects`;

const checks = [
  { name: 'API backlog rows match failed runner executions', expected: failedExecutions.length, actual: apiRows },
  { name: 'Android backlog rows match open tracker rows', expected: openAndroid.length, actual: androidRows },
  { name: 'Main report Android count text is current', expected: true, actual: mainReport.includes(expectedAndroidText) },
];

let failed = false;
for (const check of checks) {
  const ok = check.expected === check.actual;
  if (!ok) failed = true;
  console.log(`${ok ? 'OK' : 'FAIL'} ${check.name}: expected ${check.expected}, actual ${check.actual}`);
}

if (failed) process.exit(1);
