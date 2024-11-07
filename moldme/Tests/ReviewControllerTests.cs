using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.Controllers;
using moldme.data;
using moldme.DTOs;
using moldme.Models;
using Xunit;
using Task = System.Threading.Tasks.Task;

namespace moldme.Tests;

public class ReviewControllerTests
{
    private ApplicationDbContext GetInMemoryDbContext()
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
        
        var employee1 = new Employee
        {
            EmployeeID = "EMP001",
            Name = "John Doe",
            Profession = "Developer",
            NIF = 123456789,
            Email = "john.doe@example.com",
            Password = "password123",
            Company = company
        };

        var employee2 = new Employee
        {
            EmployeeID = "EMP002",
            Name = "Jane Doe",
            Profession = "Designer",
            NIF = 987654321,
            Email = "exemplo@gmail.com",
            Password = "password123",
            Company = company  // This is the change to review later
        };
        
        dbContext.Companies.Add(company);
        dbContext.Employees.AddRange(employee1, employee2);
        dbContext.SaveChanges();
    }
    
    [Fact]
    public async Task AddReview_WhenValid()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new ReviewController(dbContext);

        var reviewDto = new ReviewDto
        {
            Comment = "Great employee",
            Stars = Stars.Five,
            ReviewerId = "EMP001",
            ReviewedId = "EMP002"
        };

        var result = await controller.AddReview(reviewDto) as OkObjectResult;

        Assert.NotNull(result);
        Assert.Equal("Review added successfully", result.Value);
    }

[Fact]
public async Task AddReview_InvalidReviewer()
{
    // Arrange
    var dbContext = GetInMemoryDbContext();
    SeedData(dbContext);
    
    var controller = new ReviewController(dbContext);
    
    var reviewDto = new ReviewDto
    {
        Comment = "Great employee",
        Stars = Stars.Five,
        ReviewerId = "EMP003",
        ReviewedId = "EMP002"
    };
    
    // Act
    var result = await controller.AddReview(reviewDto) as NotFoundObjectResult;
    
    // Assert
    Assert.NotNull(result);
    Assert.Equal("Reviewer not found", result.Value);
    
    var reviewInDb = dbContext.Reviews.FirstOrDefault(r => r.ReviewerId == reviewDto.ReviewerId && r.ReviewedId == reviewDto.ReviewedId);
    Assert.Null(reviewInDb);
    
    Assert.Equal(0, dbContext.Reviews.Count());
}

[Fact]
public async Task AddReview_InvalidReviewedEmployee()
{
    var dbContext = GetInMemoryDbContext();
    SeedData(dbContext);
    
    var controller = new ReviewController(dbContext);
    
    var reviewDto = new ReviewDto
    {
        Comment = "Great employee",
        Stars = Stars.Five,
        ReviewerId = "EMP001",
        ReviewedId = "notright"
    };
    
    var result = await controller.AddReview(reviewDto) as NotFoundObjectResult;
    
    Assert.NotNull(result);
    Assert.Equal("Reviewed Employee not found", result.Value);
    
}
}