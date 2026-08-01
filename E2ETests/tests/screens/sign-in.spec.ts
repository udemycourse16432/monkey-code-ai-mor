import { test, expect } from '../../fixtures/extended-test';
import { hasTestUser } from '../../fixtures/extended-test';

/**
 * SCREEN: Sign In (/sign-in)
 * Razor page: Pages/SignIn.cshtml + SignIn.cshtml.cs
 *
 * POST /sign-in with Email + Password. On success redirects to ReturnUrl,
 * /CustomerInfo (power user), /EnterStock (admin emails) or /WholesaleAccepted.
 * On failure sets TempData ErrorMessage and re-renders with a warning alert.
 */
test.describe('Sign In screen', () => {
  test('renders the sign-in form', async ({ page }) => {
    await page.goto('/sign-in');
    await expect(page.locator('input[name="Email"]')).toBeVisible();
    await expect(page.locator('input[name="Password"]')).toBeVisible();
    await expect(page.getByRole('button', { name: /sign in/i })).toBeVisible();
  });

  test('shows "Email address not found" for an unknown email', async ({ page }) => {
    await page.goto('/sign-in');
    await page.locator('input[name="Email"]').fill(`nobody-${Date.now()}@example.com`);
    await page.locator('input[name="Password"]').fill('WrongPass123');
    await page.getByRole('button', { name: /sign in/i }).click();

    await expect(page.locator('.alert-warning')).toContainText('Email address not found');
  });

  test('shows an invalid-password error for an existing email with the wrong password', async ({ page }) => {
    test.skip(!hasTestUser(), 'TEST_USER_EMAIL/TEST_USER_PASSWORD not configured');

    await page.goto('/sign-in');
    await page.locator('input[name="Email"]').fill(process.env.TEST_USER_EMAIL!);
    await page.locator('input[name="Password"]').fill('DefinitelyWrong123');
    await page.getByRole('button', { name: /sign in/i }).click();

    await expect(page.locator('.alert-warning')).toContainText(/invalid password/i);
  });

  test('successful login redirects away from the sign-in page', async ({ page, envConfig }) => {
    test.skip(!hasTestUser(), 'TEST_USER_EMAIL/TEST_USER_PASSWORD not configured');

    await page.goto('/sign-in');
    await page.locator('input[name="Email"]').fill(envConfig.userEmail);
    await page.locator('input[name="Password"]').fill(envConfig.userPassword);
    await page.getByRole('button', { name: /sign in/i }).click();

    // Should land on a protected landing page, not the login form
    await expect(page).not.toHaveURL(/sign-in/i);
  });

  test('honors a local returnUrl after successful login', async ({ page, envConfig }) => {
    test.skip(!hasTestUser(), 'TEST_USER_EMAIL/TEST_USER_PASSWORD not configured');

    await page.goto('/sign-in?returnUrl=/your-orders');
    await page.locator('input[name="Email"]').fill(envConfig.userEmail);
    await page.locator('input[name="Password"]').fill(envConfig.userPassword);
    await page.getByRole('button', { name: /sign in/i }).click();

    await expect(page).toHaveURL(/your-orders/i);
  });

  test('protects against open redirect: external returnUrl is ignored', async ({ page, envConfig }) => {
    test.skip(!hasTestUser(), 'TEST_USER_EMAIL/TEST_USER_PASSWORD not configured');

    await page.goto('/sign-in?returnUrl=https://evil.example.com');
    await page.locator('input[name="Email"]').fill(envConfig.userEmail);
    await page.locator('input[name="Password"]').fill(envConfig.userPassword);
    await page.getByRole('button', { name: /sign in/i }).click();

    await expect(page).not.toHaveURL(/evil\.example\.com/i);
  });
});
