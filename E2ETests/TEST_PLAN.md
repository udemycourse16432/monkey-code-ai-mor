# MillionsOfRecordsApp - End-to-End Test Plan

**Application under test:** `MillionsOfRecordsApp` - .NET 10 Razor Pages e-commerce storefront (music catalog, cart, PayPal V2 checkout).
**Test framework:** Playwright (TypeScript) - see the `E2ETests/` project in this repository.
**Default target:** `https://localhost:7244` (override with `BASE_URL`).

---

## 1. Purpose & Scope

This plan defines the full end-to-end test coverage for the web storefront:

- Every user-facing **screen** (Razor page) and the behaviors exercised on it.
- Every **API controller endpoint** and its request/response contract.
- The business flows that cross screens: guest browse -> add to cart -> sign-in -> checkout -> PayPal capture -> order confirmation -> order history.
- Negative, boundary, and security-oriented cases (open-redirect, auth gating, validation, legacy endpoint auth).

Out of scope: unit tests, database-level tests, PayPal merchant configuration, and performance/load testing.

---

## 2. Environment & Prerequisites

| Item | Requirement |
| --- | --- |
| App runtime | `MillionsOfRecordsApp` built with .NET 10 and running (Kestrel/IIS Express) |
| Database | SQL Server instance `INTERNETREGGAE` seeded with catalog + at least one customer account |
| PayPal | Sandbox app credentials configured in `appsettings.json` |
| Node | Node 18+ (project tested with Node 22) |
| Browsers | `npx playwright install chromium firefox webkit` |

Environment variables consumed by the tests (see `E2ETests/.env.example`):

| Variable | Purpose |
| --- | --- |
| `BASE_URL` | App base URL (default `https://localhost:7244`) |
| `TEST_USER_EMAIL` / `TEST_USER_PASSWORD` | Existing customer account for authenticated specs |
| `TEST_ITEM_ID` | A valid in-stock inventory item id |
| `TEST_ORDER_NUMBER` | A known order number (format `WEB-xxx-xxx-xxx`) |
| `LEGACY_DOWNLOAD_PASSWORD` | Value of `LegacyApiSettings:DownloadDataPassword` |
| `DEBUG_PAGE_ALLOWED` | Set to `1` to enable `/admin/debug` assertions in Development |

---

## 3. Screen Inventory

Razor Pages are mapped by their `@page` directive or default route. All screens listed below are covered by a spec file in `E2ETests/tests/screens/`.

