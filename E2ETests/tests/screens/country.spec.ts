import { test, expect } from '../../fixtures/extended-test';

/**
 * SCREEN: Country (/country)
 * Razor page: Pages/Country.cshtml + Country.cshtml.cs
 *
 * Country picker used before account sign-up. Reads wr=r (retail) / wr=w
 * (wholesale) and ContinueToPurchasePage. Submitting (GET) navigates to
 * /sign-up with CountryListCode, WholesaleOrRetailTxt and ContinueToPurchasePage.
 */
test.describe('Country screen', () => {
  test('renders the country picker with the default country selected', async ({ page }) => {
    await page.goto('/country');
    await expect(page.getByRole('heading', { name: /select your country/i })).toBeVisible();

    const select = page.locator('#CountryListCode');
    await expect(select).toBeVisible();
    await expect(select.locator('option')).not.toHaveCount(0);
  });

  test('wr=r selects retail mode and continues to sign-up', async ({ page }) => {
    await page.goto('/country?wr=r');
    await expect(page.locator('#WholesaleOrRetailTxt')).toHaveValue('retail');

    await page.locator('#CountryListCode').selectOption({ index: 0 });
    await page.getByRole('button', { name: /continue/i }).click();

    await expect(page).toHaveURL(/\/sign-up/);
    await expect(page).toHaveURL(/CountryListCode=/);
  });

  test('wr=w selects wholesale mode and continues to sign-up', async ({ page }) => {
    await page.goto('/country?wr=w');
    await expect(page.locator('#WholesaleOrRetailTxt')).toHaveValue('wholesale');
  });

  test('changing the country dropdown submits immediately (onchange)', async ({ page }) => {
    await page.goto('/country?wr=r');
    await page.locator('#CountryListCode').selectOption({ index: 1 });
    // Auto-submit should land on /sign-up
    await expect(page).toHaveURL(/\/sign-up/, { timeout: 10_000 });
  });
});
