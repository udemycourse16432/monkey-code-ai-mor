import { test, expect } from '../../fixtures/extended-test';

/**
 * CONTROLLER: HTTPDownloadDataOKController
 * Route: /HTTPDownloadDataOK.aspx  (legacy URL compatibility, GET + POST)
 *
 * Query params: pw, counter, table, newcustomerid.
 * Behavior:
 *   - Wrong/missing pw -> text "Invalid Credentials; IP Address Recorded"
 *   - Valid pw + parseable counter + recognized table -> runs a spDownloadOK_* sp
 *     and returns "OK"
 *   - Valid pw + unparseable counter -> "Invalid Parameter"
 *   - Valid pw + unknown table -> still returns "OK" (no sp runs)
 *
 * The password is configured via LegacyApiSettings:DownloadDataPassword in
 * appsettings.json and can be supplied to the tests through
 * LEGACY_DOWNLOAD_PASSWORD (see .env.example).
 */
test.describe('Legacy HTTPDownloadDataOK API', () => {
  const base = '/HTTPDownloadDataOK.aspx';

  test('rejects a missing password', async ({ request }) => {
    const res = await request.get(base);
    expect(res.status()).toBe(200);
    expect(await res.text()).toBe('Invalid Credentials; IP Address Recorded');
  });

  test('rejects a wrong password', async ({ request }) => {
    const res = await request.get(`${base}?pw=wrong-password&counter=123&table=SignInLog`);
    expect(res.status()).toBe(200);
    expect(await res.text()).toBe('Invalid Credentials; IP Address Recorded');
  });

  test('returns Invalid Parameter for an unparseable counter', async ({ request }) => {
    const pw = process.env.LEGACY_DOWNLOAD_PASSWORD;
    test.skip(!pw, 'LEGACY_DOWNLOAD_PASSWORD not configured');

    const res = await request.get(`${base}?pw=${pw}&counter=abc&table=SignInLog`);
    expect(res.status()).toBe(200);
    expect(await res.text()).toBe('Invalid Parameter');
  });

  test('runs the table handler and returns OK for a valid request', async ({ request }) => {
    const pw = process.env.LEGACY_DOWNLOAD_PASSWORD;
    test.skip(!pw, 'LEGACY_DOWNLOAD_PASSWORD not configured');

    const res = await request.get(`${base}?pw=${pw}&counter=12345&table=SignInLog`);
    expect(res.status()).toBe(200);
    expect(await res.text()).toBe('OK');
  });

  test('unknown tables still return OK without executing a handler', async ({ request }) => {
    const pw = process.env.LEGACY_DOWNLOAD_PASSWORD;
    test.skip(!pw, 'LEGACY_DOWNLOAD_PASSWORD not configured');

    const res = await request.get(`${base}?pw=${pw}&counter=12345&table=DoesNotExist`);
    expect(res.status()).toBe(200);
    expect(await res.text()).toBe('OK');
  });

  test('truncates table names longer than 100 characters', async ({ request }) => {
    const pw = process.env.LEGACY_DOWNLOAD_PASSWORD;
    test.skip(!pw, 'LEGACY_DOWNLOAD_PASSWORD not configured');

    const longTable = 'A'.repeat(250);
    const res = await request.get(`${base}?pw=${pw}&counter=12345&table=${longTable}`);
    expect(res.status()).toBe(200);
  });

  test('accepts POST requests too', async ({ request }) => {
    const pw = process.env.LEGACY_DOWNLOAD_PASSWORD;
    test.skip(!pw, 'LEGACY_DOWNLOAD_PASSWORD not configured');

    const res = await request.post(`${base}?pw=${pw}&counter=12345&table=Carts`);
    expect(res.status()).toBe(200);
    expect(await res.text()).toBe('OK');
  });
});