| # | Screen | Route(s) | Page model | Auth | Key interactions | Spec file |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Home / Storefront | `/` | `Index.cshtml.cs` | - | 13 catalog sections, add-to-cart buttons, header cart count | `home.spec.ts` |
| 2 | Shop / Catalog | `/shop` | `Shop.cshtml.cs` | - | filters (format, genre, label, artist, title, year, rhythm, feaitem, sid, price), sorting, pagination (48/page) | `shop.spec.ts` |
| 3 | Album Details | `/AlbumDetails/{id}` | `AlbumDetails.cshtml.cs` | - | full metadata, gallery, qty add/adjust, similar-items + more-by-artist rails | `album-details.spec.ts` |
| 4 | Cart | `/cart` | `Cart.cshtml.cs` | - | line items, +/-/delete (POST /api/cart/adjust), summary totals | `cart.spec.ts` |
| 5 | Checkout | `/checkout` | `Checkout.cshtml.cs` | required | shipping-method radios, totals, PayPal button, shipping freeze | `checkout.spec.ts` |
| 6 | Order Success | `/checkout/success?orderNumber=` | `Success.cshtml.cs` | required | receipt: shipping address, itemized table, totals | `success.spec.ts` |
| 7 | Sign In | `/sign-in` | `SignIn.cshtml.cs` | - | login form, error alerts, returnUrl handling, admin redirects | `sign-in.spec.ts` |
| 8 | Sign Up | `/sign-up?CountryListCode=&WholesaleOrRetailTxt=` | `SignUp.cshtml.cs` | - | full registration, zone validation, same-as-shipping, wholesale/retail | `sign-up.spec.ts` |
| 9 | Country Picker | `/country?wr=r\|w` | `Country.cshtml.cs` | - | country dropdown, auto-submit to /sign-up | `country.spec.ts` |
| 10 | My Account | `/my-account` | `MyAccount.cshtml.cs` | required | edit profile/address, same-as-shipping, country zone validation | `my-account.spec.ts` |
| 11 | Your Orders | `/your-orders` | `YourOrders.cshtml.cs` | required | pending orders + invoice history + tracking links | `your-orders.spec.ts` |
| 12 | Wholesale | `/wholesale` | `Wholesale.cshtml.cs` | - | static marketing page | `wholesale.spec.ts` |
| 13 | Wholesale Accepted | `/wholesale-accepted` | `WholesaleAccepted.cshtml.cs` | required | cart migration + item count summary | `wholesale.spec.ts` |
| 14 | About Us | `/about-us` | `AboutUs.cshtml.cs` | - | static | `static-pages.spec.ts` |
| 15 | Policies | `/policies` | `Policies.cshtml.cs` | - | static | `static-pages.spec.ts` |
| 16 | Privacy Policy | `/privacy-policy` | `PrivacyPolicy.cshtml.cs` | - | static | `static-pages.spec.ts` |
| 17 | Terms & Conditions | `/terms-and-conditions` | `TermsAndConditions.cshtml.cs` | - | static | `static-pages.spec.ts` |
| 18 | Customer Service & Returns | `/customer-service-and-returns` | `CustomerServiceAndReturns.cshtml.cs` | - | static | `static-pages.spec.ts` |
| 19 | Help / Shipping | `/help-shipping` | `HelpShipping.cshtml.cs` | - | static | `static-pages.spec.ts` |
| 20 | Forgot Password | `/forgot-password` | `ForgotPassword.cshtml.cs` | - | placeholder reset form | `forgot-password.spec.ts` |
| 21 | Debug | `/admin/debug` | `Debug.cshtml.cs` | - | session diagnostics + clear session (dev only; 403 otherwise) | `debug.spec.ts` |
| 22 | Error | `/Error` | `Error.cshtml.cs` | - | exception handling page | `error.spec.ts` |
| 23 | Sign Out | `/sign-out` | `SignOut.cshtml.cs` | - | clears session, redirects home | `static-pages.spec.ts` |

---

## 4. API Controller Inventory

| # | Controller | Method | Endpoint | Body / Query | Success | Failure modes | Spec file |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `CartController` | POST | `/api/cart/add` | JSON `{ id, price, type, qty, searchId }` | 200 `CartResponse` | 400 `Invalid ID` when `id <= 0` | `api/cart-api.spec.ts` |
| 2 | `CartController` | POST | `/api/cart/adjust` | JSON `{ id, price, type, qty, searchId }` | 200 `CartResponse` with `productsPrice`, `shippingFee`, `totalAmount` | 400 `Invalid ID` | `api/cart-api.spec.ts` |
| 3 | `CheckoutController` | POST | `/api/checkout/create-order` | JSON `{ shippingCode }` | PayPal `Order` (id, status) | 5xx without valid customer session; PayPal error payload on validation failure | `api/checkout-api.spec.ts` |
| 4 | `CheckoutController` | POST | `/api/checkout/capture-order/{orderId}` | - | captured PayPal `Order` | PayPal 4xx for invalid/expired order; 500 on unexpected exception | `api/checkout-api.spec.ts` |
| 5 | `ProxyController` | GET | `/api/suggestions/albums` | `search, page, limit, order, alpha, genre` | `ApiResponse<WebSearchSuggestionDto>` | - | `api/proxy-api.spec.ts` |
| 6 | `ProxyController` | GET | `/api/suggestions/artists` | `search, page, limit, order, alpha, genre` | same envelope; genre-scoped grouping when `genre` set | - | `api/proxy-api.spec.ts` |
| 7 | `ProxyController` | GET | `/api/suggestions/labels` | `search, page, limit, order, alpha, genre` | same envelope | - | `api/proxy-api.spec.ts` |
| 8 | `ProxyController` | GET | `/api/suggestions/genres` | `search, page, limit, order, alpha` | same envelope | - | `api/proxy-api.spec.ts` |
| 9 | `ProxyController` | GET | `/api/suggestions/allartists` | `page, limit, order, alpha` | same envelope | - | `api/proxy-api.spec.ts` |
| 10 | `ProxyController` | GET | `/api/suggestions/alllabels` | `page, limit, order, alpha` | same envelope | - | `api/proxy-api.spec.ts` |
| 11 | `ProxyController` | GET | `/api/suggestions/allgenres` | `page, limit, order, alpha` | same envelope | - | `api/proxy-api.spec.ts` |
| 12 | `HTTPDownloadDataOKController` | GET/POST | `/HTTPDownloadDataOK.aspx` | `pw, counter, table, newcustomerid` | text `OK` | `Invalid Credentials; IP Address Recorded` (bad pw), `Invalid Parameter` (bad counter) | `api/http-download-api.spec.ts` |

