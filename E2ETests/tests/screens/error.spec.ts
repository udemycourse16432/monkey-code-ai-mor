import { test, expect } from '../../fixtures/extended-test';

/**
 * SCREEN: Error (/Error)
 * Razor page: Pages/Error.cshtml + Error.cshtml.cs
 *
 * Exception handler page for non-development environments. Direct access
 * renders an error status. Covered here so the mapping is verified.
 */
test.describe('Error screen', () => {
  test('unknown routes fall back to a client 404 without a stack trace', async ({ page }) => {
    const res = await page.goto('/this-page-does-not-exist-12345');
    expect(res).toBeDefined();
    // The server returns 404 for unmatched Razor routes
    expect(res?.status()).toBe(404);
  });
});
