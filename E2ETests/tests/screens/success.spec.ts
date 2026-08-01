import { test, expect } from '../../fixtures/extended-test';
import { signInViaUi } from '../../helpers/auth';
import { hasTestUser, hasOrderNumber } from '../../fixtures/extended-test';

/**
 * SCREEN: Success (/checkout/success?orderNumber=...)
 * Razor page: Pages/Success.cshtml + Success.cshtml.cs
 *
 * Auth-gated order confirmation. Reads the order via spGetOrdersRow /
 * spGetOrderItems and renders shipping + itemized receipt. Redirects to
 * /your-orders when the order number is unknown.
 */
test.describe('Success (order confirmation) screen', () => {
  test('redirects anonymous users to sign-in, preserving the order number in returnUrl', async ({ page }) => {
    await page.goto('/checkout/success?orderNumber=WEB-000-000-000');
    await expect(page).toHaveURL(/\/sign-in/);
    await expect(page).toHaveURL(/returnUrl=.*checkout%2Fsuccess/i);
  });

  test('redirects to Your Orders when the order number is unknown', async ({ page, envConfig }) => {
    test.skip(!hasTestUser(), 'TEST_USER_EMAIL/TEST_USER_PASSWORD not configured');

    await signInViaUi(page, envConfig.userEmail, envConfig.userPassword);
    await page.goto('/checkout/success?orderNumber=WEB-999-999-999');
    await expect(page).toHaveURL(/your-orders/i);
  });

  test('renders the receipt for a known order number', async ({ page, envConfig, testData }) => {
    test.skip(!hasTestUser(), 'TEST_USER_EMAIL/TEST_USER_PASSWORD not configured');
    test.skip(!hasOrderNumber(), 'TEST_ORDER_NUMBER not configured');

    await signInViaUi(page, envConfig.userEmail, envConfig.userPassword);
    await page.goto(`/checkout/success?orderNumber=${testData.orderNumber}`);

    // Receipt header / order confirmation copy
    await expect(page.getByRole('heading', { name: /order confirmed|thank you/i }).first()).toBeVisible();

    // Shipping destination rendered
    await expect(page.locator('text=/shipping to/i').first()).toBeVisible();

    // Line items table
    await expect(page.locator('table').first()).toBeVisible();
  });
});