### API response envelope

`ApiResponse<WebSearchSuggestionDto>` (ProxyController):

```json
{
  "data": [ { "artistTitle": "...", "count": 12, "counter": 123, "frontImg": "..." } ],
  "pagination": {
    "current_page": 1, "last_page": 10, "per_page": 10, "total": 96,
    "from": 1, "to": 10,
    "next_page_url": "...", "prev_page_url": null,
    "first_page_url": "...", "last_page_url": "..."
  }
}
```

`CartResponse` (CartController):

```json
{ "success": true, "message": "OK", "cartCount": 2, "productsPrice": "25.00", "shippingFee": "5.00", "totalAmount": "30.00" }
```

### Supporting services & stored procedures (context for data setup)

| Service | Purpose | Notable stored procedures |
| --- | --- | --- |
| `CartService` | cart totals, item details, price updates | `AdjustCart`, `spGetCartItems`, `spGetCartTotalsRetailPrice`, `spGetCartTotalsWholesalePrice`, `spCartPricesSalePricesToo`, `spGetWeightOfProduct`, `spUpdateCartQuantityInCustomersTable` |
| `CustomerAuthService` | login + guest-cart migration | `spGetCustomerDetails`, `spInsertStoreLogOnAccessedSuccessful/Unsuccessful`, `spUpdateCustomerDateOfLastLogin`, `spUpdateCustomerTotalSignIns` |
| `CustomerService` | email existence checks | `spCheckLogInEmailExists`, `spCheckIfLogInEmailExists` |
| `ShippingService` | zone calculation + shipping options | `spGetShippingMethodsRow`, `spGetWebSHIPX_*` (zones, weights, holidays, in-transit), `spResidentialDelivery`, `spGetShippingCutoffMinutes` |
| `OrderService` | unique order number generation | `spSeeIfOrderNumberExists` |
| `EmailService` | confirmation emails | `spGetEmailFooter`, `spUpdateEmailedOrderConfirmation` |
| `SignUp` flow | registration | `spInsertCustomer`, `spInsertNewReleaseEmailOptInOrOut`, `spGetCountryList`, `spGetWebCountryStateProvincesList`, `spGetWebCountryShippingZonesTRow` |
| `Checkout capture` | order recording | `spRecordPurchase`, `DeleteBackorders`, `spOrderedQueries`, `spGetCustomerDetailsByServerCounter` |
| Orders screens | history | `spGetPendingCustomerOrders`, `spGetCustomerInvoices`, `spGetOrdersRow`, `spGetOrderItems`, `spInventoryItemFeaturesForListView` |

---

## 5. Detailed Test Cases by Screen

Legend: **P0** critical path - **P1** high - **P2** medium - **P3** low. `@smoke` = run-first connectivity checks.

### 5.1 Home `/` (`home.spec.ts`)

| ID | Priority | Test case | Expected result |
| --- | --- | --- | --- |
| HOME-01 | P0 @smoke | Load `/` | 200; storefront shell renders |
| HOME-02 | P0 | Catalog sections render (Best Selling / New Release / Back In Stock for LP, CD, 7", 12"/10"; Used & Collectible 7") | each `h2`/section heading visible |
| HOME-03 | P0 | Product card renders with an "Add to Cart" button | `#btn-container-<id>` with `onclick=addToCart(...)` |
| HOME-04 | P1 | Add to cart updates header cart count | `#cartCount` increments; toast "Album Added to Cart" |
| HOME-05 | P1 | Header/footer navigation links work | Shop link -> `/shop`; cart link -> `/cart` |
| HOME-06 | P2 | Featured albums link to correct detail pages | card image/`AlbumDetails` link resolves |

