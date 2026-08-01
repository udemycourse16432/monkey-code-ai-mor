using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Extensions;
using MillionsOfRecordsApp.Models.Shared;
using MillionsOfRecordsApp.Services;

namespace MillionsOfRecordsApp.Pages
{
    public class SignInModel : PageModel
    {
        private readonly CustomerAuthService _authService;
        private readonly CustomerService _customerService;

        public SignInModel(CustomerAuthService authService, CustomerService customerService)
        {
            _authService = authService;
            _customerService = customerService;
        }
        [BindProperty(SupportsGet = true)]
        public string? ReturnUrl { get; set; }
        [BindProperty]
        public string Email { get; set; } = string.Empty;

        [BindProperty]
        public string Password { get; set; } = string.Empty;

        public string ErrorMessage { get; set; } = string.Empty;

        public void OnGet()
        {
            // Pull the error from TempData (if it exists) and put it in the Model property
            if (TempData.ContainsKey("ErrorMessage"))
            {
                ErrorMessage = TempData["ErrorMessage"]?.ToString() ?? string.Empty;
            }

            // Optional: If you want to persist the email address so they don't have to re-type it
            if (TempData.ContainsKey("SubmittedEmail"))
            {
                Email = TempData["SubmittedEmail"]?.ToString() ?? string.Empty;
            }
        }


        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid) return Page();

            var cleanEmail = Email.Trim();
            var cleanPassword = Password.Trim();

            string userIp = HttpContext.Connection.RemoteIpAddress?.ToString() ?? "Unknown";

            // Special Legacy Admin Logins [cite: 1021, 1022]
            if (cleanEmail == "@." && cleanPassword.Equals("AMESSAGE3921", StringComparison.OrdinalIgnoreCase))
            {
                HttpContext.Session.SetString("EditAMessageFromErnieOK", "yes");
                return RedirectToPage("/AMessageFromErnie");
            }

            // Execute auth workflow via the shared service (Session updates, logging, cart migration)
            bool loginSuccessful = await _authService.ProcessLoginAndMigrateAsync(HttpContext, cleanEmail, cleanPassword);
            if (loginSuccessful)
            {
                // 1. ReturnUrl priority (e.g., redirecting back to /Checkout)
                if (!string.IsNullOrEmpty(ReturnUrl) && Url.IsLocalUrl(ReturnUrl))
                {
                    return Redirect(ReturnUrl);
                }

                // 2. PowerUser redirect rule
                string powerUser = HttpContext.Session.GetPowerUserName();
                if (!string.IsNullOrEmpty(powerUser))
                {
                    return RedirectToPage("/CustomerInfo");
                }

                // 3. Legacy Admin Email specific redirects
                var emailUpper = cleanEmail.ToUpper();
                if (emailUpper == "POTATOKID2004@GMAIL.COM" ||
                    emailUpper == "KDOGROSS06@GMAIL.COM" ||
                    emailUpper == "HECHARLOTTE31@GMAIL.COM")
                {
                    return RedirectToPage("/EnterStock");
                }

                // 4. Default landing page
                return RedirectToPage("/WholesaleAccepted");
            }
            // Failure path: Check email existence for customized error message
            bool emailExists = await _customerService.CheckLogInEmailExists(cleanEmail);

            TempData["ErrorMessage"] = emailExists
                ? "Invalid password. Your password has been emailed to you."
                : "Email address not found.";

            return RedirectToPage();

            //// 1. Attempt Login using spGetCustomerDetails
            //List<Models.spGetCustomerDetailsResult> results = await _procedures.spGetCustomerDetailsAsync(cleanEmail, cleanPassword);
            //if (results.Count > 0)
            //{
            //    var result = results[0];

            //    HttpContext.Session.SetCustomerServerCounter(result.counter);
            //    HttpContext.Session.SetCustomerID(int.Parse(result.CustomerID));
            //    HttpContext.Session.SetPowerUserName(result.PowerUserName);
            //    HttpContext.Session.SetPriceGroupWithFallback(result.PriceGroup);
            //    HttpContext.Session.SetStoreName(result.FullName);

