using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.data;
using moldme.Models;
using moldme.Controllers;
using Xunit;
using Task = moldme.Models.Task;

namespace moldme.Tests;

public class ProjectControllerTest
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


        var employee = new Employee
        {
            EmployeeID = "EMP001",
            Name = "John Doe",
            Profession = "Developer",
            NIF = 123456789,
            Email = "john.doe@example.com",
            Password = "password123",
            CompanyId = company.CompanyID
        };

        var project = new Project
        {
            ProjectId = "PROJ01",
            Name = "New Project",
            Description = "Project Description",
            Budget = 1000,
            StartDate = DateTime.Now,
            EndDate = DateTime.Now,
            CompanyId = company.CompanyID
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
    public void Project_Properties_GetterSetter_WorksCorrectly()
    {
        var project = new Project
        {
            ProjectId = "P12345",
            Name = "Project 1",
            Description = "Description of Project 1",
            Budget = 10000,
            Status = Status.INPROGRESS,
            StartDate = new DateTime(2023, 1, 1),
            EndDate = new DateTime(2023, 12, 31),
            CompanyId = "C12345",
            Company = new Company { CompanyID = "C12345", Name = "Tech Corp" },
            Tasks = new List<Task>
            {
                new Task { TaskId = "T1", TitleName = "Task 1", Description = "Task 1 Description" },
                new Task { TaskId = "T2", TitleName = "Task 2", Description = "Task 2 Description" }
            },
            Employees = new List<Employee>
            {
                new Employee { EmployeeID = "EMP001", Name = "John Doe", Profession = "Developer" }
            }
        };

        Assert.Equal("P12345", project.ProjectId);
        Assert.Equal("Project 1", project.Name);
        Assert.Equal("Description of Project 1", project.Description);
        Assert.Equal(10000, project.Budget);
        Assert.Equal(Status.INPROGRESS, project.Status);
        Assert.Equal(new DateTime(2023, 1, 1), project.StartDate);
        Assert.Equal(new DateTime(2023, 12, 31), project.EndDate);
        Assert.Equal("C12345", project.CompanyId);
        Assert.Equal("Tech Corp", project.Company.Name);
        Assert.Equal(2, project.Tasks.Count);
        Assert.Equal("Task 1", project.Tasks[0].TitleName);
        Assert.Equal("Task 2", project.Tasks[1].TitleName);

        project.Name = "Updated Project";
        project.Description = "Updated Description";
        project.Budget = 20000;
        project.Status = Status.DONE;
        project.StartDate = new DateTime(2023, 2, 1);
        project.EndDate = new DateTime(2023, 11, 30);
        project.CompanyId = "C67890";
        project.Company = new Company { CompanyID = "C67890", Name = "New Tech Corp" };
        project.Tasks = new List<Task>
        {
            new Task { TaskId = "T3", TitleName = "Task 3", Description = "Task 3 Description" }
        };

        Assert.Equal("Updated Project", project.Name);
        Assert.Equal("Updated Description", project.Description);
        Assert.Equal(20000, project.Budget);
        Assert.Equal(Status.DONE, project.Status);
        Assert.Equal(new DateTime(2023, 2, 1), project.StartDate);
        Assert.Equal(new DateTime(2023, 11, 30), project.EndDate);
        Assert.Equal("C67890", project.CompanyId);
        Assert.Equal("New Tech Corp", project.Company.Name);
        Assert.Single(project.Tasks);
        Assert.Equal("Task 3", project.Tasks[0].TitleName);
    }

    [Fact]
    public void AssignEmployee_ShouldReturnOk_WhenEmployeeAndProjectAreValid()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new ProjectController(dbContext);

        var employeeId = "EMP001";
        var projectId = "PROJ01";

        // Act
        var result = controller.AssignEmployee(employeeId, projectId);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal("Employee assigned to project successfully.", okResult.Value);
        Assert.True(dbContext.Projects.Any(p => p.ProjectId == projectId));
    }

    [Fact]
    public void AssignEmployee_ShouldReturnConflict_WhenEmployeeAlreadyAssigned()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new ProjectController(dbContext);

        var employeeId = "EMP001";
        var projectId = "PROJ01";

        // Primeira associação
        controller.AssignEmployee(employeeId, projectId);

        // Act
        var result = controller.AssignEmployee(employeeId, projectId);

        // Assert
        var conflictResult = Assert.IsType<ConflictObjectResult>(result);
        Assert.Equal("Employee is already assigned to this project.", conflictResult.Value);
    }

    [Fact]
    public void RemoveEmployee_ShouldReturnNotFound_WhenEmployeeNotAssignedToProject()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new ProjectController(dbContext);

        var employeeId = "EMP002"; // Employee não existente
        var projectId = "PROJ02"; // Projeto não existente

        // Act
        var result = controller.RemoveEmployee(employeeId, projectId);

        // Assert
        var notFoundResult = Assert.IsType<NotFoundObjectResult>(result);
        Assert.Equal("Employee not found.", notFoundResult.Value); // Corrigido para a mensagem correta
    }


    [Fact]
    public void RemoveEmployee_ShouldReturnOk_WhenEmployeeAssigned()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new ProjectController(dbContext);

        var employeeId = "EMP001";
        var projectId = "PROJ01";

        // Primeiro atribuímos o funcionário ao projeto
        controller.AssignEmployee(employeeId, projectId);

        // Act
        var result = controller.RemoveEmployee(employeeId, projectId);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal("Employee removed from project successfully.", okResult.Value);
        Assert.False(dbContext.Projects.Any(p =>
            p.ProjectId == projectId && p.Employees.Any(e => e.EmployeeID == employeeId)));
    }

    [Fact]
    public void AssignEmployee_ShouldReturnBadRequest_WhenEmployeeIdIsNull()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new ProjectController(dbContext);

        var projectId = "PROJ01";

        // Act
        var result = controller.AssignEmployee(null, projectId);

        // Assert
        var badRequestResult = Assert.IsType<BadRequestObjectResult>(result);
        Assert.Equal("Employee ID cannot be null or empty.", badRequestResult.Value);
    }

    [Fact]
    public void AssignEmployee_ShouldReturnBadRequest_WhenProjectIdIsNull()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new ProjectController(dbContext);

        var employeeId = "EMP001";

        // Act
        var result = controller.AssignEmployee(employeeId, null);

        // Assert
        var badRequestResult = Assert.IsType<BadRequestObjectResult>(result);
        Assert.Equal("Project ID cannot be null or empty.", badRequestResult.Value);
    }

    [Fact]
    public void RemoveEmployee_ShouldReturnBadRequest_WhenEmployeeIdIsNull()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new ProjectController(dbContext);

        var projectId = "PROJ01";

        // Act
        var result = controller.RemoveEmployee(null, projectId);

        // Assert
        var badRequestResult = Assert.IsType<BadRequestObjectResult>(result);
        Assert.Equal("Employee ID cannot be null or empty.", badRequestResult.Value);
    }

    [Fact]
    public void RemoveEmployee_ShouldReturnBadRequest_WhenProjectIdIsNull()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new ProjectController(dbContext);

        var employeeId = "EMP001";

        // Act
        var result = controller.RemoveEmployee(employeeId, null);

        // Assert
        var badRequestResult = Assert.IsType<BadRequestObjectResult>(result);
        Assert.Equal("Project ID cannot be null or empty.", badRequestResult.Value);
    }

    // Testes para o método AcceptOffer
    [Fact]
    public void AcceptOffer_ShouldReturnOk_WhenOfferIsAccepted()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new ProjectController(dbContext);

            var result = controller.AcceptOffer("1", "PROJ01", "OFFER01");
            var okResult = result.Result as OkObjectResult;


            Assert.NotNull(result);
            Assert.Equal("Offer accepted successfully", okResult.Value);

            var acceptedOffer = dbContext.Offers.FirstOrDefault(o => o.OfferId == "OFFER01");
            Assert.NotNull(acceptedOffer);
            Assert.Equal(Status.ACCEPTED, acceptedOffer.Status);
        }
    }

    [Fact]
    public async Task AcceptOffer_InvalidCompany_ReturnsNotFound()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new ProjectController(dbContext);

            var result = await controller.AcceptOffer("invalid", "PROJ01", "OFFER01") as NotFoundObjectResult;
            
            Assert.NotNull(result);
            Assert.Equal("Company not found", result.Value);
        }
    }

    [Fact]
    public async Task AcceptOffer_InvalidProject_ReturnsNotFound()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new ProjectController(dbContext);

            var result = await controller.AcceptOffer("1", "invalid", "OFFER01") as NotFoundObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Project not found", result.Value);
        }
    }

    [Fact]
    public async Task AcceptOffer_InvalidOffer_ReturnsNotFound()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new ProjectController(dbContext);

            var result = await controller.AcceptOffer("1", "PROJ01", "invalid") as NotFoundObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Offer not found", result.Value);
        }
    }

    // Testes para o método RejectOffer
    [Fact]
    public void RejectOffer_ShouldReturnOk_WhenOfferIsRejected()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new ProjectController(dbContext);

            var result = controller.RejectOffer("1", "PROJ01", "OFFER01") ;
            var okResult = result.Result as OkObjectResult;


            Assert.NotNull(result);
            Assert.Equal("Offer rejected successfully", okResult.Value);

            var rejectedOffer = dbContext.Offers.FirstOrDefault(o => o.OfferId == "OFFER01");
            Assert.NotNull(rejectedOffer);
            Assert.Equal(Status.DENIED, rejectedOffer.Status);
        }
    }

    [Fact]
    public async Task RejectOffer_InvalidCompany_ReturnsNotFound()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new ProjectController(dbContext);

            var result = await controller.RejectOffer("invalid", "PROJ01", "OFFER01") as NotFoundObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Company not found", result.Value);
        }
    }

    [Fact]
    public async Task RejectOffer_InvalidProject_ReturnsNotFound()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new ProjectController(dbContext);

            var result = await controller.RejectOffer("1", "invalid", "OFFER01") as NotFoundObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Project not found", result.Value);
        }
    }

    [Fact]
    public async Task RejectOffer_InvalidOffer_ReturnsNotFound()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new ProjectController(dbContext);

            var result = await controller.RejectOffer("1", "PROJ01", "invalid") as NotFoundObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Offer not found", result.Value);
        }
    }
}