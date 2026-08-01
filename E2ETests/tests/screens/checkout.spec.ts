import { test, expect } from '../../fixtures/extended-test';
import { signInViaUi } from '../../helpers/auth';
import { hasTestUser, hasItemId } from '../../fixtures/extended-test';

/**
 * SCREEN: Checkout (/checkout)
 * Razor page: Pages/Checkout.cshtml + Checkout.cshtml.cs
 *
 * Auth-gated. Shows shipping method radios (input[name="SelectedShippingCode"]),
 * order summary, and the PayPal button container (#paypal-button-container).
 * Order creation goes to POST /api/checkout/create-order, capture to
 * POST /api/checkout/capture-order/{orderId}.
 */
test.describe('Checkout screen', () => {
  test('redirects anonymous users to the sign-in page with returnUrl=/checkout', async ({ page }) => {
    await page.goto('/checkout');
    await expect(page).toHaveURL(/\/sign-in/);
    await expect(page).toHaveURL(/returnUrl=/i);
  });

  test('renders shipping methods and order summary for a signed-in user with a cart', async ({ page, envConfig, testData }) => {
    test.skip(!hasTestUser(), 'TEST_USER_EMAIL/TEST_USER_PASSWORD not configured');
    test.skip(!hasItemId(), 'TEST_ITEM_ID not configured');

    // 1. Add item to cart
    await page.request.post('/api/cart/add', {
      data: { id: testData.itemId, price: 10, type: 1, qty: 1, searchId: '-' },
    });

    // 2. Sign in (session is now logged in)
    await signInViaUi(page, envConfig.userEmail, envConfig.userPassword);
    await page.goto('/checkout');

    // 3. Shipping method radios
    const radios = page.locator('input[name="SelectedShippingCode"]');
    await expect(radios.first()).toBeVisible();

    // 4. Totals display
    await expect(page.locator('#products-price-display')).toBeVisible();
    await expect(page.locator('#shipping-cost-display')).toBeVisible();
    await expect(page.locator('#total-amount-display')).toBeVisible();

    // 5. PayPal SDK placeholder
    await expect(page.locator('#paypal-button-container')).toBeAttached();
  });

  test('selecting a shipping method updates the summary total', async ({ page, envConfig, testData }) => {
    test.skip(!hasTestUser(), 'TEST_USER_EMAIL/TEST_USER_PASSWORD not configured');
    test.skip(!hasItemId(), 'TEST_ITEM_ID not configured');

    await page.request.post('/api/cart/add', {
      data: { id: testData.itemId, price: 10, type: 1, qty: 1, searchId: '-' },
    });
    await signInViaUi(page, envConfig.userEmail, envConfig.userPassword);
    await page.goto('/checkout');

    const radios = page.locator('input[name="SelectedShippingCode"]');
    const totalBefore = await page.locator('#total-amount-display').innerText();

    const second = radios.nth(1);
    if ((await second.count()) === 0) {
      test.skip(true, 'Only one shipping method available for this account.');
    }
    await second.check({ force: true });
    await expect(page.locator('#total-amount-display')).not.toHaveText(totalBefore);
  });

  test('paypal SDK script is requested when the checkout page loads', async ({ page, envConfig, testData }) => {
    test.skip(!hasTestUser(), 'TEST_USER_EMAIL/TEST_USER_PASSWORD not configured');
    test.skip(!hasItemId(), 'TEST_ITEM_ID not configured');

    await page.request.post('/api/cart/add', {
      data: { id: testData.itemId, price: 10, type: 1, qty: 1, searchId: '-' },
    });
    await signInViaUi(page, envConfig.userEmail, envConfig.userPassword);

    const sdk = page.waitForResponse((r) => r.url().includes('sandbox.paypal.com') && r.status() < 400);
    await page.goto('/checkout');
    await sdk;
  });
});
