using MillionsOfRecordsApp.Models;

namespace MillionsOfRecordsApp.Services;

public class TaxOptions
{
    public decimal Rate { get; set; }

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

    public async Task<decimal> CalculateTaxAsync(
        spGetCustomerDetailsByServerCounterResult customer,
        decimal productsTotal,
        decimal shippingCost,
        CancellationToken cancellationToken = default)
    {
        if (!IsTaxable(customer))
        {
            return 0m;
        }

        decimal rate = _options.Rate;
        if (rate <= 0m)
        {
            return 0m;
        }

        decimal taxableBase = _options.TaxOnShipping ? productsTotal + shippingCost : productsTotal;
        decimal tax = Math.Round(taxableBase * rate, 2, MidpointRounding.AwayFromZero);

        return tax;
    }

    private bool IsTaxable(spGetCustomerDetailsByServerCounterResult customer)
    {
        // Legacy rule 1: a customer with ChargeSalesTax = "N" is exempt from sales tax.
        if (string.Equals(customer.ChargeSalesTax, "n", StringComparison.OrdinalIgnoreCase))
        {
            return false;
        }

        // Legacy rule 2: only orders shipping to California are charged sales tax.
        if (_options.TaxableStates.Count > 0 &&
            !_options.TaxableStates.Contains(customer.StateProvince ?? string.Empty, StringComparer.OrdinalIgnoreCase))
        {
            return false;
        }

        return true;
    }
}
