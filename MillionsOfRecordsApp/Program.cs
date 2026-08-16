using System.Diagnostics;
using Microsoft.AspNetCore.HttpOverrides;
using Microsoft.AspNetCore.StaticFiles;
using Microsoft.EntityFrameworkCore;
using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Middlewares;
using MillionsOfRecordsApp.Pages;
using MillionsOfRecordsApp.Services;

namespace MillionsOfRecordsApp
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);
            // --- FORWARDED HEADERS CONFIGURATION ---
            // This is required when the app is deployed behind a proxy (IIS, Nginx, Cloudflare, Azure).
            // It ensures context.Connection.RemoteIpAddress returns the user's real IP, 
            // and context.Request.Scheme correctly detects HTTPS.
            builder.Services.Configure<ForwardedHeadersOptions>(options =>
            {
                options.ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto;
                // Note: Clear these only if you trust the headers coming from your network infrastructure.
                // This is often necessary for cloud environments like Azure App Service or Cloudflare.
                options.KnownIPNetworks.Clear();
                options.KnownProxies.Clear();

                //Summary of the Flow
                //When a user visits millionsofrecords.com:
                //Cloudflare / IIS adds a header: X-Forwarded-For: 203.0.113.195.
                //UseForwardedHeaders reads that and sets context.Connection.RemoteIpAddress = 203.0.113.195.
                //SessionInitMiddleware runs and saves that IP into "RemHost" session variable.
            });
            builder.Services.Configure<EmailSettings>(builder.Configuration.GetSection("EmailSettings"));
            builder.Services.AddTransient<IEmailService, EmailService>();

            // --- 1. REGISTER SERVICES ---
            builder.Services.AddHttpContextAccessor();
            builder.Services.AddHttpClient();
            builder.Services.AddControllers();
            builder.Services.AddRazorPages();

            builder.Services.AddMemoryCache();
            builder.Services.AddDistributedMemoryCache();
            builder.Services.AddSession(options =>
            {
                options.IdleTimeout = TimeSpan.FromMinutes(30);
                options.Cookie.HttpOnly = true;
                options.Cookie.IsEssential = true;
                options.Cookie.Name = ".MillionsOfRecords.Session";
            });
            builder.Services.AddMiniProfiler(options =>
            {
                // Route to access the full profiler dashboard
                options.RouteBasePath = "/profiler";

                // Aesthetic: Use a dark theme for the popup
                options.ColorScheme = StackExchange.Profiling.ColorScheme.Dark;

                // EXCLUDE STATIC ASSETS
                // This ignores the standard folders and common file extensions
                options.IgnoredPaths.Add("/lib/");
                options.IgnoredPaths.Add("/css/");
                options.IgnoredPaths.Add("/js/");
                options.IgnoredPaths.Add("/assets/");

                // You can also use a predicate for more control
                options.ShouldProfile = request =>
                {
                    var path = request.Path.Value;
                    if (!string.IsNullOrEmpty(path) && (path.Contains(".png") || path.Contains(".jpg") ||
                        path.Contains(".css") || path.Contains(".woff")))
                    {
                        return false;
                    }
                    return true;
                };

            }).AddEntityFramework(); // This tracks your SQL queries automatically!

            builder.Services.AddDbContext<ReggaeDbContext>(options =>
                options.UseSqlServer(builder.Configuration.GetConnectionString("ReggaeDbContextConnection")));
            builder.Services.AddScoped<IReggaeDbContextProcedures, ReggaeDbContextProceduresManual>();
            builder.Services.AddScoped<CartService>();
            builder.Services.AddScoped<CustomerService>();
            builder.Services.AddScoped<ShippingService>();
            builder.Services.AddScoped<OrderService>();
            builder.Services.AddScoped<TaxService>();
            builder.Services.AddScoped<CustomerAuthService>();
            builder.Services.AddScoped<ICustomerValidationService, CustomerValidationService>();

            var app = builder.Build();

            app.UseForwardedHeaders();

            // --- CONFIGURE MIME TYPES FOR FONTS & REACT ASSETS ---
            var provider = new FileExtensionContentTypeProvider();
            // Add support for fonts
            provider.Mappings[".woff"] = "font/woff";
            provider.Mappings[".woff2"] = "font/woff2";
            provider.Mappings[".otf"] = "font/otf";
            provider.Mappings[".ttf"] = "font/ttf";
            provider.Mappings[".json"] = "application/json";
            provider.Mappings[".webmanifest"] = "application/manifest+json";

            app.UseStaticFiles(new StaticFileOptions
            {
                ContentTypeProvider = provider
            });

            if (!app.Environment.IsDevelopment())
            {
                app.UseExceptionHandler("/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseRouting();

            app.UseSession(); // 1. Enable Session
            app.UseMiddleware<SessionInitMiddleware>();

            app.UseMiniProfiler();

            app.UseAuthorization();

            app.MapStaticAssets();
            app.MapRazorPages().WithStaticAssets();

            if (!app.Environment.IsDevelopment())
            {
                // You could also add an Authorization policy here for Admins
                app.MapGet("/admin/debug", context =>
                {
                    context.Response.StatusCode = 403;
                    return Task.CompletedTask;
                });
            }

            app.MapControllers();

            // --- AUTO-START LOCAL SMTP TOOL IN DEVELOPMENT ---
            if (app.Environment.IsDevelopment())
            {
                EnsureSmtp4DevIsRunning();
            }

            app.Run();
        }

        private static void EnsureSmtp4DevIsRunning()
        {
            try
            {
                // 1. Check if smtp4dev process is already running
                var runningProcesses = Process.GetProcessesByName("smtp4dev");
                if (runningProcesses.Length > 0)
                {
                    return;
                }

                // 2. Attempt to launch smtp4dev via dotnet tool runner
                var startInfo = new ProcessStartInfo
                {
                    FileName = "dotnet",
                    Arguments = "tool run smtp4dev",
                    UseShellExecute = false, // Set to false so we can modify EnvironmentVariables
                    CreateNoWindow = false
                };

                // Remove Visual Studio's injected hosting assemblies to prevent "Microsoft.WebTools.ApiEndpointDiscovery" errors
                startInfo.EnvironmentVariables.Remove("ASPNETCORE_HOSTINGSTARTUPASSEMBLIES");

                var process = Process.Start(startInfo);

                // Wait up to 1 second to see if the process exited immediately with an error (e.g., tool not found)
                if (process != null && process.WaitForExit(1000) && process.ExitCode != 0)
                {
                    ShowSmtp4DevMissingWarning();
                }
            }
            catch
            {
                ShowSmtp4DevMissingWarning();
            }
        }

        private static void ShowSmtp4DevMissingWarning()
        {
            Console.ForegroundColor = ConsoleColor.Yellow;
            Console.WriteLine();
            Console.WriteLine("==========================================================================================");
            Console.WriteLine("[DEV WARNING] Could not auto-start local SMTP server (smtp4dev).");
            Console.WriteLine("If smtp4dev is not installed on your machine, run one of the following commands:");
            Console.WriteLine();
            Console.WriteLine("  1. Restore as local repository tool (preferred):");
            Console.WriteLine("     dotnet tool restore");
            Console.WriteLine();
            Console.WriteLine("  2. Install as global tool:");
            Console.WriteLine("     dotnet tool install -g Rnwood.Smtp4dev");
            Console.WriteLine("==========================================================================================");
            Console.WriteLine();
            Console.ResetColor();
        }
    }
}