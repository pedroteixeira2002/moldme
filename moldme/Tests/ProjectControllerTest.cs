using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.Controllers;
using moldme.data;
using moldme.Models;
using Xunit;

namespace moldme.Tests
{
    public class ProjectControllerTest
    {
        //private readonly ApplicationDbContext dbContext;
        //private readonly ProjectController projectController;

        public ProjectControllerTest()
        {
            var options = new DbContextOptionsBuilder<ApplicationDbContext>()
                .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
                .Options;

            //dbContext = new ApplicationDbContext(options);
            //projectController = new ProjectController(dbContext);
            return new ApplicationDbContext(options);
        }
        [Fact]
        public void AssignEmployee_ShouldReturnOk_WhenEmployeeAndProjectAreValid()
        {
            // Arrange
            var employeeId = "EMP001";
            var projectId = "PROJ01";
            var companyId = "1";
            
            dbContext.Employees.Add(new Employee
            {
                EmployeeID = employeeId,
                Name = "John Doe",
                Profession = "Developer",
                NIF = 123456789,
                Email = "john.doe@example.com",
                Password = "password123",
                CompanyID = companyId 
            });
            dbContext.Projects.Add(new Project
            {
                ProjectId = projectId,
                Name = "New Project",
                Description = "Project Description",
                Budget = 1000,
                StartDate = DateTime.Now,
                EndDate = DateTime.Now.AddDays(30),
                CompanyId = companyId // Preencher o CompanyId
            });
    
            dbContext.SaveChanges();

            // Act
            var result = projectController.AssignEmployee(employeeId, projectId);

            // Assert
            var okResult = Assert.IsType<OkObjectResult>(result);
            Assert.Equal("Employee assigned to project successfully.", okResult.Value);
            Assert.NotEmpty(dbContext.StaffOnProjects);
        }


        [Fact]
        public void AssignEmployee_ShouldReturnConflict_WhenStaffOnProjectAlreadyExists()
        {
            // Arrange
            var employeeId = "EMP002";
            var projectId = "PROJ02";
            var staffOnProject = new StaffOnProject
            {
                Id = Guid.NewGuid().ToString(),
                EmployeeId = employeeId,
                ProjectId = projectId
            };

            dbContext.StaffOnProjects.Add(staffOnProject);
            dbContext.SaveChanges();

            // Act
            var result = projectController.AssignEmployee(employeeId, projectId);

            // Assert
            var conflictResult = Assert.IsType<ConflictObjectResult>(result);
            Assert.Equal("Employee is already assigned to this project.", conflictResult.Value);
        }

        [Fact]
        public void RemoveEmployee_ShouldReturnOk_WhenEmployeeExists()
        {
            // Arrange
            var employeeId = "EMP003";
            var projectId = "PROJ03";
            var staffOnProject = new StaffOnProject
            {
                Id = Guid.NewGuid().ToString(),
                EmployeeId = employeeId,
                ProjectId = projectId
            };

            dbContext.StaffOnProjects.Add(staffOnProject);
            dbContext.SaveChanges();

            // Act
            var result = projectController.RemoveEmployee(employeeId, projectId);

            // Assert
            var okResult = Assert.IsType<OkObjectResult>(result);
            Assert.Equal("Employee removed from project successfully.", okResult.Value);
            Assert.Empty(dbContext.StaffOnProjects); // Verificar se foi removido
        }

        [Fact]
        public void RemoveEmployee_ShouldReturnNotFound_WhenEmployeeDoesNotExist()
        {
            // Arrange
            var employeeId = "EMP004";
            var projectId = "PROJ04";

            // Act
            var result = projectController.RemoveEmployee(employeeId, projectId);

            // Assert
            var notFoundResult = Assert.IsType<NotFoundObjectResult>(result);
            Assert.Equal("No record found for this employee in this project.", notFoundResult.Value);
        }

        [Fact]
        public void AssignEmployee_ShouldReturnBadRequest_WhenEmployeeIdIsNull()
        {
            // Arrange
            var projectId = "PROJ05";

            // Act
            var result = projectController.AssignEmployee(null, projectId);

            // Assert
            var badRequestResult = Assert.IsType<BadRequestObjectResult>(result);
            Assert.Equal("Employee ID cannot be null or empty.", badRequestResult.Value);
        }

        [Fact]
        public void AssignEmployee_ShouldReturnBadRequest_WhenProjectIdIsNull()
        {
            // Arrange
            var employeeId = "EMP005";

            // Act
            var result = projectController.AssignEmployee(employeeId, null);

            // Assert
            var badRequestResult = Assert.IsType<BadRequestObjectResult>(result);
            Assert.Equal("Project ID cannot be null or empty.", badRequestResult.Value);
        }

        [Fact]
        public void RemoveEmployee_ShouldReturnBadRequest_WhenEmployeeIdIsNull()
        {
            // Arrange
            var projectId = "PROJ06"; // ID de projeto

            // Act
            var result = projectController.RemoveEmployee(null, projectId);

            // Assert
            var badRequestResult = Assert.IsType<BadRequestObjectResult>(result); 
            Assert.Equal("Employee ID cannot be null or empty.", badRequestResult.Value);
        }
        

        [Fact]
        public void RemoveEmployee_ShouldReturnBadRequest_WhenProjectIdIsNull()
        {
            // Arrange
            var employeeId = "EMP006";

            // Act
            var result = projectController.RemoveEmployee(employeeId, null);

            // Assert
            var badRequestResult = Assert.IsType<BadRequestObjectResult>(result);
            Assert.Equal("Project ID cannot be null or empty.", badRequestResult.Value);
        }
        
        
        private void SeedData(ApplicationDbContext dbContext)
        {
            var company = new Company
            {
                CompanyID = "1",
                Name = "Company 1",
                Address = "Address 1",
                Email = "email@example.com",
                Contact = 123456789,
                TaxId = 123456789,
                Sector = "Sector 1",
                Plan = SubscriptionPlan.Premium,
                Password = "password"
            };

            var project = new Project
            {
                ProjectId = "1",
                Name = "Project 1",
                Description = "Description 1",
                Budget = 1000,
                Status = Status.INPROGRESS,
                StartDate = DateTime.Now,
                EndDate = DateTime.Now.AddDays(30),
                CompanyId = company.CompanyID
            };
            
            var offer = new Offer
            {
                OfferId = "1",
                CompanyId = "1",
                ProjectId = "1",
                Date = DateTime.Now,
                Status = Status.PENDING,
                Description = "Description 1"
            };

            dbContext.Companies.Add(company);
            dbContext.Projects.Add(project);
            dbContext.Offers.Add(offer);
            dbContext.SaveChanges();
        }
        
        // Testes para o método AcceptOffer
        [Fact]
        public void AcceptOffer_ShouldReturnOk_WhenOfferIsAccepted()
        {
            using (var dbContext = GetInMemoryDbContext())
            {
                SeedData(dbContext);

                var controller = new ProjectController(dbContext);

                var result = controller.AcceptOffer("1", "1", "1") as OkObjectResult;

                Assert.NotNull(result);
                Assert.Equal("Offer accepted successfully", result.Value);

                var acceptedOffer = dbContext.Offers.FirstOrDefault(o => o.OfferId == "1");
                Assert.NotNull(acceptedOffer);
                Assert.Equal(Status.ACCEPTED, acceptedOffer.Status);
            }

        }
    }
}
