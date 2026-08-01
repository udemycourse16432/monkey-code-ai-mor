import { Page } from '@playwright/test';

/**
 * Sign in through the UI. Assumes the SignIn page is reachable at /sign-in.
 * Returns true when the resulting redirect indicates a successful login
 * (i.e. the URL no longer contains /sign-in).
 */
export async function signInViaUi(page: Page, email: string, password: string): Promise<void> {
  await page.goto('/sign-in');
  await page.locator('input[name="Email"]').fill(email);
  await page.locator('input[name="Password"]').fill(password);
  await page.getByRole('button', { name: /sign in/i }).click();
}

/** Signs the current browser context out (clears the server session). */
export async function signOutViaUi(page: Page): Promise<void> {
  await page.goto('/sign-out');
  await page.goto('/');
}

/**
 * Directly seed the session so tests can reach authenticated screens
 * without typing credentials. Requires a valid customer record + the login
 * stored-procedure to accept the credentials. If that is not feasible, fall
 * back to `signInViaUi`.
 */
export async function loginAndSeedSession(
  page: Page,
  request: import('@playwright/test').APIRequestContext,
  email: string,
  password: string,
): Promise<void> {
  // 1. Get a session cookie by hitting any page
  await page.goto('/');
  const cookies = await page.context().cookies();
  const sessionCookie = cookies.find((c) => c.name.includes('MillionsOfRecords'));

  if (!sessionCookie) {
    throw new Error('Could not obtain a session cookie from the app.');
  }

  // 2. Try the sign-in POST directly to set session state server-side
  await request.post('/sign-in', {
    form: { Email: email, Password: password },
    headers: { Cookie: `${sessionCookie.name}=${sessionCookie.value}` },
  });
}
