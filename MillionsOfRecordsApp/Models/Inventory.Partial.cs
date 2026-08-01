namespace MillionsOfRecordsApp.Models;

public partial class Inventory
{
    public decimal GetComputedPrice(string sessionPriceGroup)
    {
        DateTime? saleEndDate = null;
        decimal? salePrice = null;
        decimal? regularPrice = null;
        bool isStorePriceGroup = sessionPriceGroup == "StorePrice";
        if (isStorePriceGroup || sessionPriceGroup == "ExportPrice")
        {
            saleEndDate = this.SaleWholesaleEndDate;
            salePrice = this.SaleWholesalePrice;
            regularPrice = isStorePriceGroup ? this.StorePrice : this.ExportPrice;
        }
        else
        {
            saleEndDate = this.SaleRetailEndDate;
            salePrice = this.SaleRetailPrice;
            regularPrice = this.RetailPrice;
        }
        bool isSaleItem = salePrice.HasValue && saleEndDate.HasValue && (saleEndDate.Value - DateTime.Now).Days >= 0;
        if (isSaleItem)
        {
            return salePrice ?? 0m;
        }
        else
        {
            return regularPrice ?? 0m;
        }

        /*
         * There is a logic in Home.aspx line #6301, which checks if the item is already in the cart and if so, it retrieves the quantity, price, and datetime for that item in the cart.
          intQuantityInCart = 0
                    Using conn2 As New SqlConnection(ConfigurationManager.ConnectionStrings(strConnectionStringName).ConnectionString)
                        SqlConnection.ClearPool(conn2)
                        conn2.Open()
                        Dim CMD_X2 As New SqlCommand("spIsItemInCart", conn2)
                        CMD_X2.CommandType = Data.CommandType.StoredProcedure
                        CMD_X2.Parameters.AddWithValue("@NameOfCart", NameOfCart)
                        CMD_X2.Parameters.AddWithValue("@ItemID", CLng(xx("ID")))
                        Dim readerX2 As SqlDataReader
                        readerX2 = CMD_X2.ExecuteReader
                        intQuantityInCart = 0
                        If readerX2.HasRows Then
                            readerX2.Read()
                            intQuantityInCart = readerX2("Quantity")
                            varCartPrice = readerX2("Price")
                            varCartDateTime = readerX2("DateTime")
                        End If
                    End Using

        There is another logic on Line #6379 is checking cart date time less than 30 days and if the price in the cart is greater than the current price, then it uses the cart price instead for display and adding to cart purposes.
        If intQuantityInCart > 0 Then
                        If CDbl(varPriceUsing) > CDbl(varCartPrice) And DateDiff("d", varCartDateTime, Date.Now) <= 30 Then
                            varPriceUsing = varCartPrice
                        End If
                    End If
                    If Session("PowerUserName") <> "" Then
                        varPriceForCartAddText = "document.getElementById('PR' + " & xx("id") & ").value"
                        If intQuantityInCart > 0 Then
                            varCartPrice = varCartPrice
                        Else
                            varCartPrice = varPriceUsing
                        End If
                        If CDbl(varCartPrice) <> CDbl(varPriceUsing) Then
                            varCartFColor = "FFFFC8"
                        Else
                            varCartFColor = "ffffff"
                        End If
                    Else
                        varPriceForCartAddText = varPriceUsing
                    End If
        */
    }
    public class ParsedFeature
    {
        public string Id { get; set; } = string.Empty;
        public string DisplayText { get; set; } = string.Empty;
        public string HoverText { get; set; } = string.Empty;
    }
    public List<ParsedFeature> GetParsedFeatures()
    {
        var features = new List<ParsedFeature>();

        // Put all 10 potential feature strings into an array to loop through them
        string[] rawFeatures = {
            ItemFeatures1, ItemFeatures2, ItemFeatures3, ItemFeatures4, ItemFeatures5,
            ItemFeatures6, ItemFeatures7, ItemFeatures8, ItemFeatures9, ItemFeatures10
        };

        foreach (var raw in rawFeatures)
        {
            if (string.IsNullOrEmpty(raw)) continue;

            // The data format is: |1|ID|2|...|4|TEXT|5|HOVER|6|
            var parts = raw.Split('|');

            // Based on your data: 
            // Index 2 is ID (after |1|)
            // Index 8 is Display Text (after |4|)
            // Index 10 is Hover Text (after |5|)
            if (parts.Length >= 11)
            {
                var featureText = parts[8];
                if (!string.IsNullOrEmpty(featureText))
                {
                    features.Add(new ParsedFeature
                    {
                        Id = parts[2],
                        DisplayText = featureText,
                        // Replicate the "inch" replacement logic from your VB code
                        HoverText = (parts[10] ?? "").Replace("\"", " inch")
                    });
                }
            }
        }
        return features;
    }
    public bool ShouldShowSimilarItemsAvailability()
    {
        bool showSimilarItems = false;

        if (!string.IsNullOrEmpty(Genre1) && int.TryParse(YearFrom, out int yearFrom))
        {
            // If Label exists, we can show similar items without checking years
            showSimilarItems = true;
        }
        return showSimilarItems;
    }
    // 1. REPLICATING ScanPath
    public string GetImagePath(string size = "320", string letter = "A")
    {
        // Logic: (Int(ID / 1000)) * 1000 padded to 7 digits
        int folderNum = (Id / 1000) * 1000;
        string folder = folderNum.ToString().PadLeft(7, '0');

        // Map the size codes to the actual file suffixes from your VB code
        string suffix = size switch
        {
            "LARGE" => "-595",
            "1130" => "-1130",
            "320" => "-320",
            "MEDIUM" => "-180",
            "SMALL" => "-54",
            _ => "-320"
        };

        return $"/{folder}/{Id}{letter}{suffix}.jpg";
    }
    // 2. REPLICATING Artist/Title Splitting
    public string CleanArtistTitle => ArtistTitle.Replace("USED ITEM:", "").Trim();

