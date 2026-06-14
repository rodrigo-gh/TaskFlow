using Microsoft.AspNetCore.Mvc;
using TaskFlow.Api.Models;

namespace TaskFlow.Api.Controllers;

[ApiController]
[Route("api/tasks")]
public class TaskController : ControllerBase
{
    private static readonly List<TaskItem> Tasks = [];

    [HttpGet]
    public ActionResult<List<TaskItem>> GetAll()
    {
        return Ok(Tasks);
    }

    [HttpGet("{id:guid}")]
    public ActionResult<TaskItem> GetById(Guid id)
    {
        var task = Tasks.FirstOrDefault(task => task.Id == id);

        if (task is null)
        {
            return NotFound();
        }

        return Ok(task);
    }

    [HttpPost]
    public ActionResult<TaskItem> Create(TaskItem task)
    {
        task.Id = Guid.NewGuid();
        task.CreatedAt = DateTime.UtcNow;
        task.UpdatedAt = null;

        Tasks.Add(task);

        return CreatedAtAction(nameof(GetById), new { id = task.Id }, task);
    }

    [HttpPut("{id:guid}")]
    public ActionResult<TaskItem> Update(Guid id, TaskItem updatedTask)
    {
        var task = Tasks.FirstOrDefault(task => task.Id == id);
        if (task is null)
        {
            return NotFound();
        }

        task.Title = updatedTask.Title;
        task.Description = updatedTask.Description;
        task.IsCompleted = updatedTask.IsCompleted;
        task.UpdatedAt = DateTime.UtcNow;

        return Ok(task);
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

}