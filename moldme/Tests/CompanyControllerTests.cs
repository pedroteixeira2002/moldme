namespace DefaultNamespace;

using Xunit;
using DefaultNamespace;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

public class CompanyControllerTests
{
    private readonly CompanyController _controller;
    private readonly InMemoryRepository _repository;

    public CompanyControllerTests()
    {
        _repository = new InMemoryRepository();
        _controller = new CompanyController(_repository);

        var initialCompany = new Company
        {
            Name = "Test Company",
            TaxId = 123456789,
            Address = "123 Test Street",
            Contact = 987654321,
            Email = "test@company.com",
            Sector = "IT"
        };

        _repository.AddCompany(initialCompany);
    }

    [Fact]
    public void CreateProject_ShouldAddProjectToCompany()
    {
        var project = new Project
        {
            Name = "Test Project",
            Description = "A test project",
            Budget = 1000,
            Status = "Ongoing",
            StartDate = DateTime.Now,
            EndDate = DateTime.Now.AddMonths(1)
        };
        
        var result = _controller.AddProject(1, project) as OkObjectResult;

        Assert.NotNull(result);
        Assert.Equal(200, result.StatusCode);

        var company = _repository.GetCompany(1);
        Assert.Single(company.Projects);
        Assert.Equal("Test Project", company.Projects[0].Name);
    }

    [Fact]
    public void EditProject_ShouldUpdateProjectDetails()
    {
        var initialProject = new Project
        {
            Name = "Old Project Name",
            Description = "Old Description",
            Budget = 500,
            Status = "Ongoing",
            StartDate = DateTime.Now,
            EndDate = DateTime.Now.AddMonths(1)
        };

        _repository.AddProject(1, initialProject);
        var updatedProject = new Project
        {
            Name = "Updated Project Name",
            Description = "Updated Description",
            Budget = 2000,
            Status = "Completed",
            StartDate = DateTime.Now,
            EndDate = DateTime.Now.AddMonths(2)
        };
        
        var result = _controller.EditProject(1, updatedProject) as OkObjectResult;
        Assert.NotNull(result);
        Assert.Equal(200, result.StatusCode);
        var company = _repository.GetCompany(1);
        var project = company.Projects[0];
        Assert.Equal("Updated Project Name", project.Name);
        Assert.Equal("Updated Description", project.Description);
        Assert.Equal(2000, project.Budget);
        Assert.Equal("Completed", project.Status);
    }

    [Fact]
    public void ViewProject_ShouldReturnProjectDetails()
    {
        var project = new Project
        {
            Name = "Viewable Project",
            Description = "A project to view",
            Budget = 1500,
            Status = "Pending",
            StartDate = DateTime.Now,
            EndDate = DateTime.Now.AddMonths(1)
        };
        _repository.AddProject(1, project);
        
        var result = _controller.ViewProject(1) as OkObjectResult;
        
        Assert.NotNull(result);
        Assert.Equal(200, result.StatusCode);
        
        var returnedProject = result.Value as Project;
        Assert.NotNull(returnedProject);
        Assert.Equal("Viewable Project", returnedProject.Name);
        Assert.Equal("A project to view", returnedProject.Description);
        Assert.Equal(1500, returnedProject.Budget);
        Assert.Equal("Pending", returnedProject.Status);
    }
}
