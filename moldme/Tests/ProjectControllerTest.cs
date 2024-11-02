using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.data;
using moldme.Models;
using moldme.Controllers;
using Xunit;

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
        
        var employeeId = "EMP002";  // Employee não existente
        var projectId = "PROJ02";   // Projeto não existente

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
        Assert.False(dbContext.Projects.Any(p => p.ProjectId == projectId && p.Employees.Any(e => e.EmployeeID == employeeId)));
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

            var result = controller.AcceptOffer("1", "PROJ01", "OFFER01") as OkObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Offer accepted successfully", result.Value);

            var acceptedOffer = dbContext.Offers.FirstOrDefault(o => o.OfferId == "OFFER01");
            Assert.NotNull(acceptedOffer);
            Assert.Equal(Status.ACCEPTED, acceptedOffer.Status);
        }
    }
    
    [Fact]
    public void AcceptOffer_InvalidCompany_ReturnsNotFound()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new ProjectController(dbContext);

            var result = controller.AcceptOffer("invalid", "PROJ01", "OFFER01") as NotFoundObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Company not found", result.Value);
        }
    }
    
    [Fact]
    public void AcceptOffer_InvalidProject_ReturnsNotFound()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new ProjectController(dbContext);

            var result = controller.AcceptOffer("1", "invalid", "OFFER01") as NotFoundObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Project not found", result.Value);
        }
    }
    
    [Fact]
    public void AcceptOffer_InvalidOffer_ReturnsNotFound()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new ProjectController(dbContext);

            var result = controller.AcceptOffer("1", "PROJ01", "invalid") as NotFoundObjectResult;

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

            var result = controller.RejectOffer("1", "PROJ01", "OFFER01") as OkObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Offer rejected successfully", result.Value);

            var rejectedOffer = dbContext.Offers.FirstOrDefault(o => o.OfferId == "OFFER01");
            Assert.NotNull(rejectedOffer);
            Assert.Equal(Status.DENIED, rejectedOffer.Status);
        }
    }
    
    [Fact]
    public void RejectOffer_InvalidCompany_ReturnsNotFound()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new ProjectController(dbContext);

            var result = controller.RejectOffer("invalid", "PROJ01", "OFFER01") as NotFoundObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Company not found", result.Value);
        }
    }
    
    [Fact]
    public void RejectOffer_InvalidProject_ReturnsNotFound()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new ProjectController(dbContext);

            var result = controller.RejectOffer("1", "invalid", "OFFER01") as NotFoundObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Project not found", result.Value);
        }
    }
    
    [Fact]
    public void RejectOffer_InvalidOffer_ReturnsNotFound()
    {
        using (var dbContext = GetInMemoryDbContext())
        {
            SeedData(dbContext);

            var controller = new ProjectController(dbContext);

            var result = controller.RejectOffer("1", "PROJ01", "invalid") as NotFoundObjectResult;

            Assert.NotNull(result);
            Assert.Equal("Offer not found", result.Value);
        }
    }
}

