using DefaultNamespace;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.data;
using Xunit;
using System;
using System.Linq;
using moldme.Models;

public class CompanyControllerTests
{
    private readonly CompanyController _controller;
    private readonly ApplicationDbContext _context;

    public CompanyControllerTests()
    {
        // Configuring the InMemoryDatabase for tests
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: "TestDatabase")
            .Options;

        _context = new ApplicationDbContext(options);
        _controller = new CompanyController(_context);
        
        // Creating an initial company for testing
        var initialCompany = new Company
        {
            CompanyID = "1",  // Set to string, aligning with VARCHAR(6)
            Name = "Test Company",
            TaxId = 123456789,
            Address = "123 Test Street",
            Contact = 987654321,
            Email = "test@company.com",
            Sector = "IT",
            Plan = SubscriptionPlan.Basic, // Set a valid subscription plan
            Password = "password"
        };

        _context.Companies.Add(initialCompany);
        _context.SaveChanges();
    }

    [Fact]
    public void CreateProject_ShouldAddProjectToCompany()
    {
        var project = new Project
        {
            ProjectId = "PR001",  // Set to string
            Name = "Test Project",
            Description = "A test project",
            Budget = 1000,
            Status = Status.ACCEPTED,
            StartDate = DateTime.Now,
            EndDate = DateTime.Now.AddMonths(1),
            CompanyId = "1"  // Ensure the company ID matches the initial company
        };
        
        var result = _controller.AddProject("1", project) as OkObjectResult;

        Assert.NotNull(result);
        Assert.Equal(200, result.StatusCode);

        // Check if the project was added correctly
        var company = _context.Companies.Include(c => c.Projects).FirstOrDefault(c => c.CompanyID == "1");
        Assert.NotNull(company);
        Assert.Single(company.Projects);
        Assert.Equal("Test Project", company.Projects[0].Name); // Adjust for casing
    }

    [Fact]
    public void EditProject_ShouldUpdateProjectDetails()
    {
        var initialProject = new Project
        {
            ProjectId = "PR002",  // Set to string
            Name = "Old Project Name",
            Description = "Old Description",
            Budget = 500,
            Status = Status.ACCEPTED,
            StartDate = DateTime.Now,
            EndDate = DateTime.Now.AddMonths(1),
            CompanyId = "1"
        };

        _context.Projects.Add(initialProject);
        _context.SaveChanges();

        // Creating an updated project with the same ID
        var updatedProject = new Project
        {
            ProjectId = initialProject.ProjectId, // Ensure it matches
            Name = "Updated Project Name",
            Description = "Updated Description",
            Budget = 2000,
            Status = Status.ACCEPTED,
            StartDate = DateTime.Now,
            EndDate = DateTime.Now.AddMonths(2)
        };
        
        var result = _controller.EditProject(initialProject.ProjectId, updatedProject) as OkObjectResult;

        Assert.NotNull(result);
        Assert.Equal(200, result.StatusCode);

        var project = _context.Projects.FirstOrDefault(p => p.ProjectId == initialProject.ProjectId);
        Assert.NotNull(project);
        Assert.Equal("Updated Project Name", project.Name); // Adjust for casing
        Assert.Equal("Updated Description", project.Description);
        Assert.Equal(2000, project.Budget);
        Assert.Equal(Status.ACCEPTED, project.Status);
    }

    [Fact]
    public void ViewProject_ShouldReturnProjectDetails()
    {
        var project = new Project
        {
            ProjectId = "PR003",  // Set to string
            Name = "Viewable Project",
            Description = "A project to view",
            Budget = 1500,
            Status = Status.ACCEPTED,
            StartDate = DateTime.Now,
            EndDate = DateTime.Now.AddMonths(1),
            CompanyId = "C001"
        };

        _context.Projects.Add(project);
        _context.SaveChanges();
        
        var result = _controller.ViewProject(project.ProjectId) as OkObjectResult;
        
        Assert.NotNull(result);
        Assert.Equal(200, result.StatusCode);
        
        var returnedProject = result.Value as Project;
        Assert.NotNull(returnedProject);
        Assert.Equal("Viewable Project", returnedProject.Name); // Adjust for casing
        Assert.Equal("A project to view", returnedProject.Description);
        Assert.Equal(1500, returnedProject.Budget);
        Assert.Equal(Status.ACCEPTED, returnedProject.Status);
    }
}
