﻿using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.Controllers;
using moldme.data;
using moldme.Models;
using Xunit;

public class CompanyControllerTests
{
    private readonly ApplicationDbContext dbContext;
    private readonly CompanyController companyController;

    public CompanyControllerTests()
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;

        dbContext = new ApplicationDbContext(options);
        companyController = new CompanyController(dbContext);
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

        var payment = new Payment
        {
            PaymentID = "PAY001",
            companyId = company.CompanyID,
            Date = DateTime.Now,
            Value = 500,
            Plan = SubscriptionPlan.Premium
        };
        dbContext.Projects.RemoveRange(dbContext.Projects);

        dbContext.Companies.Add(company);
        dbContext.Employees.Add(employee);
        dbContext.Projects.Add(project);
        dbContext.Payments.Add(payment);
        dbContext.SaveChanges();
    }

    [Fact]
    public void AddProjectTest_ShouldReturnOk_WhenProjectIsValid()
    {
        SeedData();
        var project = new Project
        {
            ProjectId = "PROJ02",
            Name = "New Project 2",
            Description = "Description of Project 2",
            Budget = 2000,
            Status = Status.INPROGRESS,
            StartDate = DateTime.Now,
            EndDate = DateTime.Now.AddDays(60),
            CompanyId = "1"
        };

        var result = companyController.AddProject("1", project) as OkObjectResult;

        Assert.NotNull(result);
        Assert.Equal("Project added successfully", result.Value);
        Assert.True(dbContext.Projects.Any(p => p.ProjectId == "PROJ02"));
    }

    [Fact]
    public void EditProjectTest_ShouldReturnOk_WhenProjectIsUpdated()
    {
        {
            // Arrange
            SeedData();
            var existingProject = dbContext.Projects.FirstOrDefault(p => p.ProjectId == "PROJ01");
            Assert.NotNull(existingProject); // Ensure the project exists

            var updatedProject = new Project
            {
                ProjectId = "PROJ01",
                Name = "Updated Project",
                Description = "Updated Description",
                Budget = 10000,
                Status = Status.DONE,
                StartDate = DateTime.Now.AddDays(-10),
                EndDate = DateTime.Now.AddDays(20),
                CompanyId = existingProject.CompanyId // Ensure this matches
            };

            // Act
            var result = companyController.EditProject("PROJ01", updatedProject) as OkObjectResult;

            // Assert
            Assert.NotNull(result);
            Assert.IsType<OkObjectResult>(result);

            var updatedProjectFromDb = dbContext.Projects.Find("PROJ01");
            Assert.Equal("Updated Project", updatedProjectFromDb.Name);
            Assert.Equal(10000, updatedProjectFromDb.Budget);
            Assert.Equal(Status.DONE, updatedProjectFromDb.Status);
        }

    }

    [Fact]
    public void AddEmployeeTest_ShouldReturnOk_WhenEmployeeIsValid()
    {
        SeedData();
        var employee = new Employee
        {
            EmployeeID = "EMP002",
            Name = "Jane Smith",
            Profession = "Designer",
            NIF = 987654321,
            Email = "jane.smith@example.com",
            Contact = 123456789,
            Password = "password",
            CompanyID = "1"
        };

        var result = companyController.AddEmployee("1", employee) as OkObjectResult;

        Assert.NotNull(result);
        Assert.Equal("Employee created successfully", result.Value);
        Assert.True(dbContext.Employees.Any(e => e.EmployeeID == "EMP002"));
    }

    [Fact]
    public void RemoveEmployeeTest_ShouldReturnOk_WhenEmployeeExists()
    {
        SeedData();
        var result = companyController.RemoveEmployee("EMP001") as OkObjectResult;

        Assert.NotNull(result);
        Assert.Equal("Employee removed successfully", result.Value);
        Assert.False(dbContext.Employees.Any(e => e.EmployeeID == "EMP001"));
    }

    [Fact]
    public void ListAllEmployeesTest_ShouldReturnOk_WhenEmployeesExist()
    {
        SeedData();
        var result = companyController.ListAllEmployees() as OkObjectResult;

        Assert.NotNull(result);
        var employees = result.Value as List<Employee>;
        Assert.Equal(1, employees.Count);
    }

    [Fact]
    public void ViewProjectTest_ShouldReturnOk_WhenProjectExists()
    {
        SeedData();
        var result = companyController.ViewProject("PROJ01") as OkObjectResult;

        Assert.NotNull(result);
        var project = result.Value as Project;
        Assert.Equal("New Project", project.Name);
    }

    [Fact]
    public void RemoveProjectTest_ShouldReturnOk_WhenProjectExists()
    {
        SeedData();
        var result = companyController.RemoveProject("PROJ01") as OkObjectResult;

        Assert.NotNull(result);
        Assert.Equal("Project removed successfully", result.Value);
        Assert.False(dbContext.Projects.Any(p => p.ProjectId == "PROJ01"));
    }

    [Fact]
    public void ListPaymentHistory_ShouldReturnOk_WhenPaymentsExist()
    {
        // Arrange
        SeedData(); // Seed the initial data

        // Clear existing payments to isolate the test
        dbContext.Payments.RemoveRange(dbContext.Payments);
        dbContext.SaveChanges();

        // Adding a payment to ensure there is data to retrieve
        var payment = new Payment
        {
            PaymentID = "PAY002",
            companyId = "1", // Ensure this matches a valid company ID
            Date = DateTime.Now,
            Value = 600,
            Plan = SubscriptionPlan.Premium
        };

        // Add the payment to the in-memory database
        dbContext.Payments.Add(payment);
        dbContext.SaveChanges(); // Persist changes

        // Act
        var result = companyController.ListPaymentHistory("1") as OkObjectResult;

        // Assert
        Assert.NotNull(result); // Check that the result is not null
        var payments = result.Value as List<Payment>; // Cast the result value
        Assert.NotNull(payments); // Ensure the payments list is not null
        Assert.Single(payments); // Assert that there's exactly one payment in the list
        Assert.Equal("PAY002", payments[0].PaymentID);
    }

    [Fact]
    public void UpgradePlan_ShouldReturnOk_WhenPlanIsUpgraded()
    {
        // Arrange: Seed the data with a specific initial plan
        SeedData();
    
        // Ensure the company has an initial plan that is different from the new plan
        var existingCompany = dbContext.Companies.FirstOrDefault(c => c.CompanyID == "1");
        if (existingCompany != null)
        {
            existingCompany.Plan = SubscriptionPlan.Basic; // Set the current plan to Basic
            dbContext.SaveChanges();
        }

        // Act: Attempt to upgrade to a new plan
        var newPlan = SubscriptionPlan.Premium; // New plan to upgrade to

        var result = companyController.UpgradePlan("1", newPlan) as OkObjectResult;

        // Assert: Check if the response is as expected
        Assert.NotNull(result); // This assertion is failing, indicating the result is null
        Assert.Equal($"Subscription plan updated to {newPlan}", result.Value);

        // Assert: Check if the plan is updated in the database
        var updatedCompany = dbContext.Companies.Find("1");
        Assert.Equal(newPlan, updatedCompany.Plan);
    }

    [Fact]
    public void UpgradePlan_ShouldReturnBadRequest_WhenPlanIsSame()
    {
        SeedData();
        var result = companyController.UpgradePlan("1", SubscriptionPlan.Premium) as BadRequestObjectResult;

        Assert.NotNull(result);
        Assert.Equal("Subscription plan already upgraded", result.Value);
    }

    [Fact]
    public void UpgradePlan_ShouldReturnNotFound_WhenCompanyDoesNotExist()
    {
        var result = companyController.UpgradePlan("999", SubscriptionPlan.Premium) as NotFoundObjectResult;

        Assert.NotNull(result);
        Assert.Equal("Company not found", result.Value);
    }
}
