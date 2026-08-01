namespace MillionsOfRecordsApp.Models.DTOs
{
    public class CartRequest
    {
        public int Id { get; set; }
        public decimal Price { get; set; }
        public int Type { get; set; }
        public int Qty { get; set; }
        public string SearchId { get; set; } = "-";
    }
}
