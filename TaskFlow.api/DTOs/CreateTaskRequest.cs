namespace TaskFlow.Api.DTOs;

public class CreateTasksRequest
{
    public string Title { get; set; } = string.Empty;
    public string? Description { get; set; }
}