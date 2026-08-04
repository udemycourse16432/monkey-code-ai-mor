import { test, expect } from '../../fixtures/extended-test';

/**
 * SCREEN: Home (/)
 * Razor page: Pages/Index.cshtml + Index.cshtml.cs
 *
 * Loads 13 product sections (Best Selling / New Release / Back In Stock for
 * LP, CD, 7" and 12"/10", plus Used & Collectible 7"). Each section shows up
 * to 4 album cards (_AlbumCard partial) with an "Add to Cart" button wired to
 * POST /api/cart/add.
 *
 * Locator contract: data-testid attributes injected in step 1 of the E2E
 * readiness work (see E2ETests/testids/index.json). Prefer user-facing roles
 * (getByRole/getByPlaceholder) where available; use getByTestId for dynamic,
 * icon-only, or repeating-loop elements.
 *
 * Tests that depend on a seeded database self-skip when TEST_ITEM_ID is not
 * configured - see fixtures/test-data.ts and helpers/env.ts.
 */

// Section wrappers carry `index-category-<sectionKey>`; the inner heading is
// `index-category-title`. The negative lookahead keeps the two apart.
const sectionTestId = /^index-category-(?!title$)/;
// Matches only the card wrapper (`product-card-<id>`), not child testids
// like `product-card-price-<id>` or `product-card-label-<id>`.
const productCardTestId = /^product-card-\d+$/;

const topMenuLabels = [
  'Home',
  'My Account',
  'Your Orders',
  'Shipping & Payment',
  'Customer Service & Returns',
  'Wholesale',
  'About Us',
];

