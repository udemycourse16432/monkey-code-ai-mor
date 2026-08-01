import { test as base, expect } from '@playwright/test';
import { env, hasItemId, hasOrderNumber, hasTestUser } from '../helpers/env';
import { TestData } from './test-data';
/**
 * Extended fixture that carries environment-derived configuration and
 * test-data into every spec, so specs stay clean and data-driven.
 */
export const test = base.extend<{
  envConfig: typeof env;
  testData: typeof TestData;
}>({
  envConfig: async ({}, use) => use(env),
  testData: async ({}, use) => use(TestData),
});

export { expect, hasItemId, hasOrderNumber, hasTestUser };
