using Microsoft.AspNetCore.Mvc;
using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Models;
using System.Security.Cryptography;
using System.Text;

namespace MillionsOfRecordsApp.Controllers
{
    // to test this page use the following URL: https://localhost:7244/HTTPUploadData.aspx?pw=a5b6c8ugjt76g4q0m![]f67w2-lx3eu7&counter=12345&table=SignInLog
    [ApiController]
    [Route("HTTPUploadData.aspx")] // Keeps backwards compatibility with legacy URL calls
    public class HTTPUploadDataController : ControllerBase
    {
        private readonly IReggaeDbContextProcedures _procedures;
        private readonly ILogger<HTTPUploadDataController> _logger;
        private readonly string _uploadDataPassword;
        public HTTPUploadDataController(
        IReggaeDbContextProcedures procedures,
        ILogger<HTTPUploadDataController> logger,
        IConfiguration configuration)
        {
            _procedures = procedures;
            _logger = logger;
            // Fetch from appsettings / Environment Variables
            _uploadDataPassword = configuration["LegacyApiSettings:HTTPUploadDataPassword"] ?? string.Empty;
        }

        private async Task<IActionResult> HandleEmailFooterAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");
            string? footer = payload.GetString("Footer");

            _logger.LogDebug("Executing spSync_EmailFooterAsync with Counter: {Counter}", counter);
            await _procedures.spSync_EmailFooterAsync(counter, footer);
            return Ok("success");
        }
        private async Task<IActionResult> HandleEmailFooterDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_EmailFooter_DeletesAsync with Counter: {Counter}", counter);
            await _procedures.spSync_EmailFooter_DeletesAsync(counter);
            return Ok("success");
        }
        private async Task<IActionResult> HandleMaintenanceOpenAsync(string rawData)
        {
            string? randomNumber = rawData.Length >= 13 ? rawData[13..] : null;

            _logger.LogDebug("Executing spSync_IsINTERNETREGGAEMaintenanceOpenUpdateFieldAsync");
            await _procedures.spSync_IsINTERNETREGGAEMaintenanceOpenUpdateFieldAsync(randomNumber);
            return Ok("success");
        }
        private async Task<IActionResult> HandleBackordersInStockAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");
            int? customerId = payload.GetInt("CustomerID");

            _logger.LogDebug("Executing spSync_BackordersInStockNowAsync for CustomerId: {CustomerId}, Counter: {Counter}", customerId, counter);
            await _procedures.spSync_BackordersInStockNowAsync(
                counter,
                customerId,
                payload.GetInt("BackorderInventoryID"),
                payload.GetInt("BackorderQuantity"),
                payload.GetDateTime("DateOrdered"),
                payload.GetString("PONumber"));
            return Ok("success");
        }

        private async Task<IActionResult> HandleBackordersDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_BackordersInStockNow_DeletesAsync with Counter: {Counter}", counter);
            await _procedures.spSync_BackordersInStockNow_DeletesAsync(counter);
            return Ok("success");
        }

        private async Task<IActionResult> HandleTermsOfSaleTypesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");
            int? type = payload.GetInt("Type");

            _logger.LogDebug("Executing spSync_TermsOfSaleTypesAsync for Type: {Type}, Counter: {Counter}", type, counter);
            await _procedures.spSync_TermsOfSaleTypesAsync(
                counter,
                type,
                payload.GetString("TextOnInvoice"),
                payload.GetString("TextOnWebsitePaymentButton"),
                payload.GetInt("DaysUntilDue"),
                payload.GetString("RetailUSA"),
                payload.GetString("RetailInternational"),
                payload.GetString("WholesaleUSA"),
                payload.GetString("WholesaleInternational"),
                payload.GetInt("TermsDays"));
            return Ok("success");
        }

        private async Task<IActionResult> HandleTermsOfSaleTypesDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_TermsOfSaleTypes_DeletesAsync with Counter: {Counter}", counter);
            await _procedures.spSync_TermsOfSaleTypes_DeletesAsync(counter);
            return Ok("success");
        }
        private async Task<IActionResult> HandleWebHowFoundUsAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");
            string? howFoundUs = payload.GetString("HowFoundUs");

            _logger.LogDebug("Executing spSync_WebHowFoundUs with Counter: {Counter}", counter);

            // Note: If your _procedures interface expects raw parameters or stored procedure calls directly:
            await _procedures.spSync_WebHowFoundUsAsync(counter, howFoundUs);

            return Ok("success");
        }

        private async Task<IActionResult> HandleWebHowFoundUsDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_WebHowFoundUs_Deletes with Counter: {Counter}", counter);
            await _procedures.spSync_WebHowFoundUs_DeletesAsync(counter);

            return Ok("success");
        }
        private async Task<IActionResult> HandleResidentialAsync(Dictionary<string, string> payload)
        {
            int? customerServerCounter = payload.GetInt("CustomerServerCounter");

            // Parses string/boolean/flag values safely depending on how FedExResidential is represented
            string? fedExResidential = payload.GetString("FedExResidential");

            _logger.LogDebug(
                "Executing spSync_Residential with CustomerServerCounter: {CustomerServerCounter}, FedExResidential: {FedExResidential}",
                customerServerCounter,
                fedExResidential);

            await _procedures.spSync_ResidentialAsync(customerServerCounter, fedExResidential);

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebCountryShippingZonesAsync(Dictionary<string, string> payload)
        {
            int? id = payload.GetInt("ID");
            string? country = payload.GetString("Country");

            _logger.LogDebug("Executing spSync_WebCountryShippingZonesT for Country ID: {ID}, Country: {Country}", id, country);

            await _procedures.spSync_WebCountryShippingZonesTAsync(
                id,
                country,
                payload.GetString("FedExInternationalPriorityZone"),
                payload.GetString("AirParcelPostZone"),
                payload.GetString("AirSmallPacketZone"),
                payload.GetString("ErnieShippingZone"),
                payload.GetString("LetterPostRateGroup"),
                payload.GetString("GlobalExpressZone"),
                payload.GetString("FedExInternationalEconomyZone"),
                payload.GetString("FedexExportRatesThatWeChargeCustomersZone"),
                payload.GetString("EuropeanUnionCountry"),
                payload.GetInt("AirSmallPacketWeightLimit"),
                payload.GetDecimal("RetailMinimumShippingCharge"),
                payload.GetDouble("RetailPercentShippingCharge"),
                payload.GetString("FedExCountryCode"),
                payload.GetString("PostalCodeRequired"),
                payload.GetString("StateProvinceRequired"),
                payload.GetString("StateProvinceWord"),
                payload.GetString("AddressUpperCase"),
                payload.GetString("AddressCityLine1"),
                payload.GetString("AddressCityLine2"),
                payload.GetString("CityRequired"),
                payload.GetString("IslandRequired"),
                payload.GetString("IslandWord"),
                payload.GetString("CityWord"),
                payload.GetString("PostalCodeWord"),
                payload.GetString("PostalCodeFormat"),
                payload.GetString("FedExFranceIPDZone"),
                payload.GetDouble("DutyShippingCostPercent"),
                payload.GetString("EconomySurfaceParcelPostZone"),
                payload.GetString("WebUSMailWholesaleAllowed"),
                payload.GetString("FedexPhoneNumber"),
                payload.GetInt("AirParcelPostWeightLimit"),
                payload.GetInt("GlobalExpressWeightLimit"),
                payload.GetString("AllowFedexInternationalPriorityForRetail"),
                payload.GetString("AutomaticUSMailInsurance"),
                payload.GetDecimal("DHLFlatRate"),
                payload.GetString("DHLInternationalExpressZone")
            );

            return Ok("success");
        }

        private async Task<IActionResult> HandleWebCountryShippingZonesDeletesAsync(Dictionary<string, string> payload)
        {
            int? id = payload.GetInt("ID");

            _logger.LogDebug("Executing spSync_WebCountryShippingZonesT_Deletes with ID: {ID}", id);

            await _procedures.spSync_WebCountryShippingZonesT_DeletesAsync(id);

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebCountryStateProvincesListAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");
            string? country = payload.GetString("Country");
            string? stateProvince = payload.GetString("StateProvince");
            string? stateProvinceAbbreviation = payload.GetString("StateProvinceAbbreviation");

            _logger.LogDebug(
                "Executing spSync_WebCountryStateProvincesList with Counter: {Counter}, Country: {Country}, StateProvince: {StateProvince}",
                counter,
                country,
                stateProvince);

            await _procedures.spSync_WebCountryStateProvincesListAsync(
                counter,
                country,
                stateProvince,
                stateProvinceAbbreviation);

            return Ok("success");
        }

        private async Task<IActionResult> HandleWebCountryStateProvincesListDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_WebCountryStateProvincesList_Deletes with Counter: {Counter}", counter);

            await _procedures.spSync_WebCountryStateProvincesList_DeletesAsync(counter);

            return Ok("success");
        }
        private async Task<IActionResult> HandleInventoryAsync(Dictionary<string, string> payload)
        {
            int? id = payload.GetInt("ID");
            string? artistTitle = payload.GetString("ArtistTitle");

            _logger.LogDebug("Executing spSync_InventoryAsync for Item ID: {ID}, ArtistTitle: {ArtistTitle}", id, artistTitle);

            var results = await _procedures.spSync_InventoryAsync(
                iD: id,
                artistTitle: artistTitle,
                label: payload.GetString("Label"),
                retailPrice: payload.GetDecimal("RetailPrice"),
                inventory: payload.GetInt("Inventory"),
                format: payload.GetString("Format"),
                inStockDate: payload.GetDateTime("InStockDate"),
                rhythmName: payload.GetString("RhythmName"),
                yearFrom: payload.GetString("YearFrom"),
                yearTo: payload.GetString("YearTo"),
                storePrice: payload.GetDecimal("StorePrice"),
                backInStockDate: payload.GetDateTime("BackInStockDate"),
                produceGroup: payload.GetString("ProduceGroup"),
                musicianGroup: payload.GetString("MusicianGroup"),
                tracksGroup: payload.GetString("TracksGroup"),
                catalog: payload.GetString("Catalog"),
                formatOrder: payload.GetInt("FormatOrder"),
                exportPrice: payload.GetDecimal("ExportPrice"),
                webEssential: payload.GetString("WebEssential"),
                webReviewHTML: payload.GetString("WebReviewHTML"),
                cutout: payload.GetString("Cutout"),
                weightInGrams: payload.GetDecimal("WeightInGrams"),
                numberOfTracks: payload.GetInt("NumberOfTracks"),
                deleted: payload.GetString("Deleted"),
                cost: payload.GetDecimal("Cost"),
                mP3FileCompleted: payload.GetString("MP3FileCompleted"),
                usedItem: payload.GetString("UsedItem"),
                conditionJacket: payload.GetString("ConditionJacket"),
                conditionVinylOrCD: payload.GetString("ConditionVinylOrCD"),
                conditionNotes: payload.GetString("ConditionNotes"),
                mP3SoundGroup: payload.GetInt("MP3SoundGroup"),
                dateAdded: payload.GetDateTime("DateAdded"),
                genre1: payload.GetString("Genre1"),
                genre2: payload.GetString("Genre2"),
                genre3: payload.GetString("Genre3"),
                genre4: payload.GetString("Genre4"),
                genre5: payload.GetString("Genre5"),
                genre6: payload.GetString("Genre6"),
                genre7: payload.GetString("Genre7"),
                genre8: payload.GetString("Genre8"),
                genre9: payload.GetString("Genre9"),
                uPC: payload.GetString("UPC"),
                itemDetailsWeb: payload.GetString("ItemDetailsWeb"),
                itemDetailsWebProductDetails: payload.GetString("ItemDetailsWebProductDetails"),
                sale_RetailPrice: payload.GetDecimal("Sale_RetailPrice"),
                sale_RetailEndDate: payload.GetDateTime("Sale_RetailEndDate"),
                sale_RetailFootnoteText: payload.GetString("Sale_RetailFootnoteText"),
                sale_RetailItemDetailsText: payload.GetString("Sale_RetailItemDetailsText"),
                sale_WholesalePrice: payload.GetDecimal("Sale_WholesalePrice"),
                sale_WholesaleEndDate: payload.GetDateTime("Sale_WholesaleEndDate"),
                sale_WholesaleFootnoteText: payload.GetString("Sale_WholesaleFootnoteText"),
                sale_WholesaleItemDetailsText: payload.GetString("Sale_WholesaleItemDetailsText"),
                itemFootnoteText: payload.GetString("ItemFootnoteText"),
                supplierID: payload.GetInt("SupplierID"),
                streetDate: payload.GetDateTime("StreetDate"),
                showOnWebsite: payload.GetString("ShowOnWebsite"),
                conditionText: payload.GetString("ConditionText"),
                kirbyItem: payload.GetString("KirbyItem"),
                kirbysCut: payload.GetDecimal("KirbysCut"),
                kirbyCost: payload.GetDecimal("KirbyCost")
            );

            // Matches legacy behavior: Return the result object or "success"
            //return Ok(results);
            return Ok("success");
        }
        private async Task<IActionResult> HandleInventoryDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_Inventory_DeletesAsync with Counter: {Counter}", counter);

            await _procedures.spSync_Inventory_DeletesAsync(counter);

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebShipXAirParcelPostAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");
            double? weightInPounds = payload.GetDouble("WeightInPounds");

            _logger.LogDebug("Executing spSync_webSHIPX_AirParcelPostAsync for Counter: {Counter}, WeightInPounds: {WeightInPounds}", counter, weightInPounds);

            await _procedures.spSync_webSHIPX_AirParcelPostAsync(
                counter: counter,
                weightInPounds: weightInPounds,
                zone1: payload.GetDecimal("Zone1"),
                zone2: payload.GetDecimal("Zone2"),
                zone3: payload.GetDecimal("Zone3"),
                zone4: payload.GetDecimal("Zone4"),
                zone5: payload.GetDecimal("Zone5"),
                zone6: payload.GetDecimal("Zone6"),
                zone7: payload.GetDecimal("Zone7"),
                zone8: payload.GetDecimal("Zone8"),
                zone9: payload.GetDecimal("Zone9"),
                zone10: payload.GetDecimal("Zone10"),
                zone11: payload.GetDecimal("Zone11"),
                zone12: payload.GetDecimal("Zone12"),
                zone13: payload.GetDecimal("Zone13"),
                zone14: payload.GetDecimal("Zone14"),
                zone15: payload.GetDecimal("Zone15"),
                zone16: payload.GetDecimal("Zone16"),
                zone17: payload.GetDecimal("Zone17")
            );

            return Ok("success");
        }

        private async Task<IActionResult> HandleWebShipXAirParcelPostDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_WebSHIPX_AirParcelPost_DeletesAsync with Counter: {Counter}", counter);

            await _procedures.spSync_WebSHIPX_AirParcelPost_DeletesAsync(counter);

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebShipXAirSmallPacketAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");
            double? weightInPounds = payload.GetDouble("WeightInPounds");

            _logger.LogDebug("Executing spSync_webSHIPX_AirSmallPacketAsync for Counter: {Counter}, WeightInPounds: {WeightInPounds}", counter, weightInPounds);

            await _procedures.spSync_webSHIPX_AirSmallPacketAsync(
                counter: counter,
                weightInPounds: weightInPounds,
                zone1: payload.GetDecimal("Zone1"),
                zone2: payload.GetDecimal("Zone2"),
                zone3: payload.GetDecimal("Zone3"),
                zone4: payload.GetDecimal("Zone4"),
                zone5: payload.GetDecimal("Zone5"),
                zone6: payload.GetDecimal("Zone6"),
                zone7: payload.GetDecimal("Zone7"),
                zone8: payload.GetDecimal("Zone8"),
                zone9: payload.GetDecimal("Zone9")
            );

            return Ok("success");
        }

        private async Task<IActionResult> HandleWebShipXAirSmallPacketDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_WebSHIPX_AirSmallPacket_DeletesAsync with Counter: {Counter}", counter);

            await _procedures.spSync_WebSHIPX_AirSmallPacket_DeletesAsync(counter);

            return Ok("success");
        }

        private async Task<IActionResult> HandleWebShipXDefaultShippingChargesExportPriceAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");
            string? shippingMethod = payload.GetString("ShippingMethod");

            _logger.LogDebug("Executing spSync_WebSHIPX_DefaultShippingChargesExportPriceAsync for Counter: {Counter}, ShippingMethod: {ShippingMethod}", counter, shippingMethod);

            await _procedures.spSync_webSHIPX_DefaultShippingChargesExportPriceAsync(
                counter: counter,
                shippingMethod: shippingMethod,
                amountPerPoundSurcharge: payload.GetDecimal("AmountPerPoundSurcharge"),
                percentOfPurchaseValueSurcharge: payload.GetDouble("PercentOfPurchaseValueSurcharge"),
                flatAmountSurcharge: payload.GetDecimal("FlatAmountSurcharge"),
                shippingCostSurcharge: payload.GetDouble("ShippingCostSurcharge")
            );

            return Ok("success");
        }

        private async Task<IActionResult> HandleWebShipXDefaultShippingChargesExportPriceDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_WebSHIPX_DefaultShippingChargesExportPrice_DeletesAsync with Counter: {Counter}", counter);

            await _procedures.spSync_webSHIPX_DefaultShippingChargesExportPrice_DeletesAsync(counter);

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebShipXDefaultShippingChargesRetailPriceAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");
            string? shippingMethod = payload.GetString("ShippingMethod");

            _logger.LogDebug("Executing spSync_webSHIPX_DefaultShippingChargesRetailPriceAsync for Counter: {Counter}, ShippingMethod: {ShippingMethod}", counter, shippingMethod);

            await _procedures.spSync_webSHIPX_DefaultShippingChargesRetailPriceAsync(
                counter: counter,
                shippingMethod: shippingMethod,
                amountPerPoundSurcharge: payload.GetDecimal("AmountPerPoundSurcharge"),
                percentOfPurchaseValueSurcharge: payload.GetDouble("PercentOfPurchaseValueSurcharge"),
                flatAmountSurcharge: payload.GetDecimal("FlatAmountSurcharge"),
                shippingCostSurcharge: payload.GetDouble("ShippingCostSurcharge")
            );

            return Ok("success");
        }

        private async Task<IActionResult> HandleWebShipXDefaultShippingChargesRetailPriceDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_webSHIPX_DefaultShippingChargesRetailPrice_DeletesAsync with Counter: {Counter}", counter);

            await _procedures.spSync_webSHIPX_DefaultShippingChargesRetailPrice_DeletesAsync(counter);

            return Ok("success");
        }

        private async Task<IActionResult> HandleWebShipXDefaultShippingChargesStorePriceAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");
            string? shippingMethod = payload.GetString("ShippingMethod");

            _logger.LogDebug("Executing spSync_webSHIPX_DefaultShippingChargesStorePriceAsync for Counter: {Counter}, ShippingMethod: {ShippingMethod}", counter, shippingMethod);

            await _procedures.spSync_webSHIPX_DefaultShippingChargesStorePriceAsync(
                counter: counter,
                shippingMethod: shippingMethod,
                amountPerPoundSurcharge: payload.GetDecimal("AmountPerPoundSurcharge"),
                percentOfPurchaseValueSurcharge: payload.GetDouble("PercentOfPurchaseValueSurcharge"),
                flatAmountSurcharge: payload.GetDecimal("FlatAmountSurcharge"),
                shippingCostSurcharge: payload.GetDouble("ShippingCostSurcharge")
            );

            return Ok("success");
        }

        private async Task<IActionResult> HandleWebShipXDefaultShippingChargesStorePriceDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_webSHIPX_DefaultShippingChargesStorePrice_DeletesAsync with Counter: {Counter}", counter);

            await _procedures.spSync_webSHIPX_DefaultShippingChargesStorePrice_DeletesAsync(counter);

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebShipXFirstClassAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");
            double? weightInPounds = payload.GetDouble("WeightInPounds");

            _logger.LogDebug("Executing spSync_webSHIPX_FirstClassAsync for Counter: {Counter}, WeightInPounds: {WeightInPounds}", counter, weightInPounds);

            await _procedures.spSync_webSHIPX_FirstClassAsync(
                counter: counter,
                weightInPounds: weightInPounds,
                zone1: payload.GetDecimal("Zone1"),
                zone2: payload.GetDecimal("Zone2"),
                zone3: payload.GetDecimal("Zone3"),
                zone4: payload.GetDecimal("Zone4"),
                zone5: payload.GetDecimal("Zone5"),
                zone6: payload.GetDecimal("Zone6"),
                zone7: payload.GetDecimal("Zone7"),
                zone8: payload.GetDecimal("Zone8")
            );

            return Ok("success");
        }

        private async Task<IActionResult> HandleWebShipXFirstClassDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_WebSHIPX_FirstClass_DeletesAsync with Counter: {Counter}", counter);

            await _procedures.spSync_WebSHIPX_FirstClass_DeletesAsync(counter);

            return Ok("success");
        }

        private async Task<IActionResult> HandleWebShipXMediaMailAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");
            double? weightInPounds = payload.GetDouble("WeightInPounds");

            _logger.LogDebug("Executing spSync_webSHIPX_MediaMailAsync for Counter: {Counter}, WeightInPounds: {WeightInPounds}", counter, weightInPounds);

            await _procedures.spSync_webSHIPX_MediaMailAsync(
                counter: counter,
                weightInPounds: weightInPounds,
                zone1: payload.GetDecimal("Zone1"),
                zone2: payload.GetDecimal("Zone2"),
                zone3: payload.GetDecimal("Zone3"),
                zone4: payload.GetDecimal("Zone4"),
                zone5: payload.GetDecimal("Zone5"),
                zone6: payload.GetDecimal("Zone6"),
                zone7: payload.GetDecimal("Zone7"),
                zone8: payload.GetDecimal("Zone8")
            );

            return Ok("success");
        }

        private async Task<IActionResult> HandleWebShipXMediaMailDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_WebSHIPX_MediaMail_DeletesAsync with Counter: {Counter}", counter);

            await _procedures.spSync_WebSHIPX_MediaMail_DeletesAsync(counter);

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebShipXPriorityMailAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");
            double? weightInPounds = payload.GetDouble("WeightInPounds");

            _logger.LogDebug("Executing spSync_webSHIPX_PriorityMailAsync for Counter: {Counter}, WeightInPounds: {WeightInPounds}", counter, weightInPounds);

            await _procedures.spSync_webSHIPX_PriorityMailAsync(
                counter: counter,
                weightInPounds: weightInPounds,
                zone1: payload.GetDecimal("Zone1"),
                zone2: payload.GetDecimal("Zone2"),
                zone3: payload.GetDecimal("Zone3"),
                zone4: payload.GetDecimal("Zone4"),
                zone5: payload.GetDecimal("Zone5"),
                zone6: payload.GetDecimal("Zone6"),
                zone7: payload.GetDecimal("Zone7"),
                zone8: payload.GetDecimal("Zone8")
            );

            return Ok("success");
        }

        private async Task<IActionResult> HandleWebShipXPriorityMailDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_WebSHIPX_PriorityMail_DeletesAsync with Counter: {Counter}", counter);

            await _procedures.spSync_WebSHIPX_PriorityMail_DeletesAsync(counter);

            return Ok("success");
        }

        private async Task<IActionResult> HandleWebShipXShippingHolidaysOutboundAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");
            DateTime? date = payload.GetDateTime("Date");

            _logger.LogDebug("Executing spSync_WebSHIPX_ShippingHolidaysOutboundAsync for Counter: {Counter}, Date: {Date}", counter, date);

            await _procedures.spSync_WebSHIPX_ShippingHolidaysOutboundAsync(
                counter: counter,
                date: date,
                fedexAirHoliday: payload.GetString("FedexAirHoliday"),
                fedexGroundHoliday: payload.GetString("FedexGroundHoliday"),
                uSPSHoliday: payload.GetString("USPSHoliday"),
                workHoliday: payload.GetString("WorkHoliday"),
                uPSGroundHoliday: payload.GetString("UPSGroundHoliday")
            );

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebShipXShippingHolidaysOutboundDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_WebSHIPX_ShippingHolidaysOutbound_DeletesAsync with Counter: {Counter}", counter);

            await _procedures.spSync_WebSHIPX_ShippingHolidaysOutbound_DeletesAsync(counter);

            return Ok("success");
        }

        private async Task<IActionResult> HandleWebShipXShippingMethodsAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");
            string? shippingMethodCode = payload.GetString("ShippingMethodCode");

            _logger.LogDebug("Executing spSync_WebSHIPX_ShippingMethodsAsync for Counter: {Counter}, ShippingMethodCode: {ShippingMethodCode}", counter, shippingMethodCode);

            await _procedures.spSync_WebSHIPX_ShippingMethodsAsync(
                counter: counter,
                shippingMethodCode: shippingMethodCode,
                domestic: payload.GetString("Domestic"),
                international: payload.GetString("International"),
                uSPossessions: payload.GetString("USPossessions"),
                pickUpTime: payload.GetDateTime("PickUpTime"),
                shipViaService: payload.GetString("ShipViaService"),
                shippingViaCompany: payload.GetString("ShippingViaCompany"),
                shippingCostTableName: payload.GetString("ShippingCostTableName"),
                pOBoxOK: payload.GetString("POBoxOK"),
                cODOK: payload.GetString("CODOK"),
                fuelSurcharge: payload.GetDouble("FuelSurcharge"),
                ourDutyCostPercent: payload.GetDouble("OurDutyCostPercent"),
                maxWeightOfShipment: payload.GetInt("MaxWeightOfShipment"),
                maxWeightOfBox: payload.GetInt("MaxWeightOfBox"),
                shipmentFlatRateWeight: payload.GetInt("ShipmentFlatRateWeight"),
                cODCharge: payload.GetDecimal("CODCharge"),
                residentialDeliveryCharge: payload.GetDecimal("ResidentialDeliveryCharge"),
                militaryAddressOK: payload.GetString("MilitaryAddressOK"),
                deliveryDateGuaranteed: payload.GetString("DeliveryDateGuaranteed"),
                eUCountries: payload.GetString("EUCountries"),
                numberOfBoxesMatters: payload.GetString("NumberOfBoxesMatters"),
                minimumWeightOfShipment: payload.GetInt("MinimumWeightOfShipment"),
                holidayColumnName: payload.GetString("HolidayColumnName"),
                saturdayDeliveryCharge: payload.GetDecimal("SaturdayDeliveryCharge"),
                webShippingCutoffMinutes: payload.GetInt("WebShippingCutoffMinutes"),
                officeShippingCutoffMinutes: payload.GetInt("OfficeShippingCutoffMinutes"),
                pullSheetText: payload.GetString("PullSheetText"),
                hawaii: payload.GetString("Hawaii"),
                alaska: payload.GetString("Alaska"),
                description1: payload.GetString("Description1"),
                description2: payload.GetString("Description2"),
                description3: payload.GetString("Description3"),
                description4: payload.GetString("Description4"),
                trackingWord: payload.GetString("TrackingWord"),
                websiteTrackingDescription1: payload.GetString("WebsiteTrackingDescription1"),
                websiteTrackingDescription2: payload.GetString("WebsiteTrackingDescription2"),
                websiteTrackingDescription3: payload.GetString("WebsiteTrackingDescription3"),
                websiteTrackingDescription4: payload.GetString("WebsiteTrackingDescription4"),
                lPor12InchSurcharge: payload.GetDecimal("LPor12InchSurcharge"),
                customFlatShippingChargeSpendThreshold: payload.GetDecimal("CustomFlatShippingChargeSpendThreshold"),
                customFlatShippingCharge: payload.GetDecimal("CustomFlatShippingCharge"),
                fedExAPIServiceEnumeration: payload.GetString("FedExAPIServiceEnumeration")
            );

            return Ok("success");
        }

        private async Task<IActionResult> HandleWebShipXShippingMethodsDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_WebSHIPX_ShippingMethods_DeletesAsync with Counter: {Counter}", counter);

            await _procedures.spSync_WebSHIPX_ShippingMethods_DeletesAsync(counter);

            return Ok("success");
        }

        private async Task<IActionResult> HandleCountryListAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_CountryListAsync with Counter: {Counter}", counter);

            await _procedures.spSync_CountryListAsync(
                counter,
                countryText: payload.GetString("CountryText"),
                country: payload.GetString("Country"),
                stateProvince: payload.GetString("StateProvince"),
                sortOrderText: payload.GetString("SortOrderText"),
                city: payload.GetString("City")
            );

            return Ok("success");
        }
        private async Task<IActionResult> HandleCountryListDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_CountryList_DeletesAsync with Counter: {Counter}", counter);

            await _procedures.spSync_CountryList_DeletesAsync(counter);

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebShipXPackagingWeight1Async(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_WebSHIPX_Packaging_Weight_1Async with Counter: {Counter}", counter);

            await _procedures.spSync_WebSHIPX_Packaging_Weight_1Async(
                counter,
                payload.GetInt("ItemWeight"),
                payload.GetInt("PackagingWeight"),
                payload.GetString("PackageDescription"));

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebShipXPackagingWeight1DeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_WebSHIPX_Packaging_Weight_1_DeletesAsync with Counter: {Counter}", counter);

            await _procedures.spSync_WebSHIPX_Packaging_Weight_1_DeletesAsync(counter);

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebShipXPackagingWeight2Async(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_WebSHIPX_Packaging_Weight_2Async with Counter: {Counter}", counter);

            await _procedures.spSync_WebSHIPX_Packaging_Weight_2Async(
                counter,
                payload.GetInt("ItemWeight"),
                payload.GetInt("PackagingWeight"),
                payload.GetString("PackageDescription"));

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebShipXPackagingWeight2DeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_WebSHIPX_Packaging_Weight_2_DeletesAsync with Counter: {Counter}", counter);

            await _procedures.spSync_WebSHIPX_Packaging_Weight_2_DeletesAsync(counter);

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebShipXFedexGroundAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_webSHIPX_FedexGroundAsync with Counter: {Counter}", counter);

            await _procedures.spSync_webSHIPX_FedexGroundAsync(
                counter,
                payload.GetDouble("WeightInPounds"),
                payload.GetDecimal("Zone2"),
                payload.GetDecimal("Zone3"),
                payload.GetDecimal("Zone4"),
                payload.GetDecimal("Zone5"),
                payload.GetDecimal("Zone6"),
                payload.GetDecimal("Zone7"),
                payload.GetDecimal("Zone8")
                );

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebShipXFedexGroundDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_webSHIPX_FedexGround_DeletesAsync with Counter: {Counter}", counter);

            await _procedures.spSync_webSHIPX_FedexGround_DeletesAsync(counter);

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebShipXFedexDomestic2DayAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_webSHIPX_FedexDomestic2DayAsync with Counter: {Counter}", counter);

            await _procedures.spSync_webSHIPX_FedexDomestic2DayAsync(
                counter,
                payload.GetDouble("WeightInPounds"),
                payload.GetDecimal("Zone2"),
                payload.GetDecimal("Zone3"),
                payload.GetDecimal("Zone4"),
                payload.GetDecimal("Zone5"),
                payload.GetDecimal("Zone6"),
                payload.GetDecimal("Zone7"),
                payload.GetDecimal("Zone8")
                );

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebShipXFedexDomestic2DayDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_webSHIPX_FedexDomestic2Day_DeletesAsync with Counter: {Counter}", counter);

            await _procedures.spSync_webSHIPX_FedexDomestic2Day_DeletesAsync(counter);

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebShipXFedexInternationalEconomyAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_webSHIPX_FedexInternationalEconomyAsync with Counter: {Counter}", counter);

            await _procedures.spSync_webSHIPX_FedexInternationalEconomyAsync(
                counter,
                payload.GetDouble("WeightInPounds"),
                payload.GetDecimal("ZoneA"),
                payload.GetDecimal("ZoneB"),
                payload.GetDecimal("ZoneC"),
                payload.GetDecimal("ZoneD"),
                payload.GetDecimal("ZoneE"),
                payload.GetDecimal("ZoneF"),
                payload.GetDecimal("ZoneG"),
                payload.GetDecimal("ZoneH"),
                payload.GetDecimal("ZoneI"),
                payload.GetDecimal("ZoneJ"),
                payload.GetDecimal("ZoneK"),
                payload.GetDecimal("ZoneL"),
                payload.GetDecimal("ZoneM"),
                payload.GetDecimal("ZoneN"),
                payload.GetDecimal("ZoneO")
                );

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebShipXFedexInternationalEconomyDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_webSHIPX_FedexInternationalEconomy_DeletesAsync with Counter: {Counter}", counter);

            await _procedures.spSync_webSHIPX_FedexInternationalEconomy_DeletesAsync(counter);

            return Ok("success");
        }

        private async Task<IActionResult> HandleWebShipXFedexInternationalPriorityAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_webSHIPX_FedexInternationalPriorityAsync with Counter: {Counter}", counter);

            await _procedures.spSync_webSHIPX_FedexInternationalPriorityAsync(
                counter,
                payload.GetDouble("WeightInPounds"),
                payload.GetDecimal("ZoneA"),
                payload.GetDecimal("ZoneB"),
                payload.GetDecimal("ZoneC"),
                payload.GetDecimal("ZoneD"),
                payload.GetDecimal("ZoneE"),
                payload.GetDecimal("ZoneF"),
                payload.GetDecimal("ZoneG"),
                payload.GetDecimal("ZoneH"),
                payload.GetDecimal("ZoneI"),
                payload.GetDecimal("ZoneJ"),
                payload.GetDecimal("ZoneK"),
                payload.GetDecimal("ZoneL"),
                payload.GetDecimal("ZoneM"),
                payload.GetDecimal("ZoneN"),
                payload.GetDecimal("ZoneO")
                );

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebShipXFedexInternationalPriorityDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_webSHIPX_FedexInternationalPriority_DeletesAsync with Counter: {Counter}", counter);

            await _procedures.spSync_webSHIPX_FedexInternationalPriority_DeletesAsync(counter);

            return Ok("success");
        }

        private async Task<IActionResult> HandleWebShipXFedexDomesticExpressSaverAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_webSHIPX_FedexDomesticExpressSaverAsync with Counter: {Counter}", counter);

            await _procedures.spSync_webSHIPX_FedExDomesticExpressSaverAsync(
                counter,
                payload.GetDouble("WeightInPounds"),
                payload.GetDecimal("Zone2"),
                payload.GetDecimal("Zone3"),
                payload.GetDecimal("Zone4"),
                payload.GetDecimal("Zone5"),
                payload.GetDecimal("Zone6"),
                payload.GetDecimal("Zone7"),
                payload.GetDecimal("Zone8")
                );

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebShipXFedexDomesticExpressSaverDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_webSHIPX_FedexDomesticExpressSaver_DeletesAsync with Counter: {Counter}", counter);

            await _procedures.spSync_webSHIPX_FedExDomesticExpressSaver_DeletesAsync(counter);

            return Ok("success");
        }

        private async Task<IActionResult> HandleWebShipXFedexDomesticStandardOvernightAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_webSHIPX_FedexDomesticStandardOvernightAsync with Counter: {Counter}", counter);

            await _procedures.spSync_webSHIPX_FedExDomesticStandardOvernightAsync(
                counter,
                payload.GetDouble("WeightInPounds"),
                payload.GetDecimal("Zone2"),
                payload.GetDecimal("Zone3"),
                payload.GetDecimal("Zone4"),
                payload.GetDecimal("Zone5"),
                payload.GetDecimal("Zone6"),
                payload.GetDecimal("Zone7"),
                payload.GetDecimal("Zone8")
                );

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebShipXFedexDomesticStandardOvernightDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_webSHIPX_FedexDomesticStandardOvernight_DeletesAsync with Counter: {Counter}", counter);

            await _procedures.spSync_webSHIPX_FedExDomesticStandardOvernight_DeletesAsync(counter);

            return Ok("success");
        }

        private async Task<IActionResult> HandleWebShipXInventoryItemFeatureIndexAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("Counter");

            _logger.LogDebug("Executing spSync_InventoryItemFeatureIndexAsync with Counter: {Counter}", counter);

            await _procedures.spSync_InventoryItemFeatureIndexAsync(
                counter,
                payload.GetInt("InventoryItemFeatureID"),
                payload.GetString("DescriptionForInternalUse"),
                payload.GetString("FormatText"),
                payload.GetString("FormatForInternalUse"),
                payload.GetString("ItemFeatureWebGalleryText"),
                payload.GetInt("ItemFeatureWebGalleryTextDisplaySequence"),
                payload.GetString("ItemFeatureHoverOverText"),
                payload.GetString("ItemFeatureWebProductDetailsPageText"),
                payload.GetInt("ItemFeatureWebProductDetailsPageTextDisplaySequence"),
                payload.GetString("ItemFeatureWebProductDetailsPageHyperlinkText"),
                payload.GetString("ItemFeaturesOrderAndInvoicePagesText"),
                payload.GetInt("ItemFeaturesOrderAndInvoicePagesTextDisplaySequence"),
                payload.GetString("ItemFeatureExcelFileText"),
                payload.GetInt("ItemFeatureExcelFileTextDisplaySequence"),
                payload.GetInt("EBrecordsInventoryItemFeatureID"),
                payload.GetString("Hint")
                );

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebShipXInventoryItemFeatureIndexDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_InventoryItemFeatureIndex_DeletesAsync with Counter: {Counter}", counter);

            await _procedures.spSync_InventoryItemFeatureIndex_DeletesAsync(counter);

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebShipXInventoryItemFeaturesAsync(string rawData, CancellationToken cancellationToken = default)
        {
            // 1. Array containers for up to 30 batches (0 through 29)
            int?[] ids = new int?[30];
            int?[] featureIds = new int?[30];
            int?[] itemIds = new int?[30];

            // Track counters processed for legacy return string formatting
            List<string> processedCounters = new List<string>();

            if (!string.IsNullOrWhiteSpace(rawData))
            {
                // 2. Split batch groups by "||"
                string[] dataGroups = rawData.Split(new[] { "||" }, StringSplitOptions.None);
                int maxGroups = Math.Min(dataGroups.Length, 30);

                for (int i = 0; i < maxGroups; i++)
                {
                    string strCounter = "0";
                    string strInventoryItemFeatureID = "0";
                    string strItemID = "0";

                    // 3. Split individual key-value fields by "xzsaq88aqdrt"
                    string[] items = dataGroups[i].Split(new[] { "xzsaq88aqdrt" }, StringSplitOptions.None);

                    foreach (string item in items)
                    {
                        if (item.StartsWith("ID-", StringComparison.OrdinalIgnoreCase))
                        {
                            strCounter = item.Substring(3);
                        }
                        else if (item.StartsWith("InventoryItemFeatureID-", StringComparison.OrdinalIgnoreCase))
                        {
                            strInventoryItemFeatureID = item.Substring(23);
                        }
                        else if (item.StartsWith("ItemID-", StringComparison.OrdinalIgnoreCase))
                        {
                            strItemID = item.Substring(7);
                        }
                    }

                    // Record counter for legacy response output
                    processedCounters.Add(strCounter);

                    // Parse int values or default to 0 to mimic VB.NET behavior
                    ids[i] = int.TryParse(strCounter, out int parsedId) ? parsedId : 0;
                    featureIds[i] = int.TryParse(strInventoryItemFeatureID, out int parsedFeatId) ? parsedFeatId : 0;
                    itemIds[i] = int.TryParse(strItemID, out int parsedItemId) ? parsedItemId : 0;
                }

                // Fill remaining empty slots up to 29 with 0 (matches VB.NET legacy fallback)
                for (int i = maxGroups; i < 30; i++)
                {
                    ids[i] = 0;
                    featureIds[i] = 0;
                    itemIds[i] = 0;
                }
            }
            else
            {
                // Pad all 30 elements with 0 if payload is empty
                for (int i = 0; i < 30; i++)
                {
                    ids[i] = 0;
                    featureIds[i] = 0;
                    itemIds[i] = 0;
                }
            }

            _logger.LogDebug("Executing spSync_InventoryItemFeaturesAsync with {Count} batched records.", processedCounters.Count);

            // 4. Call Stored Procedure
            List<spSync_InventoryItemFeaturesResult> results = await _procedures.spSync_InventoryItemFeaturesAsync(
                ids[0], featureIds[0], itemIds[0],
                ids[1], featureIds[1], itemIds[1],
                ids[2], featureIds[2], itemIds[2],
                ids[3], featureIds[3], itemIds[3],
                ids[4], featureIds[4], itemIds[4],
                ids[5], featureIds[5], itemIds[5],
                ids[6], featureIds[6], itemIds[6],
                ids[7], featureIds[7], itemIds[7],
                ids[8], featureIds[8], itemIds[8],
                ids[9], featureIds[9], itemIds[9],
                ids[10], featureIds[10], itemIds[10],
                ids[11], featureIds[11], itemIds[11],
                ids[12], featureIds[12], itemIds[12],
                ids[13], featureIds[13], itemIds[13],
                ids[14], featureIds[14], itemIds[14],
                ids[15], featureIds[15], itemIds[15],
                ids[16], featureIds[16], itemIds[16],
                ids[17], featureIds[17], itemIds[17],
                ids[18], featureIds[18], itemIds[18],
                ids[19], featureIds[19], itemIds[19],
                ids[20], featureIds[20], itemIds[20],
                ids[21], featureIds[21], itemIds[21],
                ids[22], featureIds[22], itemIds[22],
                ids[23], featureIds[23], itemIds[23],
                ids[24], featureIds[24], itemIds[24],
                ids[25], featureIds[25], itemIds[25],
                ids[26], featureIds[26], itemIds[26],
                ids[27], featureIds[27], itemIds[27],
                ids[28], featureIds[28], itemIds[28],
                ids[29], featureIds[29], itemIds[29],
                cancellationToken: cancellationToken
            );

            // 5. Verify SQL execution results
            var firstResult = results?.FirstOrDefault();
            if (firstResult == null)
            {
                return Ok("no rows affected");
            }

            if (string.Equals(firstResult.ReturnValue, "success", StringComparison.OrdinalIgnoreCase))
            {
                // Replicate legacy response format: "success 123+124+125"
                string successResponse = "success " + string.Join("+", processedCounters);
                return Ok(successResponse);
            }

            // TODO: Investigate the VB.net handling response when ReturnValue is not "success". For now, return the raw ReturnValue.
            return Ok(firstResult.ReturnValue);
        }

        private async Task<IActionResult> HandleWebShipXInventoryItemFeaturesDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_InventoryItemFeatures_DeletesAsync with Counter: {Counter}", counter);

            await _procedures.spSync_InventoryItemFeatures_DeletesAsync(counter);

            return Ok("success");
        }

        private async Task<IActionResult> HandleWebShipXSoldItemsAsync(string rawData, CancellationToken cancellationToken = default)
        {
            // Arrays to hold up to 30 batched items (0 through 29)
            int?[] ids = new int?[30];
            DateTime?[] invoiceDates = new DateTime?[30];
            int?[] itemIds = new int?[30];
            short?[] quantities = new short?[30];
            string[] salesChannels = new string[30];
            string[] kirbyItems = new string[30];
            decimal?[] kirbysCuts = new decimal?[30];
            int?[] supplierIds = new int?[30];
            decimal?[] costs = new decimal?[30];
            short?[] falseSales = new short?[30];
            decimal?[] kirbyCosts = new decimal?[30];

            List<string> processedCounters = new List<string>();

            if (!string.IsNullOrWhiteSpace(rawData))
            {
                // Split batch groups by "||"
                string[] dataGroups = rawData.Split(new[] { "||" }, StringSplitOptions.None);
                int maxGroups = Math.Min(dataGroups.Length, 30);

                for (int i = 0; i < maxGroups; i++)
                {
                    string strCounter = "0";
                    string strInvoiceDate = "1/1/2090";
                    string strQuantity = "0";
                    string strItemID = "0";
                    string strSalesChannel = "-";
                    string strKirbyItem = "-";
                    string strKirbysCut = "0";
                    string strSupplierID = "0";
                    string strCost = "0";
                    string strFalseSale = "0";
                    string strKirbyCost = "0";

                    // Split individual key-value fields by "xzsaq88aqdrt"
                    string[] items = dataGroups[i].Split(new[] { "xzsaq88aqdrt" }, StringSplitOptions.None);

                    foreach (string item in items)
                    {
                        if (item.StartsWith("ID-", StringComparison.OrdinalIgnoreCase))
                        {
                            strCounter = item.Substring(3);
                        }
                        else if (item.StartsWith("InvoiceDate-", StringComparison.OrdinalIgnoreCase))
                        {
                            strInvoiceDate = item.Substring(12);
                        }
                        else if (item.StartsWith("Quantity-", StringComparison.OrdinalIgnoreCase))
                        {
                            strQuantity = item.Substring(9);
                        }
                        else if (item.StartsWith("ItemID-", StringComparison.OrdinalIgnoreCase))
                        {
                            strItemID = item.Substring(7);
                        }
                        else if (item.StartsWith("SalesChannel-", StringComparison.OrdinalIgnoreCase))
                        {
                            strSalesChannel = item.Substring(13);
                        }
                        else if (item.StartsWith("KirbyItem-", StringComparison.OrdinalIgnoreCase))
                        {
                            strKirbyItem = item.Substring(10);
                        }
                        else if (item.StartsWith("KirbysCut-", StringComparison.OrdinalIgnoreCase))
                        {
                            strKirbysCut = item.Substring(10);
                        }
                        else if (item.StartsWith("SupplierID-", StringComparison.OrdinalIgnoreCase))
                        {
                            strSupplierID = item.Substring(11);
                        }
                        else if (item.StartsWith("Cost-", StringComparison.OrdinalIgnoreCase))
                        {
                            strCost = item.Substring(5);
                        }
                        else if (item.StartsWith("FalseSale-", StringComparison.OrdinalIgnoreCase))
                        {
                            strFalseSale = item.Substring(10);
                        }
                        else if (item.StartsWith("KirbyCost-", StringComparison.OrdinalIgnoreCase))
                        {
                            strKirbyCost = item.Substring(10);
                        }
                    }

                    processedCounters.Add(strCounter);

                    // Parse values with legacy defaults
                    ids[i] = int.TryParse(strCounter, out int parsedId) ? parsedId : 0;
                    invoiceDates[i] = DateTime.TryParse(strInvoiceDate, out DateTime parsedDate) ? parsedDate : new DateTime(2090, 1, 1);
                    quantities[i] = short.TryParse(strQuantity, out short parsedQty) ? parsedQty : (short)0;
                    itemIds[i] = int.TryParse(strItemID, out int parsedItemId) ? parsedItemId : 0;
                    salesChannels[i] = string.IsNullOrEmpty(strSalesChannel) ? "-" : strSalesChannel;
                    kirbyItems[i] = string.IsNullOrEmpty(strKirbyItem) ? "-" : strKirbyItem;
                    kirbysCuts[i] = decimal.TryParse(strKirbysCut, out decimal parsedCut) ? parsedCut : 0m;
                    supplierIds[i] = int.TryParse(strSupplierID, out int parsedSuppId) ? parsedSuppId : 0;
                    costs[i] = decimal.TryParse(strCost, out decimal parsedCost) ? parsedCost : 0m;
                    falseSales[i] = short.TryParse(strFalseSale, out short parsedFalseSale) ? parsedFalseSale : (short)0;
                    kirbyCosts[i] = decimal.TryParse(strKirbyCost, out decimal parsedKirbyCost) ? parsedKirbyCost : 0m;
                }

                // Fill remaining slots up to index 29 with legacy defaults
                for (int i = maxGroups; i < 30; i++)
                {
                    ids[i] = 0;
                    invoiceDates[i] = new DateTime(2090, 1, 1);
                    quantities[i] = (short)0;
                    itemIds[i] = 0;
                    salesChannels[i] = "-";
                    kirbyItems[i] = "-";
                    kirbysCuts[i] = 0m;
                    supplierIds[i] = 0;
                    costs[i] = 0m;
                    falseSales[i] = (short)0;
                    kirbyCosts[i] = 0m;
                }
            }
            else
            {
                // Default all 30 elements if payload is empty
                for (int i = 0; i < 30; i++)
                {
                    ids[i] = 0;
                    invoiceDates[i] = new DateTime(2090, 1, 1);
                    quantities[i] = (short)0;
                    itemIds[i] = 0;
                    salesChannels[i] = "-";
                    kirbyItems[i] = "-";
                    kirbysCuts[i] = 0m;
                    supplierIds[i] = 0;
                    costs[i] = 0m;
                    falseSales[i] = (short)0;
                    kirbyCosts[i] = 0m;
                }
            }

            _logger.LogDebug("Executing spSync_SoldItemsAsync with {Count} batched records.", processedCounters.Count);

            var results = await _procedures.spSync_SoldItemsAsync(
                ids[0], invoiceDates[0], itemIds[0], quantities[0], salesChannels[0], kirbyItems[0], kirbysCuts[0], supplierIds[0], costs[0], falseSales[0], kirbyCosts[0],
                ids[1], invoiceDates[1], itemIds[1], quantities[1], salesChannels[1], kirbyItems[1], kirbysCuts[1], supplierIds[1], costs[1], falseSales[1], kirbyCosts[1],
                ids[2], invoiceDates[2], itemIds[2], quantities[2], salesChannels[2], kirbyItems[2], kirbysCuts[2], supplierIds[2], costs[2], falseSales[2], kirbyCosts[2],
                ids[3], invoiceDates[3], itemIds[3], quantities[3], salesChannels[3], kirbyItems[3], kirbysCuts[3], supplierIds[3], costs[3], falseSales[3], kirbyCosts[3],
                ids[4], invoiceDates[4], itemIds[4], quantities[4], salesChannels[4], kirbyItems[4], kirbysCuts[4], supplierIds[4], costs[4], falseSales[4], kirbyCosts[4],
                ids[5], invoiceDates[5], itemIds[5], quantities[5], salesChannels[5], kirbyItems[5], kirbysCuts[5], supplierIds[5], costs[5], falseSales[5], kirbyCosts[5],
                ids[6], invoiceDates[6], itemIds[6], quantities[6], salesChannels[6], kirbyItems[6], kirbysCuts[6], supplierIds[6], costs[6], falseSales[6], kirbyCosts[6],
                ids[7], invoiceDates[7], itemIds[7], quantities[7], salesChannels[7], kirbyItems[7], kirbysCuts[7], supplierIds[7], costs[7], falseSales[7], kirbyCosts[7],
                ids[8], invoiceDates[8], itemIds[8], quantities[8], salesChannels[8], kirbyItems[8], kirbysCuts[8], supplierIds[8], costs[8], falseSales[8], kirbyCosts[8],
                ids[9], invoiceDates[9], itemIds[9], quantities[9], salesChannels[9], kirbyItems[9], kirbysCuts[9], supplierIds[9], costs[9], falseSales[9], kirbyCosts[9],
                ids[10], invoiceDates[10], itemIds[10], quantities[10], salesChannels[10], kirbyItems[10], kirbysCuts[10], supplierIds[10], costs[10], falseSales[10], kirbyCosts[10],
                ids[11], invoiceDates[11], itemIds[11], quantities[11], salesChannels[11], kirbyItems[11], kirbysCuts[11], supplierIds[11], costs[11], falseSales[11], kirbyCosts[11],
                ids[12], invoiceDates[12], itemIds[12], quantities[12], salesChannels[12], kirbyItems[12], kirbysCuts[12], supplierIds[12], costs[12], falseSales[12], kirbyCosts[12],
                ids[13], invoiceDates[13], itemIds[13], quantities[13], salesChannels[13], kirbyItems[13], kirbysCuts[13], supplierIds[13], costs[13], falseSales[13], kirbyCosts[13],
                ids[14], invoiceDates[14], itemIds[14], quantities[14], salesChannels[14], kirbyItems[14], kirbysCuts[14], supplierIds[14], costs[14], falseSales[14], kirbyCosts[14],
                ids[15], invoiceDates[15], itemIds[15], quantities[15], salesChannels[15], kirbyItems[15], kirbysCuts[15], supplierIds[15], costs[15], falseSales[15], kirbyCosts[15],
                ids[16], invoiceDates[16], itemIds[16], quantities[16], salesChannels[16], kirbyItems[16], kirbysCuts[16], supplierIds[16], costs[16], falseSales[16], kirbyCosts[16],
                ids[17], invoiceDates[17], itemIds[17], quantities[17], salesChannels[17], kirbyItems[17], kirbysCuts[17], supplierIds[17], costs[17], falseSales[17], kirbyCosts[17],
                ids[18], invoiceDates[18], itemIds[18], quantities[18], salesChannels[18], kirbyItems[18], kirbysCuts[18], supplierIds[18], costs[18], falseSales[18], kirbyCosts[18],
                ids[19], invoiceDates[19], itemIds[19], quantities[19], salesChannels[19], kirbyItems[19], kirbysCuts[19], supplierIds[19], costs[19], falseSales[19], kirbyCosts[19],
                ids[20], invoiceDates[20], itemIds[20], quantities[20], salesChannels[20], kirbyItems[20], kirbysCuts[20], supplierIds[20], costs[20], falseSales[20], kirbyCosts[20],
                ids[21], invoiceDates[21], itemIds[21], quantities[21], salesChannels[21], kirbyItems[21], kirbysCuts[21], supplierIds[21], costs[21], falseSales[21], kirbyCosts[21],
                ids[22], invoiceDates[22], itemIds[22], quantities[22], salesChannels[22], kirbyItems[22], kirbysCuts[22], supplierIds[22], costs[22], falseSales[22], kirbyCosts[22],
                ids[23], invoiceDates[23], itemIds[23], quantities[23], salesChannels[23], kirbyItems[23], kirbysCuts[23], supplierIds[23], costs[23], falseSales[23], kirbyCosts[23],
                ids[24], invoiceDates[24], itemIds[24], quantities[24], salesChannels[24], kirbyItems[24], kirbysCuts[24], supplierIds[24], costs[24], falseSales[24], kirbyCosts[24],
                ids[25], invoiceDates[25], itemIds[25], quantities[25], salesChannels[25], kirbyItems[25], kirbysCuts[25], supplierIds[25], costs[25], falseSales[25], kirbyCosts[25],
                ids[26], invoiceDates[26], itemIds[26], quantities[26], salesChannels[26], kirbyItems[26], kirbysCuts[26], supplierIds[26], costs[26], falseSales[26], kirbyCosts[26],
                ids[27], invoiceDates[27], itemIds[27], quantities[27], salesChannels[27], kirbyItems[27], kirbysCuts[27], supplierIds[27], costs[27], falseSales[27], kirbyCosts[27],
                ids[28], invoiceDates[28], itemIds[28], quantities[28], salesChannels[28], kirbyItems[28], kirbysCuts[28], supplierIds[28], costs[28], falseSales[28], kirbyCosts[28],
                ids[29], invoiceDates[29], itemIds[29], quantities[29], salesChannels[29], kirbyItems[29], kirbysCuts[29], supplierIds[29], costs[29], falseSales[29], kirbyCosts[29],
                cancellationToken: cancellationToken
            );

            var firstResult = results?.FirstOrDefault();
            if (firstResult == null)
            {
                return Ok("no rows affected");
            }

            if (string.Equals(firstResult.ReturnValue, "success", StringComparison.OrdinalIgnoreCase))
            {
                string successResponse = "success " + string.Join("+", processedCounters);
                return Ok(successResponse);
            }

            return Ok(firstResult.ReturnValue);
        }
        private async Task<IActionResult> HandleWebShipXSoldItemsDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_SoldItems_DeletesAsync with Counter: {Counter}", counter);

            await _procedures.spSync_SoldItems_DeletesAsync(counter);

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebShipXInvoicesUploadAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");
            string? webOrderNumbers = payload.GetString("WebOrderNumbers");
            int? invoiceNumber = payload.GetInt("InvoiceNumber");

            _logger.LogDebug("Executing spSync_InvoicesUploadAsync with Counter: {Counter}", counter);

            // 1. Sync InvoicesUpload record
            await _procedures.spSync_InvoicesUploadAsync(
                counter,
                custID: payload.GetInt("CustID"),
                invoiceDate: payload.GetDateTime("InvoiceDate"),
                invoiceNumber: invoiceNumber,
                shipDate: payload.GetDateTime("ShipDate"),
                trackingNumber: payload.GetString("TrackingNumber"),
                shippingCompany: payload.GetString("ShippingCompany"),
                shippingServiceName: payload.GetString("ShippingServiceName"),
                invoiceTotal: payload.GetDecimal("InvoiceTotal"),
                webOrderNumbers: webOrderNumbers,
                customerServerCounter: payload.GetInt("CustomerServerCounter"),
                pDFFileName: payload.GetString("PDFFileName"));

            // 2. Update InvoiceNumber field in Orders table (Legacy Logic Port)
            if (!string.IsNullOrEmpty(webOrderNumbers))
            {
                if (!webOrderNumbers.Contains(';'))
                {
                    await _procedures.spUpdateInvoiceNumberFieldAsync(webOrderNumbers, invoiceNumber);
                }
                else
                {
                    string strWebOrderNumber = string.Empty;
                    string strWebOrderNumberRemaining = webOrderNumbers;

                    while (true)
                    {
                        if (strWebOrderNumberRemaining.StartsWith(";"))
                        {
                            strWebOrderNumberRemaining = strWebOrderNumberRemaining.Substring(1);
                        }

                        int intSemi = strWebOrderNumberRemaining.IndexOf(';');

                        if (intSemi == -1)
                        {
                            await _procedures.spUpdateInvoiceNumberFieldAsync(strWebOrderNumberRemaining.Trim(), invoiceNumber);
                            break;
                        }

                        if (strWebOrderNumberRemaining.Length < 5)
                        {
                            break;
                        }

                        string strWebOrderNumberToLookUp = strWebOrderNumberRemaining.Substring(0, intSemi).Trim();
                        strWebOrderNumber = strWebOrderNumber + strWebOrderNumberToLookUp + "<br/>";
                        strWebOrderNumberRemaining = strWebOrderNumberRemaining.Substring(intSemi + 1).Trim();

                        await _procedures.spUpdateInvoiceNumberFieldAsync(strWebOrderNumber, invoiceNumber);
                    }
                }
            }

            return Ok("success");
        }
        private async Task<IActionResult> HandleWebShipXInvoicesUploadDeletesAsync(Dictionary<string, string> payload)
        {
            int? counter = payload.GetInt("counter");

            _logger.LogDebug("Executing spSync_InvoicesUpload_DeletesAsync with Counter: {Counter}", counter);

            await _procedures.spSync_InvoicesUpload_DeletesAsync(counter);

            return Ok("success");
        }
        [HttpGet]
        [HttpPost]
        public async Task<IActionResult> Index()
        {
            string clientIp = HttpContext.Connection.RemoteIpAddress?.ToString() ?? "Unknown";
            string? GetParam(string key)
            {
                if (Request.Query.TryGetValue(key, out var queryValue))
                    return queryValue.ToString();

                if (Request.HasFormContentType && Request.Form.TryGetValue(key, out var formValue))
                    return formValue.ToString();

                return null;
            }
            // 1. Extract values safely from Query or Form
            string? pw = GetParam("PW");
            string? table = GetParam("Table");
            string dataParam = GetParam("DATAq3298rueqcnu3498r") ?? string.Empty;

            //string? pw = Request.Query.ContainsKey("PW") ? Request.Query["PW"].ToString() : Request.Form["PW"].ToString();
            //string? table = Request.Query.ContainsKey("Table") ? Request.Query["Table"].ToString() : Request.Form["Table"].ToString();

            //string dataParam = Request.Query["DATAq3298rueqcnu3498r"].FirstOrDefault()
            //               ?? Request.Form["DATAq3298rueqcnu3498r"].FirstOrDefault()
            //               ?? string.Empty;

            // 2. Authentication check with logging
            if (!CryptographicOperations.FixedTimeEquals(
                    Encoding.UTF8.GetBytes(pw ?? string.Empty),
                    Encoding.UTF8.GetBytes(_uploadDataPassword)))
            {
                _logger.LogWarning("Unauthorized sync attempt from IP {IPAddress}. Invalid credentials supplied.", clientIp);
                return Unauthorized("Invalid Credentials; IP Address Recorded");
            }

            if (string.IsNullOrWhiteSpace(table))
            {
                _logger.LogWarning("Sync request failed from IP {IPAddress}: Missing 'table' parameter.", clientIp);
                return BadRequest("Table parameter is required.");
            }

            _logger.LogInformation("Processing sync request for Table: {TableName} from IP: {IPAddress}", table, clientIp);

            // 3. Parse custom payload into a searchable dictionary
            Dictionary<string, string> payload = PayloadParser.ParsePayload(dataParam);

            try
            {
                // 4. Dispatch using pattern matching
                var result = table switch
                {
                    "EmailFooter" => await HandleEmailFooterAsync(payload),
                    "EmailFooter_Deletes" => await HandleEmailFooterDeletesAsync(payload),
                    "IsINTERNETREGGAEMaintenanceOpen" => await HandleMaintenanceOpenAsync(dataParam),
                    "BackordersInStockNow" => await HandleBackordersInStockAsync(payload),
                    "BackordersInStockNow_Deletes" => await HandleBackordersDeletesAsync(payload),
                    "TermsOfSaleTypes" => await HandleTermsOfSaleTypesAsync(payload),
                    "TermsOfSaleTypes_Deletes" => await HandleTermsOfSaleTypesDeletesAsync(payload),
                    "WebHowFoundUs" => await HandleWebHowFoundUsAsync(payload),
                    "WebHowFoundUs_Deletes" => await HandleWebHowFoundUsDeletesAsync(payload),
                    "Residential" => await HandleResidentialAsync(payload),
                    "WebCountryShippingZonesT" => await HandleWebCountryShippingZonesAsync(payload),
                    "WebCountryShippingZonesT_Deletes" => await HandleWebCountryShippingZonesDeletesAsync(payload),
                    "WebCountryStateProvincesList" => await HandleWebCountryStateProvincesListAsync(payload),
                    "WebCountryStateProvincesList_Deletes" => await HandleWebCountryStateProvincesListDeletesAsync(payload),
                    "Inventory" => await HandleInventoryAsync(payload),
                    "Inventory_Deletes" => await HandleInventoryDeletesAsync(payload),
                    "WebSHIPX_AirParcelPost" => await HandleWebShipXAirParcelPostAsync(payload),
                    "WebSHIPX_AirParcelPost_Deletes" => await HandleWebShipXAirParcelPostDeletesAsync(payload),
                    "WebSHIPX_AirSmallPacket" => await HandleWebShipXAirSmallPacketAsync(payload),
                    "WebSHIPX_AirSmallPacket_Deletes" => await HandleWebShipXAirSmallPacketDeletesAsync(payload),
                    "WebSHIPX_DefaultShippingChargesExportPrice" => await HandleWebShipXDefaultShippingChargesExportPriceAsync(payload),
                    "WebSHIPX_DefaultShippingChargesExportPrice_Deletes" => await HandleWebShipXDefaultShippingChargesExportPriceDeletesAsync(payload),
                    "WebSHIPX_DefaultShippingChargesRetailPrice" => await HandleWebShipXDefaultShippingChargesRetailPriceAsync(payload),
                    "WebSHIPX_DefaultShippingChargesRetailPrice_Deletes" => await HandleWebShipXDefaultShippingChargesRetailPriceDeletesAsync(payload),
                    "WebSHIPX_DefaultShippingChargesStorePrice" => await HandleWebShipXDefaultShippingChargesStorePriceAsync(payload),
                    "WebSHIPX_DefaultShippingChargesStorePrice_Deletes" => await HandleWebShipXDefaultShippingChargesStorePriceDeletesAsync(payload),
                    "WebSHIPX_FirstClass" => await HandleWebShipXFirstClassAsync(payload),
                    "WebSHIPX_FirstClass_Deletes" => await HandleWebShipXFirstClassDeletesAsync(payload),
                    "WebSHIPX_MediaMail" => await HandleWebShipXMediaMailAsync(payload),
                    "WebSHIPX_MediaMail_Deletes" => await HandleWebShipXMediaMailDeletesAsync(payload),
                    "WebSHIPX_PriorityMail" => await HandleWebShipXPriorityMailAsync(payload),
                    "WebSHIPX_PriorityMail_Deletes" => await HandleWebShipXPriorityMailDeletesAsync(payload),
                    "WebSHIPX_ShippingHolidaysOutbound" => await HandleWebShipXShippingHolidaysOutboundAsync(payload),
                    "WebSHIPX_ShippingHolidaysOutbound_Deletes" => await HandleWebShipXShippingHolidaysOutboundDeletesAsync(payload),
                    "WebSHIPX_ShippingMethods" => await HandleWebShipXShippingMethodsAsync(payload),
                    "WebSHIPX_ShippingMethods_Deletes" => await HandleWebShipXShippingMethodsDeletesAsync(payload),
                    "CountryList" => await HandleCountryListAsync(payload),
                    "CountryList_Deletes" => await HandleCountryListDeletesAsync(payload),
                    "WebSHIPX_Packaging_Weight_1" => await HandleWebShipXPackagingWeight1Async(payload),
                    "WebSHIPX_Packaging_Weight_1_Deletes" => await HandleWebShipXPackagingWeight1DeletesAsync(payload),
                    "WebSHIPX_Packaging_Weight_2" => await HandleWebShipXPackagingWeight2Async(payload),
                    "WebSHIPX_Packaging_Weight_2_Deletes" => await HandleWebShipXPackagingWeight2DeletesAsync(payload),
                    "WebSHIPX_FedexGround" => await HandleWebShipXFedexGroundAsync(payload),
                    "WebSHIPX_FedexGround_Deletes" => await HandleWebShipXFedexGroundDeletesAsync(payload),
                    "WebSHIPX_FedexDomestic2Day" => await HandleWebShipXFedexDomestic2DayAsync(payload),
                    "WebSHIPX_FedexDomestic2Day_Deletes" => await HandleWebShipXFedexDomestic2DayDeletesAsync(payload),
                    //"WebSHIPX_FedexDomestic2Day" => await HandleWebShipXShippingHolidaysOutboundAsync(payload),
                    //"WebSHIPX_FedexDomestic2Day_Deletes" => await HandleWebShipXShippingHolidaysOutboundAsync(payload),
                    "WebSHIPX_FedexInternationalEconomy" => await HandleWebShipXFedexInternationalEconomyAsync(payload),
                    "WebSHIPX_FedexInternationalEconomy_Deletes" => await HandleWebShipXFedexInternationalEconomyDeletesAsync(payload),
                    "WebSHIPX_FedexInternationalPriority" => await HandleWebShipXFedexInternationalPriorityAsync(payload),
                    "WebSHIPX_FedexInternationalPriority_Deletes" => await HandleWebShipXFedexInternationalPriorityDeletesAsync(payload),
                    "WebSHIPX_FedexDomesticExpressSaver" => await HandleWebShipXFedexDomesticExpressSaverAsync(payload),
                    "WebSHIPX_FedexDomesticExpressSaver_Deletes" => await HandleWebShipXFedexDomesticExpressSaverDeletesAsync(payload),
                    "WebSHIPX_FedexDomesticStandardOvernight" => await HandleWebShipXFedexDomesticStandardOvernightAsync(payload),
                    "WebSHIPX_FedexDomesticStandardOvernight_Deletes" => await HandleWebShipXFedexDomesticStandardOvernightDeletesAsync(payload),
                    "InventoryItemFeatureIndex" => await HandleWebShipXInventoryItemFeatureIndexAsync(payload),
                    "InventoryItemFeatureIndex_Deletes" => await HandleWebShipXInventoryItemFeatureIndexDeletesAsync(payload),
                    "InventoryItemFeatures" => await HandleWebShipXInventoryItemFeaturesAsync(dataParam),
                    "InventoryItemFeatures_Deletes" => await HandleWebShipXInventoryItemFeaturesDeletesAsync(payload),
                    "SoldItems" => await HandleWebShipXSoldItemsAsync(dataParam),
                    "SoldItems_Deletes" => await HandleWebShipXSoldItemsDeletesAsync(payload),
                    "InvoicesUpload" => await HandleWebShipXInvoicesUploadAsync(payload),
                    "InvoicesUpload_Deletes" => await HandleWebShipXInvoicesUploadDeletesAsync(payload),
                    _ => null
                };

                if (result == null)
                {
                    _logger.LogWarning("Unsupported table sync target requested: {TableName} from IP: {IPAddress}", table, clientIp);
                    return BadRequest($"Unsupported table sync target: {table}");
                }

                _logger.LogInformation("Successfully processed sync for Table: {TableName}", table);
                return result;
            }
            catch (Exception ex)
            {
                // Build a sanitized parameter object for context
                var debugContext = new
                {
                    Table = table,
                    IPAddress = clientIp,
                    // Log parameters safely by excluding sensitive keys like "PW"
                    ParsedPayload = payload
                        .Where(kvp => !kvp.Key.Equals("PW", StringComparison.OrdinalIgnoreCase))
                        .ToDictionary(kvp => kvp.Key, kvp => kvp.Value)
                };

                // Log the structured context alongside the exception
                _logger.LogError(ex, "Error executing sync for Table: {TableName}. Context: {@DebugContext}", table, debugContext);

                return StatusCode(500, "An error occurred while processing your request.");
            }
        }
    }

    public static class PayloadParser
    {
        public static Dictionary<string, string> ParsePayload(string segment)
        {
            var result = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);

            if (string.IsNullOrWhiteSpace(segment))
                return result;

            // 1. Split on legacy delimiter first
            string[] parts = segment.Split(new[] { "xzsaq88aqdrt" }, StringSplitOptions.RemoveEmptyEntries);

            foreach (string part in parts)
            {
                int separatorIndex = part.IndexOf('-');

                if (separatorIndex >= 0)
                {
                    string key = part[..separatorIndex];
                    string value = (separatorIndex + 1 < part.Length)
                        ? part[(separatorIndex + 1)..]
                        : string.Empty;

                    result[key] = value;
                }
                else
                {
                    result[part] = string.Empty;
                }
            }

            return result;
        }

        public static int? GetInt(this Dictionary<string, string> data, string key)
            => data.TryGetValue(key, out var val) && int.TryParse(val, out var result) ? result : null;

        public static decimal? GetDecimal(this Dictionary<string, string> data, string key)
            => data.TryGetValue(key, out var val) && decimal.TryParse(val, out var result) ? result : null;

        public static double? GetDouble(this Dictionary<string, string> data, string key)
            => data.TryGetValue(key, out var val) && double.TryParse(val, out var result) ? result : null;

        public static DateTime? GetDateTime(this Dictionary<string, string> data, string key)
            => data.TryGetValue(key, out var val) && DateTime.TryParse(val, out var result) ? result : null;

        public static string? GetString(this Dictionary<string, string> data, string key)
            => data.TryGetValue(key, out var val) ? val : null;
    }
}