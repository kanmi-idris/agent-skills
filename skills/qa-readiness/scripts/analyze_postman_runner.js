#!/usr/bin/env node

const fs = require('fs');

const file = process.argv[2];
if (!file) {
  console.error('Usage: node analyze_postman_runner.js <postman-runner.json>');
  process.exit(2);
}

const data = JSON.parse(fs.readFileSync(file, 'utf8'));
const executions = data.run?.executions || [];

function urlToString(url) {
  if (!url) return '(URL not captured)';
  if (typeof url === 'string') return url;
  if (url.raw) return url.raw;
  const protocol = url.protocol ? `${url.protocol}://` : '';
  const host = Array.isArray(url.host) ? url.host.join('.') : (url.host || '');
  const pathParts = Array.isArray(url.path) ? url.path : (url.path ? [url.path] : []);
  return `${protocol}${host}${pathParts.length ? `/${pathParts.join('/')}` : ''}` || '(URL not captured)';
}

const failed = [];
for (const [index, execution] of executions.entries()) {
  const failedAssertions = (execution.assertions || []).filter((assertion) => assertion.error);
  if (!execution.requestError && !failedAssertions.length) continue;
  const observed = execution.requestError
    ? `Request Error: ${execution.requestError.code || execution.requestError.name || 'Request Error'}`
    : `${execution.response?.code || 'No HTTP status'} ${execution.response?.status || ''}`.trim();
  failed.push({
    runnerIndex: index + 1,
    requestName: execution.item?.name || 'Unnamed request',
    method: execution.request?.method || execution.item?.request?.method || 'UNKNOWN',
    url: urlToString(execution.request?.url || execution.item?.request?.url),
    observed,
    failedChecks: [
      ...(execution.requestError ? [{
        name: `Request error: ${execution.requestError.code || execution.requestError.name || 'Request Error'}`,
        error: execution.requestError.message || String(execution.requestError),
      }] : []),
      ...failedAssertions.map((assertion) => ({
        name: assertion.assertion || 'Unnamed assertion',
        error: assertion.error.message || String(assertion.error),
      })),
    ],
  });
}

const byObserved = failed.reduce((acc, row) => {
  acc[row.observed] = (acc[row.observed] || 0) + 1;
  return acc;
}, {});

console.log(JSON.stringify({
  stats: data.run?.stats || null,
  failedExecutions: failed.length,
  failedAssertions: failed.reduce((total, row) => total + row.failedChecks.filter((check) => !check.name.startsWith('Request error:')).length, 0),
  requestErrors: failed.filter((row) => row.observed.startsWith('Request Error')).length,
  byObserved,
  failures: failed,
}, null, 2));
