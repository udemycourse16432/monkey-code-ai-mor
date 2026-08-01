import { test, expect } from '../../fixtures/extended-test';
import { signInViaUi } from '../../helpers/auth';
import { hasTestUser } from '../../fixtures/extended-test';

/**
 * SCREEN: Wholesale (/wholesale) and Wholesale Accepted (/wholesale-accepted)
 * Razor pages: Pages/Wholesale.cshtml (static) + Pages/WholesaleAccepted.cshtml
 *
 * /wholesale is a static marketing page. /wholesale-accepted is the post-login
 * landing that migrates a retail guest cart into the customer's wholesale cart
 * (W_CART_<serverCounter>) and shows an item count summary.
 */
test.describe('Wholesale screens', () => {
  test('wholesale page loads as a static information page', async ({ page }) => {
    await page.goto('/wholesale');
    await expect(page).toHaveTitle(/wholesale/i);
  });

  test('wholesale-accepted requires login', async ({ page }) => {
    await page.goto('/wholesale-accepted');
    await expect(page).toHaveURL(/\/sign-in/i);
  });

  test('wholesale-accepted shows the cart item summary for a signed-in user', async ({ page, envConfig }) => {
    test.skip(!hasTestUser(), 'TEST_USER_EMAIL/TEST_USER_PASSWORD not configured');

    await signInViaUi(page, envConfig.userEmail, envConfig.userPassword);
    await page.goto('/wholesale-accepted');

    // Either an item count text or the empty-cart fallback renders
    const summary = page.locator('text=/Items|Cart:/i').first();
    await expect(summary).toBeVisible();
  });
});
