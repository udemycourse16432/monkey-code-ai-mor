using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.Data.SqlClient;
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