test.describe('Home screen', () => {
  test.describe('Shell & layout', () => {
    test('loads with 200, correct title and semantic landmarks', async ({ page }) => {
      const res = await page.goto('/');
      expect(res?.status()).toBe(200);

      await expect(page).toHaveTitle(/Millions of Records/i);
      await expect(page.getByRole('banner')).toBeVisible();
      await expect(page.getByRole('navigation').first()).toBeVisible();
      await expect(page.getByRole('main')).toBeVisible();
      await expect(page.getByRole('contentinfo')).toBeVisible();
    });

    test('removes the global loader after page load', async ({ page }) => {
      await page.goto('/');
      await expect(page.getByTestId('layout-global-loader')).toBeHidden({ timeout: 15_000 });
    });

    test('renders account, cart and mobile-toggle header chrome', async ({ page }) => {
      await page.goto('/');
      await expect(page.getByTestId('nav-account-link')).toBeVisible();
      await expect(page.getByTestId('nav-cart-link')).toBeVisible();
      // The hamburger only becomes visible at mobile widths; assert presence here.
      await expect(page.getByTestId('nav-mobile-toggle')).toHaveCount(1);
    });

    test('cart badge starts at 0 on a fresh session', async ({ page }) => {
      await page.goto('/');
      await expect(page.getByTestId('nav-cart-count')).toHaveText('0');
    });
  });

  test.describe('Hero banner', () => {
    test('renders heading, tagline and Explore Now link', async ({ page }) => {
      await page.goto('/');

      await expect(page.getByRole('heading', { level: 1 })).toContainText(/worldwide mail-order/i);
      await expect(page.getByText(/first-rate service/i)).toBeVisible();

      const explore = page.getByRole('link', { name: 'Explore Now' });
      await expect(explore).toBeVisible();
      await expect(explore).toHaveAttribute('href', '#homeAlbumsSection');
    });
  });

  test.describe('Catalog sections', () => {
    test('renders all catalog sections with non-empty titles', async ({ page }) => {
      await page.goto('/');

      const sections = page.getByTestId(sectionTestId);
      await expect(sections).toHaveCount(13);

      const count = await sections.count();
      for (let i = 0; i < count; i++) {
        await expect(sections.nth(i).getByTestId('index-category-title')).not.toBeEmpty();
      }
    });

    test('renders between 1 and 4 product cards per section', async ({ page }) => {
      await page.goto('/');

      const sections = page.getByTestId(sectionTestId);
      const count = await sections.count();
      expect(count).toBe(13);

      for (let i = 0; i < count; i++) {
        const cards = sections.nth(i).getByTestId(productCardTestId);
        await expect(cards.first()).toBeVisible();
        expect(await cards.count()).toBeGreaterThanOrEqual(1);
        expect(await cards.count()).toBeLessThanOrEqual(4);
      }
    });

    test('each section exposes a Show all link with correct shop params', async ({ page }) => {
      await page.goto('/');

      const sections = page.getByTestId(sectionTestId);
      // First section is "Best Selling LPs": format=LP, order=3 (Best Sellers), useditem=n.
      await expect(sections.first().getByRole('link', { name: 'Show all' })).toHaveAttribute(
        'href',
        /format=LP&order=3&useditem=n/,
      );

      const count = await sections.count();
      for (let i = 0; i < count; i++) {
        await expect(sections.nth(i).getByRole('link', { name: 'Show all' })).toBeVisible();
      }
    });
  });

  test.describe('Product cards', () => {
    test('renders complete card anatomy for the first product', async ({ page }) => {
      await page.goto('/');

      const card = page.getByTestId(productCardTestId).first();
      await expect(card).toBeVisible();

      const cardId = (await card.getAttribute('data-testid'))?.replace('product-card-', '');
      expect(cardId).toMatch(/^\d+$/);

      // Cover links to the SEO album-details route and carries a meaningful alt.
      await expect(card.locator('figure a')).toHaveAttribute('href', /\/ItemDetails\//);
      await expect(card.locator('figure img')).toHaveAttribute('alt', /.+/);

      // Price is rendered as $d.dd.
      await expect(card.getByTestId(`product-card-price-${cardId}`)).toHaveText(/^\$\d+\.\d{2}$/);

      // Fresh session -> card shows the add-to-cart control.
      await expect(card.getByRole('button', { name: /add to cart/i })).toBeVisible();
    });

    test('shop drill-down links carry the correct query params', async ({ page }) => {
      await page.goto('/');

      const card = page.getByTestId(productCardTestId).first();
      const cardId = (await card.getAttribute('data-testid'))?.replace('product-card-', '');

      await expect(card.locator('.circle a')).toHaveAttribute('href', /shop\?Format=/i);
      await expect(card.locator('h5 a').first()).toHaveAttribute('href', /shop\?artist=/i);
      await expect(card.getByTestId(`product-card-label-${cardId}`)).toHaveAttribute('href', /shop\?label=/i);
      await expect(card.getByRole('link', { name: 'Similar Items' })).toHaveAttribute('href', /shop\?sid=/);
    });
  });

  test.describe('Header navigation & state', () => {
    test('top-nav links are present and reach their pages', async ({ page }) => {
      await page.goto('/');

      // First `ul.nav` in the header is the top menu; the footer repeats these labels.
      const menu = page.locator('header ul.nav').first();
      for (const label of topMenuLabels) {
        await expect(menu.getByRole('link', { name: label })).toBeVisible();
      }

      await menu.getByRole('link', { name: 'Wholesale' }).click();
      await expect(page).toHaveURL(/\/wholesale/);

      await page.goto('/');
      await page.locator('header ul.nav').first().getByRole('link', { name: 'About Us' }).click();
      await expect(page).toHaveURL(/\/about-us/);
    });

    test('logged-out header shows Sign In / Sign Up and account link to /sign-in', async ({ page }) => {
      await page.goto('/');

      await expect(page.getByRole('link', { name: 'Sign In' })).toBeVisible();
      await expect(page.getByRole('link', { name: 'Sign Up' })).toBeVisible();
      await expect(page.getByRole('link', { name: 'Sign Out' })).toHaveCount(0);
      await expect(page.getByTestId('nav-account-link')).toHaveAttribute('href', '/sign-in');
    });

    test('cart link navigates to /cart', async ({ page }) => {
      await page.goto('/');
      await page.getByTestId('nav-cart-link').click();
      await expect(page).toHaveURL(/\/cart/);
    });
  });

  test.describe('Search suggestions', () => {
    test('short queries keep suggestions hidden', async ({ page }) => {
      await page.goto('/');
      await page.getByPlaceholder(/Search for Anything!/).fill('a');
      await expect(page.getByTestId('nav-search-suggestions')).toBeHidden();
    });

    test('queries of 3+ characters reveal suggestions and the clear button', async ({ page }) => {
      await page.goto('/');
      const input = page.getByPlaceholder(/Search for Anything!/);

      await input.fill('abc');
      await expect(page.getByTestId('nav-search-clear')).toBeVisible();
      await expect(page.getByTestId('nav-search-suggestions')).toBeVisible();
    });

    test('suggestion tabs switch between panes', async ({ page }) => {
      await page.goto('/');
      await page.getByPlaceholder(/Search for Anything!/).fill('abc');

      await expect(page.getByTestId('nav-search-suggestions')).toBeVisible();

      await page.getByRole('tab', { name: 'Artists' }).click();
      await expect(page.getByTestId('nav-search-suggestions-artists')).toHaveClass(/active/);

      await page.getByRole('tab', { name: 'Albums' }).click();
      await expect(page.getByTestId('nav-search-suggestions-albums')).toHaveClass(/active/);
    });

    test('clear button empties the query and hides suggestions', async ({ page }) => {
      await page.goto('/');
      const input = page.getByPlaceholder(/Search for Anything!/);

      await input.fill('abc');
      await expect(page.getByTestId('nav-search-suggestions')).toBeVisible();

      await page.getByTestId('nav-search-clear').click();

      await expect(input).toHaveValue('');
      await expect(page.getByTestId('nav-search-suggestions')).toBeHidden();
      await expect(page.getByTestId('nav-search-clear')).toBeHidden();
    });
  });

  test.describe('Category content popup', () => {
    test('opens with loaded content and closes', async ({ page }) => {
      await page.goto('/');

      await page.getByRole('button', { name: 'Reggae' }).click();

      const popup = page.getByTestId('nav-content-popup');
      await expect(popup).toBeVisible();
      // JS replaces the placeholder title with "<Title> (<count>)".
      await expect(popup.getByTestId('nav-content-popup-title')).not.toHaveText('>Loading...', {
        timeout: 15_000,
      });
      await expect(popup.getByTestId('nav-content-popup-body')).not.toBeEmpty({ timeout: 15_000 });

      await popup.getByTestId('nav-content-popup-close').click();
      await expect(popup).toBeHidden();
    });
  });

  test.describe('Footer', () => {
    test('renders logo, menu, contact and social links', async ({ page }) => {
      await page.goto('/');

      const footer = page.getByRole('contentinfo');
      await expect(footer.getByTestId('footer-logo')).toHaveAttribute('href', '/');

      for (const label of topMenuLabels) {
        await expect(footer.getByRole('link', { name: label })).toBeVisible();
      }

      await expect(footer.getByRole('link', { name: /916-586-9410/ })).toHaveAttribute('href', 'tel:9165869410');
      await expect(footer.getByRole('link', { name: /ernnieb12345@gmail.com/ })).toHaveAttribute(
        'href',
        'mailto:ernnieb12345@gmail.com',
      );

      const socials: Array<[string, RegExp]> = [
        ['footer-social-facebook', /facebook\.com/],
        ['footer-social-twitter', /x\.com/],
        ['footer-social-instagram', /instagram\.com/],
        ['footer-social-youtube', /youtube\.com/],
      ];
      for (const [testid, host] of socials) {
        const link = footer.getByTestId(testid);
        await expect(link).toHaveAttribute('target', '_blank');
        await expect(link).toHaveAttribute('href', host);
      }
    });
  });

  test.describe('Extras', () => {
    test('shows the newsletter section to logged-out users', async ({ page }) => {
      await page.goto('/');

      await expect(page.getByRole('heading', { name: 'Never Miss a Beat' })).toBeVisible();
      await expect(page.getByPlaceholder('Enter Email Address')).toBeVisible();
      await expect(page.getByRole('button', { name: 'Sign Up' })).toBeVisible();
    });

    test('back-to-top button appears on scroll and returns to the top', async ({ page }) => {
      await page.setViewportSize({ width: 1280, height: 800 });
      await page.goto('/');

      const btn = page.getByTestId('scroll-to-top');
      await expect(btn).toBeHidden();

      await page.mouse.wheel(0, 800);
      await expect(btn).toBeVisible();

      // Album images can overlap the fixed button (missing z-index); force the
      // click so the scroll-to-top handler still fires.
      await btn.click({ force: true });
      await expect
        .poll(() => page.evaluate(() => window.scrollY), { timeout: 10_000 })
        .toBeLessThan(10);
    });

    test('mobile menu toggle toggles the nav menu', async ({ page }) => {
      await page.setViewportSize({ width: 390, height: 844 });
      await page.goto('/');

      const toggle = page.getByTestId('nav-mobile-toggle');
      const nav = page.locator('#nav');

      await toggle.click();
      await expect(toggle).toHaveClass(/is-active/);
      await expect(nav).toHaveClass(/is-active/);

      await toggle.click();
      await expect(toggle).not.toHaveClass(/is-active/);
      await expect(nav).not.toHaveClass(/is-active/);
    });
  });

  test.describe('Robustness', () => {
    test('reports no uncaught page errors on load', async ({ page }) => {
      const errors: string[] = [];
      page.on('pageerror', (err) => errors.push(err.message));

      await page.goto('/');
      await expect(page.getByTestId(productCardTestId).first()).toBeVisible();

      expect(errors).toEqual([]);
    });

    test('renders without broken images', async ({ page }) => {
      await page.goto('/');

      // Wait until every <img> has finished loading (or failed).
      await expect
        .poll(() => page.evaluate(() => Array.from(document.images).filter((i) => !i.complete).length), {
          timeout: 15_000,
        })
        .toBe(0);

      const broken = await page.evaluate(() =>
        Array.from(document.images)
          .filter((i) => i.complete && i.naturalWidth === 0)
          .map((i) => i.currentSrc || i.src),
      );
      expect(broken).toEqual([]);
    });
  });

  test.describe('Cart flow', () => {
    test('add-to-cart from home updates the header cart count and card state', async ({ page, testData }) => {
      test.skip(!testData.itemId, 'TEST_ITEM_ID not configured - requires a seeded database');

      await page.goto('/');

      const card = page.getByTestId(`product-card-${testData.itemId}`);
      if ((await card.count()) === 0) {
        test.skip(true, `Item ${testData.itemId} is not featured on the home page.`);
      }

      await card.getByRole('button', { name: /add to cart/i }).click();

      const toast = page
        .locator('.toast-message')
        .filter({ hasText: /successfully added/i })
        .first();
      await expect(toast).toBeVisible({ timeout: 10_000 });

      const count = Number(await page.getByTestId('nav-cart-count').innerText());
      expect(count).toBeGreaterThan(0);

      // Server-side cart persists in the session -> card now renders the in-cart state.
      await page.reload();
      await expect(card.getByRole('link', { name: /in your cart/i })).toBeVisible();
    });
  });
});
