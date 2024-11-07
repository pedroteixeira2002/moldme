using Xunit;
using Microsoft.AspNetCore.Mvc;
using moldme.Controllers;
using moldme.data;
using moldme.Models;
using Microsoft.EntityFrameworkCore;
using moldme.DTOs;
using moldme.hubs;
using Moq;
using Microsoft.AspNetCore.SignalR;
using Task = System.Threading.Tasks.Task;

namespace moldme.Tests
{
    public class MessageControllerTests
    {
        private ApplicationDbContext GetInMemoryDbContext()
        {
            var options = new DbContextOptionsBuilder<ApplicationDbContext>()
                .UseInMemoryDatabase(databaseName: "MessageControllerTestDatabase")
                .Options;
            return new ApplicationDbContext(options);
        }

        private IHubContext<ChatHub> GetMockHubContext()
        {
            var mockClients = new Mock<IHubClients>();
            var mockClientProxy = new Mock<IClientProxy>();

            mockClients.Setup(clients => clients.All).Returns(mockClientProxy.Object);

            var mockHubContext = new Mock<IHubContext<ChatHub>>();
            mockHubContext.Setup(hub => hub.Clients).Returns(mockClients.Object);

            return mockHubContext.Object;
        }

        [Fact]
        public async Task SendMessage_ReturnsCreatedAtActionResult()
        {
            using (var dbContext = GetInMemoryDbContext())
            {
                var hubContext = GetMockHubContext();
                var controller = new MessageController(dbContext, hubContext);

                var company = new Company
                {
                    CompanyID = "1",
                    Name = "Test Company",
                    Address = "123 Street",
                    Email = "company@example.com",
                    Contact = 123456789,
                    TaxId = 123456789,
                    Sector = "Sector",
                    Plan = SubscriptionPlan.Premium,
                    Password = "SecurePassword123"
                };

                var project = new Project
                {
                    ProjectId = "2",
                    Name = "Test Project",
                    Description = "Description",
                    Budget = 5000,
                    Status = Status.INPROGRESS,
                    StartDate = DateTime.UtcNow,
                    EndDate = DateTime.UtcNow,
                    CompanyId = "1"
                };

                var employee = new Employee
                {
                    EmployeeID = "1",
                    Name = "John Doe",
                    Profession = "Developer",
                    Email = "johndoe@example.com",
                    Password = "password123",
                    CompanyId = "1"
                };

                var chat = new Chat
                {
                    ChatId = "1",
                    ProjectId = "2"
                };

                dbContext.Companies.Add(company);
                dbContext.Projects.Add(project);
                dbContext.Employees.Add(employee);
                dbContext.Chats.Add(chat);
                await dbContext.SaveChangesAsync();

                var messageDto = new MessageDto
                {
                    Text = "Hello, World!",
                    SenderId = "1",
                    ChatId = "1"
                };

                var result = await controller.SendMessage(messageDto);
                var actionResult = result.Result as CreatedAtActionResult;
                
                
                Assert.NotNull(actionResult);
                Assert.Equal(nameof(controller.GetMessages), actionResult.ActionName);
                Assert.Equal("1", actionResult.RouteValues["chatId"]);

                var message = actionResult.Value as Message;
                Assert.NotNull(message);
                Assert.Equal("Hello, World!", message.Text);
                Assert.Equal("1", message.ChatId);
                Assert.Equal("1", message.EmployeeId);
            }
        }

        [Fact]
        public void ListAllMessages_ReturnsOkResult()
        {
            using (var dbContext = GetInMemoryDbContext())
            {
                var message1 = new Message
                {
                    MessageId = "3",
                    Text = "Hello, World!",
                    EmployeeId = "user1",
                    Date = DateTime.Now,
                    ChatId = "1"
                };

                var message2 = new Message
                {
                    MessageId = "4",
                    Text = "Hi there!",
                    EmployeeId = "user2",
                    Date = DateTime.Now,
                    ChatId = "1"
                };

                var chat1 = new Chat
                {
                    ChatId = "2",
                    ProjectId = "2",
                    Messages = { message1, message2 }
                };
                dbContext.Messages.Add(message1);
                dbContext.Messages.Add(message2);
                dbContext.Chats.Add(chat1);

                dbContext.SaveChanges();

                var hubContext = GetMockHubContext();
                var controller = new MessageController(dbContext, hubContext);

                var result = controller.GetMessages("2").Result;
                var okResult = result.Result as OkObjectResult;

                Assert.NotNull(okResult);
                var messages = okResult.Value as List<Message>;
                Assert.Equal(2, messages.Count);
            }
        }
    }
}