using Microsoft.AspNetCore.Mvc;
using MillionsOfRecordsApp.Data;

namespace MillionsOfRecordsApp.Controllers
{
    // to test this page use the following URL: https://localhost:7244/HTTPDownloadDataOK.aspx?pw=a5b6c8ugjt76g4q0m![]f67w2-lx3eu7&counter=12345&table=SignInLog
    [ApiController]
    [Route("HTTPDownloadDataOK.aspx")] // Keeps backwards compatibility with legacy URL calls
    public class HTTPDownloadDataOKController : ControllerBase
    {
        private readonly IReggaeDbContextProcedures _procedures;
        private readonly ILogger<HTTPDownloadDataOKController> _logger;
        private readonly string _downloadDataPassword;
        public HTTPDownloadDataOKController(
        IReggaeDbContextProcedures procedures,
        ILogger<HTTPDownloadDataOKController> logger,
        IConfiguration configuration)
        {
            _procedures = procedures;
            _logger = logger;
            // Fetch from appsettings / Environment Variables
            _downloadDataPassword = configuration["LegacyApiSettings:DownloadDataPassword"] ?? string.Empty;
        }

        [HttpGet]
        [HttpPost]
        public async Task<IActionResult> ProcessRequest(
            [FromQuery] string? pw,
            [FromQuery] string? counter,
            [FromQuery] string? table,
            [FromQuery] string? newcustomerid)
        {
            // Compare with configured secret
            if (string.IsNullOrEmpty(pw) || pw != _downloadDataPassword)
            {
                _logger.LogWarning("Invalid Credentials attempt from IP: {IP}", HttpContext.Connection.RemoteIpAddress);
                return Content("Invalid Credentials; IP Address Recorded");
            }
            // Truncate table parameter up to 100 characters as done in legacy ASPX
            string tableName = string.IsNullOrEmpty(table)
                ? string.Empty
                : table.Length > 100 ? table.Substring(0, 100) : table;

            if (int.TryParse(counter, out int parsedCounter))
            {
                string customerCounter = parsedCounter.ToString();
                switch (tableName)
                {
                    case "OrderCorrectionNotes":
                        await _procedures.spDownloadOK_OrderCorrectionNotesAsync(customerCounter);
                        break;

                    case "Carts":
                        await _procedures.spDownloadOK_CartsAsync(customerCounter);
                        break;

                    case "Carts_Deletes":
                        await _procedures.spDownloadOK_Carts_DeletesAsync(customerCounter);
                        break;

                    case "SignInLog":
                        await _procedures.spDownloadOK_SignInLogAsync(customerCounter);
                        break;

                    case "DeleteBackordersInStockNow":
                        await _procedures.spDownloadOK_DeleteBackordersInStockNowAsync(customerCounter);
                        break;

                    case "Customers":
                        await _procedures.spDownloadOK_CustomersAsync(customerCounter, newcustomerid);
                        break;

                    case "PayPalIPNsReceived":
                        await _procedures.spDownloadOK_PayPalIPNsReceivedAsync(customerCounter);
                        break;

                    case "Orders":
                        await _procedures.spDownloadOK_OrdersAsync(customerCounter);
                        break;

                    case "PayFlowRequests":
                        await _procedures.spDownloadOK_PayFlowRequestsAsync(customerCounter);
                        break;

                    case "EnterStock":
                        await _procedures.spDownloadOK_EnterStockAsync(customerCounter);
                        break;

                    case "Enter7Inch":
                        await _procedures.spDownloadOK_Enter7InchAsync(customerCounter);
                        break;

                    case "CustomerEmailChanges":
                        await _procedures.spDownloadOK_CustomerEmailChangesAsync(customerCounter);
                        break;

                    default:
                        // No matching table block executed
                        break;
                }

                return Content("OK");
            }

            return Content("Invalid Parameter");
        }
    }
}