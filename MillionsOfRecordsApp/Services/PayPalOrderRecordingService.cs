using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Models;

namespace MillionsOfRecordsApp.Services;

/// <summary>
/// Records a successfully captured PayPal order into the Orders database.
/// Shared by the synchronous capture path (browser present) and the PayPal
/// webhook reconciliation path (browser abandoned after capture).
/// </summary>
public class PayPalOrderRecordingService
{
    private readonly IReggaeDbContextProcedures _procedures;

    public PayPalOrderRecordingService(IReggaeDbContextProcedures procedures)
    {
        _procedures = procedures;
    }

    public async Task RecordPurchaseAsync(
        spGetCustomerDetailsByServerCounterResult customer,
        string orderNumber,
        int customerServerCounter,
        int customerID,
        string activeCartName,
        string guestCartName,
        decimal? orderTotal,
        decimal? shipping,
        decimal? tax,
        decimal? totalPrice,
        int? totalQuantity,
        string userAgent,
        string remHost,
        string sessionId,
        string selectedShippingMethod,
        string ipAddress,
        string paypalTransactionId,
        string paypalStatus,
        string paypalEmail,
        decimal? paypalAmountDue,
        string paypalPendingReason)
    {
        string notChangedAddress = "-";
        string noCreditCardNumber = "";
        string noExpDate = "";
        string poNumber = null;
        string yesPrintedInvoice = "y";
        string noHowFoundUs = "-";
        string orderedStatus = "ordered";
        string noOrderNotes = "";
        // TODO: This is currently hardcoded because we don't have a "pull sheet
        // text" value from the shipping options. Map shipping codes to pull sheet
        // texts in the future and store that on the order.
        string shippingMethodPullSheetText = "Mail";

        decimal weight = (await _procedures.spGetWeightOfProductAsync(activeCartName)).FirstOrDefault()?.sumweight ?? 0m;

        await _procedures.spRecordPurchaseAsync(
            customer.LogInEmail,
            customer.Password,
            customer.PriceGroup,
            userAgent,
            weight,
            DateTime.UtcNow,
            customerServerCounter,
            notChangedAddress,
            customer.PowerUserName,
            remHost,
            sessionId,
            selectedShippingMethod,
            noCreditCardNumber,
            noExpDate,
            orderTotal,
            poNumber,
            yesPrintedInvoice,
            customer.Email,
            shippingMethodPullSheetText,
            customer.Phone,
            customer.FullName,
            customer.StreetAddress1,
            customer.StreetAddress2,
            customer.City,
            customer.Island,
            customer.StateProvince,
            customer.PostalCode,
            customer.Country,
            customer.BillingFullName,
            customer.BillingStreetAddress1,
            customer.BillingStreetAddress2,
            customer.BillingCity,
            customer.BillingIsland,
            customer.BillingStateProvince,
            customer.BillingPostalCode,
            customer.BillingCountry,
            noHowFoundUs,
            orderedStatus,
            orderNumber,
            "201", // OrderProcessChoice: hardcoded because there is only one option today
            customerID.ToString(),
            0m, // PayPalAmountDue is recorded separately by spUpdatePayPalPaymentInfo
            0m, // GoogleCheckoutAmountDue (not used)
            0m, // WesternUnionAmountDue (not used)
            0m, // CheckCashorMoneyOrderAmountDue (not used)
            ipAddress,
            noOrderNotes,
            shipping,
            tax,
            totalPrice,
            orderTotal,
            totalQuantity,
            0m, // GiftCardAmount (not used)
            null, // GiftCardNumber (not used)
            0, // GiftCardAccountsServerCounter (not used)
            1, // NumberOfLineItems: kept as 1 for parity with the existing flow
            activeCartName);

        await _procedures.DeleteBackordersAsync(activeCartName, customerID);

        await _procedures.spOrderedQueriesAsync(activeCartName, guestCartName, customerServerCounter);

        await _procedures.spUpdatePayPalPaymentInfoAsync(
            orderNumber: orderNumber,
            paypalTransactionID: paypalTransactionId,
            payPalPaymentStatus: paypalStatus,
            payPalEmail: paypalEmail,
            payPalAmountPaid: orderTotal,
            paypalAmountDue: paypalAmountDue,
            payPalPendingReason: paypalPendingReason);
    }
}
