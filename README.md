# MillionsOfRecordsApp

MillionsOfRecordsApp is a modern Razor Pages web application (targeting .NET 10) that demonstrates an enterprise-grade e-commerce storefront. It manages complex music catalog inventories, request-scoped shipping calculations, and secure PayPal V2 payment processing, backed by a SQL Server database.

## Key Features
- **Modern UI (2026 Standard):** Responsive checkout and success pages utilizing the Montserrat font and Bootstrap 5 for a professional dashboard aesthetic.
- **PayPal V2 Integration:** Complete "Create and Capture" flow with idempotency and error handling.
- **Performance-First Architecture:** - **MiniProfiler Integration:** Real-time tracking of SQL queries and external API latency.
  - **Request-Scoped Caching:** Optimized state lookups and shipping method calculations to reduce database round-trips.
- **Security-First Design:** Strict use of Client-Side SPAs where applicable, Secure Session management, and Open-Redirect protection.

## Prerequisites
- **.NET 10 SDK**
- **SQL Server** (Instance name: `INTERNETREGGAE`)
- **Visual Studio 2022/2026** with the **Dev Tunnels** component installed.
- **PayPal Developer Account** (Access to Sandbox credentials).

## Getting started (development)

1. Clone the repository and open the solution in Visual Studio or use the CLI:

   git clone <repo-url>
   cd MillionsOfRecordsApp

2. Update the connection string in `appsettings.json` or user secrets. The project expects a connection string named `ReggaeDbContextConnection`:

   {
     "ConnectionStrings": {
       "ReggaeDbContextConnection": "Server=.;Database=INTERNETREGGAE;Trusted_Connection=True;TrustServerCertificate=True;"
     }
   }

3. Restore and build:

   dotnet restore
   dotnet tool restore
   dotnet tool run smtp4dev
   dotnet build

4. Run the app:

   - Visual Studio: Run the project (IIS Express or Kestrel)
   - CLI: `dotnet run --project MillionsOfRecordsApp/MillionsOfRecordsApp.csproj`

The app listens on the configured URLs; when running behind a reverse proxy make sure forwarded headers are configured on the proxy so the application receives the original client IP and scheme.

## Important configuration

- Connection string: `ConnectionStrings:ReggaeDbContextConnection` (SQL Server)
- Sessions: configured with cookie name `.MillionsOfRecords.Session` and 30 minute idle timeout
- Forwarded headers: `X-Forwarded-For` and `X-Forwarded-Proto` are enabled in the app to support proxy deployments

## PayPal configuration

PayPal credentials (`PayPal:ClientId` and `PayPal:Secret`) are **never stored in source control**. The app validates them at startup and fails fast with environment-specific instructions if they are missing.

### Local development (user secrets)

Run these from the `MillionsOfRecordsApp` directory:

   dotnet user-secrets init
   dotnet user-secrets set "PayPal:ClientId" "<your-sandbox-client-id>"
   dotnet user-secrets set "PayPal:Secret" "<your-sandbox-secret>"

The non-secret PayPal settings (BaseUrl, ScriptUrl, ScripUrlAlt) stay in `appsettings.json` under the `PayPal` section.

### Production (EC2 / IIS)

Set environment variables (or an environment-specific configuration source on the host):

   PayPal__ClientId=<your-live-or-sandbox-client-id>
   PayPal__Secret=<your-live-or-sandbox-secret>

Do not put real credentials in `appsettings.json` or any file committed to the repository.

## Project structure (important folders)

- `Pages/` - Razor Pages and page models (UI)
- `Models/` - DTOs, database POCOs and stored-procedure result models
- `Data/` - `ReggaeDbContext`, DB helpers and stored-procedure wrapper `ReggaeDbContextProcedures`
- `Services/` - business logic: `CartService`, `ShippingService`, `OrderService`
- `Controllers/` - API endpoints and proxy controllers
- `Middlewares/` - custom middleware (`SessionInitMiddleware`)
- `Program.cs` - app startup and service registration

## Database / EF

The project uses `ReggaeDbContext` configured for SQL Server. If you use Entity Framework Core migrations in this project add/run migrations as usual:

- Add migration: `dotnet ef migrations add Initial -p MillionsOfRecordsApp -s MillionsOfRecordsApp`
- Apply migrations: `dotnet ef database update -p MillionsOfRecordsApp -s MillionsOfRecordsApp`

If the project relies on stored procedures or a pre-existing schema, ensure your database schema matches what the application expects.

## Running behind a proxy / deployment notes

- Forwarded headers are enabled in `Program.cs` for `X-Forwarded-For` and `X-Forwarded-Proto`.
- Static files have additional content types registered for web fonts and manifest files.
- HSTS and exception handling are configured for non-development environments.

## Logging and diagnostics

Use the standard ASP.NET Core logging configuration (appsettings) and Visual Studio output/debug windows. For production, configure an appropriate log sink (files, Application Insights, etc.).

## Contributing

Contributions are welcome. Please open issues or pull requests. Keep changes focused and include tests when appropriate.
