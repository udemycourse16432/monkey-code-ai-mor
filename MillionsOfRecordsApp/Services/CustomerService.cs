using Microsoft.EntityFrameworkCore;
using MillionsOfRecordsApp.Data;

namespace MillionsOfRecordsApp.Services
{
    public class CustomerService
    {
        ReggaeDbContext _context;

        public CustomerService(ReggaeDbContext context)
        {
            _context = context;
        }

        public Task<bool> CheckLogInEmailExists(string email)
        {
            return _context.Customers.AnyAsync(x => x.LogInEmail == email);
        }
    }
}