### 5.2 Shop `/shop` (`shop.spec.ts`)

| ID | Priority | Test case | Expected result |
| --- | --- | --- | --- |
| SHOP-01 | P0 @smoke | Load `/shop` | 200; product cards render |
| SHOP-02 | P0 | Format filter (`#formatFilterSelect`) | URL gains `format=`; results reload |
| SHOP-03 | P0 | Sort dropdown (`#sortOrderSelect`, order 1..6) | URL gains `order=`; ordering applied |
| SHOP-04 | P1 | Price filter (`#priceFilterSelect` under/over buckets) | URL gains `min_price`/`max_price` |
| SHOP-05 | P1 | Pagination | page links navigate with `page=N`; results re-render |
| SHOP-06 | P1 | Genre filter (`genre=Reggae`) | results scoped; header description shows genre |
| SHOP-07 | P2 | Combined filters (format + price + useditem) | all constraints applied |
| SHOP-08 | P2 | "Similar Items" route (`sid=<id>`) | header shows "Show Similar Items"; results scoped |
| SHOP-09 | P2 | Feature item route (`feaitem=<id>`) | header description populated from feature index |
| SHOP-10 | P2 | Year filter (`year=`) | results scoped to that year |
| SHOP-11 | P2 | Rhythm filter (`rhythm=`) | results scoped to that rhythm |
| SHOP-12 | P2 | Empty result set (`title=ZZZ...`) | graceful empty state, no 500 |
| SHOP-13 | P2 | Add to cart from a card | POST `/api/cart/add` succeeds; button flips to "IN YOUR CART" |
| SHOP-14 | P3 | Artist / label / title text filters | URL params + scoped results |

### 5.3 Album Details `/AlbumDetails/{id}` (`album-details.spec.ts`)

| ID | Priority | Test case | Expected result |
| --- | --- | --- | --- |
| ALB-01 | P0 | Load a valid album | 200; full metadata visible (artist/title/format/price/label/catalog/year/condition) |
| ALB-02 | P0 | Invalid/`0` id | renders not-found state (no 500) |
| ALB-03 | P1 | Deleted/hidden item id | not-found state |
| ALB-04 | P1 | Out-of-stock item | renders out-of-stock state, disables purchase |
| ALB-05 | P1 | Add to cart | POST `/api/cart/add`; header count updates |
| ALB-06 | P1 | Qty +/- controls (only when in cart) | POST `/api/cart/adjust`; `#displayQuantity` updates |
| ALB-07 | P2 | Customer Viewed (similar items) rail | cards link to `/shop?sid=<id>` |
| ALB-08 | P2 | More By This Artist rail | cards visible for same artist |
| ALB-09 | P2 | Genre chips link to shop | `shop?genre=` navigates |
| ALB-10 | P2 | Shop-back preserves query string | coming from `/shop?genre=X&page=N`, "Return to Shop" keeps query |
| ALB-11 | P3 | Feature detail expand/collapse toggles | `toggleFeatureDetails` shows/hides content |

### 5.4 Cart `/cart` (`cart.spec.ts`)

| ID | Priority | Test case | Expected result |
| --- | --- | --- | --- |
| CART-01 | P0 | Empty cart | summary shows `$0.00` |
| CART-02 | P0 | Line item renders with qty + price | row `#row-<id>` visible |
| CART-03 | P0 | Increment / decrement | POST `/api/cart/adjust`; count + summary update |
| CART-04 | P0 | Delete (qty=0) | row removed; header count updates; reload when empty |
| CART-05 | P1 | Summary math | `summary-total-amount = products + shipping` |
| CART-06 | P1 | Price refresh via spCartPricesSalePricesToo on load | prices match current catalog price |
| CART-07 | P2 | Similar-items link per row | navigates to `/shop?sid=<id>` |
| CART-08 | P2 | Logged-in wholesale pricing | wholesale price group reflected (requires wholesale account) |

### 5.5 Checkout `/checkout` (`checkout.spec.ts`)

