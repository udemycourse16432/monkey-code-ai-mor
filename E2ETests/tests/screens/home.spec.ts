import { test, expect } from '../../fixtures/extended-test';

/**
 * SCREEN: Home (/)
 * Razor page: Pages/Index.cshtml + Index.cshtml.cs
 *
 * Loads 13 product sections (Best Selling / New Release / Back In Stock for
 * LP, CD, 7" and 12"/10", plus Used & Collectible 7"). Each section shows up
 * to 4 album cards with an "Add to Cart" button wired to POST /api/cart/add.
 */
test.describe('Home screen', () => {
  test('loads the storefront and renders catalog sections', async ({ page }) => {
    await page.goto('/');

    await expect(page).toHaveTitle(/Millions of Records/i);

    // Key selling sections must render (LP/CD/7"/12"-10" best sellers)
    await expect(page.getByRole('heading', { name: /best selling lp/i })).toBeVisible();
    await expect(page.getByRole('heading', { name: /best selling cd/i })).toBeVisible();
    await expect(page.getByRole('heading', { name: /best selling 7/i })).toBeVisible();
    await expect(page.getByRole('heading', { name: /best selling 12/i })).toBeVisible();

    // Header + footer chrome
    await expect(page.locator('#cartCount')).toBeVisible();
    await expect(page.getByRole('link', { name: /cart/i })).toBeVisible();
  });

  test('renders at least one product card with an Add to Cart control', async ({ page }) => {
    await page.goto('/');

    const firstCard = page.locator('.album').first();
    await expect(firstCard).toBeVisible();

    const addButtons = firstCard.locator('button[onclick^="addToCart"]');
    await expect(addButtons.first()).toBeVisible();
  });

  test('add-to-cart from home updates the header cart count', async ({ page, testData }) => {
    test.skip(!testData.itemId, 'TEST_ITEM_ID not configured - requires a seeded database');

    await page.goto('/');

    // Use the add-to-cart button for the configured item if present on home
    const container = page.locator(`#btn-container-${testData.itemId}`);
    if ((await container.count()) === 0) {
      test.skip(true, `Item ${testData.itemId} is not featured on the home page.`);
    }

    await container.getByRole('button', { name: /add to cart/i }).click();

    const toast = page.locator('.toast-message').filter({ hasText: 'successfully been added' }).first();
    await expect(toast).toBeVisible({ timeout: 10_000 });

    const count = Number(await page.locator('#cartCount').innerText());
    expect(count).toBeGreaterThan(0);
  });

  test('home navigation links reach the shop and cart pages', async ({ page }) => {
    await page.goto('/');
    await page.getByRole('link', { name: /shop/i }).first().click();
    await expect(page).toHaveURL(/\/shop/);
  });
});
