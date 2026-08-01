namespace MillionsOfRecordsApp.Models.DTOs;

public class CartItemDto
{
    public List<Inventory.ParsedFeature> Features { get; set; } = new();
    public int ID { get; set; }
    public string ArtistTitle { get; set; } = string.Empty;
    public string Format { get; set; } = string.Empty;
    public decimal Price { get; set; }
    public int Quantity { get; set; }
    public string Label { get; set; } = string.Empty;
    public string YearFrom { get; set; } = string.Empty;
    public string? YearTo { get; set; }
    public string FrontImg { get; set; } = string.Empty;
    public string BackImg { get; set; } = string.Empty;
    public string LargeFrontImg { get; set; } = string.Empty;
    public string LargeBackImg { get; set; } = string.Empty;
    public string Genre1 { get; set; } = string.Empty;
    public bool ShowSimilarItems { get; set; }

    // Logic-driven fields from legacy
    public string SaveForLater { get; set; } = "n";
    public int FormatOrder { get; set; }
    public string UsedItem { get; set; } = "n";
}