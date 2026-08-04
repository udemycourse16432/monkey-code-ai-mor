import { Page } from '@playwright/test';

/**
 * Adds an album to the cart from the Shop page by clicking its "Add to Cart"
 * button. The card markup uses `id="btn-container-<itemId>"` for the wrapper.
 *
 * @param page  A page that is already on /shop
 * @param itemId  Inventory id of the album
 */
export async function addToCartFromShop(page: Page, itemId: number): Promise<void> {
  const container = page.locator(`#btn-container-${itemId}`);
  await container.waitFor({ state: 'visible' });
  await container.getByRole('button', { name: /add to cart|add/i }).click();

  // Toast confirms the item was added ("...has been successfully added to your cart.")
  await page.locator('.toast-message').filter({ hasText: /successfully added/ }).first().waitFor({ timeout: 10_000 });
}

/**
 * Reads the cart count badge shown in the header (#cartCount).
 */
export async function getHeaderCartCount(page: Page): Promise<number> {
  const el = page.locator('#cartCount');
  await el.waitFor({ state: 'visible' });
  return Number(await el.innerText());
}
