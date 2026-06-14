using TaskFlow.Api.DTOs;

namespace TaskFlow.Api.Services;

public interface ITaskService
{
    List<TaskResponse> GetAll();
    TaskResponse? GetById(Guid id);
    TaskResponse Create(CreateTaskRequest request);
    TaskResponse? Update(Guid id, UpdateTaskRequest request);
    bool Delete(Guid id);
}