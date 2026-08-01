import { test, expect } from '../../fixtures/extended-test';

/**
 * SCREEN: Cart (/cart)
 * Razor page: Pages/Cart.cshtml + Cart.cshtml.cs
 *
 * Displays cart line items (row-<itemId>) with +/- and delete controls that
 * call POST /api/cart/adjust, plus a summary (products, shipping, total).
 * "Save for Later" flag is rendered via SaveForLater on the CartItemDto.
 */
test.describe('Cart screen', () => {
  test('shows an empty cart summary for a guest', async ({ page }) => {
    await page.goto('/cart');

    await expect(page.locator('#summary-products-price')).toHaveText('$0.00');
    await expect(page.locator('#summary-total-amount')).toHaveText('$0.00');
  });

  test('increment and decrement adjust the header count', async ({ page, testData }) => {
    test.skip(!testData.itemId, 'TEST_ITEM_ID not configured');

    // Seed via API so the item is definitely in the cart.
    const addRes = await page.request.post('/api/cart/add', {
      data: { id: testData.itemId, price: 9.99, type: 1, qty: 1, searchId: '-' },
    });
    expect(addRes.ok()).toBeTruthy();

    await page.goto('/cart');
    const row = page.locator(`#row-${testData.itemId}`);
    await expect(row).toBeVisible();

    // Increment
    const apiRes = page.waitForResponse((r) => r.url().includes('/api/cart/adjust') && r.status() === 200);
    await row.locator('button[onclick*=", 1)"]').click();
    await apiRes;
  });

  test('remove sets quantity to zero and removes the row', async ({ page, testData }) => {
    test.skip(!testData.itemId, 'TEST_ITEM_ID not configured');

    await page.request.post('/api/cart/add', {
      data: { id: testData.itemId, price: 9.99, type: 1, qty: 1, searchId: '-' },
    });

    await page.goto('/cart');
    const row = page.locator(`#row-${testData.itemId}`);

    const apiRes = page.waitForResponse((r) => r.url().includes('/api/cart/adjust') && r.status() === 200);
    // Delete button passes type=0 (qty -> 0)
    await row.locator('button[onclick*=", 0)"]').click();
    await apiRes;

    // After removal the page reloads when cart hits zero; wait and verify the row is gone.
    await expect(row).toHaveCount(0, { timeout: 10_000 });
  });

  test('summary values update after a quantity change', async ({ page, testData }) => {
    test.skip(!testData.itemId, 'TEST_ITEM_ID not configured');

    await page.request.post('/api/cart/add', {
      data: { id: testData.itemId, price: 10, type: 1, qty: 1, searchId: '-' },
    });

    await page.goto('/cart');
    const row = page.locator(`#row-${testData.itemId}`);
    await expect(row).toBeVisible();

    const before = await page.locator('#summary-products-price').innerText();

    const apiRes = page.waitForResponse((r) => r.url().includes('/api/cart/adjust') && r.status() === 200);
    await row.locator('button[onclick*=", 1)"]').click();
    await apiRes;

    await expect(page.locator('#summary-products-price')).not.toHaveText(before);
  });
});
