namespace MillionsOfRecordsApp.Models.DTOs;

public class ApiResponse<T>
{
    public string Status { get; set; } = "Success";
    public string Message { get; set; } = "Data found";
    public List<T> Data { get; set; } = new();
    public PaginationMetadata Pagination { get; set; }
}