            //    string residentialDeliveryValue = string.IsNullOrWhiteSpace(result.ResidentialDelivery) ? "NO" : "YES";
            //    HttpContext.Session.SetResidentialDelivery(residentialDeliveryValue);
            //    HttpContext.Session.SetCartName(HttpContext.Session.GetWholesaleCartName());
            //    loginSuccessful = true;

            //    HttpContext.Session.SetLogInEmailMaster(result.LogInEmail);
            //    HttpContext.Session.SetPasswordMaster(result.Password);
            //    HttpContext.Session.SetCountry(result.Country);
            //    HttpContext.Session.SetPostalCode(result.PostalCode);
            //    HttpContext.Session.SetBillingCountry(result.BillingCountry);
            //    HttpContext.Session.SetBillingPostalCode(result.BillingPostalCode);
            //    HttpContext.Session.SetPostalCodeHelpShipping("");
            //}
            //// We use raw SQL with EF to handle the Stored Procedure and return a DataReader-like experience
            ////using (var command = _context.Database.GetDbConnection().CreateCommand())
            ////{
            ////    command.CommandText = "spGetCustomerDetails";
            ////    command.CommandType = CommandType.StoredProcedure;
            ////    command.Parameters.Add(new SqlParameter("@LogInEmail", cleanEmail));
            ////    command.Parameters.Add(new SqlParameter("@Password", cleanPassword));

            ////    await command.EnsureOpenAsync();

            ////    using (var reader = await command.ExecuteReaderAsync())
            ////    {
            ////        if (reader.HasRows)
            ////        {
            ////            await reader.ReadAsync();

            ////            // Set Sessions
            ////            //SetLegacySessions(reader);

            ////            HttpContext.Session.SetCustomerServerCounter(reader.GetIntOrDefault("Counter"));
            ////            HttpContext.Session.SetCustomerID(reader.GetIntOrDefault("CustomerID"));
            ////            HttpContext.Session.SetPowerUserName(reader.GetStringOrDefault("PowerUserName"));
            ////            HttpContext.Session.SetPriceGroupWithFallback(reader.GetStringOrDefault("PriceGroup"));
            ////            HttpContext.Session.SetStoreName(reader.GetStringOrDefault("FullName"));

            ////            HttpContext.Session.SetCartName(HttpContext.Session.GetWholesaleCartName());
            ////            loginSuccessful = true;
            ////        }
            ////    }
            ////}

            //// 2. Now that the connection is free, do the logging and redirect
            //if (loginSuccessful)
            //{
            //    await RecordLogOnAttempt(true, userIp, Email, Password);

            //    // Perform legacy account updates (Sign-in counts, etc.)
            //    await UpdateCustomerLoginStats();

            //    // Migrate Guest Cart to Wholesale Cart
            //    await MigrateCartLogic();

            //    // Check if we have a valid local ReturnUrl (like /Checkout)
            //    if (!string.IsNullOrEmpty(ReturnUrl) && Url.IsLocalUrl(ReturnUrl))
            //    {
            //        return Redirect(ReturnUrl);
            //    }

            //    // Determine Redirect Path based on Legacy Rules
            //    string powerUser = HttpContext.Session.GetPowerUserName();
            //    if (!string.IsNullOrEmpty(powerUser))
            //    {
            //        return RedirectToPage("/CustomerInfo");
            //    }
            //    // Specific legacy email checks for Admin redirection
            //    var emailUpper = Email.ToUpper().Trim();
            //    if (emailUpper == "POTATOKID2004@GMAIL.COM" || emailUpper == "KDOGROSS06@GMAIL.COM" || emailUpper == "HECHARLOTTE31@GMAIL.COM")
            //    {
            //        return RedirectToPage("/EnterStock");
            //    }

            //    return RedirectToPage("/WholesaleAccepted");
            //}
            //// 2. Failure Path: Check if Email exists
            //bool emailExists = await _customerService.CheckLogInEmailExists(Email);

            ////var emailParam = new SqlParameter("@LogInEmail", Email);
            ////// Using ExecuteSqlRaw to check existence efficiently
            ////using (var command = _context.Database.GetDbConnection().CreateCommand())
            ////{
            ////    command.CommandText = "spCheckLogInEmailExists";
            ////    command.CommandType = CommandType.StoredProcedure;
            ////    command.Parameters.Add(new SqlParameter("@LogInEmail", Email));
            ////    await command.EnsureOpenAsync();
            ////    using (var reader = await command.ExecuteReaderAsync())
            ////    {
            ////        emailExists = reader.HasRows;
            ////    }
            ////}

            //await RecordLogOnAttempt(false, userIp, cleanEmail, cleanPassword);

            //TempData["ErrorMessage"] = emailExists
            //    ? "Invalid password. Your password has been emailed to you."
            //    : "Email address not found.";

            //return RedirectToPage();
        }
        //private async Task MigrateCartLogic()
        //{
        //    var session = HttpContext.Session;
        //    string powerUser = session.GetPowerUserName();

        //    // Only regular users migrate carts
        //    if (string.IsNullOrEmpty(powerUser))
        //    {

        //        string retailCart = session.GetGuestCartName();
        //        string wholesaleCart = session.GetWholesaleCartName();
        //        string priceGroup = session.GetPriceGroupWithFallback();

        //        // 1. Get items from the temporary retail cart
        //        List<Models.spGetCartItemsResult> cartItems = await _procedures.spGetCartItemsAsync(retailCart);
        //        foreach (var item in cartItems)
        //        {
        //            if (item.Quantity == 0)
        //            {
        //                await _procedures.spDeleteCartItemAsync(retailCart, item.ItemID);
        //                //await _context.Database.ExecuteSqlRawAsync("EXEC spDeleteCartItem @CartName, @ItemID",
        //                //    new SqlParameter("@CartName", retailCart),
        //                //    new SqlParameter("@ItemID", item.ItemId));
        //            }
        //            else
        //            {
        //                // 2. Determine price based on legacy logic
        //                decimal price = await CalculateLegacyWholesalePrice(item.ItemID, priceGroup);

        //                // 3. Add to the permanent wholesale cart
        //                await _procedures.spAddRetailCartItemToWholesaleCartAsync(
        //                    cartName: wholesaleCart,
        //                    itemID: item.ItemID,
        //                    quantity: item.Quantity,
        //                    wholesalePrice: price,
        //                    searchCriteriaStatisticsID: item.SearchCriteriaStatisticsID,
        //                    iPAddress: item.IPAddress);

        //                //var p = new List<SqlParameter>
        //                //{
        //                //    new SqlParameter("@CartName", wholesaleCart),
        //                //    new SqlParameter("@ItemID", item.ItemId),
        //                //    new SqlParameter("@Quantity", item.Quantity),
        //                //    new SqlParameter("@WholesalePrice", price),
        //                //    new SqlParameter("@SearchCriteriaStatisticsID", item.SearchCriteriaStatisticsId ?? (object)DBNull.Value),
        //                //    new SqlParameter("@IPAddress", item.Ipaddress ?? (object)DBNull.Value)
        //                //};
        //                //await _context.Database.ExecuteSqlRawAsync("EXEC spAddRetailCartItemToWholesaleCart @CartName, @ItemID, @Quantity, @WholesalePrice, @SearchCriteriaStatisticsID, @IPAddress", p.ToArray());


        //                // 4. Cleanup
        //                await _procedures.spDeleteCartAsync(retailCart);
        //                //await _context.Database.ExecuteSqlRawAsync("EXEC spDeleteCart @CartName", new SqlParameter("@CartName", retailCart));

        //                await _procedures.spUpdateCartQuantityInCustomersTableAsync(session.GetCustomerServerCounter());
        //                //await _context.Database.ExecuteSqlRawAsync("EXEC spUpdateCartQuantityInCustomersTable @CustomerServerCounter",
        //                //    new SqlParameter("@CustomerServerCounter", session.GetCustomerServerCounter()));
        //            }
        //        }

        //    }
        //}

        //private async Task<decimal> CalculateLegacyWholesalePrice(int itemId, string priceGroup)
        //{
        //    List<Models.spGetInventoryItemResult> spGetInventoryItemResults = await _procedures.spGetInventoryItemAsync(itemId);
        //    if (!spGetInventoryItemResults.Any())
        //    {
        //        return 0m;
        //    }
        //    var item = spGetInventoryItemResults[0];
        //    bool isWholesale = (priceGroup == AppConstants.PriceGroups.StorePrice);
        //    decimal finalPrice = 0m;

        //    if (isWholesale)
        //    {
        //        if (item.Sale_WholesalePrice.HasValue && item.Sale_WholesaleEndDate.HasValue && item.Sale_WholesaleEndDate.Value >= DateTime.Today)
        //        {
        //            finalPrice = item.Sale_WholesalePrice ?? 0;
        //        }
        //        else
        //        {
        //            finalPrice = item.StorePrice;
        //        }
        //    }
        //    else
        //    {
        //        if (item.Sale_RetailPrice.HasValue && item.Sale_RetailEndDate.HasValue && item.Sale_RetailEndDate.Value >= DateTime.Today)
        //        {
        //            finalPrice = item.Sale_RetailPrice ?? 0;
        //        }
        //        else
        //        {
        //            finalPrice = item.RetailPrice;
        //        }
        //    }
        //    return finalPrice;
        //}

        //private async Task UpdateCustomerLoginStats()
        //{
        //    var powerUser = HttpContext.Session.GetPowerUserName();

        //    // Legacy Condition: Only update if not a specific IP and not a power user
        //    if (string.IsNullOrEmpty(powerUser))
        //    {
        //        var counter = HttpContext.Session.GetCustomerServerCounter();
        //        if (counter > 0)
        //        {
        //            await _procedures.spUpdateCustomerDateOfLastLoginAsync(counter);
        //            await _procedures.spUpdateCustomerTotalSignInsAsync(counter);
        //            //await _context.Database.ExecuteSqlRawAsync("EXEC spUpdateCustomerDateOfLastLogin @counter", new SqlParameter("@counter", counter));
        //            //await _context.Database.ExecuteSqlRawAsync("EXEC spUpdateCustomerTotalSignIns @counter", new SqlParameter("@counter", counter));

        //            // Shipping Cart variables initialization based on legacy logic
        //            List<Models.spGetOrdersByCustomerServerCounterResult> getOrdersByCustomerServerCounterResults =
        //                await _procedures.spGetOrdersByCustomerServerCounterAsync(counter);
        //            if (getOrdersByCustomerServerCounterResults.Any())
        //            {
        //                HttpContext.Session.SetShippingCartShippingMethod("");
        //            }
        //            else
        //            {
        //                HttpContext.Session.SetShippingCartShippingMethod("");
        //                HttpContext.Session.SetShippingCartZone("");

        //                HttpContext.Session.SetShippingCartCountry(HttpContext.Session.GetCountry());
        //                HttpContext.Session.SetShippingCartPostalCode(HttpContext.Session.GetPostalCode());
        //                HttpContext.Session.SetWebOrderNumberJustPurchased("");
        //            }
        //        }
        //    }
        //}
        //private async Task RecordLogOnAttempt(bool success, string? ip, string email, string password)
        //{
        //    // 1. Gather values from Session (if they exist)
        //    var session = HttpContext.Session;
        //    if (success)
        //    {
        //        List<Models.CartNumberOfItemsResult> cartNumberOfItems = await _procedures.CartNumberOfItemsAsync(session.GetActiveCartName());
        //        int cartQuantity = cartNumberOfItems.FirstOrDefault()?.SumOfQuantity ?? session.GetCartCount();
        //        await _procedures.spInsertStoreLogOnAccessedSuccessfulAsync(
        //            dateTime: DateTime.Now,
        //            iPAddress: ip,
        //            loggedOnSuccessful: "yes",
        //            password: password,
        //            logInEmail: email,
        //            powerUserName: session.GetPowerUserName(),
        //            cartQuantity: cartQuantity,
        //            storename: session.GetStoreName(),
        //            priceGroup: session.GetPriceGroupWithFallback(),
        //            city: null, // Legacy field, usually null during login
        //            customerServerCounter: session.GetCustomerServerCounter()
        //        );
        //    }
        //    else
        //    {
        //        await _procedures.spInsertStoreLogOnAccessedUnsuccessfulAsync(
        //            dateTime: DateTime.Now,
        //            iPAddress: ip,
        //            loggedOnSuccessful: "no",
        //            password: password,
        //            logInEmail: email,
        //            powerUserName: session.GetPowerUserName()
        //        );
        //    }

        //    //string spName = success ? "spInsertStoreLogOnAccessedSuccessful" : "spInsertStoreLogOnAccessedUnsuccessful";

        //    //var parameters = new List<SqlParameter>
        //    //{
        //    //    new SqlParameter("@DateTime", DateTime.Now),
        //    //    new SqlParameter("@IPAddress", ip ?? (object)DBNull.Value),
        //    //    new SqlParameter("@LoggedOnSuccessful", success ? "yes" : "no"),
        //    //    new SqlParameter("@Password", password ?? (object)DBNull.Value),
        //    //    new SqlParameter("@LogInEmail", email ?? (object)DBNull.Value),

        //    //    // These might be null on a failed login, so we use DBNull.Value
        //    //    new SqlParameter("@PowerUserName", session.GetPowerUserName().ToSqlNull()),
        //    //    new SqlParameter("@CartQuantity", SqlDbType.Int) { Value = session.GetCartCount() },
        //    //    new SqlParameter("@Storename", session.GetStoreName().ToSqlNull()),
        //    //    new SqlParameter("@PriceGroup", session.GetPriceGroupWithFallback()),
        //    //    new SqlParameter("@City", DBNull.Value), // Legacy field, usually null during login
        //    //    new SqlParameter("@CustomerServerCounter", session.GetCustomerServerCounter())
        //    //};

        //    //// 2. Build the EXEC string: "EXEC spName @p1, @p2, @p3..."
        //    //string paramList = string.Join(", ", parameters.Select(p => p.ParameterName));
        //    //string sql = $"EXEC {spName} {paramList}";

        //    //try
        //    //{
        //    //    await _context.Database.ExecuteSqlRawAsync(sql, parameters.ToArray());
        //    //}
        //    //catch (Exception ex)
        //    //{
        //    //    // Log to console so you can see if specific SPs have different signatures
        //    //    Console.WriteLine($"Logging Error: {ex.Message}");
        //    //}

        //    //If Session("PowerUserName") = "" And Request.ServerVariables("HTTP_X_FORWARDED_FOR") <> "104.53.90.206" Then
        //    //       Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
        //    //            SqlConnection.ClearPool(conn2)
        //    //            conn2.Open()
        //    //            Dim CMD_D As New SqlCommand("spUpdateCustomerDateOfLastLogin", conn2)
        //    //            CMD_D.CommandType = Data.CommandType.StoredProcedure
        //    //            CMD_D.Parameters.AddWithValue("@counter", xxCounter)
        //    //            CMD_D.ExecuteNonQuery()
        //    //            Dim CMD_TS As New SqlCommand("spUpdateCustomerTotalSignIns", conn2)
        //    //            CMD_TS.CommandType = Data.CommandType.StoredProcedure
        //    //            CMD_TS.Parameters.AddWithValue("@counter", xxCounter)
        //    //            CMD_TS.ExecuteNonQuery()
        //    //        End Using
        //    //    End If

        //    //'Shipping Cart variables
        //    //    Dim varZip3 As String = ""
        //    //    Dim varStateProvince As String = ""
        //    //    Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
        //    //        SqlConnection.ClearPool(conn2)
        //    //        conn2.Open()
        //    //        Dim CMD_o As New SqlCommand("spGetOrdersByCustomerServerCounter", conn2)
        //    //        CMD_o.CommandType = Data.CommandType.StoredProcedure
        //    //        CMD_o.Parameters.AddWithValue("@counter", xxCounter)
        //    //        Dim readerO As SqlDataReader
        //    //        readerO = CMD_o.ExecuteReader
        //    //        Else  /// ELSE CODE IS EXECUTED
        //    //            Session("ShippingCartShippingMethod") = ""
        //    //            Session("ShippingCartZone") = ""
        //    //            If xxResidentialDelivery = "" Then
        //    //                Session("ResidentialDelivery") = "NO"
        //    //            Else
        //    //                Session("ResidentialDelivery") = "YES"
        //    //            End If
        //    //        End If
        //    //    End Using
        //    //    Session("ShippingCartCountry") = Session("Country")
        //    //    Session("ShippingCartPostalCode") = Session("PostalCode")
        //    //    If Len(Session("ShippingCartPostalCode")) = 0 Then Session("ShippingCartPostalCode") = ""
        //    //    Session("WebOrderNumberJustPurchased") = ""
        //    //    Session("CustomerID") = IsDBSomething(Session("CustomerID"), "")
        //    //End If

        //    //Session("ShippingCartCountry") = Session("Country")
        //    //Session("ShippingCartPostalCode") = Session("PostalCode")
        //    //If Len(Session("ShippingCartPostalCode")) = 0 Then Session("ShippingCartPostalCode") = ""
        //    //Session("WebOrderNumberJustPurchased") = ""
        //    //Session("CustomerID") = IsDBSomething(Session("CustomerID"), "")

        //    //'Empty Retail Cart Into Wholesale Cart (if not a PowerUser) 
        //    //Dim RetailNameOfCart As String = ""
        //    //Dim WholesaleNameOfCart As String = ""
        //    //RetailNameOfCart = "CART" & Session.SessionID & Session("CartRandomNumbersExtension")
        //    //WholesaleNameOfCart = "W_CART_" & Session("CustomerServerCounter")
        //    //If Session("PowerUserName") = "" Then
        //    //    Using conn3 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
        //    //        SqlConnection.ClearPool(conn3)
        //    //        conn3.Open()
        //    //        Dim CMD_RC As New SqlCommand("spGetCartItems", conn3)
        //    //        CMD_RC.CommandType = Data.CommandType.StoredProcedure
        //    //        CMD_RC.Parameters.AddWithValue("@CartName", RetailNameOfCart)
        //    //        Dim readerRC As SqlDataReader
        //    //        readerRC = CMD_RC.ExecuteReader
        //    //        If readerRC.HasRows Then
        //    //            Do While readerRC.Read
        //    //                If readerRC("Quantity") = 0 Then
        //    //                    Using conn4 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
        //    //                        SqlConnection.ClearPool(conn4)
        //    //                        conn4.Open()
        //    //                        Dim CMD_D As New SqlCommand("spDeleteCartItem", conn4)
        //    //                        CMD_D.CommandType = Data.CommandType.StoredProcedure
        //    //                        CMD_D.Parameters.AddWithValue("@CartName", RetailNameOfCart)
        //    //                        CMD_D.Parameters.AddWithValue("@ItemID", readerRC("ItemID"))
        //    //                        CMD_D.ExecuteNonQuery()
        //    //                    End Using
        //    //                Else
        //    //                    Using conn4 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
        //    //                        SqlConnection.ClearPool(conn4)
        //    //                        conn4.Open()
        //    //                        Dim CMD_D As New SqlCommand("spGetInventoryItem", conn4)
        //    //                        CMD_D.CommandType = Data.CommandType.StoredProcedure
        //    //                        CMD_D.Parameters.AddWithValue("@ID", readerRC("ItemID"))
        //    //                        Dim readerInv As SqlDataReader
        //    //                        readerInv = CMD_D.ExecuteReader
        //    //                        If readerInv.HasRows Then
        //    //                            readerInv.Read()
        //    //                            If xxPriceGroup = "StorePrice" Then
        //    //                                If Not IsDBNull(readerInv("Sale_WholesalePrice")) And Not IsDBNull(readerInv("Sale_WholesaleEndDate")) Then
        //    //                                    If DateDiff(DateInterval.Day, Date.Now, readerInv("Sale_WholesaleEndDate")) >= 0 Then
        //    //                                        varSaleItem = 1
        //    //                                    End If
        //    //                                End If
        //    //                            Else
        //    //                                If Not IsDBNull(readerInv("Sale_RetailPrice")) And Not IsDBNull(readerInv("Sale_RetailEndDate")) Then
        //    //                                    If DateDiff(DateInterval.Day, Date.Now, readerInv("Sale_RetailEndDate")) >= 0 Then
        //    //                                        varSaleItem = 1
        //    //                                    End If
        //    //                                End If
        //    //                            End If
        //    //                            If varSaleItem = 1 Then
        //    //                                If xxPriceGroup = "StorePrice" Then
        //    //                                    If IsDBNull(readerInv("Sale_WholesalePrice")) Then
        //    //                                        WholesalePrice = 0
        //    //                                    Else
        //    //                                        WholesalePrice = readerInv("Sale_WholesalePrice")
        //    //                                    End If
        //    //                                Else
        //    //                                    If IsDBNull(readerInv("Sale_RetailPrice")) Then
        //    //                                        WholesalePrice = 0
        //    //                                    Else
        //    //                                        WholesalePrice = readerInv("Sale_RetailPrice")
        //    //                                    End If
        //    //                                End If
        //    //                            ElseIf Session("PriceGroup") = "StorePrice" Then
        //    //                                WholesalePrice = readerInv("StorePrice")
        //    //                            ElseIf Session("PriceGroup") = "RetailPrice" Then
        //    //                                WholesalePrice = readerInv("RetailPrice")
        //    //                            End If
        //    //                        End If
        //    //                    End Using
        //    //                    Using conn4 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
        //    //                        SqlConnection.ClearPool(conn4)
        //    //                        conn4.Open()
        //    //                        Dim CMD_D As New SqlCommand("spAddRetailCartItemToWholesaleCart", conn4)
        //    //                        CMD_D.CommandType = Data.CommandType.StoredProcedure
        //    //                        CMD_D.Parameters.AddWithValue("@CartName", WholesaleNameOfCart)
        //    //                        CMD_D.Parameters.AddWithValue("@ItemID", readerRC("ItemID"))
        //    //                        CMD_D.Parameters.AddWithValue("@Quantity", readerRC("Quantity"))
        //    //                        CMD_D.Parameters.AddWithValue("@WholesalePrice", WholesalePrice)
        //    //                        CMD_D.Parameters.AddWithValue("@SearchCriteriaStatisticsID", readerRC("SearchCriteriaStatisticsID"))
        //    //                        CMD_D.Parameters.AddWithValue("@IPAddress", readerRC("IPAddress"))
        //    //                        CMD_D.ExecuteNonQuery()
        //    //                    End Using
        //    //                End If
        //    //                Response.Cookies("Chosen").Value = "none"
        //    //                Response.Cookies("Chosen").Path = "/"
        //    //            Loop
        //    //            Using conn4 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
        //    //                SqlConnection.ClearPool(conn4)
        //    //                conn4.Open()
        //    //                Dim CMD_D As New SqlCommand("spDeleteCart", conn4)
        //    //                CMD_D.CommandType = Data.CommandType.StoredProcedure
        //    //                CMD_D.Parameters.AddWithValue("@CartName", RetailNameOfCart)
        //    //                CMD_D.ExecuteNonQuery()
        //    //            End Using
        //    //            Using conn4 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
        //    //                SqlConnection.ClearPool(conn4)
        //    //                conn4.Open()
        //    //                Dim CMD_D As New SqlCommand("spUpdateCartQuantityInCustomersTable", conn4)
        //    //                CMD_D.CommandType = Data.CommandType.StoredProcedure
        //    //                CMD_D.Parameters.AddWithValue("@CustomerServerCounter", IsSomething(Session("CustomerServerCounter"), "0"))
        //    //                CMD_D.ExecuteNonQuery()
        //    //            End Using
        //    //        End If
        //    //    End Using
        //    //End If

        //    //'Redirect Successful Log In
        //    //If varBroadcastLinkURL<> "" Then
        //    //    Response.Redirect("/home.aspx?" & varBroadcastLinkURL)
        //    //ElseIf Session("PowerUserName") <> "" Then
        //    //    If Request.QueryString("OrderSearchResultsHoldPileNumber") <> "" Then
        //    //        Response.Redirect("/CustomerOrders.aspx?OrderSearchResultsHoldPileNumber=" & Request.QueryString("OrderSearchResultsHoldPileNumber"))
        //    //    ElseIf Request.QueryString("ViewInvoices") = "yes" Then
        //    //        Response.Redirect("/CustomerOrders.aspx")
        //    //    Else
        //    //        Response.Redirect("/CustomerInfo.aspx")
        //    //    End If
        //    //Else
        //    //    If UCase(varLogInEmailMaster) = "POTATOKID2004@GMAIL.COM" Or UCase(varLogInEmailMaster) = "KDOGROSS06@GMAIL.COM" Or UCase(varLogInEmailMaster) = "HECHARLOTTE31@GMAIL.COM" Then
        //    //        Response.Redirect("/EnterStock.aspx")
        //    //    Else
        //    //        Response.Redirect("/WholesaleAccepted.aspx")
        //    //    End If
        //    //End If
        //}
    }
}