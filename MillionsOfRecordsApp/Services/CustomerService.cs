using Microsoft.EntityFrameworkCore;
using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Models;

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
        public Task<Customer?> GetCustomerByEmailAsync(string email)
        {
            return _context.Customers.FirstOrDefaultAsync(x => x.LogInEmail == email);
        }
    }
}
