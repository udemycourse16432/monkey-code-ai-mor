using Microsoft.AspNetCore.Mvc.RazorPages;

namespace MillionsOfRecordsApp.Pages
{
    public class SignOutModel : PageModel
    {
        public void OnGet()
        {
            this.HttpContext.Session.Clear();
            this.HttpContext.Response.Redirect("/");
        }
    }
}
