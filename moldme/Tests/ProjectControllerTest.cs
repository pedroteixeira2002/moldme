using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.data;
using moldme.Models;
using moldme.Controllers;
using Xunit;

namespace moldme.Tests;
public class ProjectControllerTest
{
    private readonly ApplicationDbContext dbContext;
    private readonly ProjectController projectController;

    public ProjectControllerTest()
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;

        dbContext = new ApplicationDbContext(options);
        projectController = new ProjectController(dbContext);
    }

    private void SeedData()
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
            CompanyID = company.CompanyID
        };

        var project = new Project
        {
            ProjectId = "PROJ01",
            Name = "New Project",
            Description = "Project Description",
            Budget = 1000,
            StartDate = DateTime.Now,
            EndDate = DateTime.Now.AddDays(30),
            CompanyId = company.CompanyID
        };

        dbContext.Companies.Add(company);
        dbContext.Employees.Add(employee);
        dbContext.Projects.Add(project);
        dbContext.SaveChanges();
    }

    [Fact]
    public void AssignEmployee_ShouldReturnOk_WhenEmployeeAndProjectAreValid()
    {
        SeedData();
        var employeeId = "EMP001";
        var projectId = "PROJ01";

        // Act
        var result = projectController.AssignEmployee(employeeId, projectId);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal("Employee assigned to project successfully.", okResult.Value);
        Assert.True(dbContext.Projects.Any(p => p.ProjectId == projectId));
    }

    [Fact]
    public void AssignEmployee_ShouldReturnConflict_WhenEmployeeAlreadyAssigned()
    {
        SeedData();
        var employeeId = "EMP001";
        var projectId = "PROJ01";

        // Primeira associação
        projectController.AssignEmployee(employeeId, projectId);

        // Act
        var result = projectController.AssignEmployee(employeeId, projectId);

        // Assert
        var conflictResult = Assert.IsType<ConflictObjectResult>(result);
        Assert.Equal("Employee is already assigned to this project.", conflictResult.Value);
    }

    [Fact]
    public void RemoveEmployee_ShouldReturnNotFound_WhenEmployeeNotAssignedToProject()
    {
        SeedData();
        var employeeId = "EMP002";  // Employee não existente
        var projectId = "PROJ02";   // Projeto não existente

        // Act
        var result = projectController.RemoveEmployee(employeeId, projectId);

        // Assert
        var notFoundResult = Assert.IsType<NotFoundObjectResult>(result);
        Assert.Equal("Employee not found.", notFoundResult.Value); // Corrigido para a mensagem correta
    }


    [Fact]
    public void RemoveEmployee_ShouldReturnOk_WhenEmployeeAssigned()
    {
        SeedData();
        var employeeId = "EMP001";
        var projectId = "PROJ01";

        // Primeiro atribuímos o funcionário ao projeto
        projectController.AssignEmployee(employeeId, projectId);

        // Act
        var result = projectController.RemoveEmployee(employeeId, projectId);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal("Employee removed from project successfully.", okResult.Value);
        Assert.False(dbContext.Projects.Any(p => p.ProjectId == projectId && p.Employees.Any(e => e.EmployeeID == employeeId)));
    }

    [Fact]
    public void AssignEmployee_ShouldReturnBadRequest_WhenEmployeeIdIsNull()
    {
        SeedData();
        var projectId = "PROJ01";

        // Act
        var result = projectController.AssignEmployee(null, projectId);

        // Assert
        var badRequestResult = Assert.IsType<BadRequestObjectResult>(result);
        Assert.Equal("Employee ID cannot be null or empty.", badRequestResult.Value);
    }

    [Fact]
    public void AssignEmployee_ShouldReturnBadRequest_WhenProjectIdIsNull()
    {
        SeedData();
        var employeeId = "EMP001";

        // Act
        var result = projectController.AssignEmployee(employeeId, null);

        // Assert
        var badRequestResult = Assert.IsType<BadRequestObjectResult>(result);
        Assert.Equal("Project ID cannot be null or empty.", badRequestResult.Value);
    }

    [Fact]
    public void RemoveEmployee_ShouldReturnBadRequest_WhenEmployeeIdIsNull()
    {
        SeedData();
        var projectId = "PROJ01";

        // Act
        var result = projectController.RemoveEmployee(null, projectId);

        // Assert
        var badRequestResult = Assert.IsType<BadRequestObjectResult>(result);
        Assert.Equal("Employee ID cannot be null or empty.", badRequestResult.Value);
    }

    [Fact]
    public void RemoveEmployee_ShouldReturnBadRequest_WhenProjectIdIsNull()
    {
        SeedData();
        var employeeId = "EMP001";

        // Act
        var result = projectController.RemoveEmployee(employeeId, null);

        // Assert
        var badRequestResult = Assert.IsType<BadRequestObjectResult>(result);
        Assert.Equal("Project ID cannot be null or empty.", badRequestResult.Value);
    }
    
}


