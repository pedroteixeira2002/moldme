using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.data;
using moldme.Models;
using moldme.Controllers;
using moldme.DTOs;
using Xunit;
using Task = System.Threading.Tasks.Task;

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
            Company = new Company { CompanyId = "C12345", Name = "Tech Corp" },
            Tasks = new List<Models.Task>
            {
                new Models.Task() { TaskId = "T1", TitleName = "Task 1", Description = "Task 1 Description" },
                new Models.Task() { TaskId = "T2", TitleName = "Task 2", Description = "Task 2 Description" }
            },
            Employees = new List<Employee>
            {
                new Employee { EmployeeId = "EMP001", Name = "John Doe", Profession = "Developer" }
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
        project.Company = new Company { CompanyId = "C67890", Name = "New Tech Corp" };
        project.Tasks = new List<Models.Task>
        {
            new Models.Task() { TaskId = "T3", TitleName = "Task 3", Description = "Task 3 Description" }
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
        var result = controller.ProjectAssignEmployee(employeeId, projectId);

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
        controller.ProjectAssignEmployee(employeeId, projectId);

        // Act
        var result = controller.ProjectAssignEmployee(employeeId, projectId);

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
        var result = controller.ProjectRemoveEmployee(employeeId, projectId);

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
        controller.ProjectAssignEmployee(employeeId, projectId);

        // Act
        var result = controller.ProjectRemoveEmployee(employeeId, projectId);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal("Employee removed from project successfully.", okResult.Value);
        Assert.False(dbContext.Projects.Any(p =>
            p.ProjectId == projectId && p.Employees.Any(e => e.EmployeeId == employeeId)));
    }

    [Fact]
    public void AssignEmployee_ShouldReturnBadRequest_WhenEmployeeIdIsNull()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new ProjectController(dbContext);

        var projectId = "PROJ01";

        // Act
        var result = controller.ProjectAssignEmployee(null, projectId);

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
        var result = controller.ProjectAssignEmployee(employeeId, null);

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
        var result = controller.ProjectRemoveEmployee(null, projectId);

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
        var result = controller.ProjectRemoveEmployee(employeeId, null);

        // Assert
        var badRequestResult = Assert.IsType<BadRequestObjectResult>(result);
        Assert.Equal("Project ID cannot be null or empty.", badRequestResult.Value);
    }
    [Fact]
    public void ViewProjectTest_ShouldReturnOk_WhenProjectExists()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new ProjectController(dbContext);
        var result = controller.ProjectView("PROJ01") as OkObjectResult;

        Assert.NotNull(result);
        var project = result.Value as Project;
        Assert.Equal("New Project", project.Name);
    }

    [Fact]
    public void RemoveProjectTest_ShouldReturnOk_WhenProjectExists()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new ProjectController(dbContext);
        var result = controller.ProjectRemove("PROJ01") as OkObjectResult;

        Assert.NotNull(result);
        Assert.Equal("Project removed successfully", result.Value);
        Assert.False(dbContext.Projects.Any(p => p.ProjectId == "PROJ01"));
    }

    [Fact]
    public async Task ListAllProjectsFromCompany_ShouldReturnOk_WhenProjectsExist()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new ProjectController(dbContext);
        
        var result = await controller.ListAllProjectsFromCompany("1") as OkObjectResult;

        Assert.NotNull(result);
        var projects = result.Value as List<Project>;
        Assert.Equal(1, projects.Count);
    }

    [Fact]
    public void AddProjectTest()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new ProjectController(dbContext);
        var projectDto = new ProjectDto
        {
            Name = "New Project1",
            Description = "New Project Description",
            Budget = 5000,
            StartDate = DateTime.Now,
            EndDate = DateTime.Now.AddMonths(1)
        };

        var result = controller.ProjectCreate("1", projectDto) as OkObjectResult;

        Assert.NotNull(result);
        Assert.Equal("Project added successfully", result.Value);

        var addedProject = dbContext.Projects.FirstOrDefault(p => p.Name == "New Project1");
        Assert.NotNull(addedProject);
        Assert.Equal("New Project Description", addedProject.Description);
        Assert.Equal(5000, addedProject.Budget);
    }

    [Fact]
    public void AddProject_ShouldReturnNotFound_WhenCompanyDoesNotExist()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new ProjectController(dbContext);
        var projectDto = new ProjectDto
        {
            Name = "New Project",
            Description = "New Project Description",
            Budget = 5000,
            StartDate = DateTime.Now,
            EndDate = DateTime.Now.AddMonths(1),
        };

        // Act
        var result = controller.ProjectCreate("999", projectDto) as NotFoundObjectResult;

        // Assert
        Assert.NotNull(result);
        Assert.Equal("Company not found", result.Value);
    }

    [Fact]
    public void AddProject_ShouldReturnOk()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new ProjectController(dbContext);
        var projectDto = new ProjectDto
        {
            Name = "New Project",
            Description = "New Project Description",
            Budget = 5000,
            StartDate = DateTime.Now,
            EndDate = DateTime.Now.AddMonths(1),
        };

        var result = controller.ProjectCreate("1", projectDto) as OkObjectResult;
        
        Assert.NotNull(result);
    }

    [Fact]
    public void EditProjectTest()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new ProjectController(dbContext);
        var projectDto = new ProjectDto
        {
            Name = "Updated Project",
            Description = "Updated Project Description",
            Budget = 10000,
            StartDate = DateTime.Now,
            EndDate = DateTime.Now.AddMonths(2)
        };

        // Act
        var result = controller.ProjectUpdate("PROJ01", projectDto) as OkObjectResult;

        // Assert
        Assert.NotNull(result);
        Assert.Equal("Project updated successfully", result.Value);

        var updatedProject = dbContext.Projects.FirstOrDefault(p => p.ProjectId == "PROJ01");
        Assert.NotNull(updatedProject);
        Assert.Equal("Updated Project", updatedProject.Name);
        Assert.Equal("Updated Project Description", updatedProject.Description);
        Assert.Equal(10000, updatedProject.Budget);
    }
    
    
    [Fact]
    public async Task ListAllProjectsFromCompany_ShouldReturnNotFound_WhenCompanyDoesNotExist()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new ProjectController(dbContext);
        // Act
        var result = await controller.ListAllProjectsFromCompany("999") as NotFoundObjectResult;

        // Assert
        Assert.NotNull(result);
        Assert.Equal("Company not found", result?.Value);
    }

    [Fact]
    public async Task ListAllProjectsFromCompany_ShouldReturnOk_WhenNoProjectsExist()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new ProjectController(dbContext);
        // Remove todos os projetos para simular
        dbContext.Projects.RemoveRange(dbContext.Projects);
        dbContext.SaveChanges();

        // Act
        var result = await controller.ListAllProjectsFromCompany("1") as OkObjectResult;

        // Assert
        Assert.NotNull(result);
        Assert.Equal("No projects found for this company", result.Value);
    }

    //getprojectbyid in company
    [Fact]
    public async Task GetProjectById_ShouldReturnOk_WhenProjectExists()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new ProjectController(dbContext);
        var result = await controller.GetProjectById("1", "PROJ01") as OkObjectResult;

        Assert.NotNull(result);
        var project = result.Value as Project;
        Assert.Equal("New Project", project.Name);
    }

    [Fact]
    public async Task GetProjectById_ShouldReturnNotFound_WhenProjectDoesNotExist()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new ProjectController(dbContext);
        var result = await controller.GetProjectById("1", "PROJ02") as NotFoundObjectResult;

        Assert.NotNull(result);
        Assert.Equal("Project not found or does not belong to the specified company.", result.Value);
    }

    [Fact]
    public async Task GetProjectById_ShouldReturnNotFound_WhenCompanyDoesNotExist()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new ProjectController(dbContext);
        var result = await controller.GetProjectById("999", "PROJ01") as NotFoundObjectResult;

        Assert.NotNull(result);
        Assert.Equal("Company not found", result.Value);
    }
}

