using Xunit;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.Controllers;
using moldme.data;
using moldme.DTOs;
using moldme.Models;
using Task = moldme.Models.Task;

namespace moldme.Tests
{
    public class TaskControllerTest
    {
        private ApplicationDbContext GetInMemoryDbContext()
        {
            var options = new DbContextOptionsBuilder<ApplicationDbContext>()
                .UseInMemoryDatabase(databaseName: "TestDatabase")
                .Options;
            return new ApplicationDbContext(options);
        }

        private void SeedData(ApplicationDbContext dbContext)
        {
            var project = new Project
            {
                ProjectId = "1",
                Name = "Project 1",
                CompanyId = "1",
                Description = "Project Description"
            };

            var employee = new Employee
            {
                EmployeeID = "1",
                Name = "Employee 1",
                CompanyId = "1",
                Email = "employee1@example.com",
                Password = "password123",
                Profession = "Developer"
            };

            dbContext.Projects.Add(project);
            dbContext.Employees.Add(employee);
            dbContext.SaveChanges();
        }

[Fact]
    public void Task_Properties_GetterSetter_WorksCorrectly()
    {
        var task = new Task
        {
            TaskId = "T12345",
            TitleName = "Task 1",
            Description = "Description of Task 1",
            Status = Status.INPROGRESS,
            Date = new DateTime(2023, 10, 1),
            ProjectId = "P12345",
            Project = new Project { ProjectId = "P12345", Name = "Project 1" },
            EmployeeId = "E12345",
            FilePath = "/path/to/file",
            Employee = new Employee { EmployeeID = "E12345", Name = "John Doe" }
        };

        Assert.Equal("T12345", task.TaskId);
        Assert.Equal("Task 1", task.TitleName);
        Assert.Equal("Description of Task 1", task.Description);
        Assert.Equal(Status.INPROGRESS, task.Status);
        Assert.Equal(new DateTime(2023, 10, 1), task.Date);
        Assert.Equal("P12345", task.ProjectId);
        Assert.Equal("Project 1", task.Project.Name);
        Assert.Equal("E12345", task.EmployeeId);
        Assert.Equal("/path/to/file", task.FilePath);
        Assert.Equal("John Doe", task.Employee.Name);

        task.TitleName = "Updated Task";
        task.Description = "Updated Description";
        task.Status = Status.DONE;
        task.Date = new DateTime(2023, 11, 1);
        task.ProjectId = "P67890";
        task.Project = new Project { ProjectId = "P67890", Name = "Updated Project" };
        task.EmployeeId = "E67890";
        task.FilePath = "/new/path/to/file";
        task.Employee = new Employee { EmployeeID = "E67890", Name = "Jane Doe" };

        Assert.Equal("Updated Task", task.TitleName);
        Assert.Equal("Updated Description", task.Description);
        Assert.Equal(Status.DONE, task.Status);
        Assert.Equal(new DateTime(2023, 11, 1), task.Date);
        Assert.Equal("P67890", task.ProjectId);
        Assert.Equal("Updated Project", task.Project.Name);
        Assert.Equal("E67890", task.EmployeeId);
        Assert.Equal("/new/path/to/file", task.FilePath);
        Assert.Equal("Jane Doe", task.Employee.Name);
    }        

        [Fact]
        public void CreateTask_ReturnsOkResult_WithCreatedTask()
        {
            var context = GetInMemoryDbContext();
            SeedData(context);
            var controller = new TaskController(context);

            var newTaskDto = new TaskDto
            {
                TitleName = "New Task",
                Description = "New Task Description",
                Date = DateTime.Now,
                FilePath = "path/to/file",
                ProjectId = "1",
                EmployeeId = "1",
                Status = Status.PENDING
            };

            var result = controller.Create(newTaskDto) as OkObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Task created successfully", result.Value);

            var createdTask =
                context.Tasks.FirstOrDefault(t => t.TitleName == "New Task" && t.Description == "New Task Description");
            Assert.NotNull(createdTask);
            Assert.Equal("New Task", createdTask.TitleName);
            Assert.Equal("New Task Description", createdTask.Description);
        }

        [Fact]
        public void GetAllTasks_ReturnsOkResult_WithAllTasks()
        {
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);

            context.Tasks.RemoveRange(context.Tasks);
            context.SaveChanges();

            context.Tasks.Add(new Task
            {
                TaskId = "b",
                TitleName = "Task 2",
                Description = "Task 2 Description",
                ProjectId = "20",
                EmployeeId = "10",
            });

            context.SaveChanges();

            var result = controller.GetAll() as OkObjectResult;

            Assert.NotNull(result);
            var tasks = result.Value as List<Task>;
            Assert.NotNull(tasks);
            Assert.Single(tasks);
        }

        [Fact]
        public void GetTaskById_ReturnsOkResult_WithTask()
        {
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);

            context.Tasks.Add(new Task
            {
                TaskId = "c",
                TitleName = "Task 3",
                Description = "Task 3 Description",
                ProjectId = "1",
                EmployeeId = "1",
            });

            context.SaveChanges();

            var result = controller.GetById("c") as OkObjectResult;

            Assert.NotNull(result);
            var task = result.Value as Task;
            Assert.NotNull(task);
            Assert.Equal("Task 3", task.TitleName);
            Assert.Equal("Task 3 Description", task.Description);
        }

        [Fact]
        public void UpdateTask_ReturnsOkResult_WithUpdatedTask()
        {
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);

            context.Tasks.Add(new Task
            {
                TaskId = "d",
                TitleName = "Task 4",
                Description = "Task 4 Description",
                ProjectId = "1",
                EmployeeId = "1",
            });

            context.SaveChanges();

            var updatedTaskDto = new TaskDto
            {
                TitleName = "Updated Task",
                Description = "Updated Task Description",
                Date = DateTime.Now,
                Status = Status.PENDING,
                ProjectId = "1",
                EmployeeId = "1"
            };

            var result = controller.UpdateTask("d", updatedTaskDto) as OkObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Task updated successfully", result.Value);

            var task = context.Tasks.Find("d");
            Assert.NotNull(task);
            Assert.Equal("Updated Task", task.TitleName);
            Assert.Equal("Updated Task Description", task.Description);
        }

        [Fact]
        public void DeleteTask_ReturnsOkResult_WithDeletedTask()
        {
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);

            context.Tasks.Add(new Task
            {
                TaskId = "e",
                TitleName = "Task 5",
                Description = "Task 5 Description",
                ProjectId = "1",
                EmployeeId = "1",
            });

            context.SaveChanges();

            var result = controller.DeleteTask("e") as OkObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Task deleted successfully", result.Value);

            var task = context.Tasks.Find("e");
            Assert.Null(task);
        }

        [Fact]
        public void DeleteTask_ReturnsNotFoundResult_WhenTaskNotFound()
        {
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);

            var result = controller.DeleteTask("l") as NotFoundObjectResult;

            Assert.NotNull(result);
        }

        [Fact]
        public void UpdateTask_ReturnsNotFoundResult_WhenTaskNotFound()
        {
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);

            var updatedTaskDto = new TaskDto
            {
                TitleName = "Updated Task",
                Description = "Updated Task Description",
                Date = DateTime.Now,
                Status = Status.PENDING,
                ProjectId = "1",
                EmployeeId = "1"
            };

            var result = controller.UpdateTask("i", updatedTaskDto) as NotFoundObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Task not found", result.Value);
        }

        [Fact]
        public void GetTaskById_ReturnsNotFoundResult_WhenTaskNotFound()
        {
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);

            var result = controller.GetById("j") as NotFoundObjectResult;

            Assert.NotNull(result);
        }

        [Fact]
        public void GetAllTasks_ReturnsOkResult_WithNoTasks()
        {
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);

            context.Tasks.RemoveRange(context.Tasks);
            context.SaveChanges();

            var result = controller.GetAll() as OkObjectResult;

            Assert.NotNull(result);
            var tasks = result.Value as List<Task>;
            Assert.NotNull(tasks);
            Assert.Empty(tasks);
        }

        [Fact]
        public void CreateTask_ReturnsBadRequestResult_WhenTaskIsNull()
        {
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);

            var result = controller.Create(null) as BadRequestObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Task data is null", result.Value);
        }

        [Fact]
        public void UpdateTask_ReturnsBadRequestResult_WhenModelStateIsInvalid()
        {
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);
            controller.ModelState.AddModelError("TitleName", "Required");

            var updatedTaskDto = new TaskDto
            {
                TitleName = "Updated Task",
                Date = DateTime.Now,
                Status = Status.PENDING,
                ProjectId = "1",
                EmployeeId = "1"
            };

            var result = controller.UpdateTask("c", updatedTaskDto) as BadRequestObjectResult;

            Assert.NotNull(result);
            Assert.Equal(400, result.StatusCode);
        }

        [Theory]
        [InlineData(null, "Description", "1", "1")]
        [InlineData("Title", null, "1", "1")]
        [InlineData("Title", "Description", null, "1")]
        [InlineData("Title", "Description", "1", null)]
        public void CreateTask_ReturnsBadRequestResult_WhenRequiredFieldsAreMissing(string title, string description, string projectId, string employeeId)
        {
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);

            var newTaskDto = new TaskDto
            {
                TitleName = title,
                Description = description,
                Date = DateTime.Now,
                FilePath = "path/to/file",
                ProjectId = projectId,
                EmployeeId = employeeId,
                Status = Status.PENDING
            };

            var result = controller.Create(newTaskDto) as BadRequestObjectResult;

            Assert.NotNull(result);
            Assert.Equal("TitleName, Description, ProjectId, and EmployeeId are required", result.Value);
        }

        [Theory]
        [InlineData(null, "Description", "1", "1")]
        [InlineData("Title", null, "1", "1")]
        [InlineData("Title", "Description", null, "1")]
        [InlineData("Title", "Description", "1", null)]
        public void UpdateTask_ReturnsBadRequestResult_WhenRequiredFieldsAreMissing(string title, string description, string projectId, string employeeId)
        {
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);

            var updatedTaskDto = new TaskDto
            {
                TitleName = title,
                Description = description,
                Date = DateTime.Now,
                FilePath = "path/to/file",
                ProjectId = projectId,
                EmployeeId = employeeId,
                Status = Status.PENDING
            };

            var result = controller.UpdateTask("d", updatedTaskDto) as BadRequestObjectResult;

            Assert.NotNull(result);
            Assert.Equal("TitleName, Description, ProjectId, and EmployeeId are required", result.Value);
            
        }

        [Fact]
        public void DeleteTask_ReturnsBadRequestResult_WhenIdIsInvalid()
        {
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);

            var result = controller.DeleteTask("") as BadRequestObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Task ID is required", result.Value);
        }
    }
}