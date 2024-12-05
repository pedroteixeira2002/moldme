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
                CompanyId = "1", // Ensure CompanyId is set
                Description = "Project Description" // Ensure Description is set
            };

            var employee = new Employee
            {
                EmployeeId = "1",
                Name = "Employee 1",
                CompanyId = "1", // Ensure CompanyId is set
                Email = "employee1@example.com", // Ensure Email is set
                Password = "password123", // Ensure Password is set
                Profession = "Developer" // Ensure Profession is set
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
         //   Project = new Project { ProjectId = "P12345", Name = "Project 1" },
            EmployeeId = "E12345",
           // Employee = new Employee { EmployeeId = "E12345", Name = "John Doe" }
        };

        Assert.Equal("T12345", task.TaskId);
        Assert.Equal("Task 1", task.TitleName);
        Assert.Equal("Description of Task 1", task.Description);
        Assert.Equal(Status.INPROGRESS, task.Status);
        Assert.Equal(new DateTime(2023, 10, 1), task.Date);
        Assert.Equal("P12345", task.ProjectId);
        //Assert.Equal("Project 1", task.Project.Name);
        Assert.Equal("E12345", task.EmployeeId);
        //Assert.Equal("John Doe", task.Employee.Name);

        task.TitleName = "Updated Task";
        task.Description = "Updated Description";
        task.Status = Status.DONE;
        task.Date = new DateTime(2023, 11, 1);
        task.ProjectId = "P67890";
        //task.Project = new Project { ProjectId = "P67890", Name = "Updated Project" };
        task.EmployeeId = "E67890";
        //task.Employee = new Employee { EmployeeId = "E67890", Name = "Jane Doe" };

        Assert.Equal("Updated Task", task.TitleName);
        Assert.Equal("Updated Description", task.Description);
        Assert.Equal(Status.DONE, task.Status);
        Assert.Equal(new DateTime(2023, 11, 1), task.Date);
        Assert.Equal("P67890", task.ProjectId);
       // Assert.Equal("Updated Project", task.Project.Name);
        Assert.Equal("E67890", task.EmployeeId);
        //Assert.Equal("Jane Doe", task.Employee.Name);
    }        
        [Fact]
        public void CreateTask_ReturnsOkResult_WithCreatedTask()
        {
            // Arrange
            var context = GetInMemoryDbContext();
            SeedData(context);
            var controller = new TaskController(context);

            var ProjectId = "1";
            var EmployeeId = "1";
            var newTaskDto = new TaskDto
            {
                TitleName = "New Task",
                Description = "New Task Description",
                Date = DateTime.Now,
                Status = Status.PENDING
            };
            
            var result = controller.TaskCreate(newTaskDto, ProjectId, EmployeeId) as OkObjectResult;

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
            // Arrange
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);

            // Clear the database to ensure a clean state
            context.Tasks.RemoveRange(context.Tasks);
            context.SaveChanges();

            context.Projects.Add(new Project
            {
                ProjectId = "11",
                Name = "Project 1",
                CompanyId = "1",
                Description = "Project Description"
            });
            context.Tasks.Add(new Task
            {
                TaskId = "b",
                TitleName = "Task 2",
                Description = "Task 2 Description",
                ProjectId = "11",
                EmployeeId = "10",
            });

            context.SaveChanges();

            // Act
            var result = controller.TaskGetAll(projectId: "11") as OkObjectResult;

            // Assert
            Assert.NotNull(result);
            var tasks = result.Value as List<Task>;
            Assert.NotNull(tasks);
            Assert.Equal(1, tasks.Count);
        }

        [Fact]
        public void GetTaskById_ReturnsOkResult_WithTask()
        {
            // Arrange
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

            // Act
            var result = controller.TaskGetById("c") as OkObjectResult;

            // Assert
            Assert.NotNull(result);
            var task = result.Value as Task;
            Assert.NotNull(task);
            Assert.Equal("Task 3", task.TitleName);
            Assert.Equal("Task 3 Description", task.Description);
        }

        [Fact]
        public void UpdateTask_ReturnsOkResult_WithUpdatedTask()
        {
            // Arrange
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
            };

            // Act
            var result = controller.TaskUpdate("d", updatedTaskDto) as OkObjectResult;

            // Assert
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
            // Arrange
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

            // Act
            var result = controller.TaskDelete("e") as OkObjectResult;

            // Assert
            Assert.NotNull(result);
            Assert.Equal("Task deleted successfully", result.Value);

            var task = context.Tasks.Find("e");
            Assert.Null(task);
        }

        [Fact]
        public void DeleteTask_ReturnsNotFoundResult_WhenTaskNotFound()
        {
            // Arrange
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);

            // Act
            var result = controller.TaskDelete("f") as NotFoundResult;

            // Assert
            Assert.NotNull(result);
        }

        [Fact]
        public void UpdateTask_ReturnsNotFoundResult_WhenTaskNotFound()
        {
            // Arrange
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);

            var ProjectId = "1";
            var EmployeeId = "1";
            var updatedTaskDto = new TaskDto
            {
                TitleName = "Updated Task",
                Description = "Updated Task Description",
                Date = DateTime.Now,
                Status = Status.PENDING,
            };

            // Act
            var result = controller.TaskUpdate("i", updatedTaskDto) as NotFoundObjectResult;

            // Assert
            Assert.NotNull(result);
            Assert.Equal("Task not found", result.Value);
        }

        [Fact]
        public void GetTaskById_ReturnsNotFoundResult_WhenTaskNotFound()
        {
            // Arrange
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);

            // Act
            var result = controller.TaskGetById("j") as NotFoundResult;

            // Assert
            Assert.NotNull(result);
        }

        [Fact]
        public void GetAllTasks_ReturnsOkResult_WithNoTasks()
        {
            // Arrange
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);

            // Clear the database
            context.Tasks.RemoveRange(context.Tasks);
            context.SaveChanges();

            // Act
            var result = controller.TaskGetAll(projectId: "1") as OkObjectResult;

            // Assert
            Assert.NotNull(result);
            var tasks = result.Value as List<Task>;
            Assert.NotNull(tasks);
            Assert.Empty(tasks);
        }

        [Fact]
        public void CreateTask_ReturnsBadRequestResult_WhenTaskIsNull()
        {
            // Arrange
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);

            // Act
            var result = controller.TaskCreate(null,null,null) as BadRequestObjectResult;

            // Assert
            Assert.NotNull(result);
            Assert.Equal("Task is null", result.Value);
        }

        [Fact]
        public void UpdateTask_ReturnsBadRequestResult_WhenModelStateIsInvalid()
        {
            // Arrange
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);
            controller.ModelState.AddModelError("TitleName", "Required");

            var ProjectId = "1";
            var EmployeeId = "1";
            var updatedTaskDto = new TaskDto
            {
                TitleName = "Updated Task",
                Description = "Updated Task Description",
                Date = DateTime.Now,
                Status = Status.PENDING,
            };

            // Act
            var result = controller.TaskUpdate("k", updatedTaskDto) as BadRequestObjectResult;

            // Assert
            Assert.NotNull(result);

            var errors = result.Value as SerializableError;
            Assert.NotNull(errors);
            Assert.True(errors.ContainsKey("TitleName"));
            Assert.Equal("Required", ((string[])errors["TitleName"])[0]);
        }
    }
}