using Microsoft.AspNetCore.Mvc;
using TaskFlow.Api.DTOs;
using TaskFlow.Api.Services;

namespace TaskFlow.Api.Controllers;

[ApiController]
[Route("api/tasks")]
public class TasksController : ControllerBase
{
    private readonly ITaskService _taskService;

    public TasksController(ITaskService taskService)
    {
        _taskService = taskService;
    }

    [HttpGet]
    public ActionResult<List<TaskResponse>> GetAll()
    {
        var tasks = _taskService.GetAll();

        return Ok(tasks);
    }

    [HttpGet("{id:guid}")]
    public ActionResult<TaskResponse> GetById(Guid id)
    {
        var task = _taskService.GetById(id);

        if (task is null)
        {
            return NotFound();
        }

        return Ok(task);
    }

    [HttpPost]
    public ActionResult<TaskResponse> Create(CreateTaskRequest request)
    {
        var task = _taskService.Create(request);

        return CreatedAtAction(nameof(GetById), new { id = task.Id }, task);
    }

    [HttpPut("{id:guid}")]
    public ActionResult<TaskResponse> Update(Guid id, UpdateTaskRequest request)
    {
        var task = _taskService.Update(id, request);

        if (task is null)
        {
            return NotFound();
        }

        return Ok(task);
    }

    [HttpDelete("{id:guid}")]
    public IActionResult Delete(Guid id)
    {
        var deleted = _taskService.Delete(id);

        if (!deleted)
        {
            return NotFound();
        }

        return NoContent();
    }
}