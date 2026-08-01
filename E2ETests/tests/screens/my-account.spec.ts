import { test, expect } from '../../fixtures/extended-test';
import { signInViaUi } from '../../helpers/auth';
import { hasTestUser } from '../../fixtures/extended-test';

/**
 * SCREEN: My Account (/my-account)
 * Razor page: Pages/MyAccount.cshtml + MyAccount.cshtml.cs
 *
 * Auth-gated account editor. Shows shipping/billing address, sign-in email,
 * password, and country/state drop-downs. Saves via
 * OnPostSaveAccountInfoAsync -> spUpdateCustomers. Redirects to /Options
 * when no customer session counter exists.
 */
test.describe('My Account screen', () => {
  test('redirects anonymous users away', async ({ page }) => {
    await page.goto('/my-account');
    await expect(page).not.toHaveURL(/my-account/i);
  });

  test('renders account details for a signed-in user', async ({ page, envConfig }) => {
    test.skip(!hasTestUser(), 'TEST_USER_EMAIL/TEST_USER_PASSWORD not configured');

    await signInViaUi(page, envConfig.userEmail, envConfig.userPassword);
    await page.goto('/my-account');

    await expect(page.locator('input[name="AccountInfo.SignInEmail"]')).toHaveValue(envConfig.userEmail);
    await expect(page.locator('input[name="AccountInfo.FullName"]')).toBeVisible();
    await expect(page.getByRole('button', { name: /save|update/i }).first()).toBeVisible();
  });

  test('same-as-shipping checkbox copies shipping fields into billing', async ({ page, envConfig }) => {
    test.skip(!hasTestUser(), 'TEST_USER_EMAIL/TEST_USER_PASSWORD not configured');

    await signInViaUi(page, envConfig.userEmail, envConfig.userPassword);
    await page.goto('/my-account');

    const fullName = page.locator('input[name="AccountInfo.FullName"]');
    await fullName.fill('QA Renamed Customer');

    const sameAsShipping = page.getByRole('checkbox', { name: /same as shipping/i });
    await sameAsShipping.check();
    await expect(page.locator('input[name="AccountInfo.BillingFullName"]')).toHaveValue('QA Renamed Customer');
  });
});
