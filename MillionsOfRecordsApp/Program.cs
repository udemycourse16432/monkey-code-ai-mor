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
            builder.Services.AddRazorPages(options =>
            {
                // Legacy route mapping only: /album-details/292029 -> /AlbumDetails.cshtml
                options.Conventions.AddPageRoute("/AlbumDetails2", "album-details/{id:int}");
            });

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

            app.Run();
        }
    }
}
