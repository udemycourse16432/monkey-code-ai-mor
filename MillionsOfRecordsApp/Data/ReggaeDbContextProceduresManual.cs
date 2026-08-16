using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using MillionsOfRecordsApp.Models;
using System.Data;
using System.Diagnostics.Metrics;

namespace MillionsOfRecordsApp.Data;

public class ReggaeDbContextProceduresManual : ReggaeDbContextProcedures
{
    private readonly ReggaeDbContext _context;
    public ReggaeDbContextProceduresManual(ReggaeDbContext context) : base(context)
    {
        _context = context;
    }
    private readonly Dictionary<string, List<spGetWeightOfProductResult>> _spGetWeightOfProductCache = new();

    public override async Task<List<spGetWeightOfProductResult>> spGetWeightOfProductAsync(string cartName, OutputParameter<int> returnValue = null, CancellationToken cancellationToken = default)
    {
        // 1. Normalize the Cache Key
        // Trim and Upper ensures "MyCart" and "mycart " hit the same cache entry
        string cacheKey = string.IsNullOrWhiteSpace(cartName) ? "NULL_OR_EMPTY" : cartName.Trim().ToUpper();

        // 2. Cache Lookup
        if (_spGetWeightOfProductCache.TryGetValue(cacheKey, out var cachedResult))
        {
            return cachedResult;
        }

        var parameterreturnValue = new SqlParameter
        {
            ParameterName = "returnValue",
            Direction = System.Data.ParameterDirection.Output,
            SqlDbType = System.Data.SqlDbType.Int,
        };

        var sqlParameters = new[]
        {
            new SqlParameter
            {
                ParameterName = "CartName",
                Size = 60,
                // Use the normalized string for the DB call as well for consistency
                Value = (object)cartName ?? DBNull.Value,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            parameterreturnValue,
        };

        // 3. Execute SQL
        var results = await _context.SqlQueryAsync<spGetWeightOfProductResult>(
            "EXEC @returnValue = [dbo].[spGetWeightOfProduct] @CartName = @CartName",
            sqlParameters,
            cancellationToken);

        // 4. Set Output Parameter
        returnValue?.SetValue(parameterreturnValue.Value);

        // 5. Store in Cache (Scoped lifetime)
        var finalResults = results ?? new List<spGetWeightOfProductResult>();
        _spGetWeightOfProductCache[cacheKey] = finalResults;

        return finalResults;
    }
    private readonly Dictionary<string, List<spCartPricesSalePricesTooResult>> _spCartPricesSalePricesTooCache = new();

    public override async Task<List<spCartPricesSalePricesTooResult>> spCartPricesSalePricesTooAsync(string nameOfCart, OutputParameter<int> returnValue = null, CancellationToken cancellationToken = default)
    {
        // 1. Normalize the Key
        string cacheKey = string.IsNullOrWhiteSpace(nameOfCart) ? "NULL_OR_EMPTY" : nameOfCart.Trim().ToUpper();

        // 2. Cache Lookup
        if (_spCartPricesSalePricesTooCache.TryGetValue(cacheKey, out var cachedResult))
        {
            return cachedResult;
        }

        var parameterreturnValue = new SqlParameter
        {
            ParameterName = "returnValue",
            Direction = System.Data.ParameterDirection.Output,
            SqlDbType = System.Data.SqlDbType.Int,
        };

        var sqlParameters = new[]
        {
            new SqlParameter
            {
                ParameterName = "NameOfCart",
                Size = 60,
                Value = (object)nameOfCart ?? DBNull.Value,
                SqlDbType = SqlDbType.NVarChar,
            },
            parameterreturnValue,
        };

        // 3. Execute SQL
        var results = await _context.SqlQueryAsync<spCartPricesSalePricesTooResult>(
            "EXEC @returnValue = [dbo].[spCartPricesSalePricesToo] @NameOfCart = @NameOfCart",
            sqlParameters,
            cancellationToken);

        // 4. Handle Output Parameter
        returnValue?.SetValue(parameterreturnValue.Value);

        // 5. Finalize and Cache
        var finalResults = results ?? new List<spCartPricesSalePricesTooResult>();
        _spCartPricesSalePricesTooCache[cacheKey] = finalResults;

        return finalResults;
    }
    private readonly Dictionary<string, List<spGetCartTotalsRetailPriceResult>> _spGetCartTotalsRetailPriceCache = new();

    public override async Task<List<spGetCartTotalsRetailPriceResult>> spGetCartTotalsRetailPriceAsync(string cartName, OutputParameter<int> returnValue = null, CancellationToken cancellationToken = default)
    {
        // 1. Normalize the Cache Key
        string cacheKey = string.IsNullOrWhiteSpace(cartName) ? "EMPTY_CART" : cartName.Trim().ToUpper();

        // 2. Cache Lookup
        if (_spGetCartTotalsRetailPriceCache.TryGetValue(cacheKey, out var cachedResult))
        {
            return cachedResult;
        }

        var parameterreturnValue = new SqlParameter
        {
            ParameterName = "returnValue",
            Direction = System.Data.ParameterDirection.Output,
            SqlDbType = SqlDbType.Int,
        };

        var sqlParameters = new[]
        {
            new SqlParameter
            {
                ParameterName = "CartName",
                Size = 60,
                Value = (object)cartName ?? DBNull.Value,
                SqlDbType = SqlDbType.NVarChar,
            },
            parameterreturnValue,
        };

        // 3. Execute SQL
        var results = await _context.SqlQueryAsync<spGetCartTotalsRetailPriceResult>(
            "EXEC @returnValue = [dbo].[spGetCartTotalsRetailPrice] @CartName = @CartName",
            sqlParameters,
            cancellationToken);

        // 4. Set Output Parameter
        returnValue?.SetValue(parameterreturnValue.Value);

        // 5. Store in Request-Scoped Cache
        var finalResults = results ?? new List<spGetCartTotalsRetailPriceResult>();
        _spGetCartTotalsRetailPriceCache[cacheKey] = finalResults;

        return finalResults;
    }
    private readonly Dictionary<string, List<spGetCartTotalsWholesalePriceResult>> _spGetCartTotalsWholesalePriceCache = new();

    public override async Task<List<spGetCartTotalsWholesalePriceResult>> spGetCartTotalsWholesalePriceAsync(string cartName, OutputParameter<int> returnValue = null, CancellationToken cancellationToken = default)
    {
        // 1. Normalize the Cache Key
        string cacheKey = string.IsNullOrWhiteSpace(cartName) ? "EMPTY_CART" : cartName.Trim().ToUpper();

        // 2. Cache Lookup
        if (_spGetCartTotalsWholesalePriceCache.TryGetValue(cacheKey, out var cachedResult))
        {
            return cachedResult;
        }

        var parameterreturnValue = new SqlParameter
        {
            ParameterName = "returnValue",
            Direction = ParameterDirection.Output,
            SqlDbType = SqlDbType.Int,
        };

        var sqlParameters = new[]
        {
        new SqlParameter
        {
            ParameterName = "CartName",
            Size = 60,
            Value = (object)cartName ?? DBNull.Value,
            SqlDbType = SqlDbType.NVarChar,
        },
        parameterreturnValue,
    };

        // 3. Execute SQL
        var results = await _context.SqlQueryAsync<spGetCartTotalsWholesalePriceResult>(
            "EXEC @returnValue = [dbo].[spGetCartTotalsWholesalePrice] @CartName = @CartName",
            sqlParameters,
            cancellationToken);

        // 4. Set Output Parameter
        returnValue?.SetValue(parameterreturnValue.Value);

        // 5. Store in Request-Scoped Cache
        var finalResults = results ?? new List<spGetCartTotalsWholesalePriceResult>();
        _spGetCartTotalsWholesalePriceCache[cacheKey] = finalResults;

        return finalResults;
    }


    private readonly Dictionary<string, List<spGetWebSHIPX_PackagingWeightResult>> _GetWebSHIPX_PackagingWeightCache = new();
    public override async Task<List<spGetWebSHIPX_PackagingWeightResult>> spGetWebSHIPX_PackagingWeightAsync(decimal? weightInGrams, string cartName, OutputParameter<int> returnValue = null, CancellationToken cancellationToken = default)
    {
        string weightPart = weightInGrams?.ToString("0.####") ?? "NULL";
        string cartPart = string.IsNullOrWhiteSpace(cartName) ? "DEFAULT" : cartName.Trim().ToUpper();

        string cacheKey = $"{cartPart}_{weightPart}";

        // 2. Cache Lookup
        if (_GetWebSHIPX_PackagingWeightCache.TryGetValue(cacheKey, out var cachedResult))
        {
            return cachedResult;
        }
        var parameterreturnValue = new SqlParameter
        {
            ParameterName = "returnValue",
            Direction = System.Data.ParameterDirection.Output,
            SqlDbType = System.Data.SqlDbType.Int,
        };

        var sqlParameters = new[]
        {
                new SqlParameter
                {
                    ParameterName = "WeightInGrams",
                    Precision = 9,
                    Scale = 2,
                    Value = weightInGrams ?? Convert.DBNull,
                    SqlDbType = System.Data.SqlDbType.Decimal,
                },
                new SqlParameter
                {
                    ParameterName = "CartName",
                    Size = 60,
                    Value = cartName ?? Convert.DBNull,
                    SqlDbType = System.Data.SqlDbType.NVarChar,
                },
                parameterreturnValue,
            };
        var results = await _context.SqlQueryAsync<spGetWebSHIPX_PackagingWeightResult>("EXEC @returnValue = [dbo].[spGetWebSHIPX_PackagingWeight] @WeightInGrams = @WeightInGrams, @CartName = @CartName", sqlParameters, cancellationToken);

        returnValue?.SetValue(parameterreturnValue.Value);

        _GetWebSHIPX_PackagingWeightCache[cacheKey] = results ?? new List<spGetWebSHIPX_PackagingWeightResult>();

        return _GetWebSHIPX_PackagingWeightCache[cacheKey];
    }

    private readonly Dictionary<string, List<spGetShippingMethodsRowResult>> _shippingMethodsRowCache = new();
    public override async Task<List<spGetShippingMethodsRowResult>> spGetShippingMethodsRowAsync(string shippingMethodCode, OutputParameter<int> returnValue = null, CancellationToken cancellationToken = default)
    {
        // 1. Normalize the key (handling nulls/empty strings)
        string cacheKey = shippingMethodCode ?? string.Empty;

        // 2. Cache Lookup
        if (_shippingMethodsRowCache.TryGetValue(cacheKey, out var cachedResult))
        {
            return cachedResult;
        }
        var parameterreturnValue = new SqlParameter
        {
            ParameterName = "returnValue",
            Direction = System.Data.ParameterDirection.Output,
            SqlDbType = System.Data.SqlDbType.Int,
        };

        var sqlParameters = new[]
        {
                new SqlParameter
                {
                    ParameterName = "ShippingMethodCode",
                    Size = 50,
                    Value = shippingMethodCode ?? Convert.DBNull,
                    SqlDbType = System.Data.SqlDbType.NVarChar,
                },
                parameterreturnValue,
            };
        // 3. Database Execution
        var results = await _context.SqlQueryAsync<spGetShippingMethodsRowResult>("EXEC @returnValue = [dbo].[spGetShippingMethodsRow] @ShippingMethodCode = @ShippingMethodCode", sqlParameters, cancellationToken);

        // 4. Handle Output Parameter
        returnValue?.SetValue(parameterreturnValue.Value);

        // 5. Store in Cache (using Indexer to prevent duplicate key exceptions)
        // We store an empty list if results are null to prevent re-querying "missing" methods
        _shippingMethodsRowCache[cacheKey] = results ?? new List<spGetShippingMethodsRowResult>();

        return _shippingMethodsRowCache[cacheKey];
    }

    public override async Task<List<spGetWebCountryShippingZonesTRowResult>> spGetWebCountryShippingZonesTRowAsync(string country, OutputParameter<int> returnValue = null, CancellationToken cancellationToken = default)
    {
        var parameterreturnValue = new SqlParameter
        {
            ParameterName = "returnValue",
            Direction = System.Data.ParameterDirection.Output,
            SqlDbType = System.Data.SqlDbType.Int,
        };

        var sqlParameters = new[]
        {
                new SqlParameter
                {
                    ParameterName = "Country",
                    Size = 100,
                    Value = country ?? Convert.DBNull,
                    SqlDbType = System.Data.SqlDbType.NVarChar,
                },
                parameterreturnValue,
            };
        var _ = await _context.SqlQueryAsync<spGetWebCountryShippingZonesTRowResult>("EXEC @returnValue = [dbo].[spGetWebCountryShippingZonesTRow] @Country = @Country", sqlParameters, cancellationToken);

        returnValue?.SetValue(parameterreturnValue.Value);

        return _;
    }
    public override async Task<List<spGetWebCountryStateProvincesListRowResult>> spGetWebCountryStateProvincesListRowAsync(string country, string stateProvince, OutputParameter<int> returnValue = null, CancellationToken cancellationToken = default)
    {
        var parameterreturnValue = new SqlParameter
        {
            ParameterName = "returnValue",
            Direction = System.Data.ParameterDirection.Output,
            SqlDbType = System.Data.SqlDbType.Int,
        };

        var sqlParameters = new[]
        {
                new SqlParameter
                {
                    ParameterName = "Country",
                    Size = 100,
                    Value = country ?? Convert.DBNull,
                    SqlDbType = System.Data.SqlDbType.NVarChar,
                },
                new SqlParameter
                {
                    ParameterName = "StateProvince",
                    Size = 100,
                    Value = stateProvince ?? Convert.DBNull,
                    SqlDbType = System.Data.SqlDbType.NVarChar,
                },
                parameterreturnValue,
            };
        var _ = await _context.SqlQueryAsync<spGetWebCountryStateProvincesListRowResult>("EXEC @returnValue = [dbo].[spGetWebCountryStateProvincesListRow] @Country = @Country, @StateProvince = @StateProvince", sqlParameters, cancellationToken);

        returnValue?.SetValue(parameterreturnValue.Value);

        return _;
    }

    private readonly Dictionary<string, List<spCheckForLPor12InchInCartResult>> _spCheckForLPor12InchInCartCache = new();

    public override async Task<List<spCheckForLPor12InchInCartResult>> spCheckForLPor12InchInCartAsync(string cartName, OutputParameter<int> returnValue = null, CancellationToken cancellationToken = default)
    {
        // 1. Normalize Key
        string cacheKey = string.IsNullOrWhiteSpace(cartName) ? "NULL_OR_EMPTY" : cartName.Trim().ToUpper();

        // 2. Cache Lookup
        if (_spCheckForLPor12InchInCartCache.TryGetValue(cacheKey, out var cachedResult))
        {
            return cachedResult;
        }

        var parameterreturnValue = new SqlParameter
        {
            ParameterName = "returnValue",
            Direction = ParameterDirection.Output,
            SqlDbType = SqlDbType.Int,
        };

        var sqlParameters = new[]
        {
        new SqlParameter
        {
            ParameterName = "CartName",
            Size = 60,
            Value = (object)cartName ?? DBNull.Value,
            SqlDbType = SqlDbType.NVarChar,
        },
        parameterreturnValue,
    };

        // 3. Execute SQL
        var results = await _context.SqlQueryAsync<spCheckForLPor12InchInCartResult>(
            "EXEC @returnValue = [dbo].[spCheckForLPor12InchInCart] @CartName = @CartName",
            sqlParameters,
            cancellationToken);

        // 4. Handle Output Parameter
        returnValue?.SetValue(parameterreturnValue.Value);

        // 5. Cache Results (Scoped)
        var finalResults = results ?? new List<spCheckForLPor12InchInCartResult>();
        _spCheckForLPor12InchInCartCache[cacheKey] = finalResults;

        return finalResults;
    }

    private readonly Dictionary<string, List<spGetMinimumFlatShippngChargeResult>> _flatShippingChargeCache = new();
    public override async Task<List<spGetMinimumFlatShippngChargeResult>> spGetMinimumFlatShippngChargeAsync(string shippingMethodCode, OutputParameter<int> returnValue = null, CancellationToken cancellationToken = default)
    {
        string cacheKey = shippingMethodCode ?? string.Empty;
        if (_flatShippingChargeCache.TryGetValue(cacheKey, out var cachedResult))
        {
            return cachedResult;
        }
        var parameterreturnValue = new SqlParameter
        {
            ParameterName = "returnValue",
            Direction = System.Data.ParameterDirection.Output,
            SqlDbType = System.Data.SqlDbType.Int,
        };

        var sqlParameters = new[]
        {
                new SqlParameter
                {
                    ParameterName = "ShippingMethodCode",
                    Size = 50,
                    Value = shippingMethodCode ?? Convert.DBNull,
                    SqlDbType = System.Data.SqlDbType.NVarChar,
                },
                parameterreturnValue,
            };
        var results = await _context.SqlQueryAsync<spGetMinimumFlatShippngChargeResult>("EXEC @returnValue = [dbo].[spGetMinimumFlatShippngCharge] @ShippingMethodCode = @ShippingMethodCode", sqlParameters, cancellationToken);

        returnValue?.SetValue(parameterreturnValue.Value);

        _flatShippingChargeCache[cacheKey] = results ?? new List<spGetMinimumFlatShippngChargeResult>();

        return _flatShippingChargeCache[cacheKey];
    }

    private readonly Dictionary<string, List<spGetWebSHIPX_MaxWeightOfBoxForPackingResult>> _WebSHIPX_MaxWeightOfBoxForPackingCache = new();
    public override async Task<List<spGetWebSHIPX_MaxWeightOfBoxForPackingResult>> spGetWebSHIPX_MaxWeightOfBoxForPackingAsync(string cartName, OutputParameter<int> returnValue = null, CancellationToken cancellationToken = default)
    {
        string cacheKey = cartName ?? string.Empty;
        if (_WebSHIPX_MaxWeightOfBoxForPackingCache.TryGetValue(cacheKey, out var cachedResult))
        {
            return cachedResult;
        }
        var parameterreturnValue = new SqlParameter
        {
            ParameterName = "returnValue",
            Direction = System.Data.ParameterDirection.Output,
            SqlDbType = System.Data.SqlDbType.Int,
        };

        var sqlParameters = new[]
        {
                new SqlParameter
                {
                    ParameterName = "CartName",
                    Size = 60,
                    Value = cartName ?? Convert.DBNull,
                    SqlDbType = System.Data.SqlDbType.NVarChar,
                },
                parameterreturnValue,
            };
        var results = await _context.SqlQueryAsync<spGetWebSHIPX_MaxWeightOfBoxForPackingResult>("EXEC @returnValue = [dbo].[spGetWebSHIPX_MaxWeightOfBoxForPacking] @CartName = @CartName", sqlParameters, cancellationToken);

        returnValue?.SetValue(parameterreturnValue.Value);

        _WebSHIPX_MaxWeightOfBoxForPackingCache[cacheKey] = results ?? new List<spGetWebSHIPX_MaxWeightOfBoxForPackingResult>();

        return _WebSHIPX_MaxWeightOfBoxForPackingCache[cacheKey];
    }

    private readonly Dictionary<string, List<spGetWebSHIPX_ShippingHolidaysOutboundRowResult>> _WebSHIPX_ShippingHolidaysOutboundRowCache = new();
    public override async Task<List<spGetWebSHIPX_ShippingHolidaysOutboundRowResult>> spGetWebSHIPX_ShippingHolidaysOutboundRowAsync(DateTime? date, OutputParameter<int> returnValue = null, CancellationToken cancellationToken = default)
    {
        DateTime? searchDate = date?.Date;
        string cacheKey = searchDate?.ToString("yyyy-MM-dd") ?? "NULL";
        if (_WebSHIPX_ShippingHolidaysOutboundRowCache.TryGetValue(cacheKey, out var cachedResult))
        {
            return cachedResult;
        }
        var parameterreturnValue = new SqlParameter
        {
            ParameterName = "returnValue",
            Direction = System.Data.ParameterDirection.Output,
            SqlDbType = System.Data.SqlDbType.Int,
        };

        // FIX: Ensure the date is truncated to the day and formatted as a string 
        // to prevent fractional millisecond "drift" (.016) in SQL Server
        object sqlDateValue = Convert.DBNull;
        if (date.HasValue)
        {
            // Formatting as yyyy-MM-dd ensures SQL interprets it as midnight 00:00:00.000
            sqlDateValue = date.Value.Date.ToString("yyyy-MM-dd HH:mm:ss");
        }

        var sqlParameters = new[]
        {
            new SqlParameter
            {
                ParameterName = "Date",
                Value = (object)searchDate ?? DBNull.Value,
                SqlDbType = System.Data.SqlDbType.Date, // SQL will parse the clean string back to DateTime
            },
            parameterreturnValue,
        };

        var results = await _context.SqlQueryAsync<spGetWebSHIPX_ShippingHolidaysOutboundRowResult>(
            "EXEC @returnValue = [dbo].[spGetWebSHIPX_ShippingHolidaysOutboundRow] @Date = @Date",
            sqlParameters,
            cancellationToken);

        returnValue?.SetValue(parameterreturnValue.Value);

        _WebSHIPX_ShippingHolidaysOutboundRowCache[cacheKey] = results ?? new List<spGetWebSHIPX_ShippingHolidaysOutboundRowResult>();

        return _WebSHIPX_ShippingHolidaysOutboundRowCache[cacheKey];
    }

    private readonly Dictionary<string, List<spGetCustomerDetailsByServerCounterResult>> _customerDetailsByServerCounterCache = new();
    public override async Task<List<spGetCustomerDetailsByServerCounterResult>> spGetCustomerDetailsByServerCounterAsync(int? counter, OutputParameter<int> returnValue = null, CancellationToken cancellationToken = default)
    {
        string cacheKey = counter?.ToString() ?? "NULL";
        if (_customerDetailsByServerCounterCache.TryGetValue(cacheKey, out var cachedResult))
        {
            return cachedResult;
        }
        var parameterreturnValue = new SqlParameter
        {
            ParameterName = "returnValue",
            Direction = System.Data.ParameterDirection.Output,
            SqlDbType = System.Data.SqlDbType.Int,
        };

        var sqlParameters = new[]
        {
                new SqlParameter
                {
                    ParameterName = "counter",
                    Value = counter ?? Convert.DBNull,
                    SqlDbType = System.Data.SqlDbType.Int,
                },
                parameterreturnValue,
            };
        var results = await _context.SqlQueryAsync<spGetCustomerDetailsByServerCounterResult>("EXEC @returnValue = [dbo].[spGetCustomerDetailsByServerCounter] @counter = @counter", sqlParameters, cancellationToken);

        returnValue?.SetValue(parameterreturnValue.Value);

        _customerDetailsByServerCounterCache[cacheKey] = results ?? new List<spGetCustomerDetailsByServerCounterResult>();

        return _customerDetailsByServerCounterCache[cacheKey];
    }

    public override async Task<List<spPayFlowRequests_InsertResult>> spPayFlowRequests_InsertAsync(string encryptionKey, string status, string userAgent, string request_TRXTYPE, string request_TENDER, string request_ACCT, string request_EXPDATE, decimal? request_AMT, string request_CVV2, string request_BILLTOFIRSTNAME, string request_BILLTOLASTNAME, string request_BILLTOSTREET, string request_BILLTOSTREET2, string request_BILLTOCITY, string request_BILLTOSTATE, string request_BILLTOZIP, string request_BILLTOCOUNTRY, string request_CUSTIP, string request_ORDERID, string request_COMMENT1, string request_COMMENT2, string webOrderNumber, int? customerID, string rightFour, string iV, OutputParameter<int> counterOUTPUT, OutputParameter<int> returnValue = null, CancellationToken cancellationToken = default)
    {
        var parameterCounterOUTPUT = new SqlParameter
        {
            ParameterName = "CounterOUTPUT",
            Direction = System.Data.ParameterDirection.InputOutput,
            Value = counterOUTPUT?._value ?? Convert.DBNull,
            SqlDbType = System.Data.SqlDbType.Int,
        };
        var parameterreturnValue = new SqlParameter
        {
            ParameterName = "returnValue",
            Direction = System.Data.ParameterDirection.Output,
            SqlDbType = System.Data.SqlDbType.Int,
        };

        var sqlParameters = new[]
        {
            new SqlParameter
            {
                ParameterName = "EncryptionKey",
                Size = 100,
                Value = encryptionKey ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.VarChar,
            },
            new SqlParameter
            {
                ParameterName = "Status",
                Size = 20,
                Value = status ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "UserAgent",
                Size = 300,
                Value = userAgent ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "Request_TRXTYPE",
                Size = 1,
                Value = request_TRXTYPE ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "Request_TENDER",
                Size = 1,
                Value = request_TENDER ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "Request_ACCT",
                Size = 25,
                Value = request_ACCT ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.VarChar,
            },
            new SqlParameter
            {
                ParameterName = "Request_EXPDATE",
                Size = 6,
                Value = request_EXPDATE ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "Request_AMT",
                Precision = 9,
                Scale = 2,
                Value = request_AMT ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.Decimal,
            },
            new SqlParameter
            {
                ParameterName = "Request_CVV2",
                Size = 4,
                Value = request_CVV2 ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "Request_BILLTOFIRSTNAME",
                Size = 30,
                Value = request_BILLTOFIRSTNAME ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "Request_BILLTOLASTNAME",
                Size = 30,
                Value = request_BILLTOLASTNAME ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "Request_BILLTOSTREET",
                Size = 30,
                Value = request_BILLTOSTREET ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "Request_BILLTOSTREET2",
                Size = 30,
                Value = request_BILLTOSTREET2 ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "Request_BILLTOCITY",
                Size = 20,
                Value = request_BILLTOCITY ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "Request_BILLTOSTATE",
                Size = 2,
                Value = request_BILLTOSTATE ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "Request_BILLTOZIP",
                Size = 9,
                Value = request_BILLTOZIP ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "Request_BILLTOCOUNTRY",
                Size = 3,
                Value = request_BILLTOCOUNTRY ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "Request_CUSTIP",
                Size = 20,
                Value = request_CUSTIP ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "Request_ORDERID",
                Size = 100,
                Value = request_ORDERID ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "Request_COMMENT1",
                Size = 128,
                Value = request_COMMENT1 ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "Request_COMMENT2",
                Size = 128,
                Value = request_COMMENT2 ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "WebOrderNumber",
                Size = 20,
                Value = webOrderNumber ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "CustomerID",
                Value = customerID ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.Int,
            },
            new SqlParameter
            {
                ParameterName = "RightFour",
                Size = 4,
                Value = rightFour ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "IV",
                Size = 50,
                Value = iV ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            parameterCounterOUTPUT,
            parameterreturnValue,
        };
        var _ = await _context.SqlQueryAsync<spPayFlowRequests_InsertResult>("EXEC @returnValue = [dbo].[spPayFlowRequests_Insert] @EncryptionKey = @EncryptionKey, @Status = @Status, @UserAgent = @UserAgent, @Request_TRXTYPE = @Request_TRXTYPE, @Request_TENDER = @Request_TENDER, @Request_ACCT = @Request_ACCT, @Request_EXPDATE = @Request_EXPDATE, @Request_AMT = @Request_AMT, @Request_CVV2 = @Request_CVV2, @Request_BILLTOFIRSTNAME = @Request_BILLTOFIRSTNAME, @Request_BILLTOLASTNAME = @Request_BILLTOLASTNAME, @Request_BILLTOSTREET = @Request_BILLTOSTREET, @Request_BILLTOSTREET2 = @Request_BILLTOSTREET2, @Request_BILLTOCITY = @Request_BILLTOCITY, @Request_BILLTOSTATE = @Request_BILLTOSTATE, @Request_BILLTOZIP = @Request_BILLTOZIP, @Request_BILLTOCOUNTRY = @Request_BILLTOCOUNTRY, @Request_CUSTIP = @Request_CUSTIP, @Request_ORDERID = @Request_ORDERID, @Request_COMMENT1 = @Request_COMMENT1, @Request_COMMENT2 = @Request_COMMENT2, @WebOrderNumber = @WebOrderNumber, @CustomerID = @CustomerID, @RightFour = @RightFour, @IV = @IV, @CounterOUTPUT = @CounterOUTPUT OUTPUT", sqlParameters, cancellationToken);

        counterOUTPUT?.SetValue(parameterCounterOUTPUT.Value);
        returnValue?.SetValue(parameterreturnValue.Value);

        return _;
    }

    public override async Task<int> spPayFlowRequests_Update_AnswerAsync(string status, string response_PNREF, string response_PPREF, int? response_RESULT, string response_CVV2MATCH, string response_RESPMSG, short? response_DUPLICATE, string response_PROCAVS, string vBNETPostType, int? counter, OutputParameter<int> returnValue = null, CancellationToken cancellationToken = default)
    {
        var parameterreturnValue = new SqlParameter
        {
            ParameterName = "returnValue",
            Direction = System.Data.ParameterDirection.Output,
            SqlDbType = System.Data.SqlDbType.Int,
        };

        var sqlParameters = new[]
        {
            new SqlParameter
            {
                ParameterName = "Status",
                Size = 50,
                Value = status ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "Response_PNREF",
                Size = 20,
                Value = response_PNREF ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "Response_PPREF",
                Size = 25,
                Value = response_PPREF ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "Response_RESULT",
                Value = response_RESULT ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.Int,
            },
            new SqlParameter
            {
                ParameterName = "Response_CVV2MATCH",
                Size = 1,
                Value = response_CVV2MATCH ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "Response_RESPMSG",
                Size = -1,
                Value = response_RESPMSG ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "Response_DUPLICATE",
                Value = response_DUPLICATE ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.SmallInt,
            },
            new SqlParameter
            {
                ParameterName = "Response_PROCAVS",
                Size = 10,
                Value = response_PROCAVS ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "VBNETPostType",
                Size = 10,
                Value = vBNETPostType ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.NVarChar,
            },
            new SqlParameter
            {
                ParameterName = "Counter",
                Value = counter ?? Convert.DBNull,
                SqlDbType = System.Data.SqlDbType.Int,
            },
            parameterreturnValue,
        };
        var _ = await _context.Database.ExecuteSqlRawAsync("EXEC @returnValue = [dbo].[spPayFlowRequests_Update_Answer] @Status = @Status, @Response_PNREF = @Response_PNREF, @Response_PPREF = @Response_PPREF, @Response_RESULT = @Response_RESULT, @Response_CVV2MATCH = @Response_CVV2MATCH, @Response_RESPMSG = @Response_RESPMSG, @Response_DUPLICATE = @Response_DUPLICATE, @Response_PROCAVS = @Response_PROCAVS, @VBNETPostType = @VBNETPostType, @Counter = @Counter", sqlParameters, cancellationToken);

        returnValue?.SetValue(parameterreturnValue.Value);

        return _;
    }
    private readonly Dictionary<string, List<spResidentialDeliveryResult>> _spResidentialDeliveryCache = new();

    public override async Task<List<spResidentialDeliveryResult>> spResidentialDeliveryAsync(int? counter, OutputParameter<int> returnValue = null, CancellationToken cancellationToken = default)
    {
        // 1. Normalize the Key
        string cacheKey = counter?.ToString() ?? "NULL";

        // 2. Cache Lookup
        if (_spResidentialDeliveryCache.TryGetValue(cacheKey, out var cachedResult))
        {
            return cachedResult;
        }

        var parameterreturnValue = new SqlParameter
        {
            ParameterName = "returnValue",
            Direction = ParameterDirection.Output,
            SqlDbType = SqlDbType.Int,
        };

        var sqlParameters = new[]
        {
            new SqlParameter
            {
                ParameterName = "counter",
                Value = (object)counter ?? DBNull.Value,
                SqlDbType = SqlDbType.Int,
            },
            parameterreturnValue,
        };

        // 3. Execute SQL
        var results = await _context.SqlQueryAsync<spResidentialDeliveryResult>(
            "EXEC @returnValue = [dbo].[spResidentialDelivery] @counter = @counter",
            sqlParameters,
            cancellationToken);

        // 4. Handle Output Parameter
        returnValue?.SetValue(parameterreturnValue.Value);

        // 5. Finalize and Cache
        var finalResults = results ?? new List<spResidentialDeliveryResult>();
        _spResidentialDeliveryCache[cacheKey] = finalResults;

        return finalResults;
    }

}
