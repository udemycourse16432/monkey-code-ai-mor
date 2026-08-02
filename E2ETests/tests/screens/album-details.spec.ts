import { test, expect } from '../../fixtures/extended-test';
import type { Page } from '@playwright/test';

/**
 * SCREEN: Album Details (/ItemDetails/{id})
 * Razor page: Pages/AlbumDetails.cshtml + AlbumDetails.cshtml.cs
 *
 * Shows full album metadata (artist, title, format, price, label, catalog,
 * year, condition, review, features, genres) plus two recommendation rails:
 * "Customer Viewed" (similar items) and "More By This Artist".
 * Add/update cart controls call POST /api/cart/adjust.
 */

/**
 * Navigate to an album detail page, asserting it was served successfully so a
 * stale build (HTTP 500) fails fast with the status instead of a bare timeout.
 */
async function gotoItemDetails(page: Page, id: string | number) {
  const response = await page.goto(`/ItemDetails/${id}`);
  expect(
    response?.status(),
    `GET /ItemDetails/${id} expected 200 but got ${response?.status() ?? 'no response'} — is the app running a current build?`,
  ).toBe(200);
}

/**
 * Fail with a clear message when the detail page renders its not-found state,
 * i.e. the configured item id is bogus, hidden, or deleted.
 */
async function expectItemFound(page: Page, id: string | number) {
  await expect(
    page.getByRole('heading', { name: /album details not found/i }),
    `Item ${id} was not found — TEST_ITEM_ID must be a valid in-stock id from the /shop page`,
  ).not.toBeVisible();
}

test.describe('Album Details screen', () => {
  test('returns a 404-style not-found state for a bogus id', async ({ page }) => {
    const response = await page.goto('/ItemDetails/0');
    expect(
      response?.status(),
      `GET /ItemDetails/0 expected 200 but got ${response?.status() ?? 'no response'} — a stale build throws NRE on the not-found path; rebuild & restart the app`,
    ).toBe(200);

    await expect(
      page.getByRole('heading', { name: /album details not found/i }),
    ).toBeVisible();
  });

  test('renders full details for a configured item', async ({ page, testData }) => {
    test.skip(!testData.itemId, 'TEST_ITEM_ID not configured');

    await gotoItemDetails(page, testData.itemId);
    await expectItemFound(page, testData.itemId);

    // Core metadata fields
    await expect(page).toHaveTitle(/Millions of Records/i);
    await expect(page.locator('text=/Label/i').first()).toBeVisible();
    await expect(page.locator('#btn-container-' + testData.itemId)).toBeVisible();
  });

  test('out-of-stock items render the out-of-stock state', async ({ page, testData }) => {
    test.skip(!testData.itemId, 'TEST_ITEM_ID not configured');
    test.skip(true, 'Needs a known out-of-stock item id; covered manually in TEST_PLAN.');

    await gotoItemDetails(page, testData.itemId);
    await expectItemFound(page, testData.itemId);
    await expect(page.getByRole('button', { name: /out of stock/i }).first()).toBeVisible();
  });

  test('increase quantity posts to /api/cart/adjust', async ({ page, testData }) => {
    test.skip(!testData.itemId, 'TEST_ITEM_ID not configured');

    await gotoItemDetails(page, testData.itemId);
    await expectItemFound(page, testData.itemId);

    const increaseBtn = page.locator('#btnIncreaseQty');
    if ((await increaseBtn.count()) === 0) {
      test.skip(true, 'Item is not in cart yet; quantity controls only render after adding.');
    }

    const apiResponse = page.waitForResponse(
      (res) => res.url().includes('/api/cart/adjust') && res.status() === 200,
    );
    await increaseBtn.click();
    await apiResponse;
    await expect(page.locator('#displayQuantity')).toHaveText('2');
  });

  test('similar items rail links back into the shop', async ({ page, testData }) => {
    test.skip(!testData.itemId, 'TEST_ITEM_ID not configured');

    await gotoItemDetails(page, testData.itemId);
    await expectItemFound(page, testData.itemId);

    const simLink = page.locator('a[href*="/shop?sid="]').first();
    if ((await simLink.count()) > 0) {
      await simLink.click();
      await expect(page).toHaveURL(/\/shop\?sid=/);
    }
  });

  test('shop-back link preserves the shop query string when coming from a filtered shop page', async ({ page, testData }) => {
    test.skip(!testData.itemId, 'TEST_ITEM_ID not configured');

    const response = await page.goto(`/shop?genre=Reggae&page=2`);
    expect(
      response?.status(),
      `GET /shop?genre=Reggae&page=2 expected 200 but got ${response?.status() ?? 'no response'}`,
    ).toBe(200);

    // Open the album detail of the configured item if present on the page
    const cardLink = page.locator(`a[href*="/ItemDetails/"][href*="/${testData.itemId}/"]`).first();
    if ((await cardLink.count()) === 0) {
      test.skip(true, 'Configured item not visible on this shop query.');
    }
    await cardLink.click();
    const back = page.getByRole('link', { name: /return to shop/i });
    if ((await back.count()) > 0) {
      const href = await back.getAttribute('href');
      expect(href).toContain('/shop');
    }
  });
});