| ID | Priority | Test case | Expected result |
| --- | --- | --- | --- |
| CO-01 | P0 | Anonymous user | redirected to `/sign-in?returnUrl=/checkout` |
| CO-02 | P0 | Signed-in user with cart | shipping method radios render; summary populated |
| CO-03 | P0 | Select a shipping method | summary `#shipping-cost-display` / `#total-amount-display` update |
| CO-04 | P0 | PayPal SDK loads | `sandbox.paypal.com/sdk` script requested; `#paypal-button-container` present |
| CO-05 | P1 | Shipping freeze on PayPal click | radios disabled while payment in progress (requires PayPal interaction) |
| CO-06 | P1 | Create order calls `/api/checkout/create-order` | returns PayPal order id (requires sandbox) |
| CO-07 | P1 | Successful capture redirects to `/checkout/success?orderNumber=...` | full happy-path order (requires sandbox funding) |
| CO-08 | P2 | No shipping method selected | pay button rejects with alert |
| CO-09 | P2 | Account without order history | shipping cart variables initialized (no crash) |

### 5.6 Order Success `/checkout/success?orderNumber=` (`success.spec.ts`)

| ID | Priority | Test case | Expected result |
| --- | --- | --- | --- |
| SUC-01 | P0 | Anonymous user | redirected to sign-in preserving `returnUrl` with order number |
| SUC-02 | P0 | Unknown order number (signed in) | redirected to `/your-orders` |
| SUC-03 | P0 | Known order number (signed in) | receipt renders: confirmation header, shipping address, item table, totals |
| SUC-04 | P1 | Order with no line items | redirect to `/your-orders` |
| SUC-05 | P2 | Shipping method text mapping | "FedEx Ground / USPS / UPS Ground" text rendered |

### 5.7 Sign In `/sign-in` (`sign-in.spec.ts`)

| ID | Priority | Test case | Expected result |
| --- | --- | --- | --- |
| SIN-01 | P0 | Render form | Email + Password inputs, submit button |
| SIN-02 | P0 | Unknown email | alert "Email address not found" |
| SIN-03 | P0 | Existing email + wrong password | alert "Invalid password. Your password has been emailed to you." |
| SIN-04 | P0 | Valid credentials | redirects off `/sign-in` (default `/wholesale-accepted`) |
| SIN-05 | P1 | Local `returnUrl` honored | redirects to `/your-orders` etc. |
| SIN-06 | P1 | External `returnUrl` rejected | stays on-site (open-redirect protection) |
| SIN-07 | P2 | Legacy admin email redirect | `/enter-stock` (admin accounts only) |
| SIN-08 | P2 | Power user redirect | `/customer-info` (power-user accounts only) |
| SIN-09 | P2 | Guest cart migration on login | retail cart items appear in wholesale cart after login |

### 5.8 Sign Up `/sign-up?CountryListCode=&WholesaleOrRetailTxt=` (`sign-up.spec.ts`)

| ID | Priority | Test case | Expected result |
| --- | --- | --- | --- |
| SUP-01 | P0 | No country context | redirected to `/sign-in` |
| SUP-02 | P0 | Render form | email, phone, password, name, address, country, same-as-shipping |
| SUP-03 | P0 | Password < 6 chars | validation error shown |
| SUP-04 | P0 | Duplicate email | "already registered" error |
| SUP-05 | P1 | Postal code format validation per country zone | mismatch -> warning + bypass on resubmit |
| SUP-06 | P1 | Same-as-shipping copies billing fields | billing inputs sync |
| SUP-07 | P1 | Successful retail sign-up | auto-login -> `/wholesale-accepted` |
| SUP-08 | P1 | Wholesale sign-up (`wr=w`) | price group `StorePrice`; auto-login -> `/wholesale-accepted` |
| SUP-09 | P2 | Country change reloads state options | `ShippingCountryChanged` handler |
| SUP-10 | P2 | Invalid phone formats | validation error ("standard digits") |
| SUP-11 | P3 | New-release email opt-in | `spInsertNewReleaseEmailOptInOrOut` executed (verify via DB) |

### 5.9 Country Picker `/country` (`country.spec.ts`)

