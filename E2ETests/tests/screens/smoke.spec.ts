import { test, expect } from '../../fixtures/extended-test';

/**
 * Smoke checks - run these first to confirm the app is reachable at BASE_URL.
 * Tagged @smoke so they can run in isolation:
 *   npm run test:smoke
 */
test.describe('Application smoke test @smoke', () => {
  test('home page responds and renders the storefront shell', async ({ page, envConfig }) => {
    const res = await page.goto('/');
    expect(res?.status()).toBe(200);
    await expect(page.locator('body')).toBeVisible();
    await expect(page.locator('a[href="/"]').first()).toBeVisible();
    test.info().annotations.push({ type: 'note', description: `Base URL under test: ${envConfig.baseURL}` });
  });

  test('shop page responds', async ({ page }) => {
    const res = await page.goto('/shop');
    expect(res?.status()).toBe(200);
  });

  test('API suggestions endpoint responds with JSON', async ({ request }) => {
    const res = await request.get('/api/suggestions/albums?search=a&limit=1');
    expect(res.status()).toBe(200);
    expect(res.headers()['content-type']).toContain('application/json');
  });

  test('cart API rejects an invalid id (proves the API layer is up)', async ({ request }) => {
    const res = await request.post('/api/cart/add', { data: { id: 0, price: 0, type: 1, qty: 1, searchId: '-' } });
    expect(res.status()).toBe(400);
  });
});
