using Microsoft.AspNetCore.Mvc;
using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Extensions;
using MillionsOfRecordsApp.Models;
using MillionsOfRecordsApp.Models.DTOs;
using MillionsOfRecordsApp.Services;

namespace MillionsOfRecordsApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [IgnoreAntiforgeryToken]
    public class CartController : ControllerBase
    {
        CartService _cartService;
        ShippingService _shippingService;
        IReggaeDbContextProcedures _procedures;
        public CartController(CartService cartService, ShippingService shippingService, IReggaeDbContextProcedures procedures)
        {
            _cartService = cartService;
            _shippingService = shippingService;
            _procedures = procedures;
        }
        [HttpPost("add")]
        public async Task<IActionResult> Add([FromBody] CartRequest request)
        {
            // 1. Validation Logic
            if (request.Id <= 0) return BadRequest("Invalid ID");

            // 2. Map Session variables (Modern HttpContext)
            var cartName = HttpContext.Session.GetActiveCartName();

            int.TryParse(HttpContext.Session.GetCustomerID(), out int customerId);

            await _procedures.AdjustCartAsync(
                 iD: request.Id,
                 price: request.Price,
                 type: request.Type,
                 qty: request.Qty,
                 cartName: cartName,
                 iPAddress: HttpContext.Connection.RemoteIpAddress?.ToString(),
                 searchCriteriaStatisticsID: request.SearchId,
                 customerID: customerId);

            int customerServerCounter = HttpContext.Session.GetCustomerServerCounter();
            if (customerServerCounter != 0)
            {
                await _procedures.spUpdateCartQuantityInCustomersTableAsync(customerServerCounter);
            }
            int totalItems = await _cartService.GetCartTotalItems(cartName);

            HttpContext.Session.SetCartCount(totalItems);

            // 4. Return the count to the frontend
            return Ok(new CartResponse { Success = true, Message = "OK", CartCount = totalItems });
        }

        [HttpPost("adjust")]
        public async Task<IActionResult> Adjust([FromBody] CartRequest request)
        {
            // 1. Validation Logic
            if (request.Id <= 0) return BadRequest("Invalid ID");

            // 2. Map Session variables (Modern HttpContext)
            var cartName = HttpContext.Session.GetActiveCartName();
            int.TryParse(HttpContext.Session.GetCustomerID(), out int customerId);

            // 3. Execute Stored Procedure via EF Core
            // Note: Using FromSqlInterpolated or ExecuteSqlInterpolated for safety
            await _procedures.AdjustCartAsync(
                 iD: request.Id,
                 price: request.Price,
                 type: request.Type,
                 qty: request.Qty,
                 cartName: cartName,
                 iPAddress: HttpContext.Connection.RemoteIpAddress?.ToString(),
                 searchCriteriaStatisticsID: request.SearchId,
                 customerID: customerId);
            //await _context.Database.ExecuteSqlInterpolatedAsync($@"
            //EXEC [dbo].[AdjustCart] 
            //    @ID={request.Id}, 
            //    @Price={request.Price}, 
            //    @Type={request.Type}, 
            //    @Qty={request.Qty}, 
            //    @CartName={cartName}, 
            //    @IPAddress={HttpContext.Connection.RemoteIpAddress?.ToString()}, 
            //    @SearchCriteriaStatisticsID={request.SearchId}, 
            //    @CustomerID={customerId}");

            await _procedures.spUpdateCartQuantityInCustomersTableAsync(customerServerCounter: HttpContext.Session.GetCustomerServerCounter());
            //exec spUpdateCartQuantityInCustomersTable @CustomerServerCounter = N'498043'


            List<(Cart Cart, Inventory Inv)> cartResults = await _cartService.GetCartDetailsAsync(cartName);

            decimal cartTotal = cartResults.Sum(x => x.Cart.Price * x.Cart.Quantity);
            int totalItems = cartResults.Sum(x => x.Cart.Quantity);

            decimal shippingFee = await _shippingService.FindZoneAndCalculateShippingChargeAsync(cartTotal, totalItems);
            decimal totalAmount = cartTotal + shippingFee;
            // 2. Get the NEW count from the database
            // 3. Update the Session so it persists on page refreshes
            HttpContext.Session.SetCartCount(totalItems);

            // 4. Return the count to the frontend
            return Ok(new CartResponse { Success = true, Message = "OK", CartCount = totalItems, ProductsPrice = cartTotal.ToString("F2"), ShippingFee = shippingFee.ToString("F2"), TotalAmount = totalAmount.ToString("F2") });
        }
    }
    public class CartResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; } = string.Empty;
        public int CartCount { get; set; }
        // New Fields
        public string ProductsPrice { get; set; } = string.Empty;
        public string ShippingFee { get; set; } = string.Empty;
        public string TotalAmount { get; set; } = string.Empty;
    }
}
