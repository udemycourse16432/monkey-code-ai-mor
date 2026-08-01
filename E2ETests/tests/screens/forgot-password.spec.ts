import { test, expect } from '../../fixtures/extended-test';

/**
 * SCREEN: Forgot Password (/forgot-password)
 * Razor page: Pages/ForgotPassword.cshtml + ForgotPassword.cshtml.cs
 *
 * Placeholder flow: POST sets IsSent=true and re-renders a confirmation.
 */
test.describe('Forgot Password screen', () => {
  test('renders the reset form', async ({ page }) => {
    await page.goto('/forgot-password');
    await expect(page.locator('input[name="Email"]')).toBeVisible();
    await expect(page.getByRole('button', { name: /send|submit|reset/i })).toBeVisible();
  });

  test('submitting a valid email shows the sent confirmation', async ({ page }) => {
    await page.goto('/forgot-password');
    await page.locator('input[name="Email"]').fill('customer@example.com');
    await page.getByRole('button', { name: /send|submit|reset/i }).click();

    // The page re-renders with IsSent = true
    await expect(page.locator('text=/sent|check your email/i').first()).toBeVisible();
  });
});
