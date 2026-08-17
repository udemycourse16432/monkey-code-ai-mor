namespace MillionsOfRecordsApp.Services;

public class PayPalOptions
{
    public string ClientId { get; set; } = string.Empty;
    public string Secret { get; set; } = string.Empty;
    public string BaseUrl { get; set; } = string.Empty;
    public string ScriptUrl { get; set; } = string.Empty;
    public string ScripUrlAlt { get; set; } = string.Empty;
}
