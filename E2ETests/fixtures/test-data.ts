/**
 * Static test data used across specs.
 *
 * IMPORTANT: The app needs a populated INTERNETREGGAE database. Some values
 * below (item ids, country counters, order numbers) are environment-specific.
 * Override per-run via environment variables where available, or edit here.
 */
import { env } from '../helpers/env';

export const TestData = {
  /** Valid in-stock inventory item id (override with TEST_ITEM_ID). */
  itemId: Number(env.itemId) || 0,

  /** A known order number WEB-xxx-xxx-xxx (override with TEST_ORDER_NUMBER). */
  orderNumber: env.orderNumber || '',

  /** Country counter used on the SignUp / Country pages. 2991 = United States. */
  countryCounter: '2991',

  /** SignUp form values (must not already exist in the DB). */
  signup: {
    fullName: 'QA Test Customer',
    streetAddress1: '123 Test Ave',
    streetAddress2: 'Apt 4',
    city: 'Sacramento',
    stateProvince: 'California',
    postalCode: '95762',
    telephone: '9165869410',
    emailPrefix: 'qa.millions.records',
    password: 'TestPass123!',
  },

  /** Format filter codes used by the Shop page (see AppConstants.ShopFormats). */
  formats: {
    lp: 'LP',
    cd: 'CD',
    sevenInch: '7"',
    twelveTenInch: '12"/10"',
  },
} as const;
