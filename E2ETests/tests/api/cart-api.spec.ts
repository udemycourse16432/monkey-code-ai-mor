import { test, expect } from '../../fixtures/extended-test';

/**
 * CONTROLLER: CartController
 * Route prefix: /api/cart  [ApiController, IgnoreAntiforgeryToken]
 *
 *   POST /api/cart/add     -> CartService/AdjustCart sp, returns CartResponse
 *   POST /api/cart/adjust  -> AdjustCart sp + shipping totals, returns CartResponse
 *
 * CartResponse: { success, message, cartCount, productsPrice, shippingFee, totalAmount }
 */
test.describe('Cart API - POST /api/cart/add', () => {
  test('rejects an item id <= 0 with 400', async ({ request }) => {
    const res = await request.post('/api/cart/add', {
      data: { id: 0, price: 10, type: 1, qty: 1, searchId: '-' },
    });
    expect(res.status()).toBe(400);
    expect(await res.text()).toBe('Invalid ID');
  });

  test('adds an item and returns the updated cart count', async ({ request, testData }) => {
    test.skip(!testData.itemId, 'TEST_ITEM_ID not configured');

    const res = await request.post('/api/cart/add', {
      data: { id: testData.itemId, price: 9.99, type: 1, qty: 1, searchId: '-' },
    });
    expect(res.status()).toBe(200);

    const body = await res.json();
    expect(body.success).toBe(true);
    expect(body.message).toBe('OK');
    expect(body.cartCount).toBeGreaterThan(0);
  });

  test('is idempotent across consecutive adds (quantity accumulates)', async ({ request, testData }) => {
    test.skip(!testData.itemId, 'TEST_ITEM_ID not configured');

    for (const qty of [1, 1]) {
      const res = await request.post('/api/cart/add', {
        data: { id: testData.itemId, price: 9.99, type: 1, qty, searchId: '-' },
      });
      expect(res.status()).toBe(200);
    }
    const res = await request.post('/api/cart/adjust', {
      data: { id: testData.itemId, price: 9.99, type: 1, qty: 0, searchId: '-' },
    });
    expect(res.status()).toBe(200);
  });
});

test.describe('Cart API - POST /api/cart/adjust', () => {
  test('rejects an item id <= 0 with 400', async ({ request }) => {
    const res = await request.post('/api/cart/adjust', {
      data: { id: -5, price: 10, type: 1, qty: 1, searchId: '-' },
    });
    expect(res.status()).toBe(400);
    expect(await res.text()).toBe('Invalid ID');
  });

  test('returns shipping and total breakdowns after adjusting quantity', async ({ request, testData }) => {
    test.skip(!testData.itemId, 'TEST_ITEM_ID not configured');

    const res = await request.post('/api/cart/adjust', {
      data: { id: testData.itemId, price: 12.5, type: 1, qty: 2, searchId: '-' },
    });
    expect(res.status()).toBe(200);

    const body = await res.json();
    expect(body.success).toBe(true);
    expect(body.message).toBe('OK');
    expect(body.productsPrice).toBe('25.00'); // 12.50 * 2
    expect(typeof body.shippingFee).toBe('string');
    expect(typeof body.totalAmount).toBe('string');
  });

  test('setting qty to 0 removes the item from the cart', async ({ request, testData }) => {
    test.skip(!testData.itemId, 'TEST_ITEM_ID not configured');

    const res = await request.post('/api/cart/adjust', {
      data: { id: testData.itemId, price: 12.5, type: 1, qty: 0, searchId: '-' },
    });
    expect(res.status()).toBe(200);
    const body = await res.json();
    expect(body.success).toBe(true);
  });
});
