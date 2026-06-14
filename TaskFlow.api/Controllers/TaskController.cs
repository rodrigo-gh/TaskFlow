using Microsoft.AspNetCore.Mvc;
using TaskFlow.Api.DTOs;
using TaskFlow.Api.Models;

namespace TaskFlow.Api.Controllers;

[ApiController]
[Route("api/tasks")]
public class TaskController : ControllerBase
{
    private static readonly List<TaskItem> Tasks = [];

    [HttpGet]
    public ActionResult<List<TaskResponse>> GetAll()
    {
        var response = Tasks.Select(ToResponse).ToList();
        return Ok(response);
    }

    [HttpGet("{id:guid}")]
    public ActionResult<TaskResponse> GetById(Guid id)
    {
        var task = Tasks.FirstOrDefault(task => task.Id == id);

        if (task is null)
        {
            return NotFound();
        }

        return Ok(ToResponse(task));
    }

    [HttpPost]
    public ActionResult<TaskResponse> Create(CreateTasksRequest request)
    {
        var task = new TaskItem
        {
            Id = Guid.NewGuid(),
            Title = request.Title,
            Description = request.Description,
            IsCompleted = false,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = null
        };

        Tasks.Add(task);

        var response = ToResponse(task);

        return CreatedAtAction(nameof(GetById), new { id = task.Id }, response);
    }

    [HttpPut("{id:guid}")]
    public ActionResult<TaskResponse> Update(Guid id, UpdateTaskRequest request)
    {
        var task = Tasks.FirstOrDefault(task => task.Id == id);
        if (task is null)
        {
            return NotFound();
        }

        task.Title = request.Title;
        task.Description = request.Description;
        task.IsCompleted = request.IsCompleted;
        task.UpdatedAt = DateTime.UtcNow;

        return Ok(ToResponse(task));
    }

    [HttpDelete("{id:guid}")]
    public IActionResult Delete(Guid id)
    {
        var task = Tasks.FirstOrDefault(task => task.Id == id);

        if (task is null)
        {
            return NotFound();
        }

        Tasks.Remove(task);

        return NoContent();
    }

    private static TaskResponse ToResponse(TaskItem task)
    {
        return new TaskResponse
        {
            Id = task.Id,
            Title = task.Title,
            Description = task.Description,
            IsCompleted = task.IsCompleted,
            CreatedAt = task.CreatedAt,
            UpdatedAt = task.UpdatedAt
        };
    }

}