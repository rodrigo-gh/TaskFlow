using Microsoft.AspNetCore.Mvc;
using TaskFlow.Api.DTOs;
using TaskFlow.Api.Enums;
using TaskFlow.Api.Services;

namespace TaskFlow.Api.Controllers;

[ApiController]
[Route("api/tasks")]
[Produces("application/json")]
public class TasksController : ControllerBase
{
    private readonly ITaskService _taskService;

    public TasksController(ITaskService taskService)
    {
        _taskService = taskService;
    }

    /// <summary>
    /// Gets all tasks, optionally filtered by status.
    /// </summary>
    /// <param name="status">Task status filter: All, Pending or Completed.</param>
    /// <returns>A list of tasks.</returns>
    [HttpGet]
    [ProducesResponseType(typeof(List<TaskResponse>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<List<TaskResponse>>> GetAll(
        [FromQuery] TaskStatusFilter status = TaskStatusFilter.All)
    {
        var tasks = await _taskService.GetAllAsync(status);

        return Ok(tasks);
    }

    /// <summary>
    /// Gets a task by its unique identifier.
    /// </summary>
    /// <param name="id">Task unique identifier.</param>
    /// <returns>The requested task.</returns>
    [HttpGet("{id:guid}")]
    [ProducesResponseType(typeof(TaskResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ErrorResponse), StatusCodes.Status404NotFound)]
    public async Task<ActionResult<TaskResponse>> GetById(Guid id)
    {
        var task = await _taskService.GetByIdAsync(id);

        if (task is null)
        {
            return TaskNotFound();
        }

        return Ok(task);
    }

    /// <summary>
    /// Creates a new task.
    /// </summary>
    /// <param name="request">Task creation data.</param>
    /// <returns>The created task.</returns>
    [HttpPost]
    [ProducesResponseType(typeof(TaskResponse), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<TaskResponse>> Create(CreateTaskRequest request)
    {
        var task = await _taskService.CreateAsync(request);

        return CreatedAtAction(nameof(GetById), new { id = task.Id }, task);
    }

    /// <summary>
    /// Updates an existing task.
    /// </summary>
    /// <param name="id">Task unique identifier.</param>
    /// <param name="request">Task update data.</param>
    /// <returns>The updated task.</returns>
    [HttpPut("{id:guid}")]
    [ProducesResponseType(typeof(TaskResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ErrorResponse), StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<TaskResponse>> Update(Guid id, UpdateTaskRequest request)
    {
        var task = await _taskService.UpdateAsync(id, request);

        if (task is null)
        {
            return TaskNotFound();
        }

        return Ok(task);
    }

    /// <summary>
    /// Marks a task as completed.
    /// </summary>
    /// <param name="id">Task unique identifier.</param>
    /// <returns>The updated task.</returns>
    [HttpPatch("{id:guid}/complete")]
    [ProducesResponseType(typeof(TaskResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ErrorResponse), StatusCodes.Status404NotFound)]
    public async Task<ActionResult<TaskResponse>> Complete(Guid id)
    {
        var task = await _taskService.CompleteAsync(id);

        if (task is null)
        {
            return TaskNotFound();
        }

        return Ok(task);
    }

    /// <summary>
    /// Reopens a completed task.
    /// </summary>
    /// <param name="id">Task unique identifier.</param>
    /// <returns>The updated task.</returns>
    [HttpPatch("{id:guid}/reopen")]
    [ProducesResponseType(typeof(TaskResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ErrorResponse), StatusCodes.Status404NotFound)]
    public async Task<ActionResult<TaskResponse>> Reopen(Guid id)
    {
        var task = await _taskService.ReopenAsync(id);

        if (task is null)
        {
            return TaskNotFound();
        }

        return Ok(task);
    }

    /// <summary>
    /// Deletes a task.
    /// </summary>
    /// <param name="id">Task unique identifier.</param>
    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(typeof(ErrorResponse), StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(Guid id)
    {
        var deleted = await _taskService.DeleteAsync(id);

        if (!deleted)
        {
            return TaskNotFound();
        }

        return NoContent();
    }

    private NotFoundObjectResult TaskNotFound()
    {
        return NotFound(new ErrorResponse
        {
            Message = "Task not found."
        });
    }
}