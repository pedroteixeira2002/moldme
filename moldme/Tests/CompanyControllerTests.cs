using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.Auth;
using moldme.Controllers;
using moldme.data;
using moldme.DTOs;
using moldme.Models;
using Moq;
using Xunit;
using Task = System.Threading.Tasks.Task;

namespace moldme.Tests;

public class CompanyControllerTests

{
    private readonly IConfiguration _configuration;

    public CompanyControllerTests()
    {
        // Initialize your configuration here
        _configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(new Dictionary<string, string>
            {
                { "Jwt:Key", "ThisIsASecretKeyThatIsAtLeast32CharactersLong123!" }, // 32+ characters
                { "Jwt:Issuer", "" },
                { "Jwt:Audience", "" }
            })
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

    [Theory]
    [InlineData(SubscriptionPlan.None, 0)]
    [InlineData(SubscriptionPlan.Basic, 9.99f)]
    [InlineData(SubscriptionPlan.Pro, 19.99f)]
    [InlineData(SubscriptionPlan.Premium, 29.99f)]
    public void GetPlanPrice_ReturnsCorrectPrice(SubscriptionPlan plan, float expectedPrice)
    {
        // Act
        var price = SubscriptionPlanHelper.GetPlanPrice(plan);

        // Assert
        Assert.Equal(expectedPrice, price);
    }

    [Fact]
    public void GetPlanPrice_ThrowsArgumentOutOfRangeException_ForUnknownPlan()
    {
        // Arrange
        var unknownPlan = (SubscriptionPlan)999;

        // Act & Assert
        Assert.Throws<ArgumentOutOfRangeException>(() => SubscriptionPlanHelper.GetPlanPrice(unknownPlan));
    }

    [Fact]
    public void Company_Properties_GetterSetter_WorksCorrectly()
    {
        var company = new Company
        {
            CompanyId = "C12345",
            Name = "Tech Corp",
            Address = "123 Tech Street",
            Email = "contact@techcorp.com",
            Contact = 123456789,
            TaxId = 987654321,
            Sector = "IT",
            Plan = SubscriptionPlan.Premium,
            Password = "password123"
        };

        Assert.Equal("C12345", company.CompanyId);
        Assert.Equal("Tech Corp", company.Name);
        Assert.Equal("123 Tech Street", company.Address);
        Assert.Equal("contact@techcorp.com", company.Email);
        Assert.Equal(123456789, company.Contact);
        Assert.Equal(987654321, company.TaxId);
        Assert.Equal("IT", company.Sector);
        Assert.Equal(SubscriptionPlan.Premium, company.Plan);
        Assert.Equal("password123", company.Password);

        company.Name = "New Tech Corp";
        company.Address = "456 New Street";
        company.Email = "newcontact@techcorp.com";
        company.Contact = 987654321;
        company.TaxId = 123456789;
        company.Sector = "Software";
        company.Plan = SubscriptionPlan.Basic;
        company.Password = "newpassword123";

        Assert.Equal("New Tech Corp", company.Name);
        Assert.Equal("456 New Street", company.Address);
        Assert.Equal("newcontact@techcorp.com", company.Email);
        Assert.Equal(987654321, company.Contact);
        Assert.Equal(123456789, company.TaxId);
        Assert.Equal("Software", company.Sector);
        Assert.Equal(SubscriptionPlan.Basic, company.Plan);
        Assert.Equal("newpassword123", company.Password);
    }
    
    [Fact]
    public void ListPaymentHistory_ShouldReturnOk_WhenPaymentsExist()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var tokenGenerator = new TokenGenerator(_configuration);
        var passwordHasher = new PasswordHasher<Company>();
        var companyController = new CompanyController(dbContext, tokenGenerator, passwordHasher);

        // Clear existing payments to isolate the test
        dbContext.Payments.RemoveRange(dbContext.Payments);
        dbContext.SaveChanges();


        // Adding a payment to ensure there is data to retrieve
        var payment = new Payment
        {
            PaymentId = "PAY002",
            CompanyId = "1", // Ensure this matches a valid company ID
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
        Assert.Equal("PAY002", payments[0].PaymentId);

    }

    [Fact]
    public void UpgradePlan_ShouldReturnOk_WhenPlanIsUpgraded()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var tokenGenerator = new TokenGenerator(_configuration);
        var passwordHasher = new PasswordHasher<Company>();
        var companyController = new CompanyController(dbContext, tokenGenerator, passwordHasher);

        // Configurar o plano inicial para a empresa
        var existingCompany = dbContext.Companies.FirstOrDefault(c => c.CompanyId == "1");
        if (existingCompany != null)
        {
            existingCompany.Plan = SubscriptionPlan.Basic;
            dbContext.SaveChanges();
        }

        var newPlan = SubscriptionPlan.Premium;

        // Act
        var result = companyController.UpgradePlan("1", newPlan) as OkObjectResult;

        // Assert: Confirma que o resultado não é nulo e o plano foi atualizado
        Assert.NotNull(result);
        var updatedCompany = dbContext.Companies.Find("1");
        Assert.Equal(newPlan, updatedCompany.Plan);
    }

    [Fact]
    public void UpgradePlan_ShouldReturnBadRequest_WhenPlanIsSame()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var tokenGenerator = new TokenGenerator(_configuration);
        var passwordHasher = new PasswordHasher<Company>();
        var companyController = new CompanyController(dbContext, tokenGenerator, passwordHasher);

