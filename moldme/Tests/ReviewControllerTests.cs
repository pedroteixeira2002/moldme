using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.Controllers;
using moldme.data;
using moldme.Models;
using Xunit;

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
    public void AddReview()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);
        
        var controller = new ReviewController(dbContext);
        
        var review = new Review()
        {
            ReviewID = "REV001",
            Comment = "Great employee",
            date = DateTime.Now,
            Stars = Stars.Five,
            ReviewerID = "EMP001",
            ReviewedId = "EMP002"
        };
        
        // Act
        var result = controller.AddReview(review.ReviewerID, review.ReviewedId, review) as OkObjectResult;
        
        Assert.NotNull(result);
        Assert.Equal("Review added successfully", result.Value);
        
        // Obtem a avaliação do banco de dados
        var reviewInDb = dbContext.Reviews.FirstOrDefault(r => r.ReviewID == review.ReviewID);
        // Verifica se a avaliação foi adicionada ao banco de dados
        Assert.NotNull(reviewInDb);
        // Verifica se o ReviewerID da avaliação é igual ao esperado.
        Assert.Equal("EMP001", reviewInDb.ReviewerID);
        // Verifica se o ReviewedId da avaliação é igual ao esperado.
        Assert.Equal("EMP002", reviewInDb.ReviewedId);
        
    }
    
    [Fact]
    public void AddReview_InvalidReviewer()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);
        
        var controller = new ReviewController(dbContext);
        
        var review = new Review()
        {
            ReviewID = "REV001",
            Comment = "Great employee",
            date = DateTime.Now,
            Stars = Stars.Five,
            ReviewerID = "EMP003",
            ReviewedId = "EMP002"
        };
        
        var result = controller.AddReview(review.ReviewerID, review.ReviewedId, review) as NotFoundObjectResult;
        
        Assert.NotNull(result);
        Assert.Equal("Reviewer not found", result.Value);
        
        var reviewInDb = dbContext.Reviews.FirstOrDefault(r => r.ReviewID == review.ReviewID);
        Assert.Null(reviewInDb);
        
        Assert.Equal(0, dbContext.Reviews.Count());
    }
    
    [Fact]
    public void AddReview_InvalidReviewedEmployee()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);
        
        var controller = new ReviewController(dbContext);
        
        var review = new Review()
        {
            ReviewID = "REV001",
            Comment = "Great employee",
            date = DateTime.Now,
            Stars = Stars.Five,
            ReviewerID = "EMP001",
            ReviewedId = "EMP003"
        };
        
        var result = controller.AddReview("EMP001", "invalid", review) as NotFoundObjectResult;
        
        Assert.NotNull(result);
        Assert.Equal("Reviewed Employee not found", result.Value);
        
        var reviewInDb = dbContext.Reviews.FirstOrDefault(r => r.ReviewID == review.ReviewID);
        Assert.Null(reviewInDb);
        
        Assert.Equal(0, dbContext.Reviews.Count());
    }
}