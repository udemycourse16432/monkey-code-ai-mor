namespace MillionsOfRecordsApp.Models.DTOs;

public class WebSearchSuggestionDto
{
    public int Counter { get; set; }
    public string ArtistTitle { get; set; } = string.Empty;
    public string FrontImg { get; set; } = string.Empty;
    public int Count { get; set; }
}
