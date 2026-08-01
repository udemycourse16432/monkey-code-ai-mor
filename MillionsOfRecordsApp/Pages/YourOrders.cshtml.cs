using Microsoft.AspNetCore.Mvc;
using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Extensions;
using MillionsOfRecordsApp.Models;
using MillionsOfRecordsApp.Pages.Base;
using MillionsOfRecordsApp.Services;
using System.Text.RegularExpressions;

namespace MillionsOfRecordsApp.Pages
{
    public class YourOrdersModel : MillionsBasePageModel
    {
        public YourOrdersModel(ReggaeDbContext context, CartService cartService, IReggaeDbContextProcedures procedures) : base(context, cartService, procedures) { }

        public List<OrderViewModel> Orders { get; set; } = new();

        const string InProgressMessage = "In Progress, we'll update when shipped";
        const string shipDateInProgressMessage = "Within 24 Hours";
        public async Task<IActionResult> OnGetAsync()
        {

            if (!HttpContext.Session.IsLoggedIn())
            {
                return RedirectToPage("/SignIn", new { returnUrl = "/your-orders" });
            }
            int customerServerCounter = HttpContext.Session.GetCustomerServerCounter();
            List<spGetPendingCustomerOrdersResult> pendingOrders =
                await _procedures.spGetPendingCustomerOrdersAsync(customerServerCounter);

            var p = pendingOrders.Select(order => new OrderViewModel
            {
                OrderDate = order.DateTime?.ToString("MM/dd/yyyy") ?? "N/A",
                OrderId = order.OrderNumber,
                InvoiceNo = InProgressMessage,//order.InvoiceNumber?.ToString() ?? "N/A",
                Total = InProgressMessage, //order.OrderTotal.GetValueOrDefault(),
                ShipDate = shipDateInProgressMessage,//order.ShipDate?.ToString("MM/dd/yyyy") ?? "N/A",
                ShipVia = InProgressMessage,
                TrackingNumber = InProgressMessage,
                IsPendingOrder = true,
            }).ToList();

            Orders.AddRange(p);

            List<spGetCustomerInvoicesResult> invoicesResults = await _procedures.spGetCustomerInvoicesAsync(customerServerCounter);

            var i = invoicesResults.Select(invoice =>
            {
                bool isArchived = (DateTime.Now - invoice.ShipDate).TotalDays > 365;
                string trackingUrl = GetTrackingUrl(invoice.TrackingNumber, invoice.ShippingCompany);
                return
                    new OrderViewModel
                    {
                        OrderDate = invoice.InvoiceDate.ToString("MM/dd/yyyy"),
                        OrderId = invoice.WebOrderNumbers,
                        InvoiceNo = invoice.InvoiceNumber.ToString(),//order.InvoiceNumber?.ToString() ?? "N/A",
                        Total = invoice.InvoiceTotal.ToString("C"), //order.OrderTotal.GetValueOrDefault(),
                        ShipDate = invoice.ShipDate.ToString("MM/dd/yyyy"),//order.ShipDate?.ToString("MM/dd/yyyy") ?? "N/A",
                        ShipVia = $"{invoice.ShippingCompany} {invoice.ShippingServiceName}",
                        IsArchived = isArchived,
                        TrackingNumber = invoice.TrackingNumber,
                        TrackingUrl = trackingUrl,
                        PDFFileName = $"{invoice.PDFFileName}.pdf"
                    };
            }).ToList();
            Orders.AddRange(i);

            return Page();
        }

        public static string GetTrackingUrl(string trackingNumber, string shippingCompany)
        {
            if (string.IsNullOrWhiteSpace(trackingNumber) || trackingNumber.Length < 5)
                return "NA";

            string carrier = shippingCompany?.ToUpper() ?? "";

            // Clean data once using high-performance Regex
            // This removes 'combined', spaces, and non-alphanumeric chars in one pass
            string cleanInput = Regex.Replace(trackingNumber, @"(?i)combined|[^a-zA-Z0-9;]", ";");
            var numbers = cleanInput.Split(';', StringSplitOptions.RemoveEmptyEntries);

            if (!numbers.Any()) return "NA";

            // 2026 Strategy: Use the first number for the primary link base 
            // but keep support for multi-tracking strings.
            return carrier switch
            {
                var c when c.Contains("FEDEX") || c.Contains("FEDERAL")
                    => $"https://www.fedex.com/fedextrack/?trknbr={string.Join(",", numbers)}",

                var c when c.Contains("UPS")
                    => $"https://www.ups.com/track?tracknum={string.Join("%20", numbers)}",

                var c when c.Contains("USPS") || c.Contains("MAIL")
                    => $"https://tools.usps.com/go/TrackConfirmAction.action?tLabels={string.Join(",", numbers)}",

                var c when c.Contains("DHL")
                    => $"https://www.dhl.com/en/express/tracking.html?AWB={string.Join(",", numbers)}",

                // New for 2026: Add a generic "AfterShip" or "17Track" fallback 
                // for international/unknown carriers
                _ => $"https://www.17track.net/en/track?nums={string.Join(",", numbers)}"
            };
        }
    }

    public class OrderViewModel
    {
        public string OrderDate { get; set; } = string.Empty;
        public string OrderId { get; set; } = string.Empty;
        public string InvoiceNo { get; set; } = string.Empty;
        public string Total { get; set; } = string.Empty;
        public string ShipDate { get; set; } = string.Empty;
        public string ShipVia { get; set; } = string.Empty;
        public string TrackingNumber { get; set; } = string.Empty;
        public string PDFFileName { get; set; } = string.Empty;
        public bool IsArchived { get; set; } = false;
        public bool IsPendingOrder { get; set; } = false;
        public string TrackingUrl { get; set; } = string.Empty;
    }
}
