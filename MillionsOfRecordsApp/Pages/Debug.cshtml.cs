using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace MillionsOfRecordsApp.Pages
{
    public class DebugModel : PageModel
    {
        public void OnGet()
        {
        }
        public IActionResult OnPostClearSession()
        {
            HttpContext.Session.Clear();
            return RedirectToPage();
        }
    }
}
