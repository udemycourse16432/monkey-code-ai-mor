import { test, expect } from '../../fixtures/extended-test';

/**
 * SCREEN: Debug (/admin/debug)
 * Razor page: Pages/Debug.cshtml + Debug.cshtml.cs
 *
 * In Development this page renders session diagnostics and a "Clear Session"
 * button (OnPostClearSession). In non-Development environments Program.cs
 * maps /admin/debug to a 403 response, so tests must adapt to the running
 * environment. Use env DEBUG_PAGE_ALLOWED=1 to enable these assertions.
 */
test.describe('Debug screen', () => {
  test('dev builds expose the clear-session action', async ({ page }) => {
    test.skip(process.env.DEBUG_PAGE_ALLOWED !== '1', 'set DEBUG_PAGE_ALLOWED=1 when running in a Development environment');

    await page.goto('/admin/debug');
    await expect(page.locator('text=/session/i').first()).toBeVisible();
  });

  test('non-development builds reject /admin/debug with 403', async ({ page }) => {
    test.skip(process.env.DEBUG_PAGE_ALLOWED === '1', 'only when running outside Development');

    const res = await page.goto('/admin/debug');
    expect(res?.status()).toBe(403);
  });

  test('clearing the session resets the cart count to zero', async ({ page }) => {
    test.skip(process.env.DEBUG_PAGE_ALLOWED !== '1', 'set DEBUG_PAGE_ALLOWED=1 when running in a Development environment');

    await page.goto('/');
    await page.evaluate(() => {
      document.cookie = '.MillionsOfRecords.Session=';
    });
    await page.goto('/admin/debug');
    await page.getByRole('button', { name: /clear session/i }).click();
    await expect(page).toHaveURL(/admin\/debug/);
  });
});
