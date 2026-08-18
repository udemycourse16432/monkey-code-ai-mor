namespace MillionsOfRecordsApp.Services;

public class PayPalOptions
{
    public string ClientId { get; set; } = string.Empty;
    public string Secret { get; set; } = string.Empty;
    public string BaseUrl { get; set; } = string.Empty;
    public string ScriptUrl { get; set; } = string.Empty;
    public string ScripUrlAlt { get; set; } = string.Empty;

    // ID of the webhook subscription created in the PayPal Developer portal
    // for this app. Required for signature verification of incoming webhooks
    // (POST /api/paypal/webhook). Unlike ClientId/Secret it is not validated
    // at startup so existing deployments keep booting; unverified webhooks are
    // simply rejected until it is configured.
    public string WebhookId { get; set; } = string.Empty;
}
