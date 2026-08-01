namespace MillionsOfRecordsApp.Models.Shared
{
    public static class AppConstants
    {
        public static string SEOPageNameText(string txt, string fmt, int id, string searchId)
        {
            if (string.IsNullOrWhiteSpace(txt))
                return $"/ItemDetails/Miscellaneous/{id}/";

            // 1. Clean spaces and replace symbol shorthand expressions
            txt = txt.Trim();
            txt = txt.Replace(" & ", " And ").Replace(" + ", " Plus ");

            // 2. Filter string keeping alphanumeric characters and converting spaces to hyphens
            var sb = new System.Text.StringBuilder();
            foreach (char c in txt)
            {
                if (char.IsLetterOrDigit(c))
                {
                    sb.Append(c);
                }
                else if (c == ' ')
                {
                    sb.Append('-');
                }
            }

            string slug = sb.ToString();

            // 3. Collapse multiple consecutive hyphens down to a single hyphen
            while (slug.Contains("--"))
            {
                slug = slug.Replace("--", "-");
            }

            // 4. Resolve the format category directory segment
            string category = fmt switch
            {
                "CD" => "CD",
                "CDS" => "CD",
                "LP" => "Vinyl",
                "CS" => "Tapes",
                "DVD" => "DVD",
                "B" => "Books",
                _ when fmt.StartsWith("V") => "VHS",
                _ when fmt.StartsWith("7") => "Vinyl",
                _ when fmt.StartsWith("12") => "Vinyl",
                _ when fmt.StartsWith("10") => "Vinyl",
                _ => "Miscellaneous"
            };

            // 5. Output the uniform structured routing path
            return $"/ItemDetails/{category}/{id}/{slug}?searchId={searchId}";
        }

        public static class ShopFormats
        {
            public const string Vinyl = "Vinyl";
            public const string CD = "CD";
            public const string LP = "LP";
            public const string SevenInch = "7\"";
            public const string TwelveInch = "12\"";
            public const string TenInch = "10\"";
            public const string TwelveAndTenInch = "12\",10\"";
        }
        public static class ShopSortOrders
        {
            public const string Artist = "1";
            public const string NewestArrivals = "2";
            public const string BestSellers = "3";
            public const string Label = "4";
            public const string PriceHighToLow = "5";
            public const string PriceLowToHigh = "6";
            //public const string BackInStock = "3";
            //public const string UsedCollectible = "4";

        }
        public static class WebSearchSuggestionsSearchTypes
        {
            public const string Rhythm = "Rhythm";
            public const string Genre = "Genre";
            public const string Album = "Album";
            public const string Label = "Label";
            public const string Artist = "Artist";
            public const string ItemFeature = "Item Feature";
        }
        public static class PriceGroups
        {
            public const string NoPrice = "";
            public const string RetailPrice = "RetailPrice";
            public const string StorePrice = "StorePrice";
        }
        public static readonly HashSet<string> ExcludedStates = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
        {
            "AA (Military)", "AE (Military)", "AP (Military)", "American Samoa", "Guam",
            "Marshall Islands", "Micronesia", "Northern Mariana Islands", "Palau",
            "Puerto Rico", "Virgin Islands (U.S.)", "Alaska", "Hawaii"
        };
        public const string FLAT_RATE = "FLATE_RATE";
        public const string NA = "NA";
        public const string YES = "YES";
        public const string NO = "NO";
        public const string Y = "Y";
        public const string N = "N";

        public static List<string> Countries { get; set; } = new()
        {
            "USA (50 States)", "USA (American Samoa)", "USA (Guam)", "USA (Marshall Islands)",
            "USA (Micronesia)", "USA (Northern Mariana Islands)", "USA (Palau)", "USA (Puerto Rico)",
            "USA (US Virgin Islands)", "USA (Military Address APO, AA)", "USA (Military Address APO, AE)",
            "USA (Military Address APO, AP)", "USA (Military Address FPO, AA)", "USA (Military Address FPO, AE)",
            "USA (Military Address FPO, AP)", "Abu Dhabi (United Arab Emirates)", "Albania", "Algeria",
            "American Samoa (U.S. Possession)", "Andorra", "Angola", "Anguilla", "Antigua & Barbuda",
            "APO, AA (USA Military Address)", "APO, AE (USA Military Address)", "APO, AP (USA Military Address)",
            "Argentina", "Armenia", "Aruba", "Ascension", "Australia", "Austria", "Azerbaijan", "Azores",
            "Bahamas", "Bahrain", "Balearic Islands (Spain)", "Bangladesh", "Barbados", "Barbuda (Antigua and Barbuda)",
            "Barthelemy (Guadeloupe)", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia",
            "Bonaire", "Borabora (French Polynesia)", "Borneo (Kalimantan) (Indonesia)", "Borneo (North) (Malaysia)",
            "Bosnia-Herzegovinia", "Botswana", "Brazil", "Britain (England)", "British Columbia (Canada)",
            "British Virgin Islands", "Brunei", "Bulgaria", "Burkina Faso", "Burundi", "Caicos Islands (Turks and Caicos Islands)",
            "Cambodia", "Cameroon", "Canada", "Canary Islands (Spain)", "Cape Verde", "Cayman Islands", "Central African Republic",
            "Chad", "Channel Islands (UK)", "Chile", "China", "Christiansted, US Virgin Islands", "Colombia", "Comoros",
            "Congo", "Cook Islands", "Corsica (France)", "Costa Rica", "Crete (Greece)", "Croatia", "Cuba", "Cumino Island (Malta)",
            "Curacao", "Cyprus", "Czech Republic", "Denmark", "Desirade Island (Guadeloupe)", "Djibouti", "Dominica",
            "Dominican Republic", "Dubai (United Arab Emirates)", "Ecuador", "Egypt", "El Salvador", "England",
            "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland Islands", "Faroe Island", "Fiji", "Finland",
            "FPO, AA (USA Military Address)", "FPO, AE (USA Military Address)", "FPO, AP (USA Military Address)", "France",
            "Frederiksted, US Virgin Islands", "French Guiana", "French Polynesia", "French West Indies (Martinique)",
            "Futuna (Wallis and Futuna Islands)", "Gabon", "Gambia", "Georgia (RUSSIA)", "Germany", "Ghana", "Gibraltar",
            "Gozo Island (Malta)", "Great Britain (England)", "Greece", "Greenland", "Grenada", "Grenadines (St. Vincent and the Grenadines)",
            "Guadeloupe", "Guam (U.S. Possession)", "Guatemala", "Guernsey (Channel Islands) (Great Britain)", "Guinea",
            "Guinea Bissau", "Guyana", "Hainan Island (China)", "Haiti", "Holland (Netherlands)", "Honduras", "Hong Kong",
            "Hungary", "Iceland", "India", "Indonesia", "Iran", "Ireland, Republic of", "Isle of Man (Great Britain)",
            "Israel", "Italy", "Ivory Coast", "Jamaica", "Japan", "Jersey (Channel Islands) (Great Britain)", "Jordan",
            "Kazakhstan", "Kenya", "Kingshill, US Virgin Islands", "Kiribati", "Korea, Republic of (South Korea)",
            "Kowloon (Hong Kong)", "Kuwait", "Kyrgyzstan", "Labrador (Canada)", "Laos", "Latvia", "Lebanon",
            "Les Saints Island (Guadeloupe)", "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg",
            "Macau", "Macedonia", "Madagascar", "Madeira Islands", "Malawi", "Malaysia", "Maldives", "Mali", "Malta",
            "Manitoba (Canada)", "Marie Galante (Guadeloupe)", "Marshall Islands (U.S. Possession)", "Martinique",
            "Mauritania", "Mauritius", "Mexico", "Micronesia (U.S. Possession)", "Miquelon (St. Pierre and Miquelon)",
            "Moldova", "Monaco", "Mongolia", "Montserrat", "Moorea (French Polynesia)", "Morocco", "Mozambique", "Myanmar",
            "Namibia", "Nauru", "Nepal", "Netherlands", "Netherlands Antilles", "New Brunswick (Canada)", "New Caledonia",
            "New Zealand", "Newfoundland (Canada)", "Nicaragua", "Niger", "Nigeria", "Northern Ireland (UK)",
            "Northern Mariana Islands (U.S. Possession)", "Northwest Territory (Canada)", "Norway", "Nova Scotia (Canada)",
            "Oman", "Ontario (Canada)", "Pakistan", "Palau (U.S. Possession)", "Panama", "Papua New Guinea", "Paraguay",
            "Peru", "Philippines", "Pitcairn Island", "Poland", "Portugal", "Prince Edward Island (Canada)",
            "Puerto Rico (U.S. Possession)", "Qatar", "Quebec (Canada)", "Republic of Georgia", "Reunion Island", "Romania",
            "Russia", "Rwanda", "Saba", "Saint Croix, US Virgin Islands", "Saint John, US Virgin Islands",
            "Saint Kitts (St. Christopher and Nevis)", "Saint Thomas, US Virgin Islands",
            "Saipan (Northern Mariana Islands) (U.S. Possession)", "San Marino", "Sao Tome and Principe", "Saskatchewan (Canada)",
            "Saudi Arabia", "Scotland (UK)", "Senegal", "Serbia-Montenegro", "Seychelles", "Sierra Leone", "Singapore",
            "Slovak Republic", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Korea", "Spain",
            "Spitzbergen (Norway)", "Sri Lanka", "St. Barthelemy", "St. Christopher & Nevis", "St. Croix, US Virgin Islands",
            "St. Eustatius", "St. Helena", "St. John, US Virgin Islands", "St. Lucia", "St. Maarten / St. Martin",
            "St. Pierre and Miquelon", "St. Thomas, US Virgin Islands", "St. Vincent", "Sudan", "Suriname", "Swaziland",
            "Sweden", "Switzerland", "Syria", "Tahiti (French Polynesia)", "Taiwan", "Tajikistan", "Tanzania",
            "Tasmania (Australia)", "Thailand", "Timor (Indonesia)", "Togo", "Tonga", "Trinidad & Tobago", "Tristan da Cunha",
            "Tunisia", "Turkey", "Turkmenistan", "Turks & Caicos Islands", "Tuvalu", "Uganda", "UK (England)", "Ukraine",
            "Umm al Quaiwain (United Arab Emirates)", "United Arab Emirates", "United Kingdom (England)", "United States (50 States)",
            "Uruguay", "US Virgin Islands (U.S. Possession)", "USA (50 States)", "Uzbekistan", "Vanuatu", "Vatican City",
            "Venezuela", "Vietnam", "Virgin Islands (British)", "Virgin Islands (U.S.) (U.S. Possession)", "Wales (UK)",
            "Wallis and Futuna", "Western Samoa", "Yemen Arab Republic", "Yukon Territory (Canada)", "Zaire", "Zambia", "Zimbabwe"
        };
    }
}