        var result = companyController.UpgradePlan("1", SubscriptionPlan.Premium) as BadRequestObjectResult;

        Assert.NotNull(result);
        Assert.Equal("Subscription plan already upgraded", result.Value);
    }

    [Fact]
    public void UpgradePlan_ShouldReturnNotFound_WhenCompanyDoesNotExist()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var tokenGenerator = new TokenGenerator(_configuration);
        var passwordHasher = new PasswordHasher<Company>();
        var companyController = new CompanyController(dbContext, tokenGenerator, passwordHasher);

        var result = companyController.UpgradePlan("999", SubscriptionPlan.Premium) as NotFoundObjectResult;

        Assert.NotNull(result);
        Assert.Equal("Company not found", result.Value);
    }
    
    [Fact]
    public void CancelSubscriptionTest()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var tokenGenerator = new TokenGenerator(_configuration);
        var passwordHasher = new PasswordHasher<Company>();
        var companyController = new CompanyController(dbContext, tokenGenerator, passwordHasher);

        var result = companyController.CancelSubscription("1") as OkObjectResult;

        Assert.NotNull(result);
        Assert.Equal("Subscription cancelled successfully", result.Value);

        var company = dbContext.Companies.FirstOrDefault(c => c.CompanyId == "1");
        Assert.NotNull(company);
        Assert.Equal(SubscriptionPlan.None, company.Plan);
    }
    
    [Fact]
    public void RegisterCompany_Success()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        var passwordHasher = new PasswordHasher<Company>();
        var tokenGenerator = new TokenGenerator(_configuration);
        var controller = new CompanyController(dbContext, tokenGenerator, passwordHasher);

        var companyDto = new CompanyDto
        {
            Name = "New Company",
            Address = "123 Street",
            Email = "newcompany@example.com",
            Contact = 123456789,
            TaxId = 123456789,
            Sector = "Sector",
            Plan = SubscriptionPlan.Premium,
            Password = "SecurePassword123"
        };

        // Act
        var result = controller.CompanyCreate(companyDto) as OkObjectResult;

        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
        Assert.Equal("Company registered successfully", ((dynamic)result.Value).Message);
        Assert.NotNull(((dynamic)result.Value).Token);
    }

    [Fact]
    public void RegisterCompany_DuplicateEmail()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        var passwordHasher = new PasswordHasher<Company>();
        var tokenGenerator = new TokenGenerator(_configuration);
        var controller = new CompanyController(dbContext, tokenGenerator, passwordHasher);

        var existingCompany = new Company
        {
            CompanyId = "1",
            Name = "Existing Company",
            Address = "123 Street",
            Email = "duplicate@example.com",
            Contact = 123456789,
            TaxId = 123456789,
            Sector = "Sector",
            Plan = SubscriptionPlan.Premium,
            Password = "SecurePassword123"
        };

        dbContext.Companies.Add(existingCompany);
        dbContext.SaveChanges();

        var newCompanyDto = new CompanyDto
        {
            Name = "New Company",
            Address = "456 Avenue",
            Email = "duplicate@example.com", // Duplicate email
            Contact = 987654321,
            TaxId = 987654321,
            Sector = "Sector",
            Plan = SubscriptionPlan.Premium,
            Password = "SecurePassword456"
        };

        // Act
        var result = controller.CompanyCreate(newCompanyDto) as BadRequestObjectResult;

        // Assert
        Assert.NotNull(result);
        Assert.IsType<BadRequestObjectResult>(result);
        Assert.Equal("A company with this email already exists.", result.Value);
    }

    [Fact]
    public void RegisterCompany_MissingInformation()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        var passwordHasher = new PasswordHasher<Company>();
        var tokenGenerator = new TokenGenerator(_configuration);
        var controller = new CompanyController(dbContext, tokenGenerator, passwordHasher);

        var companyDto = new CompanyDto
        {
            Name = "Invalid Subscription Plan Company",
            Address = "123 Street",
            Email = "invalidplan@example.com",
            Contact = 123456789,
            TaxId = 123456789,
            Sector = "Sector",
            Plan = (SubscriptionPlan)999, // Invalid plan
            Password = "SecurePassword123"
        };

        // Act
        var result = controller.CompanyCreate(companyDto) as BadRequestObjectResult;

        // Assert
        Assert.NotNull(result);
        Assert.IsType<BadRequestObjectResult>(result);
        Assert.Equal("Invalid subscription plan.", result.Value);
    }

    [Fact]
    public void RegisterCompany_InvalidEmailFormat()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        var passwordHasher = new PasswordHasher<Company>();
        var tokenGenerator = new TokenGenerator(_configuration);
        var controller = new CompanyController(dbContext, tokenGenerator, passwordHasher);

        var companyDto = new CompanyDto
        {
            Name = "Invalid Email Company",
            Address = "789 Boulevard",
            Email = "invalid-email", // Invalid email format
            Contact = 123456789,
            TaxId = 123456789,
            Sector = "Sector",
            Plan = SubscriptionPlan.Premium,
            Password = "SecurePassword123"
        };

        // Act
        var result = controller.CompanyCreate(companyDto) as BadRequestObjectResult;

        // Assert
        Assert.NotNull(result);
        Assert.IsType<BadRequestObjectResult>(result);
        Assert.Equal("Invalid email format.", result.Value);
    }
}
