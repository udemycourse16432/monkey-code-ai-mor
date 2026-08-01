using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Extensions;
using MillionsOfRecordsApp.Models.Shared;

namespace MillionsOfRecordsApp.Services
{
    public class CustomerAuthService
    {
        private readonly IReggaeDbContextProcedures _procedures;
        private readonly CustomerService _customerService;

        public CustomerAuthService(IReggaeDbContextProcedures procedures, CustomerService customerService)
        {
            _procedures = procedures;
            _customerService = customerService;
        }

        public async Task<bool> ProcessLoginAndMigrateAsync(HttpContext httpContext, string email, string password)
        {
            string userIp = httpContext.Connection.RemoteIpAddress?.ToString() ?? "Unknown";
            var cleanEmail = email.Replace(" ", "");
            var cleanPassword = password.Replace(" ", "");

            // 1. Fetch customer details
            List<Models.spGetCustomerDetailsResult> results = await _procedures.spGetCustomerDetailsAsync(cleanEmail, cleanPassword);
            if (results.Count == 0)
            {
                await RecordLogOnAttempt(httpContext, false, userIp, cleanEmail, cleanPassword);
                return false;
            }

            var result = results[0];
            var session = httpContext.Session;

            // 2. Set Session Variables
            session.SetCustomerServerCounter(result.counter);
            session.SetCustomerID(result.CustomerID);
            session.SetPowerUserName(result.PowerUserName);
            session.SetPriceGroupWithFallback(result.PriceGroup);
            session.SetStoreName(result.FullName);

            string residentialDeliveryValue = string.IsNullOrWhiteSpace(result.ResidentialDelivery) ? "NO" : "YES";
            session.SetResidentialDelivery(residentialDeliveryValue);
            session.SetCartName(session.GetWholesaleCartName());

            session.SetLogInEmailMaster(result.LogInEmail);
            session.SetPasswordMaster(result.Password);
            session.SetCountry(result.Country);
            session.SetPostalCode(result.PostalCode);
            session.SetBillingCountry(result.BillingCountry);
            session.SetBillingPostalCode(result.BillingPostalCode);
            session.SetPostalCodeHelpShipping("");

            // 3. Record Log-on & Stats
            await RecordLogOnAttempt(httpContext, true, userIp, cleanEmail, cleanPassword);
            await UpdateCustomerLoginStats(session);

            // 4. Migrate Guest Cart to Wholesale Cart
            await MigrateCartLogic(session);

            return true;
        }

        private async Task MigrateCartLogic(ISession session)
        {
            string powerUser = session.GetPowerUserName();
            if (!string.IsNullOrEmpty(powerUser)) return;

            string retailCart = session.GetGuestCartName();
            string wholesaleCart = session.GetWholesaleCartName();
            string priceGroup = session.GetPriceGroupWithFallback();

            List<Models.spGetCartItemsResult> cartItems = await _procedures.spGetCartItemsAsync(retailCart);
            foreach (var item in cartItems)
            {
                if (item.Quantity == 0)
                {
                    await _procedures.spDeleteCartItemAsync(retailCart, item.ItemID);
                }
                else
                {
                    decimal price = await CalculateLegacyWholesalePrice(item.ItemID, priceGroup);

                    await _procedures.spAddRetailCartItemToWholesaleCartAsync(
                        cartName: wholesaleCart,
                        itemID: item.ItemID,
                        quantity: item.Quantity,
                        wholesalePrice: price,
                        searchCriteriaStatisticsID: item.SearchCriteriaStatisticsID,
                        iPAddress: item.IPAddress);

                    await _procedures.spDeleteCartAsync(retailCart);
                    await _procedures.spUpdateCartQuantityInCustomersTableAsync(session.GetCustomerServerCounter());
                }
            }
        }

        private async Task<decimal> CalculateLegacyWholesalePrice(int itemId, string priceGroup)
        {
            var spGetInventoryItemResults = await _procedures.spGetInventoryItemAsync(itemId);
            if (!spGetInventoryItemResults.Any()) return 0m;

            var item = spGetInventoryItemResults[0];
            bool isWholesale = (priceGroup == AppConstants.PriceGroups.StorePrice);

            if (isWholesale)
            {
                if (item.Sale_WholesalePrice.HasValue && item.Sale_WholesaleEndDate.HasValue && item.Sale_WholesaleEndDate.Value >= DateTime.Today)
                    return item.Sale_WholesalePrice.Value;
                return item.StorePrice;
            }

            if (item.Sale_RetailPrice.HasValue && item.Sale_RetailEndDate.HasValue && item.Sale_RetailEndDate.Value >= DateTime.Today)
                return item.Sale_RetailPrice.Value;
            return item.RetailPrice;
        }

        private async Task UpdateCustomerLoginStats(ISession session)
        {
            var powerUser = session.GetPowerUserName();
            if (string.IsNullOrEmpty(powerUser))
            {
                var counter = session.GetCustomerServerCounter();
                if (counter > 0)
                {
                    await _procedures.spUpdateCustomerDateOfLastLoginAsync(counter);
                    await _procedures.spUpdateCustomerTotalSignInsAsync(counter);

                    var getOrders = await _procedures.spGetOrdersByCustomerServerCounterAsync(counter);
                    if (getOrders.Any())
                    {
                        session.SetShippingCartShippingMethod("");
                    }
                    else
                    {
                        session.SetShippingCartShippingMethod("");
                        session.SetShippingCartZone("");
                        session.SetShippingCartCountry(session.GetCountry());
                        session.SetShippingCartPostalCode(session.GetPostalCode());
                        session.SetWebOrderNumberJustPurchased("");
                    }
                }
            }
        }

        private async Task RecordLogOnAttempt(HttpContext httpContext, bool success, string ip, string email, string password)
        {
            var session = httpContext.Session;
            if (success)
            {
                var cartNumberOfItems = await _procedures.CartNumberOfItemsAsync(session.GetActiveCartName());
                int cartQuantity = cartNumberOfItems.FirstOrDefault()?.SumOfQuantity ?? session.GetCartCount();

                await _procedures.spInsertStoreLogOnAccessedSuccessfulAsync(
                    dateTime: DateTime.Now,
                    iPAddress: ip,
                    loggedOnSuccessful: "yes",
                    password: password,
                    logInEmail: email,
                    powerUserName: session.GetPowerUserName(),
                    cartQuantity: cartQuantity,
                    storename: session.GetStoreName(),
                    priceGroup: session.GetPriceGroupWithFallback(),
                    city: null,
                    customerServerCounter: session.GetCustomerServerCounter()
                );
            }
            else
            {
                await _procedures.spInsertStoreLogOnAccessedUnsuccessfulAsync(
                    dateTime: DateTime.Now,
                    iPAddress: ip,
                    loggedOnSuccessful: "no",
                    password: password,
                    logInEmail: email,
                    powerUserName: session.GetPowerUserName()
                );
            }
        }
    }
}