    public (string Artist, string Title) SplitTitle()
    {
        var parts = CleanArtistTitle.Split(new[] { " - " }, 2, StringSplitOptions.None);
        return (parts[0], parts.Length > 1 ? parts[1] : "");
    }
    // 3. REPLICATING Artist List (for the links)
    public List<string> GetArtistList()
    {
        var artistPart = SplitTitle().Artist;
        if (string.IsNullOrWhiteSpace(artistPart)) return new List<string>();

        return artistPart.Split(new[] { "," }, StringSplitOptions.RemoveEmptyEntries)
                         .Select(a => a.Trim())
                         .ToList();
    }
    // NEW: Logic to handle the legacy truncation/Etc rules
    public List<(string Name, bool IsLink)> GetFormattedArtistLinks()
    {
        var artists = GetArtistList();
        var result = new List<(string Name, bool IsLink)>();

        for (int i = 0; i < artists.Count; i++)
        {
            string name = artists[i];

            // Rule: Handle "Various" as first entry (No Link)
            if (i == 0 && name.Equals("Various", StringComparison.OrdinalIgnoreCase))
            {
                result.Add((name, false));
                return result; // Usually ends there in legacy
            }


            // Rule: Skip linking "Etc." or "Various"
            bool shouldLink = !name.Equals("Etc.", StringComparison.OrdinalIgnoreCase) &&
                              !name.Equals("Various", StringComparison.OrdinalIgnoreCase);

            result.Add((name, shouldLink));
        }

        return result;
    }
    public class FormatInfo
    {
        public string DisplayText { get; set; } = string.Empty;
        public string Tooltip { get; set; } = string.Empty;
        public string BgColor { get; set; } = "rgb(153, 153, 153)"; // Default Grey
        public string TextColor { get; set; } = "white";
    }
    public FormatInfo GetFormatDetails()
    {
        string fmt = Format ?? "";

        return fmt switch
        {
            "CD" => new FormatInfo { DisplayText = "CD", Tooltip = "CD (Compact Disc)", BgColor = "rgb(84, 117, 242)" },
            "CDS" => new FormatInfo { DisplayText = "CS", Tooltip = "CD Single", BgColor = "rgb(84, 117, 242)" },
            "LP" => new FormatInfo { DisplayText = "LP", Tooltip = "LP (Vinyl Record)", BgColor = "rgb(235, 146, 12)" },
            "CS" => new FormatInfo { DisplayText = "CT", Tooltip = "Audio Cassette Tape", BgColor = "rgb(228, 43, 200)" },
            "DVD" => new FormatInfo { DisplayText = "DV", Tooltip = "DVD (Video)", BgColor = "rgb(174, 70, 208)" },
            "Blu-ray" => new FormatInfo { DisplayText = "BR", Tooltip = "Blu-ray Disc", BgColor = "rgb(0, 161, 225)" },
            "VHS" => new FormatInfo { DisplayText = "VH", Tooltip = "VHS Video", BgColor = "rgb(228, 43, 200)" },

            // StartsWith logic for sizes and Video
            _ when fmt.StartsWith("7") => new FormatInfo { DisplayText = "7\"", Tooltip = "7 Inch Vinyl Record", BgColor = "rgb(238, 89, 122)" },
            _ when fmt.StartsWith("10") => new FormatInfo { DisplayText = "10", Tooltip = "10 Inch Vinyl Record", BgColor = "rgb(132, 113, 92)" },
            _ when fmt.StartsWith("12") => new FormatInfo { DisplayText = "12\"", Tooltip = "12 Inch Vinyl Record", BgColor = "rgb(129, 184, 122)" },
            _ when fmt.StartsWith("V") => new FormatInfo { DisplayText = "VHS", Tooltip = "Video", BgColor = "rgb(228, 43, 200)" },

            // Defaults for other distinct formats in your DB
            "BOX" => new FormatInfo { DisplayText = "BX", Tooltip = "Box Set", BgColor = "rgb(100, 100, 100)" },
            "MAG" => new FormatInfo { DisplayText = "MG", Tooltip = "Magazine", BgColor = "rgb(150, 150, 150)" },

            // Fallback for anything else (ADP, BK, CASE, P, etc.)
            _ => new FormatInfo { DisplayText = fmt.Length > 2 ? fmt.Substring(0, 2).ToUpper() : fmt, Tooltip = fmt }
        };
    }
    public string GetTruncatedRhythmName()
    {
        if (string.IsNullOrEmpty(RhythmName)) return string.Empty;

        // The legacy code had two different truncation lengths based on 
        // whether features existed or not.
        bool hasFeatures = !string.IsNullOrEmpty(ItemFeatures1);
        int maxLength = hasFeatures ? 31 : 76;
        int substringLength = hasFeatures ? 28 : 73;

        if (RhythmName.Length > maxLength)
        {
            return RhythmName.Substring(0, substringLength) + "...";
        }

        return RhythmName;
    }
}
