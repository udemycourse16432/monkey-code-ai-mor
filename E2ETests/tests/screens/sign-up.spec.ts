import { test, expect } from '../../fixtures/extended-test';
import { TestData } from '../../fixtures/test-data';

/**
 * SCREEN: Sign Up (/sign-up?CountryListCode=<counter>&WholesaleOrRetailTxt=<r|w>)
 * Razor page: Pages/SignUp.cshtml + SignUp.cshtml.cs
 *
 * Multi-field account creation with dynamic country/zone validation
 * (city/state/postal requirements per shipping zone), "Same as Shipping"
 * checkbox, wholesale vs retail price groups, and guest-cart migration on
 * success (auto-login -> /WholesaleAccepted).
 *
 * NOTE: Successful registration inserts a real customer row. Tests that
 * register use a unique email per run so re-runs do not collide. Cleanup of
 * created customers must be done in the DB if desired.
 */
test.describe('Sign Up screen', () => {
  const signupUrl = `/sign-up?CountryListCode=${TestData.countryCounter}&WholesaleOrRetailTxt=retail&ContinueToPurchasePage=no`;

  test('redirects to sign-in when no country context is provided', async ({ page }) => {
    await page.goto('/sign-up');
    await expect(page).toHaveURL(/\/sign-in/);
  });

  test('renders the shipping + billing form', async ({ page }) => {
    await page.goto(signupUrl);

    await expect(page.locator('input[name="Input.EmailAddress"]')).toBeVisible();
    await expect(page.locator('input[name="Input.FullName"]')).toBeVisible();
    await expect(page.locator('input[name="Input.Country"]')).toBeVisible();
    await expect(page.getByRole('checkbox', { name: /same as shipping/i })).toBeVisible();
  });

  test('requires a password of at least 6 characters', async ({ page }) => {
    await page.goto(signupUrl);

    const email = `qa-invalid-${Date.now()}@example.com`;
    await fillSignupCore(page, email, '123');
    await page.getByRole('button', { name: /create account|sign up|register/i }).first().click();

    await expect(page.locator('text=Password must be at least 6 characters').first()).toBeVisible();
  });

  test('rejects an already-registered email address', async ({ page, envConfig }) => {
    test.skip(!envConfig.userEmail, 'TEST_USER_EMAIL not configured');

    await page.goto(signupUrl);
    await fillSignupCore(page, envConfig.userEmail, 'ValidPass123');
    await page.getByRole('button', { name: /create account|sign up|register/i }).first().click();

    await expect(page.locator('text=already registered').first()).toBeVisible();
  });

  test('registers a new retail account and lands on the wholesale-accepted page', async ({ page }) => {
    const email = `qa-retail-${Date.now()}@example.com`;
    await page.goto(signupUrl);

    await fillSignupCore(page, email, 'ValidPass123');
    await page.getByRole('button', { name: /create account|sign up|register/i }).first().click();

    // Auto-login after insert redirects to /WholesaleAccepted
    await expect(page).toHaveURL(/wholesale-accepted/i, { timeout: 15_000 });
  });
});

/** Fills the required core fields for a retail signup (US defaults). */
async function fillSignupCore(page: import('@playwright/test').Page, email: string, password: string) {
  await page.locator('input[name="Input.EmailAddress"]').fill(email);
  await page.locator('input[name="Input.TelephoneNumber"]').fill(TestData.signup.telephone);
  await page.locator('input[name="Input.Password"]').fill(password);
  await page.locator('input[name="Input.FullName"]').fill(TestData.signup.fullName);
  await page.locator('input[name="Input.StreetAddress1"]').fill(TestData.signup.streetAddress1);
  await page.locator('input[name="Input.City"]').fill(TestData.signup.city);
  await page.locator('input[name="Input.StateOrProvince"]').selectOption(TestData.signup.stateProvince);
  await page.locator('input[name="Input.PostalCode"]').fill(TestData.signup.postalCode);
}
