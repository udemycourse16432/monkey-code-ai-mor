/**
 * Central configuration read from environment variables.
 * See .env.example for the full list.
 */
export interface TestEnv {
  baseURL: string;
  userEmail: string;
  userPassword: string;
  itemId: string;
  orderNumber: string;
  legacyDownloadPassword: string;
  paypalClientId: string;
}

function get(name: string): string {
  return process.env[name] ?? '';
}

export const env: TestEnv = {
  baseURL: get('BASE_URL') || 'https://localhost:7244',
  userEmail: get('TEST_USER_EMAIL'),
  userPassword: get('TEST_USER_PASSWORD'),
  itemId: get('TEST_ITEM_ID'),
  orderNumber: get('TEST_ORDER_NUMBER'),
  legacyDownloadPassword: get('LEGACY_DOWNLOAD_PASSWORD'),
  paypalClientId: get('PAYPAL_CLIENT_ID'),
};

/** True when a test user has been configured. */
export const hasTestUser = (): boolean => Boolean(env.userEmail && env.userPassword);

/** True when a valid inventory item id has been configured. */
export const hasItemId = (): boolean => Boolean(env.itemId);

/** True when a known order number has been configured. */
export const hasOrderNumber = (): boolean => Boolean(env.orderNumber);
