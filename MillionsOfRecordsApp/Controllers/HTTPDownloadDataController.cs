using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Models;
using System.Text;

namespace MillionsOfRecordsApp.Controllers
{
    // to test this page use the following URL: https://localhost:7244/HTTPDownloadData.aspx?pw=a5b6c8ugjt76g4q0m![]f67w2-lx3eu7&table=Carts
    [ApiController]
    [Route("HTTPDownloadData.aspx")] // Keeps backwards compatibility with legacy URL calls
    public class HTTPDownloadDataController : ControllerBase
    {
        private readonly IReggaeDbContextProcedures _procedures;
        private readonly ILogger<HTTPDownloadDataController> _logger;
        private readonly string _downloadDataPassword;
        private readonly ReggaeDbContext _context;
        public HTTPDownloadDataController(
        IReggaeDbContextProcedures procedures,
        ILogger<HTTPDownloadDataController> logger,
        IConfiguration configuration,
        ReggaeDbContext context)
        {
            _procedures = procedures;
            _logger = logger;
            _context = context;
            // Fetch from appsettings / Environment Variables
            _downloadDataPassword = configuration["LegacyApiSettings:HTTPDownloadDataPassword"] ?? string.Empty;
        }

        [HttpGet]
        [HttpPost]
        public async Task<IActionResult> Index([FromForm] string? PW, [FromForm] string? table, [FromForm] string? ordernumber)
        {

            // Fallback to query string parameters if form values are empty
            PW ??= Request.Query["PW"].ToString();
            table ??= Request.Query["table"].ToString();
            ordernumber ??= Request.Query["ordernumber"].ToString();

            if (PW != _downloadDataPassword)
            {
                _logger.LogWarning("Invalid Credentials attempt from IP: {IP}", HttpContext.Connection.RemoteIpAddress);
                return Content("Invalid Credentials; IP Address Recorded", "text/plain");
            }

            string strTable = (table ?? string.Empty).Length > 100
                ? table!.Substring(0, 100)
                : (table ?? string.Empty);

            switch (strTable)
            {
                case "OrderItems":
                    {
                        string strOrderNumber = (ordernumber ?? string.Empty).Length > 20
                            ? ordernumber!.Substring(0, 20)
                            : (ordernumber ?? string.Empty);

                        var items = await _procedures.spHTTPDownloadDataOrderItemsAsync(strOrderNumber);

                        if (items != null && items.Any())
                        {
                            int intNumberOfRows = 0;
                            var properties = typeof(spHTTPDownloadDataOrderItemsResult).GetProperties();
                            int fieldCount = properties.Length;

                            StringBuilder sb = new StringBuilder();
                            sb.Append(fieldCount.ToString());
                            sb.Append("vfrqNEWROWpyhq");

                            foreach (var row in items)
                            {
                                intNumberOfRows++;
                                foreach (var prop in properties)
                                {
                                    var val = prop.GetValue(row)?.ToString() ?? string.Empty;
                                    sb.Append("9v!2wz");
                                    sb.Append(prop.Name);
                                    sb.Append("=");
                                    sb.Append(val);
                                }
                                sb.Append("vfrqNEWROWpyhq");
                            }

                            sb.Append("ROWSyte7s67w2qxuz");
                            sb.Append(intNumberOfRows.ToString());
                            return Content(sb.ToString(), "text/plain");
                        }

                        return Content("n", "text/plain");
                    }

                case "IsINTERNETREGGAEMaintenanceOpen":
                    {
                        var result = await _procedures.spSync_IsINTERNETREGGAEMaintenanceOpenGetValueAsync();
                        var firstRow = result?.FirstOrDefault();

                        if (firstRow != null)
                        {
                            string val = firstRow.IsINTERNETREGGAEMaintenanceOpen?.ToString() ?? string.Empty;
                            return Content($"xzsaq88aqdrtIsINTERNETREGGAEMaintenanceOpen={val}", "text/plain");
                        }

                        return Content("n", "text/plain");
                    }

                case "OrderCorrectionNotes":
                    {
                        var result = await _procedures.spDownload_OrderCorrectionNotesAsync();
                        return FormatSingleRowResponse(result?.FirstOrDefault());
                    }

                case "Carts":
                    {
                        var result = await _procedures.spDownload_CartsAsync();
                        return FormatSingleRowResponse(result?.FirstOrDefault());
                    }

                case "Carts_Deletes":
                    {
                        var result = await _procedures.spDownload_Carts_DeletesAsync();
                        return FormatSingleRowResponse(result?.FirstOrDefault());
                    }

                case "SignInLog":
                    {
                        var result = await _procedures.spDownload_SignInLogAsync();
                        return FormatSingleRowResponse(result?.FirstOrDefault());
                    }

                case "CustomerEmailChanges":
                    {
                        var result = await _procedures.spDownload_CustomerEmailChangesAsync();
                        return FormatSingleRowResponse(result?.FirstOrDefault());
                    }

                case "DeleteBackordersInStockNow":
                    {
                        var result = await _procedures.spDownload_DeleteBackordersInStockNowAsync();
                        return FormatSingleRowResponse(result?.FirstOrDefault());
                    }

                case "Customers":
                    {
                        var result = await _procedures.spDownload_CustomersAsync();
                        return FormatSingleRowResponse(result?.FirstOrDefault());
                    }

                case "PayPalIPNsReceived":
                    {
                        var result = await _procedures.spDownload_PayPalIPNsReceivedAsync();
                        return FormatSingleRowResponse(result?.FirstOrDefault());
                    }

                case "Orders":
                    {
                        //select DownloadOrders from DatabaseVariables
                        var downloadOrders = await _context.DatabaseVariables.Select(x => x.DownloadOrders).FirstOrDefaultAsync();
                        if (downloadOrders != "y")
                        {
                            return Content(string.Empty, "text/plain");
                        }

                        var orders = await _procedures.spDownload_OrdersAsync();
                        var orderRow = orders?.FirstOrDefault();

                        if (orderRow == null)
                        {
                            return Content("n", "text/plain");
                        }

                        StringBuilder sb = new StringBuilder();
                        var properties = orderRow.GetType().GetProperties();
                        sb.Append(properties.Length.ToString());

                        string strWebOrderNumber = string.Empty;

                        foreach (var prop in properties)
                        {
                            var val = prop.GetValue(orderRow)?.ToString() ?? string.Empty;
                            if (prop.Name.Equals("OrderNumber", StringComparison.OrdinalIgnoreCase))
                            {
                                strWebOrderNumber = val;
                            }
                            sb.Append("xzsaq88aqdrt");
                            sb.Append(prop.Name);
                            sb.Append("=");
                            sb.Append(val);
                        }

                        // Kirbys Cut Today
                        var todayCut = (await _procedures.spGetKirbysCutTodayAsync())?.FirstOrDefault();
                        sb.Append("xzsaq88aqdrtKirbysCutToday=").Append(todayCut?.Today6PercentCut?.ToString() ?? string.Empty);
                        sb.Append("xzsaq88aqdrtKirbysItemCutToday=").Append(todayCut?.TodayKirbyItemCut?.ToString() ?? string.Empty);
                        sb.Append("xzsaq88aqdrtKirbysCapDealCutToday=").Append(todayCut?.TodayKirbyCapDealCut?.ToString() ?? string.Empty);

                        // Kirbys Cut This Month
                        var monthCut = (await _procedures.spGetKirbysCutThisMonthAsync())?.FirstOrDefault();
                        sb.Append("xzsaq88aqdrtKirbysCutThisMonth=").Append(monthCut?.ThisMonth6PercentCut?.ToString() ?? string.Empty);
                        sb.Append("xzsaq88aqdrtKirbysItemCutThisMonth=").Append(monthCut?.ThisMonthKirbyItemCut?.ToString() ?? string.Empty);
                        sb.Append("xzsaq88aqdrtKirbysCapDealCutThisMonth=").Append(monthCut?.ThisMonthKirbyCapDealCut?.ToString() ?? string.Empty);

                        // Kirbys Cut This Order
                        var orderCut = (await _procedures.spGetKirbysCutThisOrderAsync(strWebOrderNumber))?.FirstOrDefault();
                        sb.Append("xzsaq88aqdrtKirbysCutThisOrder=").Append(orderCut?.ThisOrder6PercentCut?.ToString() ?? string.Empty);
                        sb.Append("xzsaq88aqdrtKirbysItemCutThisOrder=").Append(orderCut?.ThisOrderKirbyItemCut?.ToString() ?? string.Empty);
                        sb.Append("xzsaq88aqdrtKirbysCapDealCutThisOrder=").Append(orderCut?.ThisOrderKirbyCapDealCut?.ToString() ?? string.Empty);

                        // Check Kirby Item Data Insertion
                        var checkKirby = (await _procedures.spCheckForInsertKirbyItemDataAsync())?.FirstOrDefault();
                        if (checkKirby?.InsertData == "y")
                        {
                            await _procedures.spKirbyItemDataAsync();
                        }

                        return Content(sb.ToString(), "text/plain");
                    }

                case "PayFlowRequests":
                    {
                        var result = await _procedures.spDownload_PayFlowRequestsAsync();
                        return FormatSingleRowResponse(result?.FirstOrDefault());
                    }

                case "EnterStock":
                    {
                        var result = await _procedures.spDownload_EnterStockAsync();
                        return FormatSingleRowResponse(result?.FirstOrDefault());
                    }

                case "Enter7Inch":
                    {
                        var result = await _procedures.spDownload_Enter7InchAsync();
                        return FormatSingleRowResponse(result?.FirstOrDefault());
                    }

                default:
                    return Content(string.Empty, "text/plain");
            }
        }

        private ContentResult FormatSingleRowResponse<T>(T? row)
        {
            if (row == null)
            {
                return Content("n", "text/plain");
            }

            var properties = typeof(T).GetProperties();
            StringBuilder sb = new StringBuilder();
            sb.Append(properties.Length.ToString());

            foreach (var prop in properties)
            {
                var val = prop.GetValue(row)?.ToString() ?? string.Empty;
                sb.Append("xzsaq88aqdrt");
                sb.Append(prop.Name);
                sb.Append("=");
                sb.Append(val);
            }

            return Content(sb.ToString(), "text/plain");
        }
    }
}