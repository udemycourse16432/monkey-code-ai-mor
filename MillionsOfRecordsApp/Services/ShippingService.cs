using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Extensions;
using MillionsOfRecordsApp.Models;
using MillionsOfRecordsApp.Models.DTOs;
using MillionsOfRecordsApp.Models.Shared;
using System.Data;

namespace MillionsOfRecordsApp.Services
{

    public class ShippingService
    {
        private readonly IReggaeDbContextProcedures _procedures;
        private readonly HttpContext _httpContext;
        private readonly ReggaeDbContext _context;

        public ShippingService(IReggaeDbContextProcedures procedures, IHttpContextAccessor httpContextAccessor, ReggaeDbContext context)
        {
            _procedures = procedures;
            _httpContext = httpContextAccessor.HttpContext!;
            _context = context;
        }
        private async Task<(int varNumberOfBoxes, decimal varWeightOfEachBox, int varWeightInOunces)> Z_SHIPX_CalculateBoxesAndWeightsAsync(string defaultCountry, int varNumberOfBoxes, decimal varWeightOfEachBox, int varWeightInOunces, string shippingMethod, int varWeightOfProductInGrams, List<spGetShippingMethodsRowResult> shippingMethodsRowResults, int? overrideNumberOfBoxes = null)
        {
            varNumberOfBoxes = overrideNumberOfBoxes.HasValue ? overrideNumberOfBoxes.Value : (await Z_SHIPX_FigureNumberOfBoxesAsync(defaultCountry, NameOfCart, shippingMethod, (int)varWeight, varWeightOfProductInGrams, shippingMethodsRowResults));
            varWeightOfEachBox = (int)Math.Floor((varWeight / varNumberOfBoxes) + 0.9999m);
            if (varWeightOfEachBox < 1) varWeightOfEachBox = 1;
            varWeightInOunces = (int)Math.Floor(((varWeight * 16) / varNumberOfBoxes) + 0.9999m);
            if (varWeightInOunces < 1) varWeightInOunces = 1;
            return (varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces);
        }
        public async Task<List<ShippingMethodDto>> CalculateShippingOptionsAsync(spGetCustomerDetailsByServerCounterResult details, decimal CartTotal, int totalCartItems, int varWeightOfProductInGrams)
        {
            var options = new List<ShippingMethodDto>();

            int varAllowOtherFedexShippingMethods = 0;
            string varAllowFedExInternationalPriorityForRetail = "";

            var varCustomerIDForPurchase = details.CustomerID;
            var defaultCountry = details.Country;
            var defaultPostalCode = details.PostalCode;
            var defaultStateProvince = details.StateProvince;

            string varPriceGroup = _httpContext.Session.GetPriceGroupWithFallback();
            string varCountryForCustomer = "";
            string varZip3;
            if (defaultPostalCode.Length < 3)
            {
                varZip3 = "";
            }
            else
            {
                varZip3 = defaultPostalCode.Substring(0, 3);
            }

            if (!string.IsNullOrWhiteSpace(varCustomerIDForPurchase) && varCustomerIDForPurchase != "NA")
            {
                varPriceGroup = details.PriceGroup;
                varCountryForCustomer = details.Country;
            }
            spGetWebCountryShippingZonesTRowResult shippingZonesTRowResult = new();
            var shippingZonesTRowResults = await GetShippingZonesCacheByCountry(details.Country);
            if (shippingZonesTRowResults.Any())
            {
                shippingZonesTRowResult = shippingZonesTRowResults.First();

                varAllowFedExInternationalPriorityForRetail = "yes";
                if (varPriceGroup == AppConstants.PriceGroups.RetailPrice)
                {
                    if (shippingZonesTRowResult.AllowFedexInternationalPriorityForRetail != null)
                    {
                        if (shippingZonesTRowResult.AllowFedexInternationalPriorityForRetail.ToUpper() == "Y")
                        {
                            varAllowFedExInternationalPriorityForRetail = "yes";
                        }
                        else
                        {
                            varAllowFedExInternationalPriorityForRetail = "no";
                        }
                    }
                }
            }


            var varUPSGroundZone = Z_SHIPX_FigureUPSGroundZone(defaultCountry, defaultPostalCode, defaultStateProvince);
            var varFedExGroundZone = Z_SHIPX_FigureFedExGroundZone(defaultCountry, defaultPostalCode, defaultStateProvince);
            var varUPSGroundCanadaZone = Z_SHIPX_FigureUPSGroundCanadaZone(defaultCountry, defaultPostalCode);
            var varPriorityMailZone = Z_SHIPX_FigurePriorityMailZone(defaultCountry, varZip3);
            var varExpressMailZone = Z_SHIPX_FigureExpressMailZone(defaultCountry, defaultStateProvince, varPriceGroup, varZip3);
            var varMediaMailZone = Z_SHIPX_FigureMediaMailZone(defaultCountry, defaultStateProvince, varPriceGroup, varZip3);
            var varAirMailLetterPostZone = await Z_SHIPX_FigureAirMailLetterPostZoneAsync(defaultCountry);
            var varAirParcelPostZone = await Z_SHIPX_FigureAirParcelPostZoneAsync(defaultCountry);
            var varGlobalExpressZone = Z_SHIPX_FigureGlobalExpressZone(defaultCountry);
            var varDHLInternationalZone = await Z_SHIPX_FigureDHLInternationalZoneAsync(defaultCountry);
            var varFedExExpressZone = Z_SHIPX_FigureFedExExpressZone(defaultCountry, defaultPostalCode, defaultStateProvince);
            var varFedExInternationalPriorityZone = await Z_SHIPX_FigureFedExInternationalPriorityZoneAsync(defaultCountry, varZip3);
            var varFedExInternationalEconomyZone = await Z_SHIPX_FigureFedExInternationalEconomyZoneAsync(defaultCountry, varZip3);
            int varNumberOfBoxes = 0;
            decimal varWeightOfEachBox = 0m;



            await SetWeightOfProductInGramsAsync();
            varWeight = varWeightOfProductInGrams;
            await ApplyPackageWeightAsync();
            await SetResidentialDeliveryAsync();


            decimal varCarrierRate = 0m;
            string varFESOAvailable = "";
            string varDays = "";
            string varCOD = AppConstants.NO;
            string varPossiblePOBox = Z_CheckForPOBox(details.StreetAddress1, details.StreetAddress2);
            string varPOBoxAllowed = "";
            string varCODAllowed = "";
            bool varIsAShippingMethodAvailable = false;
            List<spGetShippingMethodsRowResult> shippingMethodsRowResults;
            List<spGetWebCountryStateProvincesListRowResult> countryStateProvincesListRowResults =
                await GetWebCountryStateProvincesListCache("USA", defaultStateProvince);

            // 'First Class
            if (!string.IsNullOrWhiteSpace(varPriorityMailZone) && varPriorityMailZone != "NA")
            {
                string shippingMethod = "FC";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);

                varNumberOfBoxes = 1;
                varWeightOfEachBox = varWeight;
                varCarrierRate = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, defaultPostalCode, CartTotal, varPriorityMailZone, defaultStateProvince, defaultCountry, varWeight, 1, varWeight, varCOD, varResidentialDelivery, varPriceGroup);
                if (varCarrierRate != -1)
                {
                    varDays = await Z_SHIPX_FigureTransitDaysFirstClassAsync(countryStateProvincesListRowResults, varPriorityMailZone, defaultStateProvince);
                    (varPOBoxAllowed, varCODAllowed, varIsAShippingMethodAvailable) =
                        await Z_SHIPX_ProcessAndAddShippingOptionAsync(options, varCarrierRate, varDays, varPossiblePOBox, shippingMethodsRowResults,
                        shippingMethod, "USPS First Class");
                }
            }
            int varWeightInOunces = 0;
            // 'FedEx 2 Day
            if (!string.IsNullOrWhiteSpace(varFedExExpressZone) && varFedExExpressZone != "NA")
            {
                string shippingMethod = "FE2D";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);
                (varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces) = await Z_SHIPX_CalculateBoxesAndWeightsAsync(defaultCountry, varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces, shippingMethod, varWeightOfProductInGrams, shippingMethodsRowResults);
                varCarrierRate = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, defaultPostalCode, CartTotal, varFedExExpressZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, varWeight, varCOD, varResidentialDelivery, varPriceGroup);
                if (varCarrierRate != -1)
                {
                    varDays = Z_SHIPX_FigureTransitDaysFedEx2Day(defaultCountry, defaultPostalCode);
                    (varPOBoxAllowed, varCODAllowed, varIsAShippingMethodAvailable) =
                        await Z_SHIPX_ProcessAndAddShippingOptionAsync(options, varCarrierRate, varDays, varPossiblePOBox, shippingMethodsRowResults,
                        shippingMethod, "FedEx 2-Day Air");
                }
            }

            // 'Media Mail
            if (!string.IsNullOrWhiteSpace(varMediaMailZone) && varMediaMailZone != "NA")
            {
                string shippingMethod = "MM";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);
                (varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces) = await Z_SHIPX_CalculateBoxesAndWeightsAsync(defaultCountry, varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces, shippingMethod, varWeightOfProductInGrams, shippingMethodsRowResults);
                varCarrierRate = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, defaultPostalCode, CartTotal, varMediaMailZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, varWeight, varCOD, varResidentialDelivery, varPriceGroup);
                if (varCarrierRate != -1)
                {
                    varDays = Z_SHIPX_FigureTransitDaysMediaMail(varMediaMailZone, defaultStateProvince);
                    (varPOBoxAllowed, varCODAllowed, varIsAShippingMethodAvailable) =
                        await Z_SHIPX_ProcessAndAddShippingOptionAsync(options, varCarrierRate, varDays, varPossiblePOBox, shippingMethodsRowResults,
                        shippingMethod, "USPS Media Mail");
                }
            }

            // 'Priority Mail
            if (!string.IsNullOrWhiteSpace(varPriorityMailZone) && varPriorityMailZone != "NA")
            {
                string shippingMethod = "PM";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);

                (varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces) = await Z_SHIPX_CalculateBoxesAndWeightsAsync(defaultCountry, varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces, shippingMethod, varWeightOfProductInGrams, shippingMethodsRowResults);
                varCarrierRate = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, defaultPostalCode, CartTotal, varPriorityMailZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, varWeight, varCOD, varResidentialDelivery, varPriceGroup);
                if (varCarrierRate != -1)
                {
                    varDays = Z_SHIPX_FigureTransitDaysPriorityMail(countryStateProvincesListRowResults, varPriorityMailZone, defaultStateProvince);
                    (varPOBoxAllowed, varCODAllowed, varIsAShippingMethodAvailable) =
                        await Z_SHIPX_ProcessAndAddShippingOptionAsync(options, varCarrierRate, varDays, varPossiblePOBox, shippingMethodsRowResults,
                        shippingMethod, "USPS Priority Mail");
                }
            }

            // 'Express Mail to Address
            if (!string.IsNullOrWhiteSpace(varExpressMailZone) && varExpressMailZone != "NA")
            {
                string shippingMethod = "EMA";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);

                (varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces) = await Z_SHIPX_CalculateBoxesAndWeightsAsync(defaultCountry, varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces, shippingMethod, varWeightOfProductInGrams, shippingMethodsRowResults);
                varCarrierRate = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, defaultPostalCode, CartTotal, varExpressMailZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, varWeight, varCOD, varResidentialDelivery, varPriceGroup);
                if (varCarrierRate != -1)
                {
                    varDays = Z_SHIPX_FigureTransitDaysExpressMail();
                    (varPOBoxAllowed, varCODAllowed, varIsAShippingMethodAvailable) =
                        await Z_SHIPX_ProcessAndAddShippingOptionAsync(options, varCarrierRate, varDays, varPossiblePOBox, shippingMethodsRowResults,
                        shippingMethod, "USPS Express");
                }
            }

            // 'DHL International Express
            if (!string.IsNullOrWhiteSpace(varDHLInternationalZone) && varDHLInternationalZone != "NA")
            {
                string shippingMethod = "DHLIE";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);
                int? overrideNumberOfBoxes = 1;
                (varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces) = await Z_SHIPX_CalculateBoxesAndWeightsAsync(defaultCountry, varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces, shippingMethod, varWeightOfProductInGrams, shippingMethodsRowResults, overrideNumberOfBoxes);
                varCarrierRate = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, defaultPostalCode, CartTotal, varDHLInternationalZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, varWeight, varCOD, varResidentialDelivery, varPriceGroup);

                if (varCarrierRate != -1)
                {
                    varDays = "2-5";
                    varPOBoxAllowed = AppConstants.Y;
                    varCODAllowed = AppConstants.N;
                    varIsAShippingMethodAvailable = true;
                    var shippingDate = await Z_SHIPX_FigureShipDateAsync(DateTime.Now.Date, shippingMethod);
                    var arrivingDate = await Z_SHIPX_FigureArrivalDateAsync(shippingMethodsRowResults, shippingDate, varDays, shippingMethod);

                    options.Add(new ShippingMethodDto()
                    {
                        Code = shippingMethod,
                        Name = "DHL International Express",
                        Price = varCarrierRate,
                        POBoxAllowed = varPOBoxAllowed,
                        CODAllowed = AppConstants.N,
                        ArrivingDate = arrivingDate,
                    });
                }
            }

            // 'First Class Mail International
            if (!string.IsNullOrWhiteSpace(varAirMailLetterPostZone) && varAirMailLetterPostZone != "NA" && varWeightInDecimal <= 3)
            {
                string shippingMethod = "ALP";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);

                varNumberOfBoxes = await Z_SHIPX_FigureNumberOfBoxesAsync(defaultCountry, NameOfCart, shippingMethod, (int)varWeightInDecimal, varWeightOfProductInGrams, shippingMethodsRowResults);
                varWeightOfEachBox = (int)Math.Floor((varWeightInDecimal / varNumberOfBoxes) + 0.9999m);

                varCarrierRate = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, defaultPostalCode, CartTotal, varAirMailLetterPostZone, defaultStateProvince, defaultCountry, varWeightInDecimal, varNumberOfBoxes, varWeightInDecimal, varCOD, varResidentialDelivery, varPriceGroup);

                if (varCarrierRate != -1)
                {
                    varDays = Z_SHIPX_FigureTransitDaysAirmailLetterPost();
                    (varPOBoxAllowed, varCODAllowed, varIsAShippingMethodAvailable) =
                        await Z_SHIPX_ProcessAndAddShippingOptionAsync(options, varCarrierRate, varDays, varPossiblePOBox, shippingMethodsRowResults,
                        shippingMethod, "USPS First Class International");
                }
            }
            // 'Priority Mail International
            if (!string.IsNullOrWhiteSpace(varAirParcelPostZone) && varAirParcelPostZone != "NA" && varWeightInDecimal > 3)
            {
                string shippingMethod = "APP";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);

                (varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces) = await Z_SHIPX_CalculateBoxesAndWeightsAsync(defaultCountry, varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces, shippingMethod, varWeightOfProductInGrams, shippingMethodsRowResults);
                varCarrierRate = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, defaultPostalCode, CartTotal, varAirParcelPostZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, varWeight, varCOD, varResidentialDelivery, varPriceGroup);

                if (varCarrierRate != -1)
                {
                    varDays = Z_SHIPX_FigureTransitDaysAirParcelPost();
                    (varPOBoxAllowed, varCODAllowed, varIsAShippingMethodAvailable) =
                        await Z_SHIPX_ProcessAndAddShippingOptionAsync(options, varCarrierRate, varDays, varPossiblePOBox, shippingMethodsRowResults,
                        shippingMethod, "USPS Priority Mail International");
                }
            }
            // 'Express Mail International
            if (!string.IsNullOrWhiteSpace(varGlobalExpressZone) && varGlobalExpressZone != "NA")
            {
                string shippingMethod = "GE";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);

                (varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces) = await Z_SHIPX_CalculateBoxesAndWeightsAsync(defaultCountry, varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces, shippingMethod, varWeightOfProductInGrams, shippingMethodsRowResults);
                varCarrierRate = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, defaultPostalCode, CartTotal, varGlobalExpressZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, varWeight, varCOD, varResidentialDelivery, varPriceGroup);

                if (varCarrierRate != -1)
                {
                    varDays = Z_SHIPX_FigureTransitDaysGlobalExpress();
                    (varPOBoxAllowed, varCODAllowed, varIsAShippingMethodAvailable) =
                        await Z_SHIPX_ProcessAndAddShippingOptionAsync(options, varCarrierRate, varDays, varPossiblePOBox, shippingMethodsRowResults,
                        shippingMethod, "USPS Global Express");
                }
            }
            // 'UPS Ground
            if (!string.IsNullOrWhiteSpace(varUPSGroundZone) && varUPSGroundZone != "NA")
            {
                string shippingMethod = "UPSGR";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);

                (varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces) = await Z_SHIPX_CalculateBoxesAndWeightsAsync(defaultCountry, varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces, shippingMethod, varWeightOfProductInGrams, shippingMethodsRowResults);
                varCarrierRate = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, defaultPostalCode, CartTotal, varUPSGroundZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, varWeight, varCOD, varResidentialDelivery, varPriceGroup);

                if (varCarrierRate != -1)
                {
                    varDays = await Z_SHIPX_FigureTransitDaysUPSGroundAsync(defaultCountry, defaultPostalCode);
                    (varPOBoxAllowed, varCODAllowed, varIsAShippingMethodAvailable) =
                        await Z_SHIPX_ProcessAndAddShippingOptionAsync(options, varCarrierRate, varDays, varPossiblePOBox, shippingMethodsRowResults,
                        shippingMethod, "UPS Ground");
                }
            }
            // 'FedEx Ground
            if (!string.IsNullOrWhiteSpace(varFedExGroundZone) && varFedExGroundZone != "NA")
            {
                string shippingMethod = "FEGR";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);

                (varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces) = await Z_SHIPX_CalculateBoxesAndWeightsAsync(defaultCountry, varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces, shippingMethod, varWeightOfProductInGrams, shippingMethodsRowResults);
                varCarrierRate = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, defaultPostalCode, CartTotal, varFedExGroundZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, varWeight, varCOD, varResidentialDelivery, varPriceGroup);

                if (varCarrierRate != -1)
                {
                    varDays = await Z_SHIPX_FigureTransitDaysFedExGroundAsync(defaultCountry, defaultPostalCode);
                    (varPOBoxAllowed, varCODAllowed, varIsAShippingMethodAvailable) =
                        await Z_SHIPX_ProcessAndAddShippingOptionAsync(options, varCarrierRate, varDays, varPossiblePOBox, shippingMethodsRowResults,
                        shippingMethod, "FedEx Ground");
                }
            }

            // 'FedEx Express Saver 3-day
            if (!string.IsNullOrWhiteSpace(varFedExExpressZone) && varFedExExpressZone != "NA" && varAllowOtherFedexShippingMethods == 1)
            {
                string shippingMethod = "FEES";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);

                (varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces) = await Z_SHIPX_CalculateBoxesAndWeightsAsync(defaultCountry, varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces, shippingMethod, varWeightOfProductInGrams, shippingMethodsRowResults);
                varCarrierRate = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, defaultPostalCode, CartTotal, varFedExExpressZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, varWeight, varCOD, varResidentialDelivery, varPriceGroup);

                if (varCarrierRate != -1)
                {
                    varDays = Z_SHIPX_FigureTransitDaysFedExExpressSaver();
                    (varPOBoxAllowed, varCODAllowed, varIsAShippingMethodAvailable) =
                        await Z_SHIPX_ProcessAndAddShippingOptionAsync(options, varCarrierRate, varDays, varPossiblePOBox, shippingMethodsRowResults,
                        shippingMethod, "FedEx 3-Day");
                }
            }

            //'FedEx Standard Overnight
            if (!string.IsNullOrWhiteSpace(varFedExExpressZone) && varFedExExpressZone != "NA" && varAllowOtherFedexShippingMethods == 1)
            {
                string shippingMethod = "FESO";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);

                (varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces) = await Z_SHIPX_CalculateBoxesAndWeightsAsync(defaultCountry, varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces, shippingMethod, varWeightOfProductInGrams, shippingMethodsRowResults);
                varCarrierRate = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, defaultPostalCode, CartTotal, varFedExExpressZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, varWeight, varCOD, varResidentialDelivery, varPriceGroup);

                if (varCarrierRate != -1)
                {
                    varFESOAvailable = "yes";
                    varDays = Z_SHIPX_FigureTransitDaysFedExStandardOvernight();
                    (varPOBoxAllowed, varCODAllowed, varIsAShippingMethodAvailable) =
                        await Z_SHIPX_ProcessAndAddShippingOptionAsync(options, varCarrierRate, varDays, varPossiblePOBox, shippingMethodsRowResults,
                        shippingMethod, "FedEx Standard Overnight");
                }
            }

            // 'FedEx International Economy
            if (!string.IsNullOrWhiteSpace(varFedExInternationalEconomyZone) && varFedExInternationalEconomyZone != "NA" && varAllowFedExInternationalPriorityForRetail == "yes")
            {
                string shippingMethod = "FEINTE";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);

                (varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces) = await Z_SHIPX_CalculateBoxesAndWeightsAsync(defaultCountry, varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces, shippingMethod, varWeightOfProductInGrams, shippingMethodsRowResults);
                varCarrierRate = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, defaultPostalCode, CartTotal, varFedExInternationalEconomyZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, varWeight, varCOD, varResidentialDelivery, varPriceGroup);

                if (varCarrierRate != -1)
                {
                    varDays = Z_SHIPX_FigureTransitDaysFedExInternationalEconomy();
                    (varPOBoxAllowed, varCODAllowed, varIsAShippingMethodAvailable) =
                        await Z_SHIPX_ProcessAndAddShippingOptionAsync(options, varCarrierRate, varDays, varPossiblePOBox, shippingMethodsRowResults,
                        shippingMethod, "FedEx International Priority");
                }
            }

            // 'FedEx International Priority
            if (!string.IsNullOrWhiteSpace(varFedExInternationalPriorityZone) && varFedExInternationalPriorityZone != "NA" && varAllowFedExInternationalPriorityForRetail == "yes")
            {
                string shippingMethod = "FEINTP";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);

                (varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces) = await Z_SHIPX_CalculateBoxesAndWeightsAsync(defaultCountry, varNumberOfBoxes, varWeightOfEachBox, varWeightInOunces, shippingMethod, varWeightOfProductInGrams, shippingMethodsRowResults);
                varCarrierRate = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, defaultPostalCode, CartTotal, varFedExInternationalPriorityZone, defaultStateProvince, defaultCountry, varWeightOfEachBox, varNumberOfBoxes, varWeight, varCOD, varResidentialDelivery, varPriceGroup);

                if (varCarrierRate != -1)
                {
                    varDays = Z_SHIPX_FigureTransitDaysFedExInternationalPriority(defaultCountry);

                    (varPOBoxAllowed, varCODAllowed, varIsAShippingMethodAvailable) =
                        await Z_SHIPX_ProcessAndAddShippingOptionAsync(options, varCarrierRate, varDays, varPossiblePOBox, shippingMethodsRowResults,
                        shippingMethod, "FedEx International Priority");
                }
            }
            return options.OrderBy(o => o.Price).ToList();
        }


        public string Z_SHIPX_FigureTransitDaysFedExInternationalPriority(string subVarCountry)
        {
            // Default transit time
            string transitDays = "2";

            // Adjust for neighboring countries
            if (subVarCountry == "Canada" || subVarCountry == "Mexico")
            {
                transitDays = "1-2";
            }

            return transitDays;
        }
        public async Task<string> Z_SHIPX_FigureTransitDaysFedExGroundAsync(string subVarCountry, string subVarZipCode)
        {
            // Basic validation matching legacy logic
            if (string.IsNullOrWhiteSpace(subVarZipCode) || subVarZipCode.Length < 5)
            {
                return "NA";
            }

            if (subVarCountry != "USA")
            {
                return "NA";
            }

            // Equivalent to Left(subVarZipCode, 5)
            string subVarZip5 = subVarZipCode.Substring(0, 5);

            // Call the stored procedure using the existing service/procedures interface
            var results = await _procedures.spGetWebSHIPX_FedExGroundTimeInTransitRowAsync(subVarZip5);

            // Check if a row was returned and access the 'Days' property
            var row = results?.FirstOrDefault();
            if (row != null && row.Days != null)
            {
                return row.Days.ToString()!;
            }

            // Default return if no record found
            return "NA";
        }
        public async Task<string> Z_SHIPX_FigureTransitDaysUPSGroundAsync(string subVarCountry, string subVarZipCode)
        {
            // Basic validation: length and country
            if (string.IsNullOrWhiteSpace(subVarZipCode) || subVarZipCode.Length < 5)
            {
                return AppConstants.NA;
            }

            if (subVarCountry != "USA")
            {
                return AppConstants.NA;
            }

            // Equivalent to VB.NET Left(subVarZipCode, 5)
            string subVarZip5 = subVarZipCode.Substring(0, 5);

            // Using the existing _procedures interface to call the stored proc
            var results = await _procedures.spGetWebSHIPX_UPSTimeInTransitRowAsync(subVarZip5);

            // Check if the result exists and has the 'Days' value
            var row = results?.FirstOrDefault();
            if (row != null && row.Days.HasValue)
            {
                return row.Days.ToString()!;
            }

            return AppConstants.NA;
        }
        private async Task<(string varPOBoxAllowed, string varCODAllowed, bool varIsAShippingMethodAvailable)> Z_SHIPX_ProcessAndAddShippingOptionAsync(
            List<ShippingMethodDto> options, decimal varCarrierRate, string varDays, string varPossiblePOBox,
            List<spGetShippingMethodsRowResult> shippingMethodsRowResults, string shippingMethod, string shippingMethodName)
        {
            string varPOBoxAllowed, varCODAllowed;
            bool varIsAShippingMethodAvailable;
            if (varPossiblePOBox == AppConstants.Y)
            {
                varPOBoxAllowed = Z_SHIPX_FigureIfPOBoxAllowed(shippingMethodsRowResults, shippingMethod);
            }
            else
            {
                varPOBoxAllowed = AppConstants.Y;
            }
            varCODAllowed = Z_SHIPX_FigureIfCODAllowed(shippingMethodsRowResults, shippingMethod);
            varIsAShippingMethodAvailable = true;
            var shippingDate = await Z_SHIPX_FigureShipDateAsync(DateTime.Now.Date, shippingMethod);
            var arrivingDate = await Z_SHIPX_FigureArrivalDateAsync(shippingMethodsRowResults, shippingDate, varDays, shippingMethod);

            options.Add(new ShippingMethodDto()
            {
                Code = shippingMethod,
                Name = shippingMethodName,
                Price = varCarrierRate,
                POBoxAllowed = varPOBoxAllowed,
                CODAllowed = AppConstants.N,
                ArrivingDate = arrivingDate,
            });
            return (varPOBoxAllowed, varCODAllowed, varIsAShippingMethodAvailable);
        }

        private string Z_SHIPX_FigureTransitDaysFedExInternationalEconomy() => "5";
        private string Z_SHIPX_FigureTransitDaysFedExStandardOvernight() => "1";
        private string Z_SHIPX_FigureTransitDaysFedExExpressSaver() => "3";
        private string Z_SHIPX_FigureTransitDaysGlobalExpress() => "3-5";
        private string Z_SHIPX_FigureTransitDaysAirParcelPost() => "4-10";
        private string Z_SHIPX_FigureTransitDaysAirmailLetterPost() => "4-10";
        private string Z_SHIPX_FigureTransitDaysExpressMail() => "1-2";

        private string Z_SHIPX_FigureTransitDaysPriorityMail(List<spGetWebCountryStateProvincesListRowResult> results, string varPriorityMailZone, string defaultStateProvince)
        {
            // Validate inputs
            if (string.IsNullOrWhiteSpace(defaultStateProvince) || string.IsNullOrWhiteSpace(varPriorityMailZone))
            {
                return "";
            }

            // Fetch state details

            // Default fallback if state not found
            if (results == null || !results.Any())
            {
                return "2-3";
            }

            string stateAbbr = results.First().StateProvinceAbbreviation;
            int.TryParse(varPriorityMailZone, out int zone);

            // Determine transit days
            if (stateAbbr == "HI" || stateAbbr == "AK")
            {
                return "2-4";
            }

            if (stateAbbr == "AA" || stateAbbr == "AE" || stateAbbr == "AP" ||
                stateAbbr == "GU" || stateAbbr == "PR" || stateAbbr == "VI")
            {
                return "3-6";
            }

            if (zone <= 5)
            {
                return "1-3";
            }

            // Default case for zones >= 6
            return "2-3";
        }
        private string Z_SHIPX_FigureTransitDaysMediaMail(string subVarPriorityMailZone, string subVarState)
        {
            // Validate inputs
            if (string.IsNullOrWhiteSpace(subVarState) || string.IsNullOrWhiteSpace(subVarPriorityMailZone))
            {
                return "";
            }

            // Since every zone (1-8) returns the same transit time, 
            // we only need to verify that it is a valid zone value.
            if (int.TryParse(subVarPriorityMailZone, out int zone) && zone >= 1 && zone <= 8)
            {
                return "4-8";
            }

            return "";
        }
        private string Z_SHIPX_FigureTransitDaysFedEx2Day(string subVarCountry, string subVarZipCode)
        {
            // Basic validation
            if (string.IsNullOrWhiteSpace(subVarZipCode) || subVarZipCode.Length < 5) return "NA";
            if (subVarCountry != "USA") return "NA";

            string zipPart = subVarZipCode.Substring(0, 5);
            if (!int.TryParse(zipPart, out int zip)) return "NA";

            // Alaska: Returns "3"
            if (zip >= 99500 && zip <= 99999) return "3";

            // Hawaii: Logic based on legacy zip ranges
            if (zip >= 96701 && zip <= 96705) return "2";

            // Grouping the "3" return values for readability
            if ((zip == 96708) ||
                (zip == 96710) ||
                (zip >= 96713 && zip <= 96716) ||
                (zip >= 96718 && zip <= 96729) ||
                (zip >= 96732 && zip <= 96733) ||
                (zip >= 96737 && zip <= 96743) ||
                (zip >= 96745 && zip <= 96757) ||
                (zip >= 96760 && zip <= 96761) ||
                (zip >= 96763 && zip <= 96781) ||
                (zip >= 96783 && zip <= 96785) ||
                (zip == 96788 || zip == 96790 || zip == 96793 || zip == 96796))
            {
                return "3";
            }

            if (zip == 96742) return "4";

            // Default for everything else
            return "2";
        }
        private async Task<DateTime> Z_SHIPX_FigureShipDateAsync(DateTime subVarShipmentDate, string subVarShippingMethod)
        {
            // 1. Handle initial validation
            if (subVarShipmentDate == default(DateTime))
            {
                // Returning DateTime.MinValue as a proxy for "NA" 
                return DateTime.MinValue;
            }

            int intShippingCutoffMinutes = 600; // Default fallback

            // 2. Call the stored procedure via your injected procedures interface
            var result = await _procedures.spGetShippingCutoffMinutesAsync(subVarShippingMethod);

            if (result != null && result.Any())
            {
                // Assuming the SP returns an object with the field
                intShippingCutoffMinutes = result.First().WebShippingCutoffMinutes ?? 0;
            }

            // 3. Calculate current time in minutes
            int currentTotalMinutes = DateTime.Now.Hour * 60 + DateTime.Now.Minute;

            // 4. Compare and determine Ship Date
            if (currentTotalMinutes >= intShippingCutoffMinutes)
            {
                return subVarShipmentDate.AddDays(1);
            }
            else
            {
                return subVarShipmentDate;
            }
        }
        private string Z_SHIPX_FigureIfCODAllowed(List<spGetShippingMethodsRowResult> results, string shippingMethod)
        {
            string result = "N";
            if (results != null && results.Any())
            {
                result = results.First().CODOK ?? "N";
            }
            return result;
        }

        private string Z_SHIPX_FigureIfPOBoxAllowed(List<spGetShippingMethodsRowResult> results, string subVarShippingMethod)
        {
            string result = "N";
            if (results != null && results.Any())
            {
                result = results.First().POBoxOK ?? "N";
            }
            return result;
        }

        private async Task<string> Z_SHIPX_FigureArrivalDateAsync(List<spGetShippingMethodsRowResult> methodResults, DateTime subVarShipDate, string subVarDays, string subVarShippingMethod)
        {
            if (subVarShipDate == default || string.IsNullOrWhiteSpace(subVarDays) || string.IsNullOrWhiteSpace(subVarShippingMethod) || subVarDays == "NA")
                return "";

            // 1. Get Shipping Method Config
            string holidayColumn = methodResults?.FirstOrDefault()?.HolidayColumnName ?? "";

            // 'Fedex And UPS and DHL ----------------------------------------------------------------------------------------------------------------------
            bool isCarrier = subVarShippingMethod.StartsWith("FE", StringComparison.OrdinalIgnoreCase) ||
                             subVarShippingMethod.StartsWith("UP", StringComparison.OrdinalIgnoreCase);

            DateTime Z_SHIPX_FigureArrivalDate;
            // 'Exact Date---------------
            if (!subVarDays.Contains("-"))
            {
                // 'Ship Date
                Z_SHIPX_FigureArrivalDate = subVarShipDate;
                do
                {
                    if (isCarrier && Z_SHIPX_FigureArrivalDate.DayOfWeek == DayOfWeek.Saturday)
                    {
                        Z_SHIPX_FigureArrivalDate = Z_SHIPX_FigureArrivalDate.AddDays(2);
                    }
                    else if (Z_SHIPX_FigureArrivalDate.DayOfWeek == DayOfWeek.Sunday || (await IsHolidayAsync(Z_SHIPX_FigureArrivalDate, holidayColumn)))
                    {
                        Z_SHIPX_FigureArrivalDate = Z_SHIPX_FigureArrivalDate.AddDays(1);
                    }
                    else
                    {
                        break;
                    }
                } while (true);

                // 'Transit Days
                int transitDays = int.Parse(subVarDays);
                DateTime arrivalDate = await CalculateArrivalDate(Z_SHIPX_FigureArrivalDate, transitDays, holidayColumn, isCarrier);
                return $"Arrives {arrivalDate:MMMM d}";
            }
            else
            {
                string[] parts = subVarDays.Split('-');
                int firstDays = int.Parse(parts[0]);
                int secondDays = int.Parse(parts[1].Trim());

                DateTime firstArrival = await CalculateArrivalDate(subVarShipDate, firstDays, holidayColumn, isCarrier);
                DateTime secondArrival = await CalculateArrivalDate(subVarShipDate, secondDays, holidayColumn, isCarrier);

                return $"Arrives {firstArrival:MMMM d} - {secondArrival:MMMM d}";
            }
        }
        private async Task<DateTime> CalculateArrivalDate(DateTime shipDate, int transitDays, string holidayCol, bool isCarrier)
        {
            DateTime current = shipDate;

            // Process transit days
            for (int i = 0; i < transitDays; i++)
            {
                current = current.AddDays(1);

                // Skip weekends and holidays
                while (IsWeekend(current, isCarrier) || await IsHolidayAsync(current, holidayCol))
                {
                    current = current.AddDays(1);
                }
            }
            return current;
        }
        private bool IsWeekend(DateTime date, bool isCarrier)
        {
            // FedEx/UPS/DHL (isCarrier = true) skip Sat/Sun (7=Sat, 1=Sun)
            // US Mail (isCarrier = false) skips only Sun (1=Sun)
            if (isCarrier) return date.DayOfWeek == DayOfWeek.Saturday || date.DayOfWeek == DayOfWeek.Sunday;
            return date.DayOfWeek == DayOfWeek.Sunday;
        }
        private async Task<bool> IsHolidayAsync(DateTime date, string holidayColumn)
        {
            var holidayData = await GetWebSHIPX_ShippingHolidaysOutboundRowCache(date.Date);
            var row = holidayData?.FirstOrDefault();

            if (row == null) return false;

            bool isSpecificHoliday = false;

            switch (holidayColumn)
            {
                case nameof(spGetWebSHIPX_ShippingHolidaysOutboundRowResult.FedexAirHoliday):
                    isSpecificHoliday = row.FedexAirHoliday == "y";
                    break;
                case nameof(spGetWebSHIPX_ShippingHolidaysOutboundRowResult.FedexGroundHoliday):
                    isSpecificHoliday = row.FedexGroundHoliday == "y";
                    break;
                case nameof(spGetWebSHIPX_ShippingHolidaysOutboundRowResult.USPSHoliday):
                    isSpecificHoliday = row.USPSHoliday == "y";
                    break;
                case nameof(spGetWebSHIPX_ShippingHolidaysOutboundRowResult.UPSGroundHoliday):
                    isSpecificHoliday = row.UPSGroundHoliday == "y";
                    break;
            }

            return isSpecificHoliday || row.WorkHoliday == "y";
        }
        public string Z_CheckForPOBox(string subVarStreetAddress1, string subVarStreetAddress2)
        {
            string isPOBox = "N";

            // Combine strings to check them more efficiently if both exist
            string combinedAddress = (subVarStreetAddress1 ?? "") + " " + (subVarStreetAddress2 ?? "");
            string upperAddress = combinedAddress.ToUpper();

            if (upperAddress.Contains("BOX ") || upperAddress.Contains("POB "))
            {
                isPOBox = "Y";
            }

            return isPOBox;
        }
        private async Task<string> Z_SHIPX_FigureTransitDaysFirstClassAsync(List<spGetWebCountryStateProvincesListRowResult> spGetWebCountryStateProvincesListRowResults, string varPriorityMailZone, string defaultStateProvince)
        {
            string Z_SHIPX_FigureTransitDaysFirstClass = "";
            if (string.IsNullOrWhiteSpace(defaultStateProvince) || defaultStateProvince.Length == 0)
            {
                Z_SHIPX_FigureTransitDaysFirstClass = "";
                return Z_SHIPX_FigureTransitDaysFirstClass;
            }
            if (string.IsNullOrWhiteSpace(varPriorityMailZone))
            {
                Z_SHIPX_FigureTransitDaysFirstClass = "";
                return Z_SHIPX_FigureTransitDaysFirstClass;
            }
            string subVarStateAbbreviation = "";

            if (spGetWebCountryStateProvincesListRowResults.Any())
            {
                subVarStateAbbreviation = spGetWebCountryStateProvincesListRowResults.First().StateProvinceAbbreviation;

                if (subVarStateAbbreviation == "HI" || subVarStateAbbreviation == "AK" ||
                    subVarStateAbbreviation == "AA" || subVarStateAbbreviation == "AE" || subVarStateAbbreviation == "AP" ||
                    varPriorityMailZone == "4" || varPriorityMailZone == "5" || varPriorityMailZone == "6" || varPriorityMailZone == "7" || varPriorityMailZone == "8")
                {
                    Z_SHIPX_FigureTransitDaysFirstClass = "2-3";
                }
                else if (varPriorityMailZone == "2")
                {
                    Z_SHIPX_FigureTransitDaysFirstClass = "1-3";
                }
                else if (varPriorityMailZone == "3")
                {
                    Z_SHIPX_FigureTransitDaysFirstClass = "1-2";
                }
                else
                {
                    Z_SHIPX_FigureTransitDaysFirstClass = "2-3";
                }
            }
            else
            {
                Z_SHIPX_FigureTransitDaysFirstClass = "2-3";
            }
            return Z_SHIPX_FigureTransitDaysFirstClass;
        }
        private async Task SetResidentialDeliveryAsync()
        {
            List<spResidentialDeliveryResult> spResidentialDeliveryResults = await _procedures.spResidentialDeliveryAsync(_httpContext.Session.GetCustomerServerCounter());
            if (spResidentialDeliveryResults.Any())
            {
                varResidentialDelivery = spResidentialDeliveryResults.First().ResidentialDelivery == AppConstants.Y ? AppConstants.YES : AppConstants.NO;
            }

        }
        private string NameOfCart
        {
            get
            {
                return _httpContext.Session.GetActiveCartName();
            }
        }
        decimal varWeightOfProductInGrams = 0;
        private async Task SetWeightOfProductInGramsAsync()
        {

            var weightOfProductResults = await _procedures.spGetWeightOfProductAsync(NameOfCart);
            if (weightOfProductResults.Any())
            {
                varWeightOfProductInGrams = weightOfProductResults.First().sumweight;
            }
        }
        private async Task ApplyPackageWeightAsync()
        {
            varWeight = varWeightOfProductInGrams;
            varWeightInGrams = varWeightOfProductInGrams;
            if (varWeight != 0)
            {
                varWeightInDecimal = varWeight.ConvertToPounds();
                varWeight = varWeightInDecimal;
                var packagingWeightResults = await _procedures.spGetWebSHIPX_PackagingWeightAsync(varWeightInGrams, NameOfCart);
                if (packagingWeightResults.Count > 0)
                {
                    int? packagingWeight = packagingWeightResults.First().PackagingWeight;
                    if (packagingWeight.HasValue)
                    {
                        varWeightInGrams += packagingWeight.Value;
                        varWeightInDecimal += ((decimal)packagingWeight.Value).ConvertToPounds();
                        varWeight = varWeightInDecimal;
                    }
                }
            }
        }
        decimal varWeight = 0m;
        decimal varWeightInGrams = 0m;
        decimal varWeightInDecimal = 0m;
        string varResidentialDelivery = AppConstants.YES;
        string defaultCountry1 = "USA";
        string defaultPostalCode1 = "95762";
        string defaultStateProvince1 = "California";
        string varZip3 = "957";
        string varPriceGroup = "";
        private async Task<spGetCustomerDetailsByServerCounterResult> InitializeCustomerDetailsAsync()
        {
            // --- 1. Variable Initializations (Ported as-is) ---

            varPriceGroup = _httpContext.Session.GetPriceGroupWithFallback();
            List<spGetCustomerDetailsByServerCounterResult> results = await _procedures.spGetCustomerDetailsByServerCounterAsync(_httpContext.Session.GetCustomerServerCounter());
            spGetCustomerDetailsByServerCounterResult? customerDetails = results.FirstOrDefault();
            if (customerDetails == null)
            {
                customerDetails = new()
                {
                    Country = defaultCountry1,
                    PostalCode = defaultPostalCode1,
                    StateProvince = defaultStateProvince1,
                };
            }
            else
            {
                varZip3 = customerDetails.PostalCode?.Length >= 3 ? customerDetails.PostalCode.Substring(0, 3) : "";
                varPriceGroup = string.IsNullOrEmpty(customerDetails.PriceGroup) ? varPriceGroup : customerDetails.PriceGroup;
            }
            return customerDetails;
        }
        public async Task<decimal> FindZoneAndCalculateShippingChargeAsync(decimal CartTotal, int cartItemsCount, bool isV1 = true, decimal WeightInGrams = -1m)
        {
            if (cartItemsCount <= 0)
            {
                return 0m;
            }
            spGetCustomerDetailsByServerCounterResult customerDetails;

            if (isV1)
            {
                customerDetails = await InitializeCustomerDetailsAsync();

                await SetWeightOfProductInGramsAsync();

                int varXXRecordCount = cartItemsCount;
                if (varXXRecordCount > 0)
                {
                    await ApplyPackageWeightAsync();
                }

                await SetResidentialDeliveryAsync();
            }
            else
            {
                if (cartItemsCount > 0)
                {
                    varWeightOfProductInGrams = WeightInGrams;
                    await ApplyPackageWeightAsync();
                }
                customerDetails = await InitializeCustomerDetailsAsync();
            }
            decimal varShippingCharge = 0;

            // 'Shipping Cost ------------------------------------------------------------------
            // --- 2. Zone Lookups ---
            string varDHLInternationalZone = await Z_SHIPX_FigureDHLInternationalZoneAsync(customerDetails.Country);
            string varUPSGroundZone = Z_SHIPX_FigureUPSGroundZone(customerDetails.Country, customerDetails.PostalCode, customerDetails.StateProvince);
            string varFedExGroundZone = Z_SHIPX_FigureFedExGroundZone(customerDetails.Country, customerDetails.PostalCode, customerDetails.StateProvince);
            string varPriorityMailZone = Z_SHIPX_FigurePriorityMailZone(customerDetails.Country, varZip3);
            string varExpressMailZone = Z_SHIPX_FigureExpressMailZone(customerDetails.Country, customerDetails.StateProvince, varPriceGroup, varZip3);
            string varMediaMailZone = Z_SHIPX_FigureMediaMailZone(customerDetails.Country, customerDetails.StateProvince, varPriceGroup, varZip3);
            string varAirMailLetterPostZone = await Z_SHIPX_FigureAirMailLetterPostZoneAsync(customerDetails.Country);
            string varAirParcelPostZone = await Z_SHIPX_FigureAirParcelPostZoneAsync(customerDetails.Country);
            string varGlobalExpressZone = Z_SHIPX_FigureGlobalExpressZone(customerDetails.Country);
            string varFedExExpressZone = Z_SHIPX_FigureFedExExpressZone(customerDetails.Country, customerDetails.PostalCode, customerDetails.StateProvince);
            string varFedExInternationalPriorityZone = await Z_SHIPX_FigureFedExInternationalPriorityZoneAsync(customerDetails.Country, varZip3);
            string varFedExInternationalEconomyZone = await Z_SHIPX_FigureFedExInternationalEconomyZoneAsync(customerDetails.Country, varZip3);

            // --- 3. Execution ---
            int? varNumberOfBoxes = null;
            decimal varWeightOfEachBox = 0m;
            decimal varLastRateChecked = 0m;
            // 'Shipping Cost ------------------------------------------------------------------
            // 'First Class
            if (varPriorityMailZone != "NA")
            {
                varNumberOfBoxes = 1;
                varWeightOfEachBox = varWeight;
                varLastRateChecked = await Z_SHIPX_FigureShippingCost("FC", NameOfCart, customerDetails.PostalCode, CartTotal, varPriorityMailZone, customerDetails.StateProvince, customerDetails.Country, varWeight, 1, varWeight, "No", varResidentialDelivery, varPriceGroup);
                if (varLastRateChecked != -1)
                {
                    if (varShippingCharge == 0 || varLastRateChecked < varShippingCharge)
                    {
                        varShippingCharge = varLastRateChecked;
                    }
                }
            }
            List<spGetShippingMethodsRowResult> shippingMethodsRowResults;
            // 'Media Mail
            if (varMediaMailZone != "NA")
            {
                var shippingMethod = "MM";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);

                varNumberOfBoxes = await Z_SHIPX_FigureNumberOfBoxesAsync(customerDetails.Country, NameOfCart, shippingMethod, (int)varWeight, (int)varWeightOfProductInGrams, shippingMethodsRowResults);
                varWeightOfEachBox = (int)Math.Floor((varWeight / varNumberOfBoxes.Value) + 0.9999m);
                if (varWeightOfEachBox < 1)
                {
                    varWeightOfEachBox = 1;
                }
                varLastRateChecked = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, customerDetails.PostalCode, CartTotal, varMediaMailZone, customerDetails.StateProvince, customerDetails.Country, varWeightOfEachBox, varNumberOfBoxes.Value, varWeight, "No", varResidentialDelivery, varPriceGroup);
                if (varLastRateChecked != -1)
                {
                    if (varShippingCharge == 0 || varLastRateChecked < varShippingCharge)
                    {
                        varShippingCharge = varLastRateChecked;
                    }
                }
            }
            // 'priority Mail
            if (varPriorityMailZone != "NA")
            {
                var shippingMethod = "PM";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);

                varNumberOfBoxes = await Z_SHIPX_FigureNumberOfBoxesAsync(customerDetails.Country, NameOfCart, shippingMethod, (int)varWeight, (int)varWeightOfProductInGrams, shippingMethodsRowResults);
                varWeightOfEachBox = (int)Math.Floor((varWeight / varNumberOfBoxes.Value) + 0.9999m);
                if (varWeightOfEachBox < 1)
                {
                    varWeightOfEachBox = 1;
                }
                varLastRateChecked = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, customerDetails.PostalCode, CartTotal, varPriorityMailZone, customerDetails.StateProvince, customerDetails.Country, varWeightOfEachBox, varNumberOfBoxes.Value, varWeight, "No", varResidentialDelivery, varPriceGroup);
                if (varLastRateChecked != -1)
                {
                    if (varShippingCharge == 0 || varLastRateChecked < varShippingCharge)
                    {
                        varShippingCharge = varLastRateChecked;
                    }
                }
            }
            // 'Express Mail to Address
            if (varExpressMailZone != "NA")
            {
                var shippingMethod = "EMA";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);

                varNumberOfBoxes = await Z_SHIPX_FigureNumberOfBoxesAsync(customerDetails.Country, NameOfCart, shippingMethod, (int)varWeight, (int)varWeightOfProductInGrams, shippingMethodsRowResults);
                varWeightOfEachBox = (int)Math.Floor((varWeight / varNumberOfBoxes.Value) + 0.9999m);
                if (varWeightOfEachBox < 1)
                {
                    varWeightOfEachBox = 1;
                }
                varLastRateChecked = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, customerDetails.PostalCode, CartTotal, varExpressMailZone, customerDetails.StateProvince, customerDetails.Country, varWeightOfEachBox, varNumberOfBoxes.Value, varWeight, "No", varResidentialDelivery, varPriceGroup);
                if (varLastRateChecked != -1)
                {
                    if (varShippingCharge == 0 || varLastRateChecked < varShippingCharge)
                    {
                        varShippingCharge = varLastRateChecked;
                    }
                }
            }
            // 'First Class Mail International
            if (varAirMailLetterPostZone != "NA" && varWeightInDecimal <= 3)
            {
                var shippingMethod = "ALP";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);

                varNumberOfBoxes = await Z_SHIPX_FigureNumberOfBoxesAsync(customerDetails.Country, NameOfCart, shippingMethod, (int)varWeightInDecimal, (int)varWeightOfProductInGrams, shippingMethodsRowResults);
                varWeightOfEachBox = (int)Math.Floor((varWeightInDecimal / varNumberOfBoxes.Value) + 0.9999m);
                varLastRateChecked = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, customerDetails.PostalCode, CartTotal, varAirMailLetterPostZone, customerDetails.StateProvince, customerDetails.Country, varWeightInDecimal, varNumberOfBoxes.Value, varWeightInDecimal, "No", varResidentialDelivery, varPriceGroup);
                if (varLastRateChecked != -1)
                {
                    if (varShippingCharge == 0 || varLastRateChecked < varShippingCharge)
                    {
                        varShippingCharge = varLastRateChecked;
                    }
                }
            }
            // 'Priority Mail International
            if (varAirParcelPostZone != "NA" && varWeightInDecimal > 3)
            {
                var shippingMethod = "APP";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);

                varNumberOfBoxes = await Z_SHIPX_FigureNumberOfBoxesAsync(customerDetails.Country, NameOfCart, shippingMethod, (int)varWeight, (int)varWeightOfProductInGrams, shippingMethodsRowResults);
                varWeightOfEachBox = (int)Math.Floor((varWeight / varNumberOfBoxes.Value) + 0.9999m);
                if (varWeightOfEachBox < 1)
                {
                    varWeightOfEachBox = 1;
                }
                varLastRateChecked = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, customerDetails.PostalCode, CartTotal, varAirParcelPostZone, customerDetails.StateProvince, customerDetails.Country, varWeightOfEachBox, varNumberOfBoxes.Value, varWeight, "No", varResidentialDelivery, varPriceGroup);
                if (varLastRateChecked != -1)
                {
                    if (varShippingCharge == 0 || varLastRateChecked < varShippingCharge)
                    {
                        varShippingCharge = varLastRateChecked;
                    }
                }
            }
            // 'Express Mail International
            if (varGlobalExpressZone != "NA")
            {
                var shippingMethod = "GE";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);

                varNumberOfBoxes = await Z_SHIPX_FigureNumberOfBoxesAsync(customerDetails.Country, NameOfCart, shippingMethod, (int)varWeight, (int)varWeightOfProductInGrams, shippingMethodsRowResults);
                varWeightOfEachBox = (int)Math.Floor((varWeight / varNumberOfBoxes.Value) + 0.9999m);
                if (varWeightOfEachBox < 1)
                {
                    varWeightOfEachBox = 1;
                }
                varLastRateChecked = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, customerDetails.PostalCode, CartTotal, varGlobalExpressZone, customerDetails.StateProvince, customerDetails.Country, varWeightOfEachBox, varNumberOfBoxes.Value, varWeight, "No", varResidentialDelivery, varPriceGroup);
                if (varLastRateChecked != -1)
                {
                    if (varShippingCharge == 0 || varLastRateChecked < varShippingCharge)
                    {
                        varShippingCharge = varLastRateChecked;
                    }
                }
            }
            // 'UPS Ground
            if (varUPSGroundZone != "NA")
            {
                var shippingMethod = "UPSGR";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);

                varNumberOfBoxes = await Z_SHIPX_FigureNumberOfBoxesAsync(customerDetails.Country, NameOfCart, shippingMethod, (int)varWeight, (int)varWeightOfProductInGrams, shippingMethodsRowResults);
                varWeightOfEachBox = (int)Math.Floor((varWeight / varNumberOfBoxes.Value) + 0.9999m);
                if (varWeightOfEachBox < 1)
                {
                    varWeightOfEachBox = 1;
                }
                varLastRateChecked = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, customerDetails.PostalCode, CartTotal, varUPSGroundZone, customerDetails.StateProvince, customerDetails.Country, varWeightOfEachBox, varNumberOfBoxes.Value, varWeight, "No", varResidentialDelivery, varPriceGroup);
                if (varLastRateChecked != -1)
                {
                    if (varShippingCharge == 0 || varLastRateChecked < varShippingCharge)
                    {
                        varShippingCharge = varLastRateChecked;
                    }
                }
            }
            // 'DHL International Economy
            if (varDHLInternationalZone != "NA")
            {
                varNumberOfBoxes = 1;
                varWeightOfEachBox = (int)Math.Floor((varWeight / varNumberOfBoxes.Value) + 0.9999m);
                if (varWeightOfEachBox < 1)
                {
                    varWeightOfEachBox = 1;
                }
                varLastRateChecked = await Z_SHIPX_FigureShippingCost("DHLIE", NameOfCart, customerDetails.PostalCode, CartTotal, varDHLInternationalZone, customerDetails.StateProvince, customerDetails.Country, varWeightOfEachBox, varNumberOfBoxes.Value, varWeight, "No", varResidentialDelivery, varPriceGroup);
                if (varLastRateChecked != -1)
                {
                    if (varShippingCharge == 0 || varLastRateChecked < varShippingCharge)
                    {
                        varShippingCharge = varLastRateChecked;
                    }
                }
            }
            // 'FedEx Ground
            if (varFedExGroundZone != "NA")
            {
                var shippingMethod = "FEGR";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);

                varNumberOfBoxes = await Z_SHIPX_FigureNumberOfBoxesAsync(customerDetails.Country, NameOfCart, shippingMethod, (int)varWeight, (int)varWeightOfProductInGrams, shippingMethodsRowResults);
                varWeightOfEachBox = (int)Math.Floor((varWeight / varNumberOfBoxes.Value) + 0.9999m);
                if (varWeightOfEachBox < 1)
                {
                    varWeightOfEachBox = 1;
                }
                varLastRateChecked = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, customerDetails.PostalCode, CartTotal, varFedExGroundZone, customerDetails.StateProvince, customerDetails.Country, varWeightOfEachBox, varNumberOfBoxes.Value, varWeight, "No", varResidentialDelivery, varPriceGroup);
                if (varLastRateChecked != -1)
                {
                    if (varShippingCharge == 0 || varLastRateChecked < varShippingCharge)
                    {
                        varShippingCharge = varLastRateChecked;
                    }
                }
            }
            // 'FedEx 2 Day
            if (varFedExExpressZone != "NA")
            {
                var shippingMethod = "FE2D";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);

                varNumberOfBoxes = await Z_SHIPX_FigureNumberOfBoxesAsync(customerDetails.Country, NameOfCart, shippingMethod, (int)varWeight, (int)varWeightOfProductInGrams, shippingMethodsRowResults);
                varWeightOfEachBox = (int)Math.Floor((varWeight / varNumberOfBoxes.Value) + 0.9999m);
                if (varWeightOfEachBox < 1)
                {
                    varWeightOfEachBox = 1;
                }
                varLastRateChecked = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, customerDetails.PostalCode, CartTotal, varFedExExpressZone, customerDetails.StateProvince, customerDetails.Country, varWeightOfEachBox, varNumberOfBoxes.Value, varWeight, "No", varResidentialDelivery, varPriceGroup);
                if (varLastRateChecked != -1)
                {
                    if (varShippingCharge == 0 || varLastRateChecked < varShippingCharge)
                    {
                        varShippingCharge = varLastRateChecked;
                    }
                }
            }
            // 'FedEx International Economy
            if (varFedExInternationalEconomyZone != "NA")
            {
                var shippingMethod = "FEINTE";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);

                varNumberOfBoxes = await Z_SHIPX_FigureNumberOfBoxesAsync(customerDetails.Country, NameOfCart, shippingMethod, (int)varWeight, (int)varWeightOfProductInGrams, shippingMethodsRowResults);
                varWeightOfEachBox = (int)Math.Floor((varWeight / varNumberOfBoxes.Value) + 0.9999m);
                if (varWeightOfEachBox < 1)
                {
                    varWeightOfEachBox = 1;
                }
                varLastRateChecked = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, customerDetails.PostalCode, CartTotal, varFedExInternationalEconomyZone, customerDetails.StateProvince, customerDetails.Country, varWeightOfEachBox, varNumberOfBoxes.Value, varWeight, "No", varResidentialDelivery, varPriceGroup);
                if (varLastRateChecked != -1)
                {
                    if (varShippingCharge == 0 || varLastRateChecked < varShippingCharge)
                    {
                        varShippingCharge = varLastRateChecked;
                    }
                }
            }
            // 'FedEx International Priority
            if (varFedExInternationalPriorityZone != "NA")
            {
                var shippingMethod = "FEINTP";
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);

                varNumberOfBoxes = await Z_SHIPX_FigureNumberOfBoxesAsync(customerDetails.Country, NameOfCart, shippingMethod, (int)varWeight, (int)varWeightOfProductInGrams, shippingMethodsRowResults);
                varWeightOfEachBox = (int)Math.Floor((varWeight / varNumberOfBoxes.Value) + 0.9999m);
                if (varWeightOfEachBox < 1)
                {
                    varWeightOfEachBox = 1;
                }
                varLastRateChecked = await Z_SHIPX_FigureShippingCost(shippingMethod, NameOfCart, customerDetails.PostalCode, CartTotal, varFedExInternationalPriorityZone, customerDetails.StateProvince, customerDetails.Country, varWeightOfEachBox, varNumberOfBoxes.Value, varWeight, "No", varResidentialDelivery, varPriceGroup);
                if (varLastRateChecked != -1)
                {
                    if (varShippingCharge == 0 || varLastRateChecked < varShippingCharge)
                    {
                        varShippingCharge = varLastRateChecked;
                    }
                }
            }
            return varShippingCharge;
        }

        Dictionary<string, List<spGetWebSHIPX_ShippingHolidaysOutboundRowResult>> shippingHolidaysCacheByDate = new();

        private async Task<List<spGetWebSHIPX_ShippingHolidaysOutboundRowResult>> GetWebSHIPX_ShippingHolidaysOutboundRowCache(DateTime date)
        {
            DateTime normalizedDate = date.Date;
            string dateStr = normalizedDate.ToString("yyyy-MM-dd");
            bool isCached = shippingHolidaysCacheByDate.TryGetValue(dateStr, out var cachedResult);
            if (!isCached || cachedResult == null)
            {
                cachedResult = await _procedures.spGetWebSHIPX_ShippingHolidaysOutboundRowAsync(normalizedDate);
                shippingHolidaysCacheByDate.Add(dateStr, cachedResult);
            }
            return cachedResult;
        }

        Dictionary<string, List<spGetWebCountryShippingZonesTRowResult>> shippingZonesCacheByCountry = new();

        private async Task<List<spGetWebCountryShippingZonesTRowResult>> GetShippingZonesCacheByCountry(string country)
        {
            shippingZonesCacheByCountry.TryGetValue(country, out var cachedResult);
            if (cachedResult == null)
            {
                cachedResult = await _procedures.spGetWebCountryShippingZonesTRowAsync(country);
                shippingZonesCacheByCountry.Add(country, cachedResult);
            }
            return cachedResult;
        }

        Dictionary<(string country, string stateProvince), List<spGetWebCountryStateProvincesListRowResult>> webCountryStateProvincesListCache = new();

        private async Task<List<spGetWebCountryStateProvincesListRowResult>> GetWebCountryStateProvincesListCache(string country, string stateProvince)
        {
            webCountryStateProvincesListCache.TryGetValue((country, stateProvince), out var cachedResult);
            if (cachedResult == null)
            {
                cachedResult = await _procedures.spGetWebCountryStateProvincesListRowAsync(country, stateProvince);
                webCountryStateProvincesListCache.Add((country, stateProvince), cachedResult);
            }
            return cachedResult;
        }
        Dictionary<string, List<spGetWebSHIPX_MaxWeightOfBoxForPackingResult>> spGetWebSHIPX_MaxWeightOfBoxForPackingCache = new();

        private async Task<List<spGetWebSHIPX_MaxWeightOfBoxForPackingResult>> GetWebSHIPX_MaxWeightOfBoxForPackingCache(string cartName)
        {
            spGetWebSHIPX_MaxWeightOfBoxForPackingCache.TryGetValue(cartName, out var cachedResult);
            if (cachedResult == null)
            {
                cachedResult = await _procedures.spGetWebSHIPX_MaxWeightOfBoxForPackingAsync(cartName);
                spGetWebSHIPX_MaxWeightOfBoxForPackingCache.Add(cartName, cachedResult);
            }
            return cachedResult;
        }

        Dictionary<string, List<spCheckForLPor12InchInCartResult>> spCheckForLPor12InchInCartCache = new();

        private async Task<List<spCheckForLPor12InchInCartResult>> CheckForLPor12InchInCartCache(string cartName)
        {
            spCheckForLPor12InchInCartCache.TryGetValue(cartName, out var cachedResult);
            if (cachedResult == null)
            {
                cachedResult = await _procedures.spCheckForLPor12InchInCartAsync(cartName);
                spCheckForLPor12InchInCartCache.Add(cartName, cachedResult);
            }
            return cachedResult;
        }

        private async Task<int> Z_SHIPX_FigureNumberOfBoxesAsync(string subVarCountry, string subVarNameOfCart, string subVarShippingMethod, int subVarWeight, int varWeightOfProductInGrams, List<spGetShippingMethodsRowResult> shippingMethodsRowResults)
        {
            int numOfBoxes = 1;
            if (string.IsNullOrWhiteSpace(subVarNameOfCart) || string.IsNullOrWhiteSpace(subVarShippingMethod) || subVarWeight == 0)
            {
                return numOfBoxes;
            }

            int varWeightInGrams = subVarWeight.ConvertToGrams();
            int varMaxBoxWeightInGrams = 0;
            int subVarMaxWeightOfBoxInGramsForShippingMethod = 0;
            int varMaxWeightOfBoxInGramsForPacking = 0;
            //int varWeightOfProductInGrams = 0;

            //var weightOfProductResults = await _procedures.spGetWeightOfProductAsync(subVarNameOfCart);
            //if (weightOfProductResults.Any())
            //{
            //    varWeightOfProductInGrams = Convert.ToInt32(weightOfProductResults.First().sumweight);
            //}

            spGetShippingMethodsRowResult shippingMethodRow = new();
            if (shippingMethodsRowResults == null)
            {
                shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(subVarShippingMethod);
            }
            if (shippingMethodsRowResults.Any())
            {
                shippingMethodRow = shippingMethodsRowResults.First();
                subVarMaxWeightOfBoxInGramsForShippingMethod = (shippingMethodRow.MaxWeightOfBox ?? 0).ConvertToGrams();
            }

            if (subVarShippingMethod == "GE" || subVarShippingMethod == "APP")
            {
                spGetWebCountryShippingZonesTRowResult shippingZonesTRowResult = new();

                var shippingZonesTRowResults = await GetShippingZonesCacheByCountry(subVarCountry);
                if (shippingZonesTRowResults.Any())
                {
                    shippingZonesTRowResult = shippingZonesTRowResults.First();
                    if (subVarShippingMethod == "APP")
                    {
                        subVarMaxWeightOfBoxInGramsForShippingMethod = shippingZonesTRowResult.AirParcelPostWeightLimit ?? 44;
                    }
                    else
                    {
                        subVarMaxWeightOfBoxInGramsForShippingMethod = shippingZonesTRowResult.GlobalExpressWeightLimit ?? 44;
                    }
                }
                else
                {
                    subVarMaxWeightOfBoxInGramsForShippingMethod = 19976;
                    return numOfBoxes;
                }
            }
            var webSHIPX_MaxWeightOfBoxForPackingResults = await GetWebSHIPX_MaxWeightOfBoxForPackingCache(subVarNameOfCart);
            if (webSHIPX_MaxWeightOfBoxForPackingResults.Any())
            {
                varMaxWeightOfBoxInGramsForPacking = webSHIPX_MaxWeightOfBoxForPackingResults.First().MaxWeightInGrams ?? 0;
            }
            varMaxBoxWeightInGrams = subVarMaxWeightOfBoxInGramsForShippingMethod;
            if (varMaxBoxWeightInGrams > varMaxWeightOfBoxInGramsForPacking)
            {
                varMaxBoxWeightInGrams = varMaxWeightOfBoxInGramsForPacking;
            }

            if (varWeightOfProductInGrams < varMaxBoxWeightInGrams)
            {
                numOfBoxes = 1;
            }
            else
            {
                numOfBoxes = (varWeightOfProductInGrams / varMaxBoxWeightInGrams) + 1;
            }
            return numOfBoxes;
        }
        public async Task<decimal> Z_SHIPX_FigureShippingCost(string shippingMethod, string cartName, string postalCode, decimal costOfGoods,
            string zone, string stateProvince, string country, decimal weightOfEachBox, int numberOfBoxes, decimal weightOfShipment,
            string cod, string residentialDelivery, string priceGroup)
        {
            decimal Z_SHIPX_FigureShippingCost_ReturnValue = -1m;
            // 1. Initial validation
            if (string.IsNullOrEmpty(zone) || string.IsNullOrEmpty(country)) return Z_SHIPX_FigureShippingCost_ReturnValue;
            if (string.IsNullOrEmpty(priceGroup)) priceGroup = "RetailPrice";

            List<spGetShippingMethodsRowResult>? shippingMethodsRowResults = new();
            spGetShippingMethodsRowResult shippingMethodRow = new();
            shippingMethodsRowResults = await _procedures.spGetShippingMethodsRowAsync(shippingMethod);
            if (shippingMethodsRowResults.Any())
            {
                shippingMethodRow = shippingMethodsRowResults.First();
            }
            spGetWebCountryShippingZonesTRowResult shippingZonesTRowResult = new();
            var shippingZonesTRowResults = await GetShippingZonesCacheByCountry(country);
            if (shippingZonesTRowResults.Any())
            {
                shippingZonesTRowResult = shippingZonesTRowResults.First();
            }
            var countryStateProvincesListRowResult = new spGetWebCountryStateProvincesListRowResult();
            if (country == "USA")
            {
                var countryStateProvincesListRowResults = await GetWebCountryStateProvincesListCache(country, stateProvince);
                if (countryStateProvincesListRowResults.Any())
                {
                    countryStateProvincesListRowResult = countryStateProvincesListRowResults.First();
                }
                else
                {
                    Z_SHIPX_FigureShippingCost_ReturnValue = -1;
                }
            }
            // 'Check Web Wholesale US Mail Not Allowed Country
            if (shippingMethod != "ALP" && shippingMethodRow.ShippingViaCompany == "US Mail" && priceGroup == AppConstants.PriceGroups.RetailPrice && shippingZonesTRowResult.WebUSMailWholesaleAllowed?.ToUpper() == "N")
            {
                Z_SHIPX_FigureShippingCost_ReturnValue = -1;
                return Z_SHIPX_FigureShippingCost_ReturnValue;
            }

            //'Check subVarZone parameter
            if (string.IsNullOrWhiteSpace(zone) || zone == "NA")
            {
                Z_SHIPX_FigureShippingCost_ReturnValue = -1;
                return Z_SHIPX_FigureShippingCost_ReturnValue;
            }
            // 'DHL International Express -------------------------------------------------------------------------------------------
            if (shippingMethod == "DHLIE")
            {
                if (!shippingZonesTRowResults.Any())
                {
                    Z_SHIPX_FigureShippingCost_ReturnValue = -1;
                    return Z_SHIPX_FigureShippingCost_ReturnValue;
                }
                return shippingZonesTRowResult.DHLFlatRate; // Round to 2 decimals // FormatNumber(readerZ("DHLFlatRate"), 2)
            }
            // 'ALL OTHER SHIPPING METHODS ------------------------------------------------------------------------------------------

            // 'Check for Zone in Shipping Table
            bool isZoneOk = await IsZoneValidInTableAsync(shippingMethodRow.ShippingCostTableName, zone);
            if (!isZoneOk)
            {
                Z_SHIPX_FigureShippingCost_ReturnValue = -1;
                return Z_SHIPX_FigureShippingCost_ReturnValue;
            }

            // 'Check COD parameter
            if (cod.ToUpper() == "YES" && shippingMethodRow.CODOK == "N")
            {
                Z_SHIPX_FigureShippingCost_ReturnValue = -1;
                return Z_SHIPX_FigureShippingCost_ReturnValue;
            }

            // 'Check Domestic parameter
            if (country == "USA" && shippingMethodRow.Domestic == "N")
            {
                Z_SHIPX_FigureShippingCost_ReturnValue = -1;
                return Z_SHIPX_FigureShippingCost_ReturnValue;
            }
            // 'Check International parameter
            if (country != "USA" && shippingMethodRow.International == "N")
            {
                Z_SHIPX_FigureShippingCost_ReturnValue = -1;
                return Z_SHIPX_FigureShippingCost_ReturnValue;
            }
            // 'Check US Possession parameter
            if (country == "USA")
            {
                var abbr = countryStateProvincesListRowResult.StateProvinceAbbreviation;
                // US Possessions
                if (new[] { "PR", "VI", "GU" }.Contains(abbr) && shippingMethodRow.USPossessions == "N")
                    return -1;

                // 'Check Hawaii parameter
                // Hawaii
                if (abbr == "HI" && shippingMethodRow.Hawaii == "N")
                    return -1;

                // 'Check Alaska parameter
                // Alaska
                if (abbr == "AK" && shippingMethodRow.Alaska == "N")
                    return -1;

                // 'Check Military Address parameter
                // Military (APO/FPO/DPO)
                if (new[] { "AA", "AE", "AP" }.Contains(abbr) && shippingMethodRow.MilitaryAddressOK == "N")
                    return -1;

            }

            // 'Check Minimum Shipment Weight parameter
            if (weightOfShipment < shippingMethodRow.MinimumWeightOfShipment)
            {
                return -1;
            }

            // 'Shipping Rate from Table
            decimal baseCost = await GetShippingRateFromTableAsync(
                shippingMethodRow.ShippingCostTableName,
                zone,
                shippingMethod,
                (decimal)weightOfEachBox,
                numberOfBoxes
            );
            if (baseCost != -1)
            {
                Z_SHIPX_FigureShippingCost_ReturnValue = baseCost;
            }

            // 'Check for Alternate Flat Rate
            // 2. Check for Alternate Flat Rate (Bulk shipment discount)
            if (shippingMethodRow.ShipmentFlatRateWeight.HasValue && weightOfShipment >= shippingMethodRow.ShipmentFlatRateWeight)
            {
                decimal thresholdBaseRate = await GetShippingRateFromTableAsync(
                    shippingMethodRow.ShippingCostTableName,
                    zone,
                    AppConstants.FLAT_RATE, // Passing a dummy string to force the '=' logic in your method
                    (decimal)shippingMethodRow.ShipmentFlatRateWeight,
                    1
                );
                if (thresholdBaseRate > 0)
                {
                    // Math: (Rate at threshold / Threshold Weight) * Actual Total Shipment Weight
                    decimal flatRatePerPound = thresholdBaseRate / (decimal)shippingMethodRow.ShipmentFlatRateWeight;
                    baseCost = flatRatePerPound * (decimal)weightOfShipment;
                }
            }

            if (baseCost != -1)
            {
                Z_SHIPX_FigureShippingCost_ReturnValue = baseCost;
            }
            if (Z_SHIPX_FigureShippingCost_ReturnValue == -1) return Z_SHIPX_FigureShippingCost_ReturnValue;

            // 'Fuel Surcharge
            decimal fuleSurcharge = Convert.ToDecimal(shippingMethodRow.FuelSurcharge.HasValue ? shippingMethodRow.FuelSurcharge.Value : 0);
            Z_SHIPX_FigureShippingCost_ReturnValue = Z_SHIPX_FigureShippingCost_ReturnValue * (1 + fuleSurcharge);
            // 'Residential Delivery Charge
            if (residentialDelivery.ToUpper() == AppConstants.YES)
            {
                Z_SHIPX_FigureShippingCost_ReturnValue += shippingMethodRow.ResidentialDeliveryCharge ?? 0;
            }
            // 'DutyCost by ShippingMethod
            decimal ourDutyCostPercent = Convert.ToDecimal(shippingMethodRow.OurDutyCostPercent.HasValue ? shippingMethodRow.OurDutyCostPercent.Value : 0);
            Z_SHIPX_FigureShippingCost_ReturnValue = Z_SHIPX_FigureShippingCost_ReturnValue + (costOfGoods * ourDutyCostPercent);

            // 'Duty cost for Japan Retail Fedex
            decimal dutyShippingCostPercent = Convert.ToDecimal(shippingZonesTRowResult.DutyShippingCostPercent.HasValue ? shippingZonesTRowResult.DutyShippingCostPercent.Value : 0);
            if (country == "Japan" && shippingMethod.StartsWith("FE") && priceGroup == AppConstants.PriceGroups.RetailPrice)
            {
                Z_SHIPX_FigureShippingCost_ReturnValue = Z_SHIPX_FigureShippingCost_ReturnValue + (costOfGoods * dutyShippingCostPercent);
            }
            // 'Saturday Delivery
            Z_SHIPX_FigureShippingCost_ReturnValue = Z_SHIPX_FigureShippingCost_ReturnValue + (shippingMethodRow.SaturdayDeliveryCharge ?? 0m);

            // 'Okinawa Parameter
            if (stateProvince == "Okinawa" && (shippingMethod.StartsWith("FEINTP") || shippingMethod.StartsWith("FEINTE")))
            {
                Z_SHIPX_FigureShippingCost_ReturnValue += 28;
            }

            // 'Our Surcharges-------------------------------------------------------------------------------------------------------

            // 'WebSHIPX_DefaultShippingCharges Surcharge Table
            Z_SHIPX_FigureShippingCost_ReturnValue = await ApplySurchargesAsync(Z_SHIPX_FigureShippingCost_ReturnValue, priceGroup, shippingMethod, weightOfShipment, costOfGoods);

            // 'LP or 12 Inch Surcharge
            spCheckForLPor12InchInCartResult lPor12InchInCartResult = new();
            List<spCheckForLPor12InchInCartResult> spCheckForLPor12InchInCartResults = await CheckForLPor12InchInCartCache(cartName);
            if (spCheckForLPor12InchInCartResults.Any())
            {
                Z_SHIPX_FigureShippingCost_ReturnValue += shippingMethodRow.LPor12InchSurcharge;
            }

            // 'Australia Surcharge For Fedex
            if ((shippingMethod.StartsWith("FEINTE") || shippingMethod.StartsWith("FEINTP")) && country.ToUpper() == "AUSTRALIA")
            {
                Z_SHIPX_FigureShippingCost_ReturnValue += 25;
            }

            // 'New Zealand Surcharge For Fedex
            if ((shippingMethod.StartsWith("FEINTE") || shippingMethod.StartsWith("FEINTP")) && country.ToUpper() == "NEW ZEALAND")
            {
                Z_SHIPX_FigureShippingCost_ReturnValue += 59;
            }

            // 'Check for Minumum Order Amount For Flat Shipping Charge
            decimal minOrderForFlatShippingCharge = 200000m;
            decimal flatShippingCharge = 0m;

            List<spGetMinimumFlatShippngChargeResult> spGetMinimumFlatShippngChargeResults = await _procedures.spGetMinimumFlatShippngChargeAsync(shippingMethod);

            if (spGetMinimumFlatShippngChargeResults.Any())
            {
                var result = spGetMinimumFlatShippngChargeResults.First();
                minOrderForFlatShippingCharge = result.CustomFlatShippingChargeSpendThreshold ?? 200000m;
                flatShippingCharge = result.CustomFlatShippingCharge ?? 0m;
                if (minOrderForFlatShippingCharge == 0)
                {
                    minOrderForFlatShippingCharge = 200000m;
                }
            }
            if (costOfGoods >= minOrderForFlatShippingCharge && flatShippingCharge < Z_SHIPX_FigureShippingCost_ReturnValue)
            {
                Z_SHIPX_FigureShippingCost_ReturnValue = flatShippingCharge;
            }
            Z_SHIPX_FigureShippingCost_ReturnValue = Math.Round(Z_SHIPX_FigureShippingCost_ReturnValue, 2, MidpointRounding.AwayFromZero);

            return Z_SHIPX_FigureShippingCost_ReturnValue;
        }
        private async Task<decimal> ApplySurchargesAsync(decimal z_SHIPX_FigureShippingCost_ReturnValue, string priceGroup, string shippingMethod, decimal weightOfShipment, decimal costOfGoods)
        {
            if (z_SHIPX_FigureShippingCost_ReturnValue <= 0)
                return z_SHIPX_FigureShippingCost_ReturnValue;

            string sql = $@"SELECT * 
                    FROM WebSHIPX_DefaultShippingCharges{priceGroup}
                    WHERE ShippingMethod = @ShippingMethod";

            using (var command = _context.Database.GetDbConnection().CreateCommand())
            {
                command.CommandText = sql;
                var shippingMethodParam = new SqlParameter("@ShippingMethod", SqlDbType.VarChar) { Value = shippingMethod };
                command.Parameters.Add(shippingMethodParam);

                if (command.Connection != null && command.Connection.State != ConnectionState.Open)
                    await command.Connection.OpenAsync();

                using (var reader = await command.ExecuteReaderAsync())
                {
                    if (await reader.ReadAsync())
                    {
                        decimal shippingCostSurcharge = reader["ShippingCostSurcharge"] != DBNull.Value ? Convert.ToDecimal(reader["ShippingCostSurcharge"]) : 0m;
                        decimal amountPerPoundSurcharge = reader["AmountPerPoundSurcharge"] != DBNull.Value ? Convert.ToDecimal(reader["AmountPerPoundSurcharge"]) : 0m;
                        decimal percentOfPurchaseValueSurcharge = reader["PercentOfPurchaseValueSurcharge"] != DBNull.Value ? Convert.ToDecimal(reader["PercentOfPurchaseValueSurcharge"]) : 0m;
                        decimal flatAmountSurcharge = reader["FlatAmountSurcharge"] != DBNull.Value ? Convert.ToDecimal(reader["FlatAmountSurcharge"]) : 0m;

                        z_SHIPX_FigureShippingCost_ReturnValue = z_SHIPX_FigureShippingCost_ReturnValue +
                            (shippingCostSurcharge * z_SHIPX_FigureShippingCost_ReturnValue) +
                            (amountPerPoundSurcharge * weightOfShipment) +
                            (percentOfPurchaseValueSurcharge * costOfGoods) +
                            flatAmountSurcharge;
                    }
                }
            }
            return z_SHIPX_FigureShippingCost_ReturnValue;
            //strSQL = "select * from WebSHIPX_DefaultShippingCharges" & subVarPriceGroup _
            // & " where ShippingMethod ='" & subVarShippingMethod & "'"
            //Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
            //    SqlConnection.ClearPool(conn)
            //    conn.Open()
            //    Dim CMD_S5 As New SqlCommand(strSQL, conn)
            //    CMD_S5.CommandType = Data.CommandType.Text
            //    Dim readerS5 As SqlDataReader
            //    readerS5 = CMD_S5.ExecuteReader
            //    If readerS5.HasRows Then
            //        readerS5.Read()
            //        Z_SHIPX_FigureShippingCost = Z_SHIPX_FigureShippingCost + (readerS5("ShippingCostSurcharge") * Z_SHIPX_FigureShippingCost) + (readerS5("AmountPerPoundSurcharge") * subVarWeightOfShipment) + (readerS5("PercentOfPurchaseValueSurcharge") * subVarCostOfGoods) + readerS5("FlatAmountSurcharge")
            //    End If
            //End Using
        }
        public async Task<decimal> GetShippingRateFromTableAsync(string tableName, string zone, string method, decimal weightOfEachBox, int numberOfBoxes)
        {
            // 1. Sanitize/Format Column and Table Names
            string zoneColumn = $"Zone{zone}";
            string fullTableName = $"Web{tableName}";

            // 2. Determine Logic: FC/ALP use "Next Weight Up", others use "Exact Weight"
            bool isRangeBased = (method == "FC" || method == "ALP");
            string operatorSign = isRangeBased ? ">=" : "=";
            string orderBy = isRangeBased ? " ORDER BY WeightInPounds ASC" : "";

            // 3. Build the Query (Top 1 ensures we only get the closest match for range-based)
            string sql = $@"SELECT TOP 1 {zoneColumn} 
                    FROM {fullTableName} 
                    WHERE WeightInPounds {operatorSign} @Weight 
                    {orderBy}";

            using (var command = _context.Database.GetDbConnection().CreateCommand())
            {
                command.CommandText = sql;
                //var weightParam = new SqlParameter("@Weight", SqlDbType.Decimal) { Value = weightOfEachBox };
                //SqlDbType weightType = GetSqlTypeForTable(fullTableName);
                //var weightParam = new SqlParameter("@Weight", weightType) { Value = weightOfEachBox };
                var dbType = GetSqlTypeAndValue(fullTableName, weightOfEachBox, out object parameterValue);
                var weightParam = new SqlParameter("@Weight", dbType) { Value = parameterValue };
                command.Parameters.Add(weightParam);

                if (command.Connection != null && command.Connection.State != ConnectionState.Open)
                    await command.Connection.OpenAsync();

                using (var reader = await command.ExecuteReaderAsync())
                {
                    if (await reader.ReadAsync())
                    {
                        decimal rate = reader[0] != DBNull.Value ? Convert.ToDecimal(reader[0]) : 0m;
                        if (method == AppConstants.FLAT_RATE)
                        {
                            return rate;
                        }
                        // Retrieve the rate and multiply by number of boxes
                        decimal totalCost = rate * numberOfBoxes;

                        // 4. Apply Legacy FedEx Rounding Rules
                        if (IsFedExMethod(method))
                        {
                            totalCost = Math.Round(totalCost, 2, MidpointRounding.AwayFromZero);
                        }

                        return totalCost;
                    }
                }
            }

            return -1; // Indicates no rate found
        }
        private SqlDbType GetSqlTypeForTable(string fullTableName)
        {
            return fullTableName.ToLower() switch
            {
                var t when t.Contains("internationalpriority") || t.Contains("packet") ||
                           t.Contains("firstclass") || t.Contains("parcelpost") ||
                           t.Contains("globalexpress") || t.Contains("overnight") ||
                           t.Contains("2day") => SqlDbType.Float,

                var t when t.Contains("ground") || t.Contains("economy") => SqlDbType.Int,

                var t when t.Contains("mail") || t.Contains("saver") => SqlDbType.SmallInt,

                _ => SqlDbType.Decimal // Default fallback
            };
        }

        /// <summary>
        /// Maps the table name to the correct SQL Type and applies necessary rounding/ceiling logic.
        /// </summary>
        private SqlDbType GetSqlTypeAndValue(string tableName, decimal weight, out object value)
        {
            string t = tableName.ToLower();

            // CATEGORY A: Tables supporting partial weights (e.g., 0.06, 0.5)
            // Max 2 decimals in data. We use 'double' to match SQL float(53).
            if (t.Contains("firstclass") || t.Contains("smallpacket") || t.Contains("globalexpress"))
            {
                // Round to 2 decimals to clean up decimal noise, then cast to double for SQL float compatibility.
                value = (double)Math.Round(weight, 2, MidpointRounding.AwayFromZero);
                return SqlDbType.Float;
            }

            // CATEGORY B: FLOAT columns that only contain whole numbers
            // Shipping Rule: Any fraction (e.g., 2.1) rounds UP to the next whole pound.
            if (t.Contains("internationalpriority") || t.Contains("overnight") || t.Contains("2day") || t.Contains("parcelpost"))
            {
                value = (double)Math.Ceiling(weight);
                return SqlDbType.Float;
            }

            // CATEGORY C: INT/SMALLINT columns (Ground, Media Mail, etc.)
            // These tables physically cannot store decimals.
            value = (int)Math.Ceiling(weight);

            return (t.Contains("mail") || t.Contains("saver"))
                ? SqlDbType.SmallInt
                : SqlDbType.Int;
        }
        private bool IsFedExMethod(string method)
        {
            string[] fedExMethods = { "FEGR", "FE2D", "FE2DSAT", "FEES", "FEPO", "FEPOSAT", "FESO" };
            return fedExMethods.Contains(method);
        }
        public async Task<bool> IsZoneValidInTableAsync(string tableName, string zone)
        {
            string targetColumn = $"Zone{zone}";

            // We use a raw command here because the result schema is dynamic (depends on tableName)
            using (var command = _context.Database.GetDbConnection().CreateCommand())
            {
                command.CommandText = "spCheckForZoneInShippingTable";
                command.CommandType = CommandType.StoredProcedure;

                var param = command.CreateParameter();
                param.ParameterName = "@TableName";
                param.Value = tableName;
                param.Size = 100;
                param.DbType = DbType.String;
                command.Parameters.Add(param);

                if (command.Connection != null && command.Connection.State != ConnectionState.Open)
                    await command.Connection.OpenAsync();

                using (var reader = await command.ExecuteReaderAsync(CommandBehavior.SchemaOnly))
                {
                    // GetColumnSchema is the modern, high-performance equivalent of looping through FieldCount
                    var schema = await reader.GetColumnSchemaAsync();
                    return schema.Any(c => string.Equals(c.ColumnName, targetColumn, StringComparison.OrdinalIgnoreCase));
                }
            }
        }
        public async Task<string> GetInternationalZoneAsync(string country, string zip, bool isPriority)
        {
            if (country == "USA") return "NA";

            // 1. Handle Canada as a priority exception to avoid unnecessary DB calls
            if (country == "Canada" && !string.IsNullOrEmpty(zip))
            {
                return CalculateCanadianZone(zip.Length >= 3 ? zip.Substring(0, 3) : zip);
            }

            // 2. Fetch from DB for all other countries
            var results = await _procedures.spGetAirParcelPostZoneAsync(country);
            var firstResult = results?.FirstOrDefault();

            if (firstResult == null) return "B"; // Or handle as an error/NA

            return isPriority ? firstResult.FedExInternationalPriorityZone
                              : firstResult.FedExInternationalEconomyZone;
        }
        public async Task<string> Z_SHIPX_FigureFedExInternationalEconomyZoneAsync(string country, string zip)
        {
            // 1. Handle USA
            if (country == "USA") return "NA";

            // 2. Handle Canada using a shared helper (or keep the current block if preferred)
            if (country == "Canada")
            {
                return CalculateCanadianZone(zip);
            }

            var results = await _procedures.spGetAirParcelPostZoneAsync(country);
            var firstResult = results.FirstOrDefault();
            if (firstResult == null) return "NA"; // TODO: Decide on a default or error handling strategy, when country is not CANADA and stored procedure returns no results
            return firstResult.FedExInternationalEconomyZone;
        }
        public async Task<string> Z_SHIPX_FigureFedExInternationalPriorityZoneAsync(string country, string zip)
        {
            if (country == "USA") return "NA";

            // 1. Get base zone from database
            var results = await _procedures.spGetAirParcelPostZoneAsync(country);
            var zone = results.FirstOrDefault()?.FedExInternationalPriorityZone ?? "B";

            // 2. If Canada, override with specific postal code logic
            if (country == "Canada" && !string.IsNullOrEmpty(zip))
            {
                zone = CalculateCanadianZone(zip.Length >= 3 ? zip.Substring(0, 3) : zip);
            }

            return zone;
        }
        private string CalculateCanadianZone(string zip3)
        {
            // We evaluate the ranges as defined in the legacy VB.NET code.
            // If it falls within an "A" range, we return A; otherwise, it defaults to B.
            if (zip3.CompareTo("G9Z") > 0 && zip3.CompareTo("H9Z") <= 0) return "A";
            if (zip3.CompareTo("J2W") > 0 && zip3.CompareTo("J3G") <= 0) return "A";
            if (zip3.CompareTo("J3K") > 0 && zip3.CompareTo("J3N") <= 0) return "A";
            if (zip3.CompareTo("J3T") > 0 && zip3.CompareTo("J4Z") <= 0) return "A";
            if (zip3.CompareTo("J6H") > 0 && zip3.CompareTo("J6R") <= 0) return "A";
            if (zip3.CompareTo("J6V") > 0 && zip3.CompareTo("J7R") <= 0) return "A";
            if (zip3.CompareTo("J8N") > 0 && zip3.CompareTo("J9C") <= 0) return "A";
            if (zip3.CompareTo("K0Z") > 0 && zip3.CompareTo("K2R") <= 0) return "A";
            if (zip3.CompareTo("L0H") > 0 && zip3.CompareTo("L0J") <= 0) return "A";
            if (zip3.CompareTo("L0N") > 0 && zip3.CompareTo("L0P") <= 0) return "A";
            if (zip3.CompareTo("L1E") > 0 && zip3.CompareTo("L1Z") <= 0) return "A";
            if (zip3.CompareTo("L2C") > 0 && zip3.CompareTo("L2W") <= 0) return "A";
            if (zip3.CompareTo("L3N") > 0 && zip3.CompareTo("L3T") <= 0) return "A";
            if (zip3.CompareTo("L3W") > 0 && zip3.CompareTo("L9T") <= 0) return "A";
            if (zip3.CompareTo("L9Z") <= 0 && zip3.CompareTo("M9Z") <= 0) return "A"; // Range coverage
            if (zip3.CompareTo("N1Z") > 0 && zip3.CompareTo("N2V") <= 0) return "A";
            if (zip3.CompareTo("N5T") > 0 && zip3.CompareTo("N6N") <= 0) return "A";
            if (zip3.CompareTo("N8M") > 0 && zip3.CompareTo("N9K") <= 0) return "A";
            if (zip3.CompareTo("R2B") > 0 && zip3.CompareTo("R4A") <= 0) return "A";
            if (zip3.CompareTo("T1X") > 0 && zip3.CompareTo("T3L") <= 0) return "A";
            if (zip3.CompareTo("V1L") > 0 && zip3.CompareTo("V1M") <= 0) return "A";
            if (zip3.CompareTo("V2V") > 0 && zip3.CompareTo("V3E") <= 0) return "A";
            if (zip3.CompareTo("V3G") > 0 && zip3.CompareTo("V4S") <= 0) return "A";
            if (zip3.CompareTo("V4T") > 0 && zip3.CompareTo("V7Z") <= 0) return "A";

            return "B";
        }
        public string Z_SHIPX_FigureFedExExpressZone(string country, string zipCode, string state)
        {
            // 1. Initial Validations
            if (string.IsNullOrWhiteSpace(zipCode) || zipCode.Length < 5 || !int.TryParse(zipCode.Substring(0, 5), out _))
                return "NA";

            if (Models.Shared.AppConstants.ExcludedStates.Contains(state))
                return "NA";

            if (country != "USA")
                return "NA";

            // 2. Extract first 3 digits for zone lookup
            int zip3 = int.Parse(zipCode.Substring(0, 3));

            // 3. Perform the Lookup
            return GetExpressZone(zip3);
        }
        private string Z_SHIPX_FigureGlobalExpressZone(string defaultCountry) => "NA";
        public async Task<string> Z_SHIPX_FigureAirParcelPostZoneAsync(string country)
        {
            // Return early if USA
            if (country == "USA") return "NA";

            // 1. Check if the country is restricted using the same procedure as before
            var restricted = await _procedures.spUSPSNotShippingToAsync(country);
            if (restricted.Any())
            {
                return "NA";
            }

            // 2. Fetch the Air Parcel Post zone
            var results = await _procedures.spGetAirParcelPostZoneAsync(country);
            var record = results.FirstOrDefault();

            // Return the zone if found, otherwise default to "NA"
            return record?.AirParcelPostZone ?? "NA";
        }
        private async Task<string> Z_SHIPX_FigureAirMailLetterPostZoneAsync(string country)
        {
            // Return early if USA
            if (country == "USA") return "NA";

            // 1. Check if shipping is prohibited
            var restricted = await _procedures.spUSPSNotShippingToAsync(country);
            if (restricted.Any())
            {
                return "NA";
            }

            // 2. Fetch the zone
            var results = await _procedures.spGetAirMailLetterPostZoneAsync(country);
            var record = results.FirstOrDefault();

            // Return the zone if found, otherwise default to "NA"
            return record?.AirSmallPacketZone ?? "NA";
        }
        private string Z_SHIPX_FigureMediaMailZone(string country, string state, string priceGroup, string zip)
        {
            // If the country is USA, return "8", otherwise return "NA"
            // We keep the parameters even if unused to match the original signature 
            // for easier porting as per your instructions.
            return (country == "USA") ? "8" : "NA";
        }
        private string Z_SHIPX_FigureExpressMailZone(string country, string state, string varPrieGroup, string varZip3) => "NA";
        public string Z_SHIPX_FigurePriorityMailZone(string country, string zip)
        {
            // 1. Validation
            if (string.IsNullOrWhiteSpace(zip) || zip.Length < 3 || !int.TryParse(zip.Substring(0, 3), out int zip3))
                return "NA";

            if (country != "USA")
                return "NA";

            // 2. Lookup Logic
            // We can use a helper method to map ranges to zones
            return GetPriorityZone(zip3);
        }
        private string Z_SHIPX_FigureUPSGroundCanadaZone(string defaultCountry, string defaultPostalCode) => "NA";
        private string Z_SHIPX_FigureFedExGroundZone(string country, string zipCode, string state)
        {
            // 1. Initial Validation
            if (string.IsNullOrWhiteSpace(zipCode) || zipCode.Length < 5 || !int.TryParse(zipCode, out int fullZip))
                return "NA";

            if (Models.Shared.AppConstants.ExcludedStates.Contains(state))
                return "NA";

            // 3. Zone Logic (Only for USA)
            if (country == "USA")
            {
                int zip3 = int.Parse(zipCode.Substring(0, 3));

                // Using a pattern-matching approach for clarity
                // Note: I've grouped these logic blocks to mirror your original structure
                if (zip3 <= 4 || (zip3 >= 6 && zip3 <= 9) || zip3 == 213 || zip3 == 269 ||
                    zip3 == 343 || zip3 == 345 || zip3 == 348 || zip3 == 353 ||
                    zip3 == 419 || zip3 == 428 || zip3 == 429 || zip3 == 517 ||
                    zip3 == 518 || zip3 == 519 || zip3 == 529 || zip3 == 533 ||
                    zip3 == 536 || zip3 == 552 || zip3 == 578 || zip3 == 579 ||
                    zip3 == 589 || zip3 == 621 || zip3 == 632 || (zip3 >= 642 && zip3 <= 643) ||
                    zip3 == 659 || zip3 == 663 || zip3 == 682 || (zip3 >= 694 && zip3 <= 699) ||
                    zip3 == 702 || zip3 == 709 || zip3 == 715 || zip3 == 732 || zip3 == 742 ||
                    (zip3 >= 817 && zip3 <= 819) || zip3 == 839 || (zip3 >= 848 && zip3 <= 849) ||
                    zip3 == 854 || zip3 == 858 || (zip3 >= 862 && zip3 <= 863) || (zip3 >= 866 && zip3 <= 869) ||
                    zip3 == 876 || (zip3 >= 886 && zip3 <= 888) || zip3 == 892 || zip3 == 896 || zip3 == 899 ||
                    zip3 == 909 || zip3 == 929 || (zip3 >= 967 && zip3 <= 969) || zip3 == 987)
                {
                    return "NA";
                }

                // Return the Zone based on range
                return GetGroundZone(zip3);
            }

            return "NA";
        }
        private string GetPriorityZone(int z)
        {
            // Define zones by ranges. This is much faster to read and update.
            if ((z >= 5 && z <= 374) || z == 344 || (z >= 376 && z <= 379) || z == 384 || z == 385 || z == 388 || (z >= 393 && z <= 395) || (z >= 397 && z <= 427) || (z >= 430 && z <= 475) || (z >= 478 && z <= 497) || (z >= 700 && z <= 704) || (z >= 967 && z <= 969) || (z >= 995 && z <= 997)) return "8";
            if (z == 375 || (z >= 380 && z <= 383) || (z >= 386 && z <= 387) || (z >= 389 && z <= 392) || z == 396 || z == 420 || z == 424 || (z >= 463 && z <= 464) || (z >= 476 && z <= 477) || (z >= 498 && z <= 509) || (z >= 520 && z <= 532) || (z >= 534 && z <= 561) || z == 563 || z == 564 || z == 566 || (z >= 600 && z <= 642) || (z >= 644 && z <= 658) || (z >= 660 && z <= 663) || z == 667 || (z >= 705 && z <= 729) || z == 733 || (z >= 744 && z <= 745) || z == 747 || (z >= 749 && z <= 759) || (z >= 765 && z <= 767) || (z >= 770 && z <= 789) || z == 998) return "7";
            if ((z >= 510 && z <= 516) || z == 562 || z == 565 || z == 567 || (z >= 570 && z <= 576) || (z >= 580 && z <= 588) || (z >= 664 && z <= 666) || (z >= 668 && z <= 681) || (z >= 683 && z <= 692) || (z >= 730 && z <= 731) || (z >= 734 && z <= 741) || z == 743 || z == 746 || z == 748 || (z >= 760 && z <= 764) || (z >= 768 && z <= 769) || (z >= 790 && z <= 797) || z == 881 || z == 999) return "6";
            if ((z >= 590 && z <= 599) || (z >= 798 && z <= 816) || (z >= 820 && z <= 831) || z == 838 || (z >= 850 && z <= 853) || (z >= 855 && z <= 857) || z == 859 || z == 865 || (z >= 870 && z <= 875) || (z >= 877 && z <= 880) || (z >= 882 && z <= 885) || (z >= 980 && z <= 982) || (z >= 990 && z <= 992)) return "5";
            if ((z >= 831 && z <= 837) || (z >= 840 && z <= 847) || z == 860 || z == 863 || z == 864 || (z >= 889 && z <= 891) || z == 893 || z == 898 || (z >= 900 && z <= 908) || (z >= 910 && z <= 928) || (z >= 930 && z <= 931) || z == 934 || (z >= 970 && z <= 974) || (z >= 977 && z <= 979) || (z >= 983 && z <= 986) || (z >= 988 && z <= 989) || (z >= 993 && z <= 994)) return "4";
            if (z == 932 || z == 933 || z == 935 || (z >= 975 && z <= 976)) return "3";
            if ((z >= 894 && z <= 895) || z == 897 || (z >= 936 && z <= 941) || (z >= 943 && z <= 954) || (z >= 960 && z <= 966)) return "2";
            if (z == 942 || (z >= 956 && z <= 959)) return "1";

            return "NA";
        }
        private string GetGroundZone(int zip3)
        {
            // Simplified range checks
            if (zip3 == 375 || (zip3 >= 382 && zip3 <= 383) || (zip3 >= 386 && zip3 <= 387) || (zip3 >= 390 && zip3 <= 392) || zip3 == 396 || zip3 == 420 || zip3 == 424 || (zip3 >= 463 && zip3 <= 464) || zip3 == 477 || (zip3 >= 500 && zip3 <= 509) || (zip3 >= 520 && zip3 <= 528) || (zip3 >= 530 && zip3 <= 532) || (zip3 >= 534 && zip3 <= 535) || (zip3 >= 540 && zip3 <= 551) || (zip3 >= 553 && zip3 <= 560) || (zip3 >= 563 && zip3 <= 564) || zip3 == 566 || (zip3 >= 600 && zip3 <= 620) || (zip3 >= 622 && zip3 <= 631) || (zip3 >= 633 && zip3 <= 641) || (zip3 >= 644 && zip3 <= 658) || (zip3 >= 660 && zip3 <= 662) || zip3 == 667 || (zip3 >= 703 && zip3 <= 704) || (zip3 >= 705 && zip3 <= 708) || (zip3 >= 710 && zip3 <= 714) || (zip3 >= 716 && zip3 <= 729) || zip3 == 733 || (zip3 >= 743 && zip3 <= 745) || zip3 == 747 || (zip3 >= 749 && zip3 <= 759) || (zip3 >= 765 && zip3 <= 767) || (zip3 >= 780 && zip3 <= 787) || zip3 == 789) return "7";
            if (zip3 == 516 || (zip3 >= 561 && zip3 <= 562) || zip3 == 565 || (zip3 >= 567 && zip3 <= 576) || (zip3 >= 580 && zip3 <= 588) || (zip3 >= 664 && zip3 <= 666) || (zip3 >= 668 && zip3 <= 681) || (zip3 >= 683 && zip3 <= 692) || (zip3 >= 730 && zip3 <= 731) || (zip3 >= 740 && zip3 <= 741) || zip3 == 746 || zip3 == 748 || (zip3 >= 760 && zip3 <= 764) || (zip3 >= 768 && zip3 <= 769) || zip3 == 788 || (zip3 >= 790 && zip3 <= 797) || zip3 == 881) return "6";
            if (zip3 == 577 || (zip3 >= 590 && zip3 <= 599) || (zip3 >= 800 && zip3 <= 816) || (zip3 >= 820 && zip3 <= 830) || zip3 == 838 || zip3 == 850 || zip3 == 852 || zip3 == 855 || zip3 == 857 || zip3 == 859 || (zip3 >= 864 && zip3 <= 865) || (zip3 >= 870 && zip3 <= 875) || (zip3 >= 877 && zip3 <= 880) || (zip3 >= 882 && zip3 <= 885) || zip3 == 893) return "5";
            if (zip3 == 831 || (zip3 >= 832 && zip3 <= 837) || (zip3 >= 840 && zip3 <= 847) || zip3 == 853 || zip3 == 860 || zip3 == 864 || (zip3 >= 890 && zip3 <= 891) || zip3 == 893 || (zip3 >= 898 && zip3 <= 908) || (zip3 >= 910 && zip3 <= 928) || (zip3 >= 930 && zip3 <= 931) || (zip3 >= 970 && zip3 <= 974) || (zip3 >= 977 && zip3 <= 979) || (zip3 >= 983 && zip3 <= 986) || (zip3 >= 988 && zip3 <= 989) || (zip3 >= 993 && zip3 <= 994)) return "4";
            if (zip3 >= 932 && zip3 <= 935) return "3";
            if ((zip3 >= 894 && zip3 <= 895) || zip3 == 897 || (zip3 >= 936 && zip3 <= 954) || (zip3 >= 956 && zip3 <= 966)) return "2";

            // Default to 8 for all the ones not explicitly defined but not in the "NA" group
            return "8";
        }
        private string GetExpressZone(int zip3)
        {
            // Return "NA" for specific "holes" in the ZIP range
            if ((zip3 >= 0 && zip3 <= 4) || (zip3 >= 6 && zip3 <= 9) || zip3 == 213 || zip3 == 269 || zip3 == 343 ||
                zip3 == 345 || zip3 == 348 || zip3 == 353 || zip3 == 419 || (zip3 >= 428 && zip3 <= 429) ||
                (zip3 >= 517 && zip3 <= 519) || zip3 == 529 || zip3 == 533 || zip3 == 536 || zip3 == 552 ||
                (zip3 >= 578 && zip3 <= 579) || zip3 == 589 || zip3 == 621 || zip3 == 632 || (zip3 >= 642 && zip3 <= 643) ||
                zip3 == 659 || zip3 == 663 || zip3 == 682 || (zip3 >= 694 && zip3 <= 699) || zip3 == 702 || zip3 == 709 ||
                zip3 == 715 || zip3 == 732 || zip3 == 742 || (zip3 >= 817 && zip3 <= 819) || zip3 == 839 || (zip3 >= 848 && zip3 <= 849) ||
                zip3 == 854 || zip3 == 858 || (zip3 >= 861 && zip3 <= 862) || (zip3 >= 866 && zip3 <= 869) || zip3 == 876 ||
                (zip3 >= 886 && zip3 <= 888) || zip3 == 892 || zip3 == 896 || zip3 == 899 || zip3 == 909 || zip3 == 929 || zip3 == 987)
                return "NA";

            // Mapping ranges to zones
            if (zip3 == 5 || (zip3 >= 10 && zip3 <= 212) || (zip3 >= 214 && zip3 <= 268) || (zip3 >= 270 && zip3 <= 342) || zip3 == 344 || (zip3 >= 346 && zip3 <= 347) || (zip3 >= 349 && zip3 <= 352) || (zip3 >= 354 && zip3 <= 374) || (zip3 >= 376 && zip3 <= 379) || (zip3 >= 384 && zip3 <= 385) || zip3 == 388 || (zip3 >= 393 && zip3 <= 395) || (zip3 >= 397 && zip3 <= 418) || (zip3 >= 430 && zip3 <= 462) || (zip3 >= 465 && zip3 <= 475) || (zip3 >= 478 && zip3 <= 497) || (zip3 >= 967 && zip3 <= 968) || (zip3 >= 995 && zip3 <= 999)) return "8";
            if (zip3 == 375 || (zip3 >= 380 && zip3 <= 383) || (zip3 >= 386 && zip3 <= 387) || (zip3 >= 389 && zip3 <= 392) || zip3 == 396 || zip3 == 420 || zip3 == 424 || (zip3 >= 463 && zip3 <= 464) || (zip3 >= 476 && zip3 <= 477) || (zip3 >= 498 && zip3 <= 509) || (zip3 >= 520 && zip3 <= 528) || (zip3 >= 530 && zip3 <= 532) || (zip3 >= 534 && zip3 <= 535) || (zip3 >= 537 && zip3 <= 551) || (zip3 >= 553 && zip3 <= 560) || zip3 == 564 || zip3 == 566 || (zip3 >= 600 && zip3 <= 620) || (zip3 >= 622 && zip3 <= 631) || (zip3 >= 633 && zip3 <= 641) || (zip3 >= 644 && zip3 <= 658) || (zip3 >= 660 && zip3 <= 662) || zip3 == 667 || (zip3 >= 700 && zip3 <= 701) || (zip3 >= 703 && zip3 <= 704) || (zip3 >= 705 && zip3 <= 708) || (zip3 >= 710 && zip3 <= 714) || (zip3 >= 716 && zip3 <= 729) || zip3 == 733 || (zip3 >= 744 && zip3 <= 745) || zip3 == 747 || (zip3 >= 749 && zip3 <= 759) || (zip3 >= 765 && zip3 <= 767) || (zip3 >= 770 && zip3 <= 787) || zip3 == 789) return "7";
            if ((zip3 >= 510 && zip3 <= 516) || (zip3 >= 561 && zip3 <= 562) || zip3 == 565 || (zip3 >= 570 && zip3 <= 576) || (zip3 >= 580 && zip3 <= 588) || (zip3 >= 664 && zip3 <= 666) || (zip3 >= 668 && zip3 <= 681) || (zip3 >= 683 && zip3 <= 692) || (zip3 >= 730 && zip3 <= 731) || (zip3 >= 734 && zip3 <= 741) || zip3 == 743 || zip3 == 746 || zip3 == 748 || (zip3 >= 760 && zip3 <= 764) || (zip3 >= 768 && zip3 <= 769) || zip3 == 788 || (zip3 >= 790 && zip3 <= 797) || zip3 == 881) return "6";
            if (zip3 == 577 || (zip3 >= 590 && zip3 <= 599) || (zip3 >= 798 && zip3 <= 816) || (zip3 >= 820 && zip3 <= 830) || zip3 == 838 || (zip3 >= 850 && zip3 <= 852) || zip3 == 855 || zip3 == 857 || zip3 == 859 || zip3 == 865 || (zip3 >= 870 && zip3 <= 875) || (zip3 >= 877 && zip3 <= 880) || (zip3 >= 882 && zip3 <= 885) || (zip3 >= 980 && zip3 <= 982) || (zip3 >= 990 && zip3 <= 992)) return "5";
            if ((zip3 >= 831 && zip3 <= 837) || (zip3 >= 840 && zip3 <= 847) || (zip3 >= 850 && zip3 <= 851) || zip3 == 853 || zip3 == 860 || (zip3 >= 863 && zip3 <= 864) || (zip3 >= 889 && zip3 <= 891) || zip3 == 893 || zip3 == 898 || (zip3 >= 900 && zip3 <= 908) || (zip3 >= 910 && zip3 <= 928) || (zip3 >= 930 && zip3 <= 931) || zip3 == 934 || (zip3 >= 970 && zip3 <= 974) || (zip3 >= 977 && zip3 <= 979) || (zip3 >= 983 && zip3 <= 986) || (zip3 >= 988 && zip3 <= 989) || (zip3 >= 993 && zip3 <= 994)) return "4";
            if (zip3 >= 932 && zip3 <= 933 || zip3 == 935 || zip3 == 955 || (zip3 >= 975 && zip3 <= 976)) return "3";
            if ((zip3 >= 894 && zip3 <= 895) || zip3 == 897 || (zip3 >= 936 && zip3 <= 941) || (zip3 >= 943 && zip3 <= 954) || (zip3 >= 956 && zip3 <= 966)) return "2";

            return "NA";
        }
        private string Z_SHIPX_FigureUPSGroundZone(string defaultCountry, string defaultPostalCode, string defaultStateProvince) => "NA";
        private async Task<string> Z_SHIPX_FigureDHLInternationalZoneAsync(string country)
        {
            // Handle the immediate local check
            if (string.IsNullOrEmpty(country) || country == "USA")
            {
                return "NA";
            }

            try
            {
                // Call the generated procedure via the service
                List<spGetAirParcelPostZoneResult> results = await _procedures.spGetAirParcelPostZoneAsync(country);
                spGetAirParcelPostZoneResult? data = results.FirstOrDefault();

                // Check if data exists and the flat rate condition is met
                if (data != null && data.DHLFlatRate != 0)
                {
                    return data.DHLInternationalExpressZone ?? "NA";
                }
            }
            catch (Exception)
            {
                // Log the exception here
                // If the database call fails, return "NA" as a fallback
            }

            return "NA";
        }

    }
}
