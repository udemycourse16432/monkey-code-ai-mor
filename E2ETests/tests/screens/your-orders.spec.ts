import { test, expect } from '../../fixtures/extended-test';
import { signInViaUi } from '../../helpers/auth';
import { hasTestUser } from '../../fixtures/extended-test';

/**
 * SCREEN: Your Orders (/your-orders)
 * Razor page: Pages/YourOrders.cshtml + YourOrders.cshtml.cs
 *
 * Auth-gated. Renders pending orders (spGetPendingCustomerOrders) then the
 * invoice history (spGetCustomerInvoices) with tracking links and PDF names.
 * Anonymous users are redirected to /sign-in?returnUrl=/your-orders.
 */
test.describe('Your Orders screen', () => {
  test('redirects anonymous users to sign-in with a returnUrl', async ({ page }) => {
    await page.goto('/your-orders');
    await expect(page).toHaveURL(/\/sign-in/);
    await expect(page).toHaveURL(/returnUrl=.*your-orders/i);
  });

  test('shows pending orders and/or invoice history for a signed-in user', async ({ page, envConfig }) => {
    test.skip(!hasTestUser(), 'TEST_USER_EMAIL/TEST_USER_PASSWORD not configured');

    await signInViaUi(page, envConfig.userEmail, envConfig.userPassword);
    await page.goto('/your-orders');

    // The page renders at least one table (pending or invoice history)
    await expect(page.locator('table').first()).toBeVisible();

    // Pending orders include an "In Progress" placeholder cell
    const inProgress = page.getByText('In Progress, we\'ll update when shipped');
    if ((await inProgress.count()) > 0) {
      await expect(inProgress.first()).toBeVisible();
    }
  });

  test('carrier tracking links are built from known carriers', async ({ page, envConfig }) => {
    test.skip(!hasTestUser(), 'TEST_USER_EMAIL/TEST_USER_PASSWORD not configured');

    await signInViaUi(page, envConfig.userEmail, envConfig.userPassword);
    await page.goto('/your-orders');

    const trackLinks = page.locator('a[href*="fedex.com"], a[href*="ups.com"], a[href*="usps.com"], a[href*="17track.net"]');
    if ((await trackLinks.count()) > 0) {
      await expect(trackLinks.first()).toHaveAttribute('href', /track/i);
    } else {
      test.info().annotations.push({ type: 'note', description: 'No shipped/invoice orders exist for this account - tracking links not asserted.' });
    }
  });
});
