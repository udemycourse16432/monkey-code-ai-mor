using MillionsOfRecordsApp.Extensions;
using StackExchange.Profiling;

namespace MillionsOfRecordsApp.Middlewares;

public class SessionInitMiddleware
{
    private readonly RequestDelegate _next;
    private readonly IWebHostEnvironment _env;

    public SessionInitMiddleware(RequestDelegate next, IWebHostEnvironment env)
    {
        _next = next;
        _env = env;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        await context.Session.LoadAsync();

        // Use your Extension method for the check
        if (!context.Session.IsInitialized())
        {
            InitializeSession(context);
            context.Session.SetInitialized();
        }

        if (_env.IsDevelopment())
        {
            var profiler = MiniProfiler.Current;
            if (profiler != null)
            {
                // This creates a category called "Session" in the profiler
                using (var timing = profiler.CustomTiming("Session", "Fetching Keys..."))
                {
                    var sessionData = new List<string>();
                    foreach (var key in context.Session.Keys)
                    {
                        var value = context.Session.GetString(key) ?? "null";
                        sessionData.Add($"{key}: {value}");
                    }

                    // This is the property that actually displays the text in the UI
                    timing.CommandString = string.Join("\n", sessionData);

                    // Optional: Give the row a descriptive title
                    timing.ExecuteType = "State Snapshot";
                }
            }
        }

        await _next(context);
    }

    private void InitializeSession(HttpContext context)
    {
        // Porting your VB Randomize logic
        Random rnd = new Random();
        int randomExtension = rnd.Next(10000000, 99999999);
        context.Session.SetCartRandomNumbersExtension("R" + randomExtension);

        context.Session.SetRemoteHost(context);

        context.Session.SetSessionStarted(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));

        //context.Session.SetString("RetailCartExists", ""); // Searched in legacy code and not found any usage
        //context.Session.SetString("AlreadyWarnedAboutCartSignIn", ""); // Search in legacy code and not found any usage

        // Initialize empty keys
        context.Session.SetWebOrderNumberJustPurchased("");
        context.Session.SetPowerUserName("");
        context.Session.SetCustomerServerCounter(0);
        // Default Cart Count for new session
        if (!context.Session.HasCartCount())
        {
            context.Session.SetCartCount(0);
        }

        context.InitializeLegacyCookies();
    }
}