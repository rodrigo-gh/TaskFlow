# TaskFlow

TaskFlow is a study project built to practice Flutter, GetX, REST API integration, Git, Clean Code, project architecture and C#.

The project is being developed as a small full-stack task management application, with a Flutter mobile app consuming an ASP.NET Core REST API.

## Tech Stack

### Backend

* C#
* ASP.NET Core Web API
* Entity Framework Core
* SQLite
* Swagger / OpenAPI
* REST API
* DTOs
* Service layer
* Dependency Injection
* Async/Await

### Frontend

* Flutter
* Dart
* GetX

> The Flutter app will be added after the API is completed.

## Features

### API

* Create tasks
* List tasks
* Filter tasks by status
* Get task by ID
* Update tasks
* Mark tasks as completed
* Reopen completed tasks
* Delete tasks
* Request validation
* Standardized not found responses
* Swagger documentation
* SQLite persistence with Entity Framework Core

## Project Structure

```text
TaskFlow/
├── TaskFlow.sln
├── README.md
└── TaskFlow.api/
    ├── Controllers/
    │   └── TasksController.cs
    ├── Data/
    │   └── AppDbContext.cs
    ├── DTOs/
    │   ├── CreateTaskRequest.cs
    │   ├── UpdateTaskRequest.cs
    │   ├── TaskResponse.cs
    │   └── ErrorResponse.cs
    ├── Enums/
    │   └── TaskStatusFilter.cs
    ├── Models/
    │   └── TaskItem.cs
    ├── Services/
    │   ├── ITaskService.cs
    │   └── TaskService.cs
    ├── Migrations/
    ├── Program.cs
    ├── appsettings.json
    └── TaskFlow.api.csproj
```

## API Setup

### Requirements

* .NET SDK
* Entity Framework Core CLI tool

Check your .NET version:

```bash
dotnet --version
```

Install the Entity Framework Core CLI tool if needed:

```bash
dotnet tool install --global dotnet-ef
```

## Running the API

From the repository root, enter the API project folder:

```bash
cd TaskFlow.api
```

Restore dependencies:

```bash
dotnet restore
```

Apply database migrations:

```bash
dotnet ef database update
```

Run the API:

```bash
dotnet run
```

The API should be available at:

```text
http://localhost:5099
```

Swagger documentation:

```text
http://localhost:5099/swagger
```

## Database

The API uses SQLite.

The local database file is generated after running:

```bash
dotnet ef database update
```

The database file is not committed to Git. It can be recreated from the migrations.

## API Endpoints

### Tasks

| Method | Endpoint                      | Description              |
| ------ | ----------------------------- | ------------------------ |
| GET    | `/api/tasks`                  | List all tasks           |
| GET    | `/api/tasks?status=All`       | List all tasks           |
| GET    | `/api/tasks?status=Pending`   | List pending tasks       |
| GET    | `/api/tasks?status=Completed` | List completed tasks     |
| GET    | `/api/tasks/{id}`             | Get a task by ID         |
| POST   | `/api/tasks`                  | Create a new task        |
| PUT    | `/api/tasks/{id}`             | Update a task            |
| PATCH  | `/api/tasks/{id}/complete`    | Mark a task as completed |
| PATCH  | `/api/tasks/{id}/reopen`      | Reopen a completed task  |
| DELETE | `/api/tasks/{id}`             | Delete a task            |

## Request Examples

### Create task

```http
POST /api/tasks
Content-Type: application/json
```

```json
{
  "title": "Study C#",
  "description": "Practice ASP.NET Core Web API"
}
```

### Update task

```http
PUT /api/tasks/{id}
Content-Type: application/json
```

```json
{
  "title": "Study C# and EF Core",
  "description": "Practice API persistence with SQLite",
  "isCompleted": true
}
```

## Response Examples

### Success response

```json
{
  "id": "7e3f42f4-7e6a-41e1-97e3-8e4d25a0f15c",
  "title": "Study C#",
  "description": "Practice ASP.NET Core Web API",
  "isCompleted": false,
  "createdAt": "2026-06-15T10:30:00Z",
  "updatedAt": null
}
```

### Not found response

```json
{
  "message": "Task not found."
}
```

## Development Notes

This project follows an incremental development approach:

1. Initial API setup
2. Swagger configuration
3. In-memory CRUD
4. DTOs for request and response objects
5. Request validation
6. Service layer
7. SQLite persistence with Entity Framework Core
8. Async/Await refactor
9. Task status endpoints
10. Task filtering
11. Standardized error responses
12. Swagger documentation improvements

## Git Commit Style

The project uses organized commits such as:

```text
chore: initialize repository
feat(api): create ASP.NET Core Web API project
feat(api): configure Swagger UI
feat(api): add in-memory task CRUD endpoints
refactor(api): use DTOs for task requests and responses
feat(api): add task request validation
refactor(api): move task logic to service layer
feat(api): persist tasks with SQLite and EF Core
refactor(api): use async methods in task service
feat(api): add task completion endpoints
feat(api): add task status filter
feat(api): improve not found error responses
docs(api): improve Swagger documentation
docs: add API setup instructions
```

## Next Steps

* Build the Flutter app
* Configure GetX routes and bindings
* Create task repository in Flutter
* Consume the ASP.NET Core API
* Implement task list, create, update, complete, reopen and delete flows

```
```
