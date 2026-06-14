using System.ComponentModel.DataAnnotations;

namespace TaskFlow.Api.DTOs;

public class UpdateTaskRequest
{
    [Required(ErrorMessage = "Title is required.")]
    [StringLength(100, MinimumLength = 3, ErrorMessage = "Title must be between 3 an 100 characters.")]
    public string Title { get; set; } = string.Empty;

    [StringLength(500, ErrorMessage = "Description must have at most 500 characters.")]
    public string? Description { get; set; }

    public bool IsCompleted { get; set; }
}