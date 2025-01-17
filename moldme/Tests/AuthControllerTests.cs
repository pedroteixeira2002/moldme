using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using moldme.Auth;
using moldme.Controllers;
using moldme.data;
using moldme.Models;
using Xunit;
using Microsoft.AspNetCore.Identity.Data;
using Microsoft.EntityFrameworkCore;
using moldme.DTOs;

namespace moldme.Tests;
    
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
            CompanyId = "1",
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
            EmployeeId = "EMP001",
            Name = "John Doe",
            Profession = "Developer",
            NIF = 123456789,
            Email = "john.doe@example.com",
            // Hashing the password before saving
            Password = employeePasswordHasher.HashPassword(null, "password123"),
            CompanyId = company.CompanyId
        };

        var project = new Project
        {
            ProjectId = "PROJ01",
            Name = "New Project",
            Description = "Project Description",
            Budget = 1000,
            StartDate = DateTime.Now,
            EndDate = DateTime.Now.AddDays(30),
            CompanyId = company.CompanyId
        };

        var payment = new Payment
        {
            PaymentId = "PAY001",
            CompanyId = company.CompanyId,
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

        var controller = new AuthenticationController(dbContext, tokenGenerator, companyPasswordHasher, employeePasswordHasher);

        var loginDto = new LoginDto
        {
            Email = "john.doe@example.com",
            Password = "password123"
        };

        // Act
        var result = controller.Login(loginDto);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result);
    
        var response = okResult.Value as dynamic;

        Assert.NotNull(response); // Verifies that the response is not null
        Assert.True(response.access_token != null, "The response should contain an 'access_token' key.");
        Assert.False(string.IsNullOrEmpty(response.access_token?.ToString()), "The access_token should not be null or empty.");
    }
}