using MillionsOfRecordsApp.Models.Shared;
using System.Data;
using System.Data.Common;

namespace MillionsOfRecordsApp.Extensions;

public static class IntegerExtensions
{
    private const int LbsConversionFactor = 454;

    public static int ConvertToPounds(this int weight)
    {
        return weight > 0 ? weight / LbsConversionFactor : 0;
    }
    public static int ConvertToGrams(this int weight)
    {
        return weight > 0 ? weight * LbsConversionFactor : 0;
    }
}
public static class DecimalExtensions
{
    private const decimal LbsConversionFactor = 454.0m;

    public static decimal ConvertToPounds(this decimal weightInGrams)
    {
        return weightInGrams > 0 ? weightInGrams / LbsConversionFactor : 0m;
    }
    public static decimal ConvertToGrams(this decimal weightInGrams)
    {
        return weightInGrams > 0 ? weightInGrams * Convert.ToDecimal(LbsConversionFactor) : 0m;
    }
}
public static class DbCommandExtensions
{
    public static async Task EnsureOpenAsync(this DbCommand command)
    {
        var conn = command.Connection;
        if (conn != null && conn.State != ConnectionState.Open)
        {
            await conn.OpenAsync();
        }
    }
}
public static class HttpContextExtensions
{
    public static void InitializeLegacyCookies(this HttpContext context)
    {
        string host = context.Request.Host.Value?.ToUpper() ?? "";
        string? domain = host.Contains("MILLIONSTEST.COM") ? "millionstest2019.com" :
                         host.Contains("MILLIONSOFRECORDS.COM") ? "millionsofrecords.com" : null;

        var options = new CookieOptions { Domain = domain, Path = "/", Expires = DateTimeOffset.Now.AddDays(1) };
        context.Response.Cookies.Append("Cart", "begin-x-end", options);
        context.Response.Cookies.Append("CartTotals", "begin-x-end", options);
    }
}
public static class DataReaderExtensions
{
    public static string GetStringOrDefault(this IDataRecord reader, string columnName)
    {
        int ordinal = reader.GetOrdinal(columnName);
        return reader.IsDBNull(ordinal) ? "" : reader.GetValue(ordinal).ToString() ?? "";
    }

    public static int GetIntOrDefault(this IDataRecord reader, string columnName)
    {
        int ordinal = reader.GetOrdinal(columnName);
        if (reader.IsDBNull(ordinal)) return 0;

        var val = reader.GetValue(ordinal);
        return Convert.ToInt32(val);
    }
}
public static class SessionExtensions
{
    private const string KeyStoreName = "StoreName";
    private const string KeyPriceGroup = "PriceGroup";
    private const string KeyPowerUserName = "PowerUserName";
    private const string KeyCustomerID = "CustomerID";
    private const string KeyCustomerServerCounter = "CustomerServerCounter";
    private const string KeyCartName = "CartName";
    private const string KeyShippingCartShippingMethod = "ShippingCartShippingMethod";
    private const string KeyResidentialDelivery = "ResidentialDelivery";
    private const string KeyShippingCartZone = "ShippingCartZone";
    private const string KeyCartRandomNumbersExtension = "CartRandomNumbersExtension";
    private const string KeyCartCount = "CartCount";
    private const string KeyInitialized = "IsInitialized";
    private const string KeyRemHost = "RemHost";
    private const string KeySessionStarted = "SessionStarted";
    //private const string KeyMasterWebOrderNumber = "masterwebordernumber"; // Searched in legacy code and it is only used in Global.asax and Signout.aspx and the value is empty string so it is safe to remove it.
    private const string KeyWebOrderNumberJustPurchased = "WebOrderNumberJustPurchased"; // select OrderNumber from Orders e.g. WEB-999-821-877
    private const string KeyReggaeOrNonReggae = "ReggaeOrNonReggae";
    private const string KeyTotalWeightGrams = "TotalWeightGrams";
    private static string KeyLogInEmailMaster = "LogInEmailMaster";
    private static string KeyPasswordMaster = "PasswordMaster";
    private static string KeyCountry = "Country";
    private static string KeyPostalCode = "PostalCode";
    private static string KeyBillingCountry = "BillingCountry";
    private static string KeyBillingPostalCode = "BillingPostalCode";
    private static string KeyShippingCartCountry = "ShippingCartCountry";
    private static string KeyPostalCodeHelpShipping = "PostalCodeHelpShipping";
    private static string KeyShippingCartPostalCode = "ShippingCartPostalCode";
    private static string KeySelectedShippingCode = "SelectedShippingCode";
    private const string KeyPayFlowRequestCounter = "PayFlowRequestCounter";

    public static int GetPayFlowRequestCounter(this ISession session)
        => session.GetInt32(KeyPayFlowRequestCounter) ?? 0;
    public static void SetPayFlowRequestCounter(this ISession session, int counter)
        => session.SetInt32(KeyPayFlowRequestCounter, counter);
    public static void ClearPayFlowRequestCounter(this ISession session)
        => session.Remove(KeyPayFlowRequestCounter);

