using Microsoft.EntityFrameworkCore;
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

    public async Task<List<TaskResponse>> GetAllAsync()
    {
        var tasks = await _context.Tasks
            .OrderByDescending(task => task.CreatedAt)
            .ToListAsync();

        return tasks.Select(ToResponse).ToList();
    }

    public async Task<TaskResponse?> GetByIdAsync(Guid id)
    {
        var task = await _context.Tasks
            .FirstOrDefaultAsync(task => task.Id == id);

        if (task is null)
        {
            return null;
        }

        return ToResponse(task);
    }

    public async Task<TaskResponse> CreateAsync(CreateTaskRequest request)
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

        await _context.Tasks.AddAsync(task);
        await _context.SaveChangesAsync();

        return ToResponse(task);
    }

    public async Task<TaskResponse?> UpdateAsync(Guid id, UpdateTaskRequest request)
    {
        var task = await _context.Tasks
            .FirstOrDefaultAsync(task => task.Id == id);

        if (task is null)
        {
            return null;
        }

        task.Title = request.Title.Trim();
        task.Description = request.Description?.Trim();
        task.IsCompleted = request.IsCompleted;
        task.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        return ToResponse(task);
    }

    public async Task<TaskResponse?> CompleteAsync(Guid id)
    {
        var task = await _context.Tasks
            .FirstOrDefaultAsync(task => task.Id == id);

        if (task is null)
        {
            return null;
        }

        task.IsCompleted = true;
        task.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        return ToResponse(task);
    }

    public async Task<TaskResponse?> ReopenAsync(Guid id)
    {
        var task = await _context.Tasks
            .FirstOrDefaultAsync(task => task.Id == id);

        if (task is null)
        {
            return null;
        }

        task.IsCompleted = false;
        task.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        return ToResponse(task);
    }

    public async Task<bool> DeleteAsync(Guid id)
    {
        var task = await _context.Tasks
            .FirstOrDefaultAsync(task => task.Id == id);

        if (task is null)
        {
            return false;
        }

        _context.Tasks.Remove(task);
        await _context.SaveChangesAsync();

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