| ID | Priority | Test case | Expected result |
| --- | --- | --- | --- |
| CNT-01 | P0 | Render with country list + default USA | heading, `#CountryListCode` populated |
| CNT-02 | P0 | `wr=r` retail mode + continue | GET `/sign-up?CountryListCode=...&WholesaleOrRetailTxt=retail` |
| CNT-03 | P0 | `wr=w` wholesale mode | hidden input `wholesale` |
| CNT-04 | P1 | Changing country auto-submits | onchange submits to `/sign-up` |

### 5.10 My Account `/my-account` (`my-account.spec.ts`)

| ID | Priority | Test case | Expected result |
| --- | --- | --- | --- |
| ACC-01 | P0 | Anonymous user | redirected away |
| ACC-02 | P0 | Signed-in user | account fields populated from `spGetCustomerDetailsByServerCounter` |
| ACC-03 | P1 | Same-as-shipping sync | billing mirrors shipping |
| ACC-04 | P1 | Save account info | `spUpdateCustomers` runs; success message "Account information updated successfully." |
| ACC-05 | P1 | Duplicate sign-in email | "already exists for another customer" error |
| ACC-06 | P2 | Country zone validation on save | missing required city/state/postal -> errors |

### 5.11 Your Orders `/your-orders` (`your-orders.spec.ts`)

| ID | Priority | Test case | Expected result |
| --- | --- | --- | --- |
| ORD-01 | P0 | Anonymous user | redirected to `/sign-in?returnUrl=/your-orders` |
| ORD-02 | P0 | Signed-in user | pending orders + invoice history tables render |
| ORD-03 | P1 | Pending order placeholder text | "In Progress, we'll update when shipped" |
| ORD-04 | P1 | Invoice totals/ship dates | formatted as currency / `MM/dd/yyyy` |
| ORD-05 | P2 | Tracking links per carrier | FedEx/UPS/USPS/17track URLs constructed correctly |
| ORD-06 | P2 | Archived orders flagged | `IsArchived` styling for >365 days |

### 5.12 Wholesale / Wholesale Accepted (`wholesale.spec.ts`)

| ID | Priority | Test case | Expected result |
| --- | --- | --- | --- |
| WHS-01 | P0 | `/wholesale` static page | loads |
| WHS-02 | P0 | `/wholesale-accepted` anonymous | redirected to sign-in |
| WHS-03 | P0 | Signed-in user | cart item summary renders ("N Items" or "Cart: $0.00") |
| WHS-04 | P1 | Guest cart -> wholesale migration | items moved from `CART<session>` to `W_CART_<counter>`; retail cart cleared |

### 5.13 Static pages (`static-pages.spec.ts`)

| ID | Priority | Test case | Expected result |
| --- | --- | --- | --- |
| ST-01 | P3 | Each static page loads | 200 + title (about-us, policies, privacy-policy, terms-and-conditions, customer-service-and-returns, help-shipping) |
| ST-02 | P2 | Sign out | `/sign-out` clears session and redirects to `/` |

### 5.14 Forgot Password (`forgot-password.spec.ts`)

| ID | Priority | Test case | Expected result |
| --- | --- | --- | --- |
| FGP-01 | P3 | Render form | email input + submit |
| FGP-02 | P3 | Submit valid email | confirmation state (`IsSent`) |

### 5.15 Debug `/admin/debug` (`debug.spec.ts`)

| ID | Priority | Test case | Expected result |
| --- | --- | --- | --- |
| DBG-01 | P3 | Development build | session diagnostics + clear-session button (guard: `DEBUG_PAGE_ALLOWED=1`) |
| DBG-02 | P3 | Non-development build | 403 forced by `Program.cs` |
| DBG-03 | P3 | Clear session | cart count resets to zero |

### 5.16 Error / Routing (`error.spec.ts`)

| ID | Priority | Test case | Expected result |
| --- | --- | --- | --- |
| ERR-01 | P2 | Unknown route | 404 (no stack trace leaked) |

---

## 6. Detailed API Test Cases

### 6.1 `POST /api/cart/add` (`api/cart-api.spec.ts`)