    public static string GetSearchId(this ISession session)
    {
        // Port as is: Replicating the legacy SearchID structure
        // Structure: [SessionID][Extension]S[8-digit Random Number]
        //'SearchID
        //Dim varXrandom1 As Integer = 0
        //For nrand1 = 1 To Date.Now.Second + 1
        //    Randomize()
        //    varXrandom1 = Rnd(2000)
        //Next
        //Dim varLengthRandomNumbersSearchID As Double = (10 ^ 8) - 1
        //Dim varSearchID As String = Session.SessionID & Session("CartRandomNumbersExtension") & "S" & Int(Rnd() * varLengthRandomNumbersSearchID)
        //If len(varSearchID) > 50 then varSearchID = left(varSearchID, 50)
        string sessionID = session.Id;
        string cartExt = session.GetCartRandomNumbersExtension();

        // Generate a random number up to 8 digits (10^8 - 1)
        int randomNumber = Random.Shared.Next(0, 99999999);

        string varSearchID = $"{sessionID}{cartExt}S{randomNumber}";

        // Safety truncate to 50 chars as per legacy requirements
        if (varSearchID.Length > 50)
        {
            varSearchID = varSearchID.Substring(0, 50);
        }

        return varSearchID;
    }
    public static string GetReggaeOrNonReggae(this ISession session)
        => session.GetString(KeyReggaeOrNonReggae) ?? "";
    public static void SetReggaeOrNonReggae(this ISession session, string? value)
        => session.SetString(KeyReggaeOrNonReggae, value ?? "");

    public static string GetWebOrderNumberJustPurchased(this ISession session)
        => session.GetString(KeyWebOrderNumberJustPurchased) ?? "";
    public static void SetWebOrderNumberJustPurchased(this ISession session, string? value)
        => session.SetString(KeyWebOrderNumberJustPurchased, value ?? "");
    //public static string GetMasterWebOrderNumber(this ISession session)
    //    => session.GetString(KeyMasterWebOrderNumber) ?? "";
    //public static void SetMasterWebOrderNumber(this ISession session, string? value)
    //    => session.SetString(KeyMasterWebOrderNumber, value ?? "");
    public static bool IsInitialized(this ISession session)
        => session.GetString(KeyInitialized) != null;
    public static void SetInitialized(this ISession session)
        => session.SetString(KeyInitialized, "true");
    public static void SetSessionStarted(this ISession session, string startTime)
        => session.SetString(KeySessionStarted, startTime);
    public static string GetRemoteHost(this ISession session)
    => session.GetString(KeyRemHost) ?? "";
    public static void SetRemoteHost(this ISession session, HttpContext context)
    {
        var referer = context.Request.Headers["Referer"].ToString();

        if (string.IsNullOrEmpty(referer))
        {
            var ip = context.Connection.RemoteIpAddress?.ToString() ?? "Direct/Unknown";
            // Translate IPv6 loopback to a readable string
            referer = (ip == "::1" || ip == "127.0.0.1") ? "localhost" : ip;
        }

        session.SetString("RemHost", referer);
    }

    // Customers table | FullName coumn is referred as StoreName in legacy code.
    public static string GetStoreName(this ISession session)
        => session.GetString(KeyStoreName) ?? "";
    public static void SetStoreName(this ISession session, string? name)
        => session.SetString(KeyStoreName, FigureCustomerName(name ?? ""));
    public static bool IsLoggedIn(this ISession session)
        => !string.IsNullOrWhiteSpace(session.GetString(KeyStoreName));

    public static string FigureCustomerName(string name)
    {
        if (string.IsNullOrEmpty(name)) return name;
        int index = name.IndexOf(", cust.");
        return index == -1 ? name : name.Substring(0, index);
    }

    public static string GetPriceGroup(this ISession session)
        => session.GetString(KeyPriceGroup) ?? AppConstants.PriceGroups.NoPrice;
    public static string GetPriceGroupWithFallback(this ISession session)
        => session.GetString(KeyPriceGroup) ?? AppConstants.PriceGroups.RetailPrice;
    public static void SetPriceGroupWithFallback(this ISession session, string? name)
        => session.SetString(KeyPriceGroup, name ?? AppConstants.PriceGroups.RetailPrice);


    public static string GetPowerUserName(this ISession session)
        => session.GetString(KeyPowerUserName) ?? "";
    public static void SetPowerUserName(this ISession session, string? name)
        => session.SetString(KeyPowerUserName, name ?? "");

    public static string GetCustomerID(this ISession session)
        => session.GetString(KeyCustomerID) ?? string.Empty;
    public static void SetCustomerID(this ISession session, string id)
    => session.SetString(KeyCustomerID, id);

    public static int GetCustomerServerCounter(this ISession session)
        => session.GetInt32(KeyCustomerServerCounter) ?? 0;
    public static void SetCustomerServerCounter(this ISession session, int counter)
        => session.SetInt32(KeyCustomerServerCounter, counter);

