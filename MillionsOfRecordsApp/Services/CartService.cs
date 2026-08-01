using Microsoft.EntityFrameworkCore;
using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Models;

namespace MillionsOfRecordsApp.Services
{
    public class CartService
    {
        ReggaeDbContext _context;
        public CartService(ReggaeDbContext context)
        {
            _context = context;
        }
        public async Task<List<(Cart Cart, Inventory Inv)>> GetCartDetailsAsync(string cartName)
        {
            var results = await (from c in _context.Carts
                                 join i in _context.Inventories on c.ItemId equals i.Id
                                 where c.CartName == cartName
                                 orderby c.SaveForLater, i.FormatOrder, i.UsedItem, i.ArtistTitle
                                 select new
                                 {
                                     c,
                                     i
                                 })
                                 .ToListAsync();

            return results.Select(r => (Cart: r.c, Inv: r.i)).ToList();
        }

        public async Task<int> GetCartTotalItems(string cartName)
        {
            // Single DB trip: Executes "SELECT SUM(Quantity) FROM Carts WHERE..."
            return await _context.Carts
                .AsNoTracking()
                .Where(c => c.CartName == cartName)
                .SumAsync(c => c.Quantity);
        }

        public async Task UpdateCartsPriceAsync(string cartName, bool isLoggedIn)
        {
            if (isLoggedIn)
            {
                await _context.Database.ExecuteSqlRawAsync(
                    "UPDATE carts SET price=[StorePrice] FROM carts, inventory " +
                    "WHERE inventory.id=carts.itemid AND cartname={0} AND [StorePrice] < price", cartName);
            }
            else
            {
                await _context.Database.ExecuteSqlRawAsync(
                    "UPDATE carts SET price=[RetailPrice] FROM carts, inventory " +
                    "WHERE inventory.id=carts.itemid AND cartname={0} AND [RetailPrice] < price", cartName);
            }
        }
    }
}