| ID | Priority | Test case | Expected result |
| --- | --- | --- | --- |
| CAPI-01 | P0 | `id <= 0` | 400 body `Invalid ID` |
| CAPI-02 | P0 | Valid item | 200 `{ success:true, message:"OK", cartCount>0 }` |
| CAPI-03 | P1 | Consecutive adds accumulate quantity | cartCount increments |
| CAPI-04 | P1 | Missing `type`/`qty` defaults | handled without 500 |
| CAPI-05 | P2 | Session-scoped cart isolation | different sessions do not share cart state |

### 6.2 `POST /api/cart/adjust` (`api/cart-api.spec.ts`)

| ID | Priority | Test case | Expected result |
| --- | --- | --- | --- |
| ADJ-01 | P0 | `id <= 0` | 400 `Invalid ID` |
| ADJ-02 | P0 | Adjust qty to 2 | 200; `productsPrice = price * 2` (e.g. "25.00") |
| ADJ-03 | P0 | `qty=0` removes item | 200 success; cart empties |
| ADJ-04 | P1 | Shipping fee + total breakdown returned | `shippingFee`, `totalAmount` non-empty strings |
| ADJ-05 | P2 | Header count synced | response `cartCount` matches DB |

### 6.3 `POST /api/checkout/create-order` (`api/checkout-api.spec.ts`)

| ID | Priority | Test case | Expected result |
| --- | --- | --- | --- |
| COAPI-01 | P0 | No customer session | mapped 5xx (no crash) |
| COAPI-02 | P0 | Signed-in user + cart | 200; PayPal `Order.id` + `status=CREATED/PAYER_ACTION_REQUIRED` |
| COAPI-03 | P1 | Invalid shipping code | falls back to $0 shipping or PayPal error (document behavior) |
| COAPI-04 | P1 | Empty cart | PayPal creation rejects or server returns error (document behavior) |

### 6.4 `POST /api/checkout/capture-order/{orderId}` (`api/checkout-api.spec.ts`)

| ID | Priority | Test case | Expected result |
| --- | --- | --- | --- |
| CAP-01 | P0 | Bogus order id | PayPal 4xx mirrored (>=400) |
| CAP-02 | P0 | No session | 5xx guard |
| CAP-03 | P1 | Successful capture | `spRecordPurchase` executes; order appears in `/your-orders`; confirmation email flagged `EmailedConfirmation` (verify via DB) |
| CAP-04 | P1 | Double-capture (idempotency key) | second call rejected without double charge |

### 6.5 `GET /api/suggestions/*` (`api/proxy-api.spec.ts`)

| ID | Priority | Test case | Expected result |
| --- | --- | --- | --- |
| SUG-01 | P0 | Each searchable endpoint returns 200 | albums/artists/labels/genres |
| SUG-02 | P0 | Envelope shape | `data[]` + `pagination{current_page,last_page,per_page,total}` |
| SUG-03 | P0 | Empty search | empty `data` + total 0 (or all results - assert current behavior) |
| SUG-04 | P1 | `limit` respected | `data.length <= limit`; `per_page == limit` |
| SUG-05 | P1 | `page` pagination + next/prev URLs | metadata correct |
| SUG-06 | P1 | `alpha` filter on full lists | results match letter prefix (A -> "-" special case) |
| SUG-07 | P1 | `order=2` popular vs alpha | ordering differs as expected |
| SUG-08 | P1 | `genre` on artists | grouped artist list |
| SUG-09 | P2 | Special characters sanitized | `search="THE X"` -> stripped leading THE |
| SUG-10 | P2 | "Elvis Presley" artist-title swap rule | album suggestions with comma-artist get reordered (regression guard) |

### 6.6 `/HTTPDownloadDataOK.aspx` (`api/http-download-api.spec.ts`)

| ID | Priority | Test case | Expected result |
| --- | --- | --- | --- |
| DL-01 | P0 | Missing password | `Invalid Credentials; IP Address Recorded` |
| DL-02 | P0 | Wrong password | same rejection text |
| DL-03 | P0 | Valid pw + bad counter | `Invalid Parameter` |
| DL-04 | P0 | Valid pw + valid counter + known table | `OK` |
| DL-05 | P1 | Unknown table | `OK` (no handler) |
| DL-06 | P1 | `table` > 100 chars | truncated, no crash |
| DL-07 | P1 | POST verb | `OK` |
| DL-08 | P2 | Each supported table (OrderCorrectionNotes, Carts, Carts_Deletes, SignInLog, DeleteBackordersInStockNow, Customers, PayPalIPNsReceived, Orders, PayFlowRequests, EnterStock, Enter7Inch, CustomerEmailChanges) | returns `OK` |

---

## 7. Cross-Cutting Flows (multi-screen journeys)

| ID | Priority | Journey | Steps | Verification |
| --- | --- | --- | --- | --- |
| J-01 | P0 | Browse -> cart | Home -> add album -> `/cart` | count + line item + totals |
| J-02 | P0 | Guest cart -> login -> checkout | add to cart, sign-in (guest cart migration), `/checkout` | cart preserved at wholesale prices; shipping radios + PayPal render |
| J-03 | P1 | Full purchase | checkout -> create-order -> capture (PayPal sandbox) -> success | receipt; order appears in `/your-orders`; DB row via `spRecordPurchase` |
| J-04 | P1 | Sign-up -> purchase | country -> sign-up -> auto-login -> wholesale-accepted -> add to cart -> checkout | new customer flows end to end |
| J-05 | P2 | Order number validation | checkout success with bogus number | redirect to `/your-orders` |
| J-06 | P2 | Session timeout | idle > 30 min -> checkout | redirected to sign-in |
| J-07 | P2 | Deep links to protected pages | `/my-account`, `/your-orders`, `/checkout` | all gate on sign-in |

---

## 8. Test Data Requirements

| Data | Source | Used by |
| --- | --- | --- |
| In-stock inventory item id | DB `Inventory` (Inventory > 0, ShowOnWebsite=y) | cart, album-details, checkout |
| Out-of-stock item id | DB `Inventory` (Inventory = 0) | ALB-04 |
| Deleted/hidden item id | `Deleted=n` / `ShowOnWebsite=n` row | ALB-03 |
| Retail customer account | seeded via `spInsertCustomer` | sign-in, checkout, account |
| Wholesale customer account | `PriceGroup = StorePrice` | SUP-08, WHS-04, CART-08 |
| Admin email account | `POTATOKID2004@GMAIL.COM` etc. | SIN-07 (manual) |
| Known order number | `Orders.WebOrderNumbers` | SUC-03 |
| PayPal sandbox buyer | PayPal developer console | J-03, CO-06/07 |

All item/user ids are injected via env vars / `fixtures/test-data.ts` so the suite is data-driven and portable across environments.

---

## 9. Execution Strategy

```bash
cd E2ETests
cp .env.example .env        # fill in real values
npm install
npx playwright install       # chromium firefox webkit

npm run test:smoke           # connectivity first (tagged @smoke)
npm run test:screens         # all UI screens (chromium default project)
npm run test:api             # all API contracts
npm run test                 # everything, all 3 browsers
npm run test -- --grep "@smoke" --project=chromium
npm run test -- --project=chromium --grep "Sign In"
```

Notes:
- Authenticated specs self-skip with a clear message when `TEST_USER_EMAIL`/`TEST_ITEM_ID` are not configured, so the suite is green-safe out of the box.
- Sign-up tests register real customers; they use unique emails per run. DB cleanup is out of scope.
- Run against the app in **Development** (`DEBUG_PAGE_ALLOWED=1`) to exercise `/admin/debug`; in non-dev the 403 guard is verified instead.
- `ignoreHTTPSErrors: true` is set because the app redirects to HTTPS with a dev certificate.

## 10. Known Risks / Notes

- `Program.cs` maps `/album-details/{id:int}` to a non-existent page `AlbumDetails2` (line 44). The functional route is `/AlbumDetails/{id}`. Add a regression test to lock in whichever route is intended.
- `CheckoutController.CreateOrder` calls `GetCustomerDetailsAsync().First()` without an empty guard; a logged-out session hits a 5xx. This is intentional behavior to verify, not a crash.
- PayPal `capture-order` returns a 5xx on the happy path if `X-Forwarded-For` parsing or session state is incomplete - treat as environment-specific.
- `Success` page silently skips the confirmation email in the current code (commented out), so email assertions are DB-only.
- Static page specs assume the exact `@page` routes shown in section 3.
