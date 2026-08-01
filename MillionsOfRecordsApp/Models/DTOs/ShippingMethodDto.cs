namespace MillionsOfRecordsApp.Models.DTOs;

public class ShippingMethodDto
{
    public string Code { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }
    public string ArrivingDate { get; set; }
    public string POBoxAllowed { get; set; }
    public string CODAllowed { get; set; }
}
