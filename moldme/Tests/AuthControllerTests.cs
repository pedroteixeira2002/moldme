using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using moldme.Auth;
using moldme.Controllers;
using moldme.data;
using moldme.Models;
using Xunit;
using System;
using System.Collections.Generic;
using Microsoft.AspNetCore.Identity.Data;
using Microsoft.EntityFrameworkCore;

public class AuthControllerTests
{
    private readonly IConfiguration _configuration;

    public AuthControllerTests()
    {
        // Configuração de JWT para testes
        _configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(new Dictionary<string, string>
            {
                { "Jwt:Key", "ThisIsASecretKeyThatIsAtLeast32CharactersLong123!" }, // Deve ter 32+ caracteres
                { "Jwt:Issuer", "TestIssuer" },
                { "Jwt:Audience", "TestAudience" }
            }!)
            .Build();
    }

    
    public ApplicationDbContext GetInMemoryDbContext()
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;

        return new ApplicationDbContext(options);
    }
    
    private void SeedData(ApplicationDbContext dbContext)
    {
        var companyPasswordHasher = new PasswordHasher<Company>();
        var employeePasswordHasher = new PasswordHasher<Employee>();

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
            // Hashing the password before saving
            Password = companyPasswordHasher.HashPassword(null, "password")
        };

        var employee = new Employee
        {
            EmployeeID = "EMP001",
            Name = "John Doe",
            Profession = "Developer",
            NIF = 123456789,
            Email = "john.doe@example.com",
            // Hashing the password before saving
            Password = employeePasswordHasher.HashPassword(null, "password123"),
            CompanyId = company.CompanyID
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
            CompanyId = company.CompanyID,
            Date = DateTime.Now,
            Value = 500,
            Plan = SubscriptionPlan.Premium
        };

        dbContext.Companies.Add(company);
        dbContext.Employees.Add(employee);
        dbContext.Projects.Add(project);
        dbContext.Payments.Add(payment);
        dbContext.SaveChanges();
    }


    
    [Fact]
    public void Login_ValidCredentials_ReturnsToken()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext); 

        var tokenGenerator = new TokenGenerator(_configuration);
        var companyPasswordHasher = new PasswordHasher<Company>();
        var employeePasswordHasher = new PasswordHasher<Employee>();

        var controller = new AuthController(dbContext, tokenGenerator, companyPasswordHasher, employeePasswordHasher);

        var loginRequest = new LoginRequest
        {
            Email = "email@example.com",
            Password = "password" 
        };

        // Act
        var result = controller.Login(loginRequest);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result);
        
        var response = okResult.Value as dynamic;

        Assert.NotNull(response); // Verifica se a resposta não é nula
        Assert.True(response.access_token != null, "The response should contain an 'access_token' key.");
        Assert.False(string.IsNullOrEmpty(response.access_token?.ToString()), "The access_token should not be null or empty.");
    }
    
    [Fact]
    public void Login_InvalidPassword_ReturnsUnauthorized()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext); 

        var tokenGenerator = new TokenGenerator(_configuration);
        var companyPasswordHasher = new PasswordHasher<Company>();
        var employeePasswordHasher = new PasswordHasher<Employee>();

        var controller = new AuthController(dbContext, tokenGenerator, companyPasswordHasher, employeePasswordHasher);

        var loginRequest = new LoginRequest
        {
            Email = "email@example.com", 
            Password = "wrongpassword"    
        };

        // Act
        var result = controller.Login(loginRequest);

        // Assert
        var unauthorizedResult = Assert.IsType<UnauthorizedObjectResult>(result);
        Assert.Equal("Invalid credentials.", unauthorizedResult.Value);
    }




}
