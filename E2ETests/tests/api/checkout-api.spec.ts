import { test, expect } from '../../fixtures/extended-test';
import { signInViaUi } from '../../helpers/auth';
import { hasTestUser, hasItemId } from '../../fixtures/extended-test';

/**
 * CONTROLLER: CheckoutController
 * Route prefix: /api/checkout
 *
 *   POST /api/checkout/create-order          -> PayPal Orders/Create, returns PayPal Order
 *   POST /api/checkout/capture-order/{id}    -> PayPal Orders/Capture + spRecordPurchase
 *
 * Both endpoints rely on a logged-in session (customer server counter), a
 * populated cart, and an anti-forgery token (the Checkout page issues
 * `window.AppConfig.ANTIFORGERY_TOKEN` paired with the antiforgery cookie).
 * PayPal sandbox credentials are required for a true order id.
 */
test.describe('Checkout API - create-order', () => {
  test('fails gracefully without a logged-in customer session', async ({ request }) => {
    // The [ValidateAntiForgeryToken] filter rejects the token-less POST with a
    // 400 before any session logic runs, so an unauthenticated request cannot
    // reach the PayPal API.
    const res = await request.post('/api/checkout/create-order', {
      data: { shippingCode: 'MM' },
    });
    expect(res.status()).toBe(400);
  });

  test('returns a PayPal order id for a signed-in user with a cart', async ({ page, request, envConfig, testData }) => {
    test.skip(!hasTestUser(), 'TEST_USER_EMAIL/TEST_USER_PASSWORD not configured');
    test.skip(!hasItemId(), 'TEST_ITEM_ID not configured');

    // Seed cart + session via the browser, then call the API with that cookie jar.
    await page.goto('/');
    await page.request.post('/api/cart/add', {
      data: { id: testData.itemId, price: 9.99, type: 1, qty: 1, searchId: '-' },
    });
    await signInViaUi(page, envConfig.userEmail, envConfig.userPassword);

    // The Checkout page issues the anti-forgery token + cookie required by
    // the [ValidateAntiForgeryToken] endpoints.
    await page.goto('/checkout');
    const antiforgeryToken = await page.evaluate(() =>
      (window as any).AppConfig?.ANTIFORGERY_TOKEN,
    );

    const cookies = await page.context().cookies();
    const cookieHeader = cookies.map((c) => `${c.name}=${c.value}`).join('; ');

    const res = await request.post('/api/checkout/create-order', {
      data: { shippingCode: 'MM' },
      headers: { Cookie: cookieHeader, RequestVerificationToken: antiforgeryToken },
    });

    expect(res.ok()).toBeTruthy();
    const body = await res.json();
    // PayPal Order object has an 'id' that starts with the sandbox order prefix
    expect(typeof body.id).toBe('string');
    expect(body.status).toMatch(/CREATED|PAYER_ACTION_REQUIRED/i);
  });
});

test.describe('Checkout API - capture-order', () => {
  test('capturing a non-existent order id returns a PayPal error payload', async ({ page, request, envConfig }) => {
    test.skip(!hasTestUser(), 'TEST_USER_EMAIL/TEST_USER_PASSWORD not configured');

    await page.goto('/');
    await signInViaUi(page, envConfig.userEmail, envConfig.userPassword);

    // The Checkout page issues the anti-forgery token + cookie required by
    // the [ValidateAntiForgeryToken] endpoints.
    await page.goto('/checkout');
    const antiforgeryToken = await page.evaluate(() =>
      (window as any).AppConfig?.ANTIFORGERY_TOKEN,
    );
    const cookies = await page.context().cookies();
    const cookieHeader = cookies.map((c) => `${c.name}=${c.value}`).join('; ');

    const res = await request.post('/api/checkout/capture-order/INVALID-ORDER-ID', {
      headers: { Cookie: cookieHeader, RequestVerificationToken: antiforgeryToken },
    });

    // PayPal returns a 4xx (UNPROCESSABLE_ENTITY etc.); the controller mirrors it.
    expect(res.status()).toBeGreaterThanOrEqual(400);
  });
});
