using moldme.Controllers;

namespace DefaultNamespace;

using Xunit;
using DefaultNamespace;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

public class CompanyControllerTests
{
    private readonly CompanyController _controller;
    public readonly InMemoryRepository _repository;

    public CompanyControllerTests()
    {
        _repository = new InMemoryRepository();
        _controller = new CompanyController(_repository);

        var initialCompany = new Company
        {
            name = "Test Company",
            taxid = 123456789,
            address = "123 Test Street",
            contact = 987654321,
            email = "test@company.com",
            sector = "IT"
        };

        _repository.AddCompany(initialCompany);
    }

    [Fact]
    public void CreateProject_ShouldAddProjectToCompany()
    {
        var project = new Project
        {
            name = "Test Project",
            description = "A test project",
            price = 1000,
            status = Project.Status.Opened,
            startDate = DateTime.Now,
            endDate = DateTime.Now.AddMonths(1)
        };
        
        var result = _controller.AddProject(1, project) as OkObjectResult;

        Assert.NotNull(result);
        Assert.Equal(200, result.StatusCode);

        var company = _repository.GetCompany(1);
        Assert.Single(company.projects);
        Assert.Equal("Test Project", company.projects[0].name);
    }

    [Fact]
    public void EditProject_ShouldUpdateProjectDetails()
    {
        var initialProject = new Project
        {
            name = "Old Project Name",
            description = "Old Description",
            price = 500,
            status = Project.Status.Opened,
            startDate = DateTime.Now,
            endDate = DateTime.Now.AddMonths(1)
        };

        _repository.AddProject(1, initialProject);
        var updatedProject = new Project
        {
            name = "Updated Project Name",
            description = "Updated Description",
            price = 2000,
            status = Project.Status.Opened,
            startDate = DateTime.Now,
            endDate = DateTime.Now.AddMonths(2)
        };
        
        var result = _controller.EditProject(1, updatedProject) as OkObjectResult;
        Assert.NotNull(result);
        Assert.Equal(200, result.StatusCode);
        var company = _repository.GetCompany(1);
        var project = company.projects[0];
        Assert.Equal("Updated Project Name", project.name);
        Assert.Equal("Updated Description", project.description);
        Assert.Equal(2000, project.price);
        Assert.Equal(Project.Status.Opened, project.status);
    }

    [Fact]
    public void ViewProject_ShouldReturnProjectDetails()
    {
        var project = new Project
        {
            name = "Viewable Project",
            description = "A project to view",
            price = 1500,
            status = Project.Status.Opened,
            startDate = DateTime.Now, 
            endDate= DateTime.Now.AddMonths(1)
        };
        _repository.AddProject(1, project);
        
        var result = _controller.ViewProject(1) as OkObjectResult;
        
        Assert.NotNull(result);
        Assert.Equal(200, result.StatusCode);
        
        var returnedProject = result.Value as Project;
        Assert.NotNull(returnedProject);
        Assert.Equal("Viewable Project", returnedProject.name);
        Assert.Equal("A project to view", returnedProject.description);
        Assert.Equal(1500, returnedProject.price);
        Assert.Equal(Project.Status.Opened, returnedProject.status);
    }
}
