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
            Company = company // This is the change to review later
        };

        dbContext.Companies.Add(company);
        dbContext.Employees.AddRange(employee1, employee2);
        dbContext.SaveChanges();
    }

    [Fact]
    public void Review_Properties_GetterSetter_WorksCorrectly()
    {
        var review = new Review
        {
            ReviewID = "R12345",
            Comment = "Great work!",
            date = new DateTime(2023, 10, 1),
            Stars = Stars.Five,
            ReviewerId = "E12345",
            Reviewer = new Employee { EmployeeID = "E12345", Name = "John Doe" },
            ReviewedId = "E54321",
            Reviewed = new Employee { EmployeeID = "E54321", Name = "Jane Smith" }
        };

        Assert.Equal("R12345", review.ReviewID);
        Assert.Equal("Great work!", review.Comment);
        Assert.Equal(new DateTime(2023, 10, 1), review.date);
        Assert.Equal(Stars.Five, review.Stars);
        Assert.Equal("E12345", review.ReviewerId);
        Assert.Equal("John Doe", review.Reviewer.Name);
        Assert.Equal("E54321", review.ReviewedId);
        Assert.Equal("Jane Smith", review.Reviewed.Name);
    }

    [Fact]
    public void AddReview()
    {
        // Arrange
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

        // Act
        var result = controller.AddReview(reviewDto) as OkObjectResult;

        // Assert
        Assert.NotNull(result);
        var resultValue = result.Value as dynamic;
        Assert.Equal("Review added successfully", resultValue.Message);

        // Obtem a avaliação do banco de dados
        var reviewInDb = dbContext.Reviews.FirstOrDefault(r =>
            r.ReviewerId == reviewDto.ReviewerId && r.ReviewedId == reviewDto.ReviewedId);
        // Verifica se a avaliação foi adicionada ao banco de dados
        Assert.NotNull(reviewInDb);
        // Verifica se o ReviewerID da avaliação é igual ao esperado.
        Assert.Equal("EMP001", reviewInDb.ReviewerId);
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

        var reviewDto = new ReviewDto
        {
            Comment = "Great employee",
            Stars = Stars.Five,
            ReviewerId = "EMP003",
            ReviewedId = "EMP002"
        };

        // Act
        var result = controller.AddReview(reviewDto) as NotFoundObjectResult;

        // Assert
        Assert.NotNull(result);
        Assert.Equal("Reviewer not found", result.Value);

        var reviewInDb = dbContext.Reviews.FirstOrDefault(r =>
            r.ReviewerId == reviewDto.ReviewerId && r.ReviewedId == reviewDto.ReviewedId);
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

        var reviewDto = new ReviewDto
        {
            Comment = "Great employee",
            Stars = Stars.Five,
            ReviewerId = "EMP001",
            ReviewedId = "EMP003"
        };

        // Act
        var result = controller.AddReview(reviewDto) as NotFoundObjectResult;

        // Assert
        Assert.NotNull(result);
        Assert.Equal("Reviewed Employee not found", result.Value);

        var reviewInDb = dbContext.Reviews.FirstOrDefault(r =>
            r.ReviewerId == reviewDto.ReviewerId && r.ReviewedId == reviewDto.ReviewedId);
        Assert.Null(reviewInDb);

        Assert.Equal(0, dbContext.Reviews.Count());
    }
}