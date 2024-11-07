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