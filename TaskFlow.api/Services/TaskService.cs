using TaskFlow.Api.Data;
using TaskFlow.Api.DTOs;
using TaskFlow.Api.Models;

namespace TaskFlow.Api.Services;

public class TaskService : ITaskService
{
    private readonly AppDbContext _context;

    public TaskService(AppDbContext context)
    {
        _context = context;
    }

    public List<TaskResponse> GetAll()
    {
        return _context.Tasks
            .OrderByDescending(task => task.CreatedAt)
            .Select(task => ToResponse(task))
            .ToList();
    }

    public TaskResponse? GetById(Guid id)
    {
        var task = _context.Tasks.FirstOrDefault(task => task.Id == id);

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

        _context.Tasks.Add(task);
        _context.SaveChanges();

        return ToResponse(task);
    }

    public TaskResponse? Update(Guid id, UpdateTaskRequest request)
    {
        var task = _context.Tasks.FirstOrDefault(task => task.Id == id);

        if (task is null)
        {
            return null;
        }

        task.Title = request.Title.Trim();
        task.Description = request.Description?.Trim();
        task.IsCompleted = request.IsCompleted;
        task.UpdatedAt = DateTime.UtcNow;

        _context.SaveChanges();

        return ToResponse(task);
    }

    public bool Delete(Guid id)
    {
        var task = _context.Tasks.FirstOrDefault(task => task.Id == id);

        if (task is null)
        {
            return false;
        }

        _context.Tasks.Remove(task);
        _context.SaveChanges();

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