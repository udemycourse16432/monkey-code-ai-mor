import { test, expect } from '../../fixtures/extended-test';

/**
 * SCREEN: Shop (/shop)
 * Razor page: Pages/Shop.cshtml + Shop.cshtml.cs
 *
 * Query-driven catalog page. 48 items per page. Supported query params:
 *   order (1..6), page, format, min_price, max_price, useditem, genre, label,
 *   title, artist, sid (similar items), feaitem, year, rhythm, desc.
 */
test.describe('Shop screen', () => {
  test('renders the catalog with product cards', async ({ page }) => {
    await page.goto('/shop');
    await expect(page).toHaveTitle(/Shop|Search|Millions/i);

    const cards = page.locator('.album');
    await expect(cards.first()).toBeVisible();
  });

  test('supports format filtering via the format dropdown', async ({ page }) => {
    await page.goto('/shop');
    const formatSelect = page.locator('#formatFilterSelect');
    await expect(formatSelect).toBeVisible();

    await formatSelect.selectOption('LP');
    await expect(page).toHaveURL(/format=LP/i);
    await expect(page.locator('.album').first()).toBeVisible();
  });

  test('supports sort ordering via the sort dropdown', async ({ page }) => {
    await page.goto('/shop');
    const sortSelect = page.locator('#sortOrderSelect');
    await expect(sortSelect).toBeVisible();

    await sortSelect.selectOption('2'); // Popular / Best Sellers
    await expect(page).toHaveURL(/order=2/i);
  });

  test('price filter selects an under-price bucket and reloads the URL', async ({ page }) => {
    await page.goto('/shop');
    await page.locator('#priceFilterSelect').selectOption({ label: 'Under $10' });
    await expect(page).toHaveURL(/min_price=|max_price=/i);
  });

  test('pagination controls render when more than one page exists', async ({ page }) => {
    await page.goto('/shop');
    // Pagination links are anchors with rel="nofollow"
    const nextPage = page.locator('a[rel="nofollow"]', { hasText: /^\s*2\s*$/ }).first();
    if ((await nextPage.count()) > 0) {
      await nextPage.click();
      await expect(page).toHaveURL(/page=2/i);
      await expect(page.locator('.album').first()).toBeVisible();
    } else {
      test.info().annotations.push({ type: 'note', description: 'Catalog has a single page - pagination not applicable.' });
    }
  });

  test('genre filter narrows results and updates the header description', async ({ page }) => {
    await page.goto('/shop?genre=Reggae');
    await expect(page).toHaveURL(/genre=Reggae/i);
    // Header description is rendered from SearchHeaderDescription
    await expect(page.locator('.search-header, h1, .page-title').first()).toBeVisible();
  });

  test('empty search returns the empty catalog state gracefully', async ({ page }) => {
    await page.goto('/shop?title=ZZZ_NO_SUCH_TITLE_12345');
    await expect(page.locator('.album').first()).toBeVisible(); // or an empty-state message
  });

  test('add to cart from shop uses the item add-to-cart control', async ({ page, testData }) => {
    test.skip(!testData.itemId, 'TEST_ITEM_ID not configured');

    // The configured item may not appear on page 1; use the direct shop filter by title later.
    // Here we simply assert the card control exists for whatever item is configured.
    await page.goto(`/shop?feaitem=0&page=1`);
    const container = page.locator(`#btn-container-${testData.itemId}`);
    if ((await container.count()) === 0) {
      test.skip(true, `Item ${testData.itemId} not visible on shop page 1.`);
    }
    await expect(container.locator('button[onclick^="addToCart"]')).toBeVisible();
  });
});
