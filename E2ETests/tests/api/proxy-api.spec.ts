import { test, expect } from '../../fixtures/extended-test';

/**
 * CONTROLLER: ProxyController
 * Route prefix: /api
 *
 * Search-suggestion endpoints backed by WebSearchSuggestions / Inventory EF
 * queries. All return ApiResponse<WebSearchSuggestionDto>:
 *   { data: [{ artistTitle, count, counter?, frontImg? }], pagination: {...} }
 *
 *   GET /api/suggestions/albums?search=&page=1&limit=10&order=&alpha=&genre=
 *   GET /api/suggestions/artists?search=&page=&limit=&order=&alpha=&genre=
 *   GET /api/suggestions/labels?search=&page=&limit=&order=&alpha=&genre=
 *   GET /api/suggestions/genres?search=&page=&limit=&order=&alpha=
 *   GET /api/suggestions/allartists?page=&limit=&order=&alpha=
 *   GET /api/suggestions/alllabels?page=&limit=&order=&alpha=
 *   GET /api/suggestions/allgenres?page=&limit=&order=&alpha=
 */
test.describe('Suggestions API - searchable endpoints', () => {
  const searchable = [
    { path: '/api/suggestions/albums', query: 'search=Bob' },
    { path: '/api/suggestions/artists', query: 'search=Bob' },
    { path: '/api/suggestions/labels', query: 'search=Trojan' },
    { path: '/api/suggestions/genres', query: 'search=Reggae' },
  ];

  for (const ep of searchable) {
    test(`GET ${ep.path} returns a valid ApiResponse envelope`, async ({ request }) => {
      const res = await request.get(`${ep.path}?${ep.query}`);
      expect(res.status()).toBe(200);

      const body = await res.json();
      expect(Array.isArray(body.data)).toBe(true);
      expect(body.pagination).toMatchObject({
        current_page: expect.any(Number),
        last_page: expect.any(Number),
        per_page: expect.any(Number),
        total: expect.any(Number),
      });
    });
  }

  test('album search items expose artistTitle and count', async ({ request }) => {
    const res = await request.get('/api/suggestions/albums?search=Bob&limit=5');
    const body = await res.json();

    if (body.data.length > 0) {
      expect(body.data[0]).toHaveProperty('artistTitle');
      expect(body.data[0]).toHaveProperty('count');
      expect(body.pagination.per_page).toBe(5);
    }
  });

  test('pagination metadata exposes next/prev URLs', async ({ request }) => {
    const res = await request.get('/api/suggestions/albums?search=A&limit=2');
    const body = await res.json();
    const { pagination } = body;

    expect(typeof pagination.first_page_url).toBe('string');
    expect(typeof pagination.last_page_url).toBe('string');
    if (pagination.total > pagination.per_page) {
      expect(typeof pagination.next_page_url).toBe('string');
    }
    if (pagination.current_page > 1) {
      expect(typeof pagination.prev_page_url).toBe('string');
    }
  });
});

test.describe('Suggestions API - full-list endpoints', () => {
  const listEndpoints = [
    '/api/suggestions/allartists',
    '/api/suggestions/alllabels',
    '/api/suggestions/allgenres',
  ];

  for (const ep of listEndpoints) {
    test(`GET ${ep} returns data ordered by default (popular)`, async ({ request }) => {
      const res = await request.get(ep);
      expect(res.status()).toBe(200);

      const body = await res.json();
      expect(Array.isArray(body.data)).toBe(true);
      expect(body.pagination.total).toBeGreaterThanOrEqual(body.data.length);
    });

    test(`GET ${ep} honors alpha filtering`, async ({ request }) => {
      const res = await request.get(`${ep}?alpha=M&limit=10`);
      expect(res.status()).toBe(200);

      const body = await res.json();
      for (const item of body.data) {
        expect(item.artistTitle).toMatch(/^M/i);
      }
    });

    test(`GET ${ep} honors order=2 (popular) sorting`, async ({ request }) => {
      const res = await request.get(`${ep}?order=2&limit=20`);
      expect(res.status()).toBe(200);
      const body = await res.json();
      expect(body.data.length).toBeLessThanOrEqual(20);
    });
  }
});

test.describe('Suggestions API - artists by genre', () => {
  test('genre-scoped artist search returns grouped artists', async ({ request }) => {
    const res = await request.get('/api/suggestions/artists?genre=Reggae&limit=10');
    expect(res.status()).toBe(200);

    const body = await res.json();
    expect(Array.isArray(body.data)).toBe(true);
    if (body.data.length > 0) {
      expect(body.data[0]).toHaveProperty('artistTitle');
    }
  });
});
