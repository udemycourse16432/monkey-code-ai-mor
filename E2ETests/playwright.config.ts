import { defineConfig, devices } from '@playwright/test';

/**
 * Playwright configuration for MillionsOfRecordsApp E2E tests.
 *
 * Target: Razor Pages web application (.NET 10) - by default https://localhost:7244
 * Override at runtime with env vars, see .env.example:
 *   BASE_URL, TEST_USER_EMAIL, TEST_USER_PASSWORD, TEST_ITEM_ID, TEST_ORDER_NUMBER
 */
export default defineConfig({
  testDir: './tests',
  fullyParallel: false,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 4 : 1,
  reporter: [
    ['list'],
    ['html', { outputFolder: 'playwright-report', open: 'never' }],
  ],
  timeout: 45_000,
  expect: {
    timeout: 10_000,
  },
  outputDir: 'test-results',

  use: {
    // The app enables UseHttpsRedirection and serves a dev certificate,
    // which Playwright treats as invalid -> ignore those errors.
    ignoreHTTPSErrors: true,
    baseURL: process.env.BASE_URL || 'https://localhost:7244',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
  ],
});
