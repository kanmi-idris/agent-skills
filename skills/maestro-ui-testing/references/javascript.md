# JavaScript Reference

Use JavaScript when YAML alone cannot express the setup, data, or assertion cleanly. Keep UI interactions in YAML where possible; use JS for dynamic data, state, API calls, and compact logic.

## Runtime Model

Maestro runs JavaScript in a restricted sandbox with no direct local filesystem access and no external Node.js libraries. This keeps flows portable across local machines and Maestro Cloud.

GraalJS is enabled by default and supports modern ECMAScript features. Rhino exists but should be avoided unless a project explicitly requires it.

## Three Execution Methods

Inline expressions are best for simple dynamic values:

```yaml
- launchApp
- inputText: ${'User_' + faker.name().firstName()}
- tapOn: ${maestro.platform === 'ios' ? 'Allow' : 'While using the app'}
```

Use `evalScript` for logic-only steps:

```yaml
- evalScript: ${output.timestamp = new Date().getTime()}
- evalScript: ${console.log('Test execution started')}
```

Use `runScript` for longer or reusable scripts:

```yaml
- runScript:
    file: setupUser.js
    env:
      userRole: "admin"
```

The script can read passed values directly:

```javascript
const role = userRole;
console.log(`Setting up user with role: ${role}`);
```

## Sharing Data with `output`

Store values on `output` to use them later in the same flow:

```yaml
- evalScript: ${output.email = faker.internet().emailAddress()}
- tapOn: "Email"
- inputText: ${output.email}
- assertVisible: ${output.email}
```

Use `output` for IDs created by APIs, generated emails, timestamps, computed totals, and flags from setup scripts.

## Logging

`console.log` output is captured in `maestro.log` and prefixed with `JsConsole`.

Multiple arguments are not supported. This logs only the first argument:

```javascript
console.log('Value:', myVar)
```

Use concatenation or template literals:

```javascript
console.log('Value: ' + myVar)
console.log(`Value is ${myVar}`)
```

Inside `evalScript`, avoid JavaScript template literals because `${...}` is already Maestro syntax:

```yaml
- evalScript: '${console.log("Value: " + myVar)}'
```

## Synthetic Data with `faker`

Use the built-in DataFaker-backed `faker` object to avoid collisions in sign-up or data-entry tests.

```yaml
- inputText:
    text: ${faker.name().firstName()}
- inputText:
    text: ${faker.internet().emailAddress()}
```

Common examples:

- `faker.name().firstName()`
- `faker.name().fullName()`
- `faker.finance().creditCard()`
- `faker.number().digits(5)`
- `faker.expression("#{number.numberBetween '1' '10'}")`
- `faker.expression("#{name.fullName} lives in #{address.city}")`

Store complex values before using them:

```yaml
- evalScript: '${output.bio = faker.expression("#{name.fullName} lives in #{address.city}")}'
- inputText: ${output.bio}
```

## HTTP Requests

Use Maestro's built-in HTTP client for API setup or backend verification:

```javascript
const response = http.get('https://api.example.com/user/1');
const userData = json(response.body);
output.username = userData.profile.name;
```

Supported helpers:

- `http.get(url, config)`
- `http.post(url, config)`
- `http.put(url, config)`
- `http.delete(url, config)`
- `http.request(url, config)` for other methods such as `PATCH`

Headers:

```javascript
const response = http.get('https://example.com', {
  headers: {
    'Authorization': 'Bearer ' + output.token,
    'Content-Type': 'application/json'
  }
});
```

JSON body:

```javascript
const response = http.post('https://example.com/login', {
  body: JSON.stringify({
    username: "test_user",
    password: "password123"
  })
});
```

Multipart file upload:

```javascript
const response = http.post('https://example.com/myEndpoint', {
  multipartForm: {
    "uploadType": "import",
    "data": {
      "filePath": filePath,
      "mediaType": "text/csv"
    }
  }
});
```

If both `body` and `multipartForm` are provided, `body` is ignored.

The response object has:

- `ok`: `true` for HTTP 200-299.
- `status`: numeric status code.
- `body`: raw string response body.
- `headers`: response headers.

API setup pattern:

```javascript
// create_appointment.js
const response = http.post('https://my-api.com/v1/appointments', {
  body: JSON.stringify({
    title: "Maestro Health Check",
    date: "2026-02-10"
  }),
  headers: { 'Content-Type': 'application/json' }
});

const data = json(response.body);
output.appointmentTitle = data.title;
```

```yaml
appId: com.example.app
---
- launchApp
- runScript: create_appointment.js
- tapOn: "My Appointments"
- assertVisible: ${output.appointmentTitle}
```
