# E2E Tests - MillionsOfRecordsApp

Playwright (TypeScript) end-to-end test suite for the `MillionsOfRecordsApp` .NET 10 Razor Pages storefront: catalog browsing, cart, PayPal V2 checkout, account management, order history, and legacy API endpoints.

Companion planning document: [`TEST_PLAN.md`](./TEST_PLAN.md) - full screen/API inventory and per-test-case matrix.

## Prerequisites

- Node 18+ (tested with Node 22)
- The app must be **running** and reachable (dotnet SDK is not bundled here). The project is a .NET 10 app; run it in Development so Kestrel serves `https://localhost:7244` with a dev certificate.
- Browsers: `npx playwright install`

## Setup

```bash
cd E2ETests
cp .env.example .env
npm install
npx playwright install chromium firefox webkit
```

## Configuration

Copy `.env.example` to `.env` and fill in real values:

| Variable | Default | Purpose |
| --- | --- | --- |
| `BASE_URL` | `https://localhost:7244` | App base URL |
| `TEST_USER_EMAIL` / `TEST_USER_PASSWORD` | - | Existing customer account for authenticated specs |
| `TEST_ITEM_ID` | - | A valid in-stock item id |
| `TEST_ORDER_NUMBER` | - | Known order number (`WEB-xxx-xxx-xxx`) |
| `LEGACY_DOWNLOAD_PASSWORD` | - | `LegacyApiSettings:DownloadDataPassword` |
| `DEBUG_PAGE_ALLOWED` | `0` | Set `1` in Development to assert `/admin/debug` |

Authenticated/cart/data-dependent tests **self-skip** with a clear message when the required env vars are missing, so the suite runs green out of the box.

## Running

```bash
npm run test:smoke      # connectivity checks (@smoke tag)
npm run test:screens    # all UI screens (chromium project)
npm run test:api        # all API contracts (chromium project)
npm run test            # full suite, all browsers (chromium/firefox/webkit)
npm run test -- --grep "Sign In" --project=chromium   # filter
npm run test:ui         # Playwright UI mode
npm run report          # open the last HTML report
```

Notes:

- `ignoreHTTPSErrors: true` is set in `playwright.config.ts` because the app redirects to HTTPS with a dev certificate.
- Run against a Development build to exercise `/admin/debug` (non-dev returns 403, which is also asserted).
- Run the app in Development with the dev database (`INTERNETREGGAE`) seeded per [`TEST_PLAN.md` §8](./TEST_PLAN.md).
- Sign-up specs register real customers with unique emails per run; DB cleanup is out of scope.

## Project Layout

```
E2ETests/
├── playwright.config.ts   # 3 browser projects, baseURL, reporters
├── fixtures/
│   ├── test-data.ts       # TestData + formatters (defaults to US country)
│   └── extended-test.ts   # envConfig + testData fixtures
├── helpers/
│   ├── env.ts             # env var access (BASE_URL, credentials, ids)
│   ├── auth.ts            # UI login helper
│   ├── cart-api.ts        # /api/cart/add, /api/cart/adjust via APIRequestContext
│   └── cart.ts            # in-browser addToCart + qty click helpers
├── tests/
│   ├── screens/           # 17 UI spec files, one per screen/flow
│   └── api/               # 4 API contract spec files
└── TEST_PLAN.md           # detailed test plan (see above)
```

## Verification

```bash
npx tsc --noEmit      # type-check
npx playwright test --list   # list all discovered tests
```
