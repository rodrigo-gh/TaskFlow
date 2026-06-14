using TaskFlow.Api.DTOs;

namespace TaskFlow.Api.Services;

public interface ITaskService
{
    Task<List<TaskResponse>> GetAllAsync();

    Task<TaskResponse?> GetByIdAsync(Guid id);

    Task<TaskResponse> CreateAsync(CreateTaskRequest request);

    Task<TaskResponse?> UpdateAsync(Guid id, UpdateTaskRequest request);

    Task<TaskResponse?> CompleteAsync(Guid id);

    Task<TaskResponse?> ReopenAsync(Guid id);

    Task<bool> DeleteAsync(Guid id);
}