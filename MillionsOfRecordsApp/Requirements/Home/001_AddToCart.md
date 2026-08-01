Based on the code provided, here is how the "Add to Cart" requirement is currently structured:

1. UI Interaction & Input Capture (CQ function)
Visual Feedback: Upon clicking, the system must show a "Yellow Card" (YC) notification to the user and ensure the "Click to View" helper is visible.

Quantity Calculation:

If Add1 is -2, the quantity is set to a literal string "X".

If Add1 is 1, the system increments the current value in the quantity input field.

If Add1 is -1, the quantity is reset to 0.

Analytics: The system must capture the SearchID from a hidden field (SearchIDTxt) to track which search led to this addition.

2. Communication (AJAX Request)
Asynchronous Call: The system must send a GET request to AdjustCart.aspx with a cache-busting random number (ran) to ensure the request isn't cached by the browser.

Security Token: Every request must include the hardcoded token Z=876sgwte.

3. Backend Processing (AdjustCart.aspx)
Server-Side Security: The server must terminate the request immediately if the security token Z is missing or incorrect.

Global Toggle: The system must query DatabaseVariables. If AddToCart is not 'y', it returns "OK" but performs no database writes.

Dynamic Cart Naming:

For Wholesale/Store Users: The cart table name must follow the pattern W_CART_[CustomerServerCounter].

For Retail/Guest Users: The cart table name must follow the pattern CART[SessionID][RandomExtension].

4. Data Persistence (SQL Execution)
The Adjustment: The system calls the AdjustCart stored procedure to sync the cart table with the requested ID, Price, and Quantity.

Session Syncing: If the user is a logged-in store, the system must trigger a secondary update (spUpdateCartQuantityInCustomersTable) to keep the master customer record accurate.

5. UI Synchronization (AJAX Callback)
Status Update: If the response contains "OK", the UI must update the display input (OA[ID]) to reflect the new quantity.

Color Coding: * If quantity > 0: Set background color to light yellow (#FFFFAA).

If quantity = 0: Clear the input and reset background color to white (#FFFFFF).

Popup Trigger: If the server response contains an exclamation mark (!), the system must display specific "PSI" (Product Status Info) divs to warn the user about stock or status.
---
The SQL procedure reveals that the system doesn't just manage a shopping cart; it also handles Backorder fulfillment logic, which is why that "X" quantity (Type -2) was so important in the VB code.

Requirements Analysis (The "Brain" Logic)
1. Audit Logging
Every time AdjustCart is called, the system must record an entry in Carts_log.

It captures the current timestamp, the action name, the specific CartName, and a "snapshot" count of how many items exist in the global Carts table at that moment.

2. Cart Upsert Logic (Quantity > 0)
Update: If the item already exists in the specific cart, the system must overwrite the Quantity, Price, and refresh the [DateTime] to the current time.

Insert: If the item is new to that cart, it must create a new record including the SearchCriteriaStatisticsID (for marketing/analytics tracking) and the user's IPAddress.

3. Removal & Backorder Cleanup (Quantity = 0)
Standard Delete: If the quantity is 0, the item must be removed from the Carts table for that specific CartName.

Backorder Fulfillment (Type -2): This is a critical business rule. If the "Type" is -2 (which corresponds to clicking the "Delete Backorder" icon in the UI):

The item must be removed from BackordersInStockNow.

A record must be inserted into DeleteBackordersInStockNow to ensure the item doesn't reappear for that customer.