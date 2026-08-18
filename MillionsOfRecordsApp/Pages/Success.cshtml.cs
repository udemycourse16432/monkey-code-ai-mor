using Microsoft.AspNetCore.Mvc;
using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Extensions;
using MillionsOfRecordsApp.Models;
using MillionsOfRecordsApp.Pages.Base;
using MillionsOfRecordsApp.Services;
using PaypalServerSdk.Standard.Models;
using System.Text;

namespace MillionsOfRecordsApp.Pages;

public class SuccessModel : MillionsBasePageModel
{
    private readonly IEmailService _emailService;
    public SuccessModel(ReggaeDbContext context, IReggaeDbContextProcedures procedures, CartService cartService, IEmailService emailService) :
        base(context, cartService, procedures)
    {
        _emailService = emailService;
    }
    // --- Order Header Properties ---
    public string OrderNumber { get; set; } = string.Empty;
    public string CustomerEmail { get; set; } = string.Empty;

    // --- Shipping Properties ---
    public string ShippingName { get; set; } = string.Empty;
    public string AddressLine1 { get; set; } = string.Empty;
    public string City { get; set; } = string.Empty;
    public string State { get; set; } = string.Empty;
    public string Zip { get; set; } = string.Empty;
    public string ShippingMethod { get; set; } = string.Empty;

    // --- Totals ---
    public decimal ShippingCost { get; set; }
    public decimal SalesTax { get; set; }
    public decimal GrandTotal { get; set; }

    // --- Line Items ---
    public List<OrderItemViewModel> OrderItems { get; set; } = new();

    public async Task<IActionResult> OnGetAsync(string orderNumber)
    {
        if (!HttpContext.Session.IsLoggedIn())
        {
            //https://localhost:7244/checkout/success?orderNumber=WEB-519-677-963// Build the target path with its own querystring
            string targetPath = $"/checkout/success?orderNumber={orderNumber}";

            // Pass that full path as the returnUrl parameter
            return RedirectToPage("/SignIn", new { returnUrl = targetPath });
        }
        // exec spGetOrdersRow @OrderNumber=N'WEB-386-231-224'
        List<spGetOrdersRowResult> ordersRowResults = await _procedures.spGetOrdersRowAsync(orderNumber);
        if (ordersRowResults.Count == 0)
        {
            // Redirect to home page
            return RedirectToPage("YourOrders");
        }
        spGetOrdersRowResult orderRow = ordersRowResults.First();

        // Security: the order must belong to the currently logged-in customer.
        // Prevent IDOR - enumeration of other customers' order confirmations.
        if (orderRow.CustomerServerCounter != HttpContext.Session.GetCustomerServerCounter())
        {
            return RedirectToPage("YourOrders");
        }

        List<spGetWebSHIPX_ShippingMethodsRowResult> shippingMethods = await _procedures.spGetWebSHIPX_ShippingMethodsRowAsync(orderRow.ShippingMethod);

        // 'Shipping Method and Payment Method
        spGetWebSHIPX_ShippingMethodsRowResult shippingMethodsRowResult = shippingMethods.First();
        string shippingMethodForOrder = $"{shippingMethodsRowResult.ShippingViaCompany} ({shippingMethodsRowResult.ShipViaService})";
        string shippingMethodText = string.Empty;
        if (shippingMethodsRowResult.ShippingViaCompany == "Federal Express")
        {
            shippingMethodText = shippingMethodsRowResult.ShipViaService == "Ground" ? "FedexGround" : "FedexAir";
        }
        else if (shippingMethodsRowResult.ShippingViaCompany == "US Mail")
        {
            shippingMethodText = "USPS";
        }
        else if (shippingMethodsRowResult.ShippingViaCompany == "UPS" && shippingMethodsRowResult.ShipViaService == "Ground")
        {
            shippingMethodText = "UPSGround";
        }

        //'Items spGetOrderItems
        List<spGetOrderItemsResult> orderItemsResults = await _procedures.spGetOrderItemsAsync(orderNumber);
        if (orderItemsResults.Count == 0)
        {
            // Redirect to home page
            return RedirectToPage("YourOrders");
        }

        foreach (var orderItem in orderItemsResults)
        {
            string description = orderItem.Description ?? "";
            List<spInventoryItemFeaturesForListViewResult> features = await _procedures.spInventoryItemFeaturesForListViewAsync(orderItem.InventoryID.GetValueOrDefault());
            foreach (var feature in features)
            {
                description += $" ({feature.ItemFeatureWebProductDetailsPageText.Replace("\"", "'")})";
            }
            OrderItems.Add(
                new OrderItemViewModel
                {
                    Format = orderItem.Format,
                    Description = description,
                    Label = orderItem.Label,
                    Quantity = orderItem.Quantity ?? 0,
                    Total = orderItem.Inventory > 0 ? orderItem.Price ?? 0 : 0,
                    Inventory = orderItem.Inventory,
                });
        }


        OrderNumber = !string.IsNullOrEmpty(orderRow.OrderNumber) ? orderRow.OrderNumber : "N/A";
        CustomerEmail = orderRow.Email;


        ShippingName = orderRow.FullName;
        AddressLine1 = orderRow.StreetAddress1;
        City = orderRow.City;
        State = orderRow.StateProvince;
        Zip = orderRow.PostalCode;
        ShippingMethod = shippingMethodForOrder;

        // Mocking Order Totals
        ShippingCost = orderRow.Shipping.GetValueOrDefault();
        SalesTax = orderRow.Tax.GetValueOrDefault();

        // Calculate Grand Total
        decimal subtotal = 0;
        foreach (var item in OrderItems) subtotal += (item.Total * item.Quantity);
        GrandTotal = subtotal + ShippingCost + SalesTax;


        if (string.IsNullOrWhiteSpace(orderRow.EmailedConfirmation))
        {
            var emailFooterResults = await _procedures.spGetEmailFooterAsync();
            string footerContent = emailFooterResults?.FirstOrDefault()?.Footer ?? "";
            string htmlBody = GetBuyerConfirmationHtml(orderRow, footerContent);
            int spUpdateEmailedOrderConfirmationCount = await _procedures.spUpdateEmailedOrderConfirmationAsync(orderRow.OrderNumber);
            //await _emailService.SendEmailAsync(
            //     orderRow.Email,
            //     $"Order Confirmation: {orderRow.OrderNumber} - Millions of Records",
            //     htmlBody
            // );

            ////Email Ernie
            //htmlBody = GetOrderNotificationHtml(orderRow, OrderItems, shippingMethodText);
            //string emailSubject = $"🛒 OWEB | {orderRow.OrderTotal.GetValueOrDefault():C} | {orderRow.TotalQuantity} | {orderRow.FullName}";
            //await _emailService.SendEmailAsync("ernieb12345@gmail.com", emailSubject, htmlBody);
        }

        return Page();
    }
    private string GetBuyerConfirmationHtml(spGetOrdersRowResult orderRow, string footerHtml)
    {
        var sb = new StringBuilder();

        // Container Styling
        sb.AppendLine("<div style='font-family: \"Montserrat\", sans-serif, Arial; max-width: 600px; color: #333; margin: 0 auto; border: 1px solid #eee; border-radius: 12px; overflow: hidden;'>");

        // Header - Clean Branding
        sb.AppendLine("<div style='background: #1a1a1a; color: #FFD200; padding: 40px 20px; text-align: center;'>");
        sb.AppendLine("<h1 style='margin: 0; font-size: 24px; text-transform: uppercase; letter-spacing: 3px;'>Order Confirmed</h1>");
        sb.AppendLine($"<p style='margin: 10px 0 0; color: #fff; opacity: 0.8;'>Thank you for choosing Millions of Records</p>");
        sb.AppendLine("</div>");

        // Body
        sb.AppendLine("<div style='padding: 30px; background: #ffffff;'>");
        sb.AppendLine($"<p style='font-size: 16px;'>Hi <strong>{orderRow.FullName}</strong>,</p>");
        sb.AppendLine("<p style='line-height: 1.6; color: #555;'>We've received your order and we're getting it ready for shipment! You can view your invoice or track your delivery status anytime through your account.</p>");

        // Order CTA Button
        sb.AppendLine("<div style='text-align: center; margin: 30px 0;'>");
        sb.AppendLine("<a href='https://millionsofrecords.com/Account/Orders' style='background: #FFD200; color: #000; padding: 15px 30px; text-decoration: none; border-radius: 8px; font-weight: 700; display: inline-block;'>VIEW YOUR ORDER</a>");
        sb.AppendLine("</div>");

        // Shipping Summary Box
        sb.AppendLine("<div style='background: #f8f8f8; padding: 20px; border-radius: 8px; margin-bottom: 30px;'>");
        sb.AppendLine("<h4 style='margin: 0 0 10px 0; font-size: 12px; text-transform: uppercase; color: #888;'>Shipping To:</h4>");
        sb.AppendLine($"<p style='margin: 0; font-weight: 600;'>{orderRow.FullName}</p>");
        sb.AppendLine($"<p style='margin: 0; font-size: 14px; color: #555;'>{orderRow.StreetAddress1}</p>");
        if (!string.IsNullOrWhiteSpace(orderRow.StreetAddress2)) sb.AppendLine($"<p style='margin: 0; font-size: 14px; color: #555;'>{orderRow.StreetAddress2}</p>");
        sb.AppendLine($"<p style='margin: 0; font-size: 14px; color: #555;'>{orderRow.City}, {orderRow.StateProvince} {orderRow.PostalCode}</p>");
        sb.AppendLine($"<p style='margin: 0; font-size: 14px; color: #555;'>{orderRow.Country}</p>");
        sb.AppendLine("</div>");

        // Footer / Professional Sign-off
        sb.AppendLine("<div style='border-top: 1px solid #eee; padding-top: 20px; font-size: 13px; color: #999;'>");
        sb.AppendLine("<p style='margin-bottom: 5px;'>Thank you,</p>");
        sb.AppendLine("<p style='margin-top: 0; font-weight: 600; color: #333;'>Millions of Records Team</p>");

        if (!string.IsNullOrWhiteSpace(footerHtml))
        {
            sb.AppendLine($"<div style='margin-top: 20px; font-style: italic;'>{footerHtml}</div>");
        }
        sb.AppendLine("</div>");

        sb.AppendLine("</div>"); // Close Body
        sb.AppendLine("</div>"); // Close Container

        return sb.ToString();
    }
    private string GetOrderNotificationHtml(spGetOrdersRowResult orderRow, IEnumerable<OrderItemViewModel> orderItems, string shippingMethodText)
    {
        var sb = new StringBuilder();

        // Container Styling
        sb.AppendLine("<div style='font-family: \"Montserrat\", sans-serif, Arial; max-width: 700px; color: #333; background: #f9f9f9; padding: 20px;'>");

        // Header - Black & Gold 2026 Branding
        sb.AppendLine("<div style='background: #1a1a1a; color: #FFD200; padding: 30px; border-radius: 12px 12px 0 0; text-align: center;'>");
        sb.AppendLine($"<h1 style='margin: 0; text-transform: uppercase; letter-spacing: 2px; font-size: 24px;'>New Order Received</h1>");
        sb.AppendLine($"<p style='margin: 10px 0 0; color: #fff; opacity: 0.7;'>Order #{orderRow.OrderNumber} &bull; {orderRow.DateTime:f}</p>");
        sb.AppendLine("</div>");

        // Body Content
        sb.AppendLine("<div style='background: #ffffff; padding: 30px; border: 1px solid #eee; border-top: none; border-radius: 0 0 12px 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.05);'>");

        // Section 1: Customer & Shipping
        sb.AppendLine("<table width='100%' cellpadding='0' cellspacing='0' style='margin-bottom: 30px;'>");
        sb.AppendLine("<tr>");
        sb.AppendLine("<td width='50%' valign='top' style='padding-right: 20px;'>");
        sb.AppendLine("<h4 style='color: #888; text-transform: uppercase; font-size: 11px; margin-bottom: 10px;'>Customer Details</h4>");
        sb.AppendLine($"<p style='margin: 0;'><strong>{orderRow.FullName}</strong></p>");
        sb.AppendLine($"<p style='margin: 0; font-size: 13px;'>{orderRow.Email}</p>");
        sb.AppendLine($"<p style='margin: 0; font-size: 13px;'>{orderRow.Phone}</p>");
        sb.AppendLine($"<p style='margin: 5px 0 0; font-size: 11px; color: #bbb;'>IP: {orderRow.IPAddress} | {orderRow.PriceGroup}</p>");
        sb.AppendLine("</td>");
        sb.AppendLine("<td width='50%' valign='top' style='border-left: 1px solid #eee; padding-left: 20px;'>");
        sb.AppendLine("<h4 style='color: #888; text-transform: uppercase; font-size: 11px; margin-bottom: 10px;'>Shipping To</h4>");
        sb.AppendLine($"<p style='margin: 0;'>{orderRow.StreetAddress1}</p>");
        if (!string.IsNullOrWhiteSpace(orderRow.StreetAddress2)) sb.AppendLine($"<p style='margin: 0;'>{orderRow.StreetAddress2}</p>");
        sb.AppendLine($"<p style='margin: 0;'>{orderRow.City}, {orderRow.StateProvince} {orderRow.PostalCode}</p>");
        sb.AppendLine($"<p style='margin: 10px 0 0;'><strong>{shippingMethodText}</strong></p>");
        sb.AppendLine("</td>");
        sb.AppendLine("</tr>");
        sb.AppendLine("</table>");

        // Section 2: Order Notes
        if (!string.IsNullOrWhiteSpace(orderRow.OrderNotes))
        {
            sb.AppendLine("<div style='background: #fff9db; padding: 15px; border-left: 4px solid #FFD200; border-radius: 4px; margin-bottom: 30px;'>");
            sb.AppendLine($"<p style='margin: 0; font-size: 13px;'><strong>Notes:</strong> {orderRow.OrderNotes}</p>");
            sb.AppendLine("</div>");
        }

        // Section 3: Itemized Table
        sb.AppendLine("<h4 style='color: #888; text-transform: uppercase; font-size: 11px; margin-bottom: 15px;'>Inventory Pull Sheet</h4>");
        sb.AppendLine("<table width='100%' style='border-collapse: collapse;'>");
        sb.AppendLine("<tr style='text-align: left; font-size: 12px; color: #999; border-bottom: 2px solid #eee;'>");
        sb.AppendLine("<th style='padding: 10px;'>FMT</th>");
        sb.AppendLine("<th style='padding: 10px;'>Description / Label</th>");
        sb.AppendLine("<th style='padding: 10px; text-align: center;'>QTY</th>");
        sb.AppendLine("<th style='padding: 10px; text-align: right;'>Price</th>");
        sb.AppendLine("</tr>");

        foreach (var item in orderItems)
        {
            sb.AppendLine("<tr style='border-bottom: 1px solid #f2f2f2; font-size: 14px;'>");
            sb.AppendLine($"<td style='padding: 15px 10px; font-weight: bold; color: #007bff;'>{item.Format}</td>");
            sb.AppendLine($"<td style='padding: 15px 10px;'><strong>{item.Description.Trim()}</strong><br><span style='font-size: 12px; color: #777;'>{item.Label}</span></td>");
            sb.AppendLine($"<td style='padding: 15px 10px; text-align: center;'>{item.Quantity} <small style='color:#ccc; display:block;'>Stock: {item.Inventory ?? 0}</small></td>");
            sb.AppendLine($"<td style='padding: 15px 10px; text-align: right; font-weight: bold;'>{item.Total:C}</td>");
            sb.AppendLine("</tr>");
        }
        sb.AppendLine("</table>");

        // Section 4: Totals Summary
        sb.AppendLine("<div style='margin-top: 30px; padding-top: 20px; border-top: 2px solid #eee; text-align: right;'>");
        sb.AppendLine($"<p style='margin: 5px 0; color: #777;'>Goods: {orderRow.TotalPrice.GetValueOrDefault():C}</p>");
        sb.AppendLine($"<p style='margin: 5px 0; color: #777;'>Shipping: {orderRow.Shipping.GetValueOrDefault():C}</p>");
        sb.AppendLine($"<p style='margin: 5px 0; color: #777;'>Tax: {orderRow.Tax.GetValueOrDefault():C}</p>");
        sb.AppendLine($"<h2 style='margin: 10px 0 0; color: #1a1a1a; font-size: 28px;'>Total: {orderRow.OrderTotal.GetValueOrDefault():C}</h2>");
        sb.AppendLine("</div>");

        sb.AppendLine("</div>"); // Close White Body
        sb.AppendLine("<p style='text-align: center; color: #bbb; font-size: 11px; margin-top: 20px;'>Millions of Records &copy; 2026 Internal Notification</p>");
        sb.AppendLine("</div>"); // Close Wrapper

        return sb.ToString();
    }
}

/// <summary>
/// View model for individual items in the order summary
/// </summary>
public class OrderItemViewModel
{
    public string Format { get; set; } = string.Empty; // e.g., 45, LP, CD
    public string Description { get; set; } = string.Empty;
    public string Label { get; set; } = string.Empty;
    public int Quantity { get; set; }
    public decimal Total { get; set; }
    public int? Inventory { get; set; }
}