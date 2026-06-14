using TaskFlow.Api.DTOs;
using TaskFlow.Api.Models;

namespace TaskFlow.Api.Services;

public class TaskService : ITaskService
{
    private static readonly List<TaskItem> Tasks = [];

    public List<TaskResponse> GetAll()
    {
        return Tasks.Select(ToResponse).ToList();
    }

    public TaskResponse? GetById(Guid id)
    {
        var task = Tasks.FirstOrDefault(task => task.Id == id);

        if (task is null)
        {
            return null;
        }

        return ToResponse(task);
    }

    public TaskResponse Create(CreateTaskRequest request)
    {
        var task = new TaskItem
        {
            Id = Guid.NewGuid(),
            Title = request.Title.Trim(),
            Description = request.Description?.Trim(),
            IsCompleted = false,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = null
        };

        Tasks.Add(task);

        return ToResponse(task);
    }

    public TaskResponse? Update(Guid id, UpdateTaskRequest request)
    {
        var task = Tasks.FirstOrDefault(task => task.Id == id);

        if (task is null)
        {
            return null;
        }

        task.Title = request.Title.Trim();
        task.Description = request.Description?.Trim();
        task.IsCompleted = request.IsCompleted;
        task.UpdatedAt = DateTime.UtcNow;

        return ToResponse(task);
    }

    public bool Delete(Guid id)
    {
        var task = Tasks.FirstOrDefault(task => task.Id == id);

        if (task is null)
        {
            return false;
        }

        Tasks.Remove(task);

        return true;
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