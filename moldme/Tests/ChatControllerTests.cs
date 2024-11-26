using Xunit;
using Microsoft.AspNetCore.Mvc;
using moldme.Controllers;
using moldme.data;
using moldme.Models;
using Microsoft.EntityFrameworkCore;
using Task = System.Threading.Tasks.Task;

namespace moldme.Tests
{
    public class ChatControllerTests
    {
        public ApplicationDbContext GetInMemoryDbContext()
        {
            var options = new DbContextOptionsBuilder<ApplicationDbContext>()
                .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
                .Options;
            return new ApplicationDbContext(options);
        }
        
        private void SeedData(ApplicationDbContext dbContext)
        {
            var company = new Company
            {
                CompanyId = "1",
                Name = "Company 1",
                Address = "Address 1",
                Email = "email@example.com",
                Contact = 123456789,
                TaxId = 123456789,
                Sector = "Sector 1",
                Plan = SubscriptionPlan.Premium,
                Password = "password"
            };

            var employee = new Employee
            {
                EmployeeId = "EMP001",
                Name = "John Doe",
                Profession = "Developer",
                NIF = 123456789,
                Email = "john.doe@example.com",
                Password = "password123",
                CompanyId = company.CompanyId
            };

            var project = new Project
            {
                ProjectId = "PROJ01",
                Name = "New Project",
                Description = "Project Description",
                Budget = 1000,
                StartDate = DateTime.Now,
                EndDate = DateTime.Now,
                CompanyId = company.CompanyId
            };

            var offer = new Offer
            {
                OfferId = "OFFER01",
                CompanyId = "1",
                ProjectId = "PROJ01",
                Date = DateTime.Now,
                Status = Status.PENDING,
                Description = "Description 1"
            };


            dbContext.Companies.Add(company);
            dbContext.Employees.Add(employee);
            dbContext.Projects.Add(project);
            dbContext.Offers.Add(offer);
            dbContext.SaveChanges();
        }

        [Fact]
        public async Task CreateChat_ReturnsOkResult()
        {
            var dbContext = GetInMemoryDbContext();
            SeedData(dbContext);
            {
                var controller = new ChatController(dbContext);

                var ProjectId = "PROJ01";


                var result = await controller.ChatCreate(ProjectId);
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
        public void DeleteChat_ExistingId_ReturnsOkResult()
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

                var result = controller.ChatDelete("1") as OkObjectResult;

                Assert.NotNull(result);
                Assert.Equal("Chat deleted successfully", result.Value);
            }
        }

        [Fact]
        public void DeleteChat_NonExistingId_ReturnsNotFoundResult()
        {
            using (var dbContext = GetInMemoryDbContext())
            {
                var controller = new ChatController(dbContext);

                var result = controller.ChatDelete("non-existing-id") as NotFoundResult;

                Assert.NotNull(result);
            }
        }
    }
}