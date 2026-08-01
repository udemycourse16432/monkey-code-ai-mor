using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Extensions;
using MillionsOfRecordsApp.Services;

namespace MillionsOfRecordsApp.Pages.Base;

public abstract class MillionsBasePageModel : PageModel
{
    protected readonly ReggaeDbContext _context;
    protected readonly CartService _cartService;
    protected readonly IReggaeDbContextProcedures _procedures;
    protected MillionsBasePageModel(ReggaeDbContext context, CartService cartService, IReggaeDbContextProcedures procedures)
    {
        _context = context;
        _cartService = cartService;
        _procedures = procedures;
    }
    public override async Task OnPageHandlerExecutionAsync(
        PageHandlerExecutingContext context,
        PageHandlerExecutionDelegate next)
    {
        // 1. Run our Cart Loading logic
        await LoadCartInfoAsync();

        // 2. Continue to the actual page handler (OnGet/OnPost)
        await next();
    }

    private async Task LoadCartInfoAsync()
    {
        string nameOfCart = HttpContext.Session.GetActiveCartName();

        // Count Items
        var totalItems = await _cartService.GetCartTotalItems(nameOfCart);
        //var count = await _context.Carts.CountAsync(c => c.CartName == nameOfCart);
        HttpContext.Session.SetCartCount(totalItems);

        //// Get Weight
        //var results = await _procedures.spGetWeightOfProductAsync(nameOfCart);
        ////var result = await _context.Database
        ////    .SqlQueryRaw<decimal>("EXEC spGetWeightOfProduct @CartName", new SqlParameter("@CartName", nameOfCart))
        ////    .ToListAsync();
        //var result = results.FirstOrDefault();
        //if (result != null)
        //{
        //    HttpContext.Session.SetTotalWeightGrams((int)(result.sumweight));
        //}
    }
}
