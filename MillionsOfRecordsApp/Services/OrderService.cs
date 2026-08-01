using MillionsOfRecordsApp.Data;

namespace MillionsOfRecordsApp.Services
{
    public class OrderService
    {
        private readonly IReggaeDbContextProcedures _procedures;
        private static readonly char[] Digits = "123456789".ToCharArray();

        public OrderService(IReggaeDbContextProcedures procedures)
        {
            _procedures = procedures;
        }

        public async Task<string> GenerateUniqueOrderNumberAsync()
        {
            int attempts = 0;
            const int maxAttempts = 10;

            while (attempts < maxAttempts)
            {
                // 1. Generate the string using the high-performance Span approach
                string orderNumber = string.Create(15, Digits, (span, digits) =>
                {
                    "WEB-".AsSpan().CopyTo(span);
                    span[7] = '-';
                    span[11] = '-';

                    Random.Shared.GetItems(digits, span.Slice(4, 3));
                    Random.Shared.GetItems(digits, span.Slice(8, 3));
                    Random.Shared.GetItems(digits, span.Slice(12, 3));
                });

                // 2. Check uniqueness in DB
                var results = await _procedures.spSeeIfOrderNumberExistsAsync(orderNumber);

                if (results == null || !results.Any())
                {
                    return orderNumber; // Success!
                }

                attempts++;
            }

            throw new Exception("Could not generate a unique order number after multiple attempts.");
        }
    }
}
