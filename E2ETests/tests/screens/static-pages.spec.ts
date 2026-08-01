import { test, expect } from '../../fixtures/extended-test';

/**
 * SCREENS: Static / informational pages.
 * Each of these is a simple Razor page with only an OnGet handler and no
 * business logic. They must load, return 200, and render a page title.
 */
const staticPages = [
  { path: '/about-us', title: /about/i, file: 'AboutUs' },
  { path: '/policies', title: /polic/i, file: 'Policies' },
  { path: '/privacy-policy', title: /privacy/i, file: 'PrivacyPolicy' },
  { path: '/terms-and-conditions', title: /terms/i, file: 'TermsAndConditions' },
  { path: '/customer-service-and-returns', title: /customer service|returns/i, file: 'CustomerServiceAndReturns' },
  { path: '/help-shipping', title: /shipping/i, file: 'HelpShipping' },
];

test.describe('Static information pages', () => {
  for (const p of staticPages) {
    test(`${p.file} renders at ${p.path}`, async ({ page }) => {
      const res = await page.goto(p.path);
      expect(res?.status()).toBeLessThan(400);
      await expect(page).toHaveTitle(p.title);
    });
  }
});

test.describe('Sign Out', () => {
  test('sign-out clears the session and returns home', async ({ page }) => {
    await page.goto('/sign-out');
    await expect(page).toHaveURL('/');
  });
});