    public static int GetTotalWeightGrams(this ISession session)
        => session.GetInt32(KeyTotalWeightGrams) ?? 0;
    public static void SetTotalWeightGrams(this ISession session, int totalWeightInGrams)
        => session.SetInt32(KeyTotalWeightGrams, totalWeightInGrams);
    public static bool HasCartCount(this ISession session)
        => session.GetInt32(KeyCartCount).HasValue;

    public static int GetCartCount(this ISession session)
        => session.GetInt32(KeyCartCount) ?? 0;
    public static void SetCartCount(this ISession session, int counter)
        => session.SetInt32(KeyCartCount, counter);

    public static string GetCartName(this ISession session)
        => session.GetString(KeyCartName) ?? "";
    public static void SetCartName(this ISession session, string? name)
        => session.SetString(KeyCartName, name ?? "");

    public static string GetCartRandomNumbersExtension(this ISession session)
        => session.GetString(KeyCartRandomNumbersExtension) ?? "";
    public static void SetCartRandomNumbersExtension(this ISession session, string? name)
        => session.SetString(KeyCartRandomNumbersExtension, name ?? "");


    public static string GetResidentialDelivery(this ISession session)
        => session.GetString(KeyResidentialDelivery) ?? "";
    public static void SetResidentialDelivery(this ISession session, string? name)
        => session.SetString(KeyResidentialDelivery, name ?? "");

    public static string GetShippingCartShippingMethod(this ISession session)
        => session.GetString(KeyShippingCartShippingMethod) ?? "";
    public static void SetShippingCartShippingMethod(this ISession session, string? name)
        => session.SetString(KeyShippingCartShippingMethod, name ?? "");

    public static string GetShippingCartZone(this ISession session)
        => session.GetString(KeyShippingCartZone) ?? "";
    public static void SetShippingCartZone(this ISession session, string? name)
        => session.SetString(KeyShippingCartZone, name ?? "");


    public static string GetLogInEmailMaster(this ISession session)
        => session.GetString(KeyLogInEmailMaster) ?? "";
    public static void SetLogInEmailMaster(this ISession session, string? name)
        => session.SetString(KeyLogInEmailMaster, name ?? "");


    public static string GetPasswordMaster(this ISession session)
        => session.GetString(KeyPasswordMaster) ?? "";
    public static void SetPasswordMaster(this ISession session, string? name)
        => session.SetString(KeyPasswordMaster, name ?? "");


    public static string GetCountry(this ISession session)
        => session.GetString(KeyCountry) ?? "";
    public static void SetCountry(this ISession session, string? name)
        => session.SetString(KeyCountry, name ?? "");


    public static string GetPostalCode(this ISession session)
        => session.GetString(KeyPostalCode) ?? "";
    public static void SetPostalCode(this ISession session, string? name)
        => session.SetString(KeyPostalCode, name ?? "");


    public static string GetBillingCountry(this ISession session)
        => session.GetString(KeyBillingCountry) ?? "";
    public static void SetBillingCountry(this ISession session, string? name)
        => session.SetString(KeyBillingCountry, name ?? "");


    public static string GetBillingPostalCode(this ISession session)
        => session.GetString(KeyBillingPostalCode) ?? "";
    public static void SetBillingPostalCode(this ISession session, string? name)
        => session.SetString(KeyBillingPostalCode, name ?? "");


    public static string GetShippingCartCountry(this ISession session)
        => session.GetString(KeyShippingCartCountry) ?? "";
    public static void SetShippingCartCountry(this ISession session, string? name)
        => session.SetString(KeyShippingCartCountry, name ?? "");


    public static string GetShippingCartPostalCode(this ISession session)
        => session.GetString(KeyShippingCartPostalCode) ?? "";
    public static void SetShippingCartPostalCode(this ISession session, string? name)
        => session.SetString(KeyShippingCartPostalCode, name ?? "");

    public static string GetPostalCodeHelpShipping(this ISession session)
        => session.GetString(KeyPostalCodeHelpShipping) ?? "";
    public static void SetPostalCodeHelpShipping(this ISession session, string? name)
        => session.SetString(KeyPostalCodeHelpShipping, name ?? "");

    public static string GetSelectedShippingCode(this ISession session)
        => session.GetString(KeySelectedShippingCode) ?? "";
    public static void SetSelectedShippingCode(this ISession session, string? name)
        => session.SetString(KeySelectedShippingCode, name ?? "");

    public static string GetGuestCartName(this ISession session)
    {
        string randomExt = session.GetCartRandomNumbersExtension();
        return $"CART{session.Id}{randomExt}";
    }

    // 2. Explicitly get the Wholesale Cart Name
    public static string GetWholesaleCartName(this ISession session)
    {
        int counter = session.GetCustomerServerCounter();
        return counter > 0 ? $"W_CART_{counter}" : "";
    }
    // 3. The "Smart" method that picks the right one for the current state
    public static string GetActiveCartName(this ISession session)
    {
        return session.IsLoggedIn()
            ? session.GetWholesaleCartName()
            : session.GetGuestCartName();
    }
    // Helper
    public static object ToSqlNull(this string? value)
    {
        return string.IsNullOrEmpty(value) ? DBNull.Value : value;
    }
}
