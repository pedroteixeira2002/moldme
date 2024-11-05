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
        //dbContext.Projects.RemoveRange(dbContext.Projects);

        dbContext.Companies.Add(company);
        dbContext.Employees.Add(employee);
        dbContext.Projects.Add(project);
        dbContext.Payments.Add(payment);
        dbContext.SaveChanges();
    }

    

[Fact]
public void AddEmployeeTest()
{
    // Arrange
    var dbContext = GetInMemoryDbContext(); // Get a new DbContext for the test
    SeedData(dbContext); // Seed any necessary data (if applicable)

    // Assuming _configuration is already defined in your test class and contains your JWT key
    var tokenGenerator = new TokenGenerator(_configuration); // Use _configuration directly
    var passwordHasher = new PasswordHasher<Company>();

    // Create and add a company only if it doesn't exist in the in-memory database
    Company company = new Company
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

    // Only add the company if it doesn't exist
    if (!dbContext.Companies.Any(c => c.CompanyID == company.CompanyID))
    {
        dbContext.Companies.Add(company);
        dbContext.SaveChanges(); // Save the company first
    }

    // Create the employee DTO to be added
    var employeeDto = new AddEmployeeDto
    {
        EmployeeID = "E1", // Ensure a unique ID for the employee
        Name = "Employee 1",
        Profession = "Profession 1",
        Nif = 123456789,
        Email = "employee@example.com",
        Contact = 987654321,
        Password = "password",
        ProjectId = "P1" // Add a project ID, assuming it exists in the seed data
    };

    // Optionally, seed a project in your database if it doesn't already exist
    var project = new Project
    {
        ProjectId = employeeDto.ProjectId,
        Name = "Project 1",
        Description = "Project Description",
        CompanyId = company.CompanyID
    };

    if (!dbContext.Projects.Any(p => p.ProjectId == project.ProjectId))
    {
        dbContext.Projects.Add(project);
        dbContext.SaveChanges(); // Save the project first
    }

    var companyController = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);

    // Act
    var result = companyController.AddEmployee(company.CompanyID, employeeDto) as OkObjectResult;

    // Assert
    Assert.NotNull(result);
    Assert.Equal("Employee created successfully", result.Value);

    var addedEmployee = dbContext.Employees.FirstOrDefault(e => e.EmployeeID == employeeDto.EmployeeID);
    Assert.NotNull(addedEmployee);
    Assert.Equal(company.CompanyID, addedEmployee.CompanyId);
}



    [Fact]
    public void RemoveEmployeeTest()
    {
        // Arrange
        // Use a fresh instance of the DbContext for this test
        var dbContext = GetInMemoryDbContext(); // Create a new in-memory DbContext for testing

        // Seed any necessary data (if applicable)
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
            EmployeeID = "E1", // Ensure a unique ID for the employee
            Name = "Employee 1",
            Profession = "Profession 1",
            NIF = 123456789,
            Email = "employee@example.com",
            Contact = 987654321,
            Password = "password",
            CompanyId = company.CompanyID
        };

        // Add company and employee to the context and save changes
        dbContext.Companies.Add(company);
        dbContext.Employees.Add(employee);
        dbContext.SaveChanges();

        // Create an instance of the CompanyController
        var tokenGenerator = new TokenGenerator(_configuration); // Use _configuration directly
        var passwordHasher = new PasswordHasher<Company>();
        var controller = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);

        // Act
        var result = controller.RemoveEmployee(company.CompanyID, employee.EmployeeID) as OkObjectResult;

        // Assert
        Assert.NotNull(result); // Ensure that the result is not null
        Assert.Equal("Employee removed successfully", result.Value); // Check that the response message is correct

        // Verify that the employee was actually removed from the database
        var removedEmployee = dbContext.Employees.FirstOrDefault(e => e.EmployeeID == employee.EmployeeID);
        Assert.Null(removedEmployee); // Assert that the removed employee is null
    }

    [Fact]
    public void EditEmployeeTest()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext(); // Create a new DbContext for the test
        var tokenGenerator = new TokenGenerator(_configuration);
        var passwordHasher = new PasswordHasher<Company>();
        var controller = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);

        // Create and add a company
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

        // Create and add an employee
        var employee = new Employee
        {
            EmployeeID = "1", // Unique ID
            Name = "Original Employee",
            Profession = "Original Profession",
            NIF = 123456789,
            Email = "employee@example.com",
            Contact = 987654321,
            Password = "password",
            CompanyId = company.CompanyID
        };

        // Persist changes to the database
        dbContext.Companies.Add(company);
        dbContext.Employees.Add(employee);
        dbContext.SaveChanges(); // This is crucial to persist the data

        // Create an updated employee object
        var updatedEmployee = new Employee
        {
            EmployeeID = "1", // Same ID for updating
            Name = "Updated Employee",
            Profession = "Updated Profession",
            NIF = 987654321,
            Email = "updated@example.com",
            Contact = 123456789,
            Password = "newpassword" // Assuming the controller handles hashing
        };

        // Act
        var result = controller.EditEmployee(company.CompanyID, employee.EmployeeID, updatedEmployee) as OkObjectResult;

        // Assert
        Assert.NotNull(result); // Check that the result is not null
        Assert.Equal("Employee updated successfully", result.Value); // Verify the success message

        // Fetch the updated employee from the database
        var updatedEmployeeFromDb = dbContext.Employees.FirstOrDefault(e => e.EmployeeID == employee.EmployeeID);
        Assert.NotNull(updatedEmployeeFromDb); // Ensure the employee exists
        Assert.Equal("Updated Employee", updatedEmployeeFromDb.Name); // Check updated name
        Assert.Equal(987654321, updatedEmployeeFromDb.NIF); // Check updated NIF
    }

    [Fact]
    public void ListAllEmployeesTest()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext(); // Ensure a new DbContext for this test
        SeedData(dbContext); // Seed data only if necessary

        var tokenGenerator = new TokenGenerator(_configuration);
        var passwordHasher = new PasswordHasher<Company>();
        var controller = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);

        var company = new Company
        {
            CompanyID = "2", // Use a unique ID
            Name = "Company 2",
            Address = "Address 2",
            Email = "email2@example.com",
            Contact = 123456788,
            TaxId = 987654321,
            Sector = "Sector 2",
            Plan = SubscriptionPlan.Premium,
            Password = "password"
        };

        var employee1 = new Employee
        {
            EmployeeID = "1",
            Name = "Employee 1",
            Profession = "Profession 1",
            NIF = 123456789,
            Email = "employee1@example.com",
            Contact = 987654321,
            Password = "password",
            CompanyId = company.CompanyID
        };

        var employee2 = new Employee
        {
            EmployeeID = "2",
            Name = "Employee 2",
            Profession = "Profession 2",
            NIF = 987654321,
            Email = "employee2@example.com",
            Contact = 123456789,
            Password = "password",
            CompanyId = company.CompanyID
        };

        // Add the company and employees to the context
        dbContext.Companies.Add(company);
        dbContext.Employees.Add(employee1);
        dbContext.Employees.Add(employee2);
        dbContext.SaveChanges();

        // Act
        var result = controller.ListAllEmployees(company.CompanyID) as OkObjectResult;

        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);
    
        var employees = result.Value as List<Employee>;
        Assert.NotNull(employees);
        Assert.Equal(2, employees.Count);
    }
    
    [Fact]
    public void ViewProjectTest_ShouldReturnOk_WhenProjectExists()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var tokenGenerator = new TokenGenerator( _configuration);
        var passwordHasher = new PasswordHasher<Company>();
        var companyController = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);
        
        var result = companyController.ViewProject("PROJ01") as OkObjectResult;

        Assert.NotNull(result);
        var project = result.Value as Project;
        Assert.Equal("New Project", project.Name);
    }

    [Fact]
    public void RemoveProjectTest_ShouldReturnOk_WhenProjectExists()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var tokenGenerator = new TokenGenerator(_configuration);
        var passwordHasher = new PasswordHasher<Company>();
        var companyController = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);
        
        var result = companyController.RemoveProject("PROJ01") as OkObjectResult;
        
        Assert.NotNull(result);
        Assert.Equal("Project removed successfully", result.Value);
        Assert.False(dbContext.Projects.Any(p => p.ProjectId == "PROJ01"));
    }

    [Fact]
    public void ListPaymentHistory_ShouldReturnOk_WhenPaymentsExist()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var tokenGenerator = new TokenGenerator(_configuration);
        var passwordHasher = new PasswordHasher<Company>();
        var companyController = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);

        // Clear existing payments to isolate the test
        dbContext.Payments.RemoveRange(dbContext.Payments);
        dbContext.SaveChanges();


        // Adding a payment to ensure there is data to retrieve
        var payment = new Payment
        {
            PaymentID = "PAY002",
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
        Assert.Equal("PAY002", payments[0].PaymentID);

    }

    [Fact]
    public void UpgradePlan_ShouldReturnOk_WhenPlanIsUpgraded()
    {
        // Arrange: Seed the data with a specific initial plan
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var tokenGenerator = new TokenGenerator(_configuration);
        var passwordHasher = new PasswordHasher<Company>();
        var companyController = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);
    
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
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var tokenGenerator = new TokenGenerator(_configuration);
        var passwordHasher = new PasswordHasher<Company>();
        var companyController = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);
        
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
        var companyController = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);
        
        var result = companyController.UpgradePlan("999", SubscriptionPlan.Premium) as NotFoundObjectResult;

        Assert.NotNull(result);
        Assert.Equal("Company not found", result.Value);
    }
    
    //testes para o ListAllProjectsFromCompany
    [Fact]
    public void ListAllProjectsFromCompany_ShouldReturnOk_WhenProjectsExist()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);
        
        var tokenGenerator = new TokenGenerator(_configuration);
        var passwordHasher = new PasswordHasher<Company>();
        var companyController = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);
        
        var result = companyController.ListAllProjectsFromCompany("1") as OkObjectResult;

        Assert.NotNull(result);
        var projects = result.Value as List<Project>;
        Assert.Equal(1, projects.Count);
    }
    
    [Fact]
    public void ListAllProjectsFromCompany_ShouldReturnNotFound_WhenCompanyDoesNotExist()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);  // Ensure no company with ID "999" is seeded

        var tokenGenerator = new TokenGenerator(_configuration);
        var passwordHasher = new PasswordHasher<Company>();
        var companyController = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);

        // Act
        var result = companyController.ListAllProjectsFromCompany("999") as NotFoundObjectResult;

        // Assert
        Assert.NotNull(result);
        Assert.Equal("Company not found", result?.Value);
    }
    
    [Fact]
    public void ListAllProjectsFromCompany_ShouldReturnOk_WhenNoProjectsExist()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);
    
        var tokenGenerator = new TokenGenerator(_configuration);
        var passwordHasher = new PasswordHasher<Company>();
        var companyController = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);
    
        // Remove todos os projetos para simular
        dbContext.Projects.RemoveRange(dbContext.Projects);
        dbContext.SaveChanges();

        // Act
        var result = companyController.ListAllProjectsFromCompany("1") as OkObjectResult;

        // Assert
        Assert.NotNull(result);
        Assert.Equal("No projects found for this company", result.Value);
    }
    //getprojectbyid in company
    [Fact]
    public void GetProjectById_ShouldReturnOk_WhenProjectExists()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);
        
        var tokenGenerator = new TokenGenerator(_configuration);
        var passwordHasher = new PasswordHasher<Company>();
        var companyController = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);
        
        var result = companyController.GetProjectById("1", "PROJ01") as OkObjectResult;

        Assert.NotNull(result);
        var project = result.Value as Project;
        Assert.Equal("New Project", project.Name);
    }
    
    [Fact]
    public void GetProjectById_ShouldReturnNotFound_WhenProjectDoesNotExist()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);
        
        var tokenGenerator = new TokenGenerator(_configuration);
        var passwordHasher = new PasswordHasher<Company>();
        var companyController = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);
        
        var result = companyController.GetProjectById("1", "PROJ02") as NotFoundObjectResult;

        Assert.NotNull(result);
        Assert.Equal("Project not found or does not belong to the specified company.", result.Value);
    }
    
    [Fact]
    public void GetProjectById_ShouldReturnNotFound_WhenCompanyDoesNotExist()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);
        
        var tokenGenerator = new TokenGenerator(_configuration);
        var passwordHasher = new PasswordHasher<Company>();
        var companyController = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);
        
        var result = companyController.GetProjectById("999", "PROJ01") as NotFoundObjectResult;

        Assert.NotNull(result);
        Assert.Equal("Company not found", result.Value);
    }

    [Fact]
    public void RegisterCompany_Success()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        var passwordHasher = new PasswordHasher<Company>();
        var tokenGenerator = new TokenGenerator(_configuration);
        var controller = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);

        var company = new Company
        {
            CompanyID = "1",
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
        var result = controller.CreateCompany(company) as OkObjectResult;

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
        var controller = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);

        var existingCompany = new Company
        {
            CompanyID = "1",
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

        var newCompany = new Company
        {
            CompanyID = "2",
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
        var result = controller.CreateCompany(newCompany) as BadRequestObjectResult;

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
        var controller = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);

        var company = new Company
        {
            CompanyID = "3",
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
        var result = controller.CreateCompany(company) as BadRequestObjectResult;

        // Assert
        Assert.NotNull(result);
        Assert.IsType<BadRequestObjectResult>(result);
        Assert.Equal("Invalid subscription plan.", result.Value); // Verificando a string diretamente

    }

    [Fact]
    public void RegisterCompany_InvalidEmailFormat()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        var passwordHasher = new PasswordHasher<Company>();
        var tokenGenerator = new TokenGenerator(_configuration);
        var controller = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);

        var company = new Company
        {
            CompanyID = "4",
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
        var result = controller.CreateCompany(company) as BadRequestObjectResult;

        // Assert
        Assert.NotNull(result);
        Assert.IsType<BadRequestObjectResult>(result);
        Assert.Equal("Invalid email format.", result.Value);
    }
}
