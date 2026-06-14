using TaskFlow.Api.DTOs;

namespace TaskFlow.Api.Services;

public interface ITaskService
{
    Task<List<TaskResponse>> GetAllAsync();

    Task<TaskResponse?> GetByIdAsync(Guid id);

    Task<TaskResponse> CreateAsync(CreateTaskRequest request);

    Task<TaskResponse?> UpdateAsync(Guid id, UpdateTaskRequest request);

    Task<bool> DeleteAsync(Guid id);
}