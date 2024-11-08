using Xunit;
using Moq;
using Microsoft.AspNetCore.Mvc;
using moldme.Controllers;
using moldme.data;
using moldme.Models;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Task = System.Threading.Tasks.Task;

namespace moldme.Tests
{
    public class ChatControllerTests
    {
        private ApplicationDbContext GetInMemoryDbContext()
        {
            var options = new DbContextOptionsBuilder<ApplicationDbContext>()
                .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
                .Options;
            return new ApplicationDbContext(options);
        }

        [Fact]
        public async Task CreateChat_ReturnsOkResult()
        {
            using (var dbContext = GetInMemoryDbContext())
            {
                var controller = new ChatController(dbContext);
                var project = new Project
                {
                    ProjectId = "2",
                    Name = "Project 1",
                    Description = "Description 1",
                    Budget = 1000,
                    Status = Status.INPROGRESS,
                    StartDate = DateTime.Now,
                    EndDate = DateTime.Now,
                    CompanyId = "1"
                };
                dbContext.Projects.Add(project);

                var chat = new Chat
                {
                    ChatId = "1",
                    ProjectId = "2"
                    
                };
                

                var result = await controller.CreateChat(chat);

                Assert.NotNull(result);
                var okResult = result.Result as OkObjectResult;
                Assert.NotNull(okResult);
                Assert.Equal("Chat created successfully", okResult.Value);
            }
        }
        [Fact]
        public void Chat_Properties_GetterSetter_WorksCorrectly()
        {
            // Arrange
            var chat = new Chat
            {
                ChatId = "C12345",
                ProjectId = "P12345",
                Messages = new List<Message>
                {
                    new Message { MessageId = "M1", Text = "Hello", Date = DateTime.Now, EmployeeId = "E1" },
                    new Message { MessageId = "M2", Text = "World", Date = DateTime.Now, EmployeeId = "E2" }
                },
                Project = new Project { ProjectId = "P12345", Name = "Project 1" }
            };

            // Act & Assert
            Assert.Equal("C12345", chat.ChatId);
            Assert.Equal("P12345", chat.ProjectId);
            Assert.Equal(2, chat.Messages.Count);
            Assert.Equal("Hello", chat.Messages[0].Text);
            Assert.Equal("World", chat.Messages[1].Text);
            Assert.Equal("Project 1", chat.Project.Name);

            // Test Messages setter
            var newMessages = new List<Message>
            {
                new Message { MessageId = "M3", Text = "New Message", Date = DateTime.Now, EmployeeId = "E3" }
            };
            chat.Messages = newMessages;
            Assert.Single(chat.Messages);
            Assert.Equal("New Message", chat.Messages[0].Text);

            // Test Project getter and setter
            var newProject = new Project { ProjectId = "P67890", Name = "New Project" };
            chat.Project = newProject;
            Assert.Equal("P67890", chat.Project.ProjectId);
            Assert.Equal("New Project", chat.Project.Name);
        }

        [Fact]
        public async Task DeleteChat_ExistingId_ReturnsOkResult()
        {
            using (var dbContext = GetInMemoryDbContext())
            {
                var chat = new Chat
                {
                    ChatId = "1",
                    ProjectId = "2"
                    
                };
                dbContext.Chats.Add(chat);
                dbContext.SaveChanges();

                var controller = new ChatController(dbContext);

                var result = await controller.DeleteChat("1") as OkObjectResult;

                Assert.NotNull(result);
                Assert.Equal("Chat deleted successfully", result.Value);
            }
        }

        [Fact]
        public async Task DeleteChat_NonExistingId_ReturnsNotFoundResult()
        {
            using (var dbContext = GetInMemoryDbContext())
            {
                var controller = new ChatController(dbContext);

                var result = await controller.DeleteChat("non-existing-id") as NotFoundObjectResult;

                Assert.Equal("Chat not found", result.Value);
            }
        }
    }
}