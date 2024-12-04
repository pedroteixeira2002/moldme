using Xunit;
using Microsoft.AspNetCore.Mvc;
using moldme.Controllers;
using moldme.data;
using moldme.Models;
using Microsoft.EntityFrameworkCore;
using moldme.DTOs;
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

        [Fact]
        public void Message_Properties_GetterSetter_WorksCorrectly()
        {
            
            var message = new Message
            {
                MessageId = "M12345",
                Text = "Hello, World!",
                Date = new DateTime(2023, 10, 1),
                EmployeeId = "E12345",
                //Employee = new Employee { EmployeeId = "E12345", Name = "John Doe" },
                ChatId = "C12345",
                //Chat = new Chat { ChatId = "C12345", ProjectId = "P12345" }
            };

            Assert.Equal("M12345", message.MessageId);
            Assert.Equal("Hello, World!", message.Text);
            Assert.Equal(new DateTime(2023, 10, 1), message.Date);
            Assert.Equal("E12345", message.EmployeeId);
            //Assert.Equal("John Doe", message.Employee.Name);
            Assert.Equal("C12345", message.ChatId);
            //Assert.Equal("P12345", message.Chat.ProjectId);
        }

        [Fact]
        public async Task SendMessage_ReturnsCreatedAtActionResult()
        {
            using (var dbContext = GetInMemoryDbContext())
            {
                var controller = new MessageController(dbContext);
                var sender = new Employee
                {
                    EmployeeId = "11",
                    Name = "Employee 1",
                    Profession = "Profession 1",
                    NIF = 123456789,
                    Email = "employee1@example.com",
                    Contact = 987654321,
                    Password = "password",
                    CompanyId = "1"
                };
                dbContext.Employees.Add(sender);
                var Chat = new Chat
                {
                    ChatId = "C12345",
                    ProjectId = "P12345"
                };
                dbContext.Chats.Add(Chat);
                dbContext.SaveChanges();
                var EmployeeId = "11";
                var ChatId = "C12345";
                
                var messageDto = new MessageDto
                {
                    Text = "Hello, World!",
                };

                var result = await controller.SendMessage(messageDto, ChatId, EmployeeId);
                var actionResult = result.Result as CreatedAtActionResult;

                Assert.NotNull(actionResult);
                Assert.Equal(nameof(controller.GetMessages), actionResult.ActionName);
                var message = actionResult.Value as Message;
                Assert.NotNull(message);
                Assert.Equal("Hello, World!", message.Text);
            }
        }

        [Fact]
        public void DeleteMessage_ExistingId_ReturnsOkResult()
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

                var message = new Message
                {
                    MessageId = "2",
                    Text = "Hello, World!",
                    EmployeeId = "user1",
                    Date = DateTime.Now,
                    ChatId = "1"
                };
                dbContext.Messages.Add(message);
                dbContext.SaveChanges();

                var controller = new MessageController(dbContext);

                var result = controller.DeleteMessage("2").Result;
                var okResult = result as OkObjectResult;

                Assert.NotNull(okResult);
                Assert.Equal("Message deleted successfully", okResult.Value);

                var deletedMessage = dbContext.Messages.FirstOrDefault(m => m.MessageId == "2");
                Assert.Null(deletedMessage);
            }
        }

        [Fact]
        public void DeleteMessage_NonExistingId_ReturnsNotFoundResult()
        {
            using (var dbContext = GetInMemoryDbContext())
            {
                var controller = new MessageController(dbContext);

                var result = controller.DeleteMessage("non-existing-id").Result;
                var notFoundResult = result as NotFoundObjectResult;

                Assert.NotNull(notFoundResult);
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
                   // Messages = { message1, message2 }
                };
                dbContext.Messages.Add(message1);
                dbContext.Messages.Add(message2);
                dbContext.Chats.Add(chat1);

                dbContext.SaveChanges();

                var controller = new MessageController(dbContext);

                var result = controller.GetMessages("2").Result;
                var okResult = result.Result as OkObjectResult;


                Assert.NotNull(okResult);
                var messages = okResult.Value as List<Message>;
                Assert.Equal(2, messages.Count);
            }
        }
    }
}