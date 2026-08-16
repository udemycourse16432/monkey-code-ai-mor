using System.Globalization;
using MillionsOfRecordsApp.Models;

namespace MillionsOfRecordsApp.Services;

public class TaxOptions
{
    public decimal Rate { get; set; }

    public List<string> TaxableCountries { get; set; } = new();

    public List<string> TaxableStates { get; set; } = new();

    public bool TaxOnShipping { get; set; }
}

public class TaxService
{
    private readonly TaxOptions _options;

    public TaxService(IConfiguration configuration)
    {
        _options = configuration.GetSection("Tax").Get<TaxOptions>() ?? new TaxOptions();
    }

    public decimal Rate => _options.Rate;

    public bool TaxOnShipping => _options.TaxOnShipping;

    public async Task<decimal> CalculateTaxAsync(
        spGetCustomerDetailsByServerCounterResult customer,
        decimal productsTotal,
        decimal shippingCost,
        CancellationToken cancellationToken = default)
    {
        if (!IsTaxableJurisdiction(customer))
        {
            return 0m;
        }

        decimal rate = GetRateForCustomer(customer);
        if (rate <= 0m)
        {
            return 0m;
        }

        decimal taxableBase = _options.TaxOnShipping ? productsTotal + shippingCost : productsTotal;
        decimal tax = Math.Round(taxableBase * rate, 2, MidpointRounding.AwayFromZero);

        return tax;
    }

    private decimal GetRateForCustomer(spGetCustomerDetailsByServerCounterResult customer)
    {
        // Legacy customers may carry their own tax rate in CaTax (e.g. "7.25").
        // Fall back to the configured default rate when it is not parseable.
        if (decimal.TryParse(customer.CaTax, NumberStyles.Any, CultureInfo.InvariantCulture, out decimal customerRate))
        {
            return customerRate / 100m;
        }

        return _options.Rate;
    }

    private bool IsTaxableJurisdiction(spGetCustomerDetailsByServerCounterResult customer)
    {
        // Legacy customer flags:
        //   ChargeSalesTax = "y" forces the order to be taxable regardless of jurisdiction,
        //   ChargeSalesTax = "n" marks the customer as exempt.
        if (string.Equals(customer.ChargeSalesTax, "y", StringComparison.OrdinalIgnoreCase))
        {
            return true;
        }

        if (string.Equals(customer.ChargeSalesTax, "n", StringComparison.OrdinalIgnoreCase))
        {
            return false;
        }

        if (_options.TaxableCountries.Count > 0 &&
            !_options.TaxableCountries.Contains(customer.Country ?? string.Empty, StringComparer.OrdinalIgnoreCase))
        {
            return false;
        }

        if (_options.TaxableStates.Count > 0 &&
            !_options.TaxableStates.Contains(customer.StateProvince ?? string.Empty, StringComparer.OrdinalIgnoreCase))
        {
            return false;
        }

        return true;
    }
}
