using Xunit;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.Controllers;
using moldme.data;
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

        [Fact]
        public void CreateTask_ReturnsOkResult_WithCreatedTask()
        {
            // Arrange
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);

            var newTask = new Task
            {
                TaskId = "a",
                TitleName = "New Task",
                Description = "New Task Description",
                Date = DateTime.Now,
                FilePath = "moldme/UpdateTask_ReturnsNotFoundResult_WhenTaskNotFound #2.testsession"
            };

            
            var result = controller.Create(newTask) as OkObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Task created successfully", result.Value);

            var createdTask = context.Tasks.FirstOrDefault(t => t.TaskId == "a");
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

            context.Tasks.Add(new Task
            {
                TaskId = "b",
                TitleName = "Task 2",
                Description = "Task 2 Description"
            });

            context.SaveChanges();

            
            var result = controller.GetAll() as OkObjectResult;

            Assert.NotNull(result);
            var tasks = result.Value as List<Task>;
            Assert.NotNull(tasks);
            Assert.Equal(2, tasks.Count);
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
                Description = "Task 3 Description"
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
        public void GetTaskById_ReturnsOkResult_WithTaskId()
        {
            // Arrange
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);

            var newTask = new Task
            {
                TaskId = "j",
                TitleName = "Task 10",
                Description = "Task 10 Description",
                Date = DateTime.Now,
                Status = Status.TODO
            };

            context.Tasks.Add(newTask);
            context.SaveChanges();

            // Act
            var result = controller.GetById("j") as OkObjectResult;

            // Assert
            Assert.NotNull(result);
            var task = result.Value as Task;
            Assert.NotNull(task);
            Assert.Equal("j", task.TaskId);
            Assert.Equal("Task 10", task.TitleName);
            Assert.Equal("Task 10 Description", task.Description);
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
                Description = "Task 4 Description"
            });

            context.SaveChanges();

            var updatedTask = new Task
            {
                TaskId = "d",
                TitleName = "Updated Task",
                Description = "Updated Task Description"
            };

            
            var result = controller.Update("d", updatedTask) as OkObjectResult;

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
                Description = "Task 5 Description"
            });

            context.SaveChanges();

            
            var result = controller.Delete("e") as OkObjectResult;

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

            
            var result = controller.Delete("f") as NotFoundResult;

            Assert.NotNull(result);
        }
        
        [Fact]
        public void UpdateTask_ReturnsNotFoundResult_WhenTaskNotFound()
        {
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);

            var updatedTask = new Task
            {
                TaskId = "i",
                TitleName = "Updated Task",
                Description = "Updated Task Description"
            };

            var result = controller.Update("i", updatedTask) as NotFoundResult;

            Assert.NotNull(result);
        }
        
        [Fact]
        public void GetTaskById_ReturnsNotFoundResult_WhenTaskNotFound()
        {
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);

            var result = controller.GetById("j") as NotFoundResult;

            Assert.NotNull(result);
        }
        
        [Fact]
        public void GetAllTasks_ReturnsOkResult_WithNoTasks()
        {
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);

            // Clear the database
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
            Assert.Equal("Task is null", result.Value);
        }
        
        [Fact]
        public void UpdateTask_ReturnsBadRequestResult_WhenModelStateIsInvalid()
        {
            var context = GetInMemoryDbContext();
            var controller = new TaskController(context);
            controller.ModelState.AddModelError("TitleName", "Required");

            var updatedTask = new Task
            {
                TaskId = "k",
                TitleName = "Updated Task",
                Description = "Updated Task Description"
            };

            var result = controller.Update("k", updatedTask) as BadRequestObjectResult;

            Assert.NotNull(result);

            var errors = result.Value as SerializableError;
            Assert.NotNull(errors);
            Assert.True(errors.ContainsKey("TitleName"));
            Assert.Equal("Required", ((string[])errors["TitleName"])[0]);
        }
    }
    
}