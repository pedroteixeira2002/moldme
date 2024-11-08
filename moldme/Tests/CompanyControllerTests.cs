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
    public void Payment_Properties_GetterSetter_WorksCorrectly()
    {
        // Arrange
        var payment = new Payment
        {
            PaymentID = "PAY01",
            Value = (float)100.50,
            Date = new DateTime(2023, 10, 1),
            CompanyId = "C12345",
            Company = new Company
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
            },
            Plan = SubscriptionPlan.Premium
        };

        Assert.Equal("PAY01", payment.PaymentID);
        Assert.Equal(100.50, payment.Value);
        Assert.Equal(new DateTime(2023, 10, 1), payment.Date);
        Assert.Equal("C12345", payment.CompanyId);
        Assert.Equal("Company 1", payment.Company.Name);
        Assert.Equal(SubscriptionPlan.Premium, payment.Plan);
        Assert.Equal("Company 1", payment.Company.Name);


        payment.Value = (float)200.75;
        payment.Date = new DateTime(2023, 11, 1);
        payment.CompanyId = "C67890";
        payment.Plan = SubscriptionPlan.Basic;
        payment.Company = new Company
        {
            CompanyID = "2",
            Name = "Company 2",
            Address = "Address 2",
            Email = "email2@example.com",
            Contact = 987654321,
            TaxId = 987654321,
            Sector = "Sector 2",
            Plan = SubscriptionPlan.Basic,
            Password = "password2"
        };

        Assert.Equal(200.75, payment.Value);
        Assert.Equal(new DateTime(2023, 11, 1), payment.Date);
        Assert.Equal("C67890", payment.CompanyId);
        Assert.Equal("Company 2", payment.Company.Name);
        Assert.Equal(SubscriptionPlan.Basic, payment.Company.Plan);
        Assert.Equal("Company 2", payment.Company.Name);
    }

    [Fact]
    public void Company_Properties_GetterSetter_WorksCorrectly()
    {
        var company = new Company
        {
            CompanyID = "C12345",
            Name = "Tech Corp",
            Address = "123 Tech Street",
            Email = "contact@techcorp.com",
            Contact = 123456789,
            TaxId = 987654321,
            Sector = "IT",
            Plan = SubscriptionPlan.Premium,
            Password = "password123"
        };

        Assert.Equal("C12345", company.CompanyID);
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
        var employeeDto = new EmployeeDto
        {
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

        var addedEmployee = dbContext.Employees.FirstOrDefault(e => e.Email == employeeDto.Email);
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

        // Create an updated employee DTO
        var updatedEmployeeDto = new EmployeeDto
        {
            Name = "Updated Employee",
            Profession = "Updated Profession",
            Nif = 987654321,
            Email = "updated@example.com",
            Contact = 123456789,
            Password = "newpassword" // Assuming the controller handles hashing
        };

        // Act
        var result =
            controller.EditEmployee(company.CompanyID, employee.EmployeeID, updatedEmployeeDto) as OkObjectResult;

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

        var tokenGenerator = new TokenGenerator(_configuration);
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
        // Arrange
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var tokenGenerator = new TokenGenerator(_configuration);
        var passwordHasher = new PasswordHasher<Company>();
        var companyController = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);

        // Configurar o plano inicial para a empresa
        var existingCompany = dbContext.Companies.FirstOrDefault(c => c.CompanyID == "1");
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
    public void AddProjectTest()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var tokenGenerator = new TokenGenerator(_configuration);
        var passwordHasher = new PasswordHasher<Company>();
        var companyController = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);

        var projectDto = new ProjectDto
        {
            Name = "New Project1",
            Description = "New Project Description",
            Budget = 5000,
            StartDate = DateTime.Now,
            EndDate = DateTime.Now.AddMonths(1)
        };

        var result = companyController.AddProject("1", projectDto) as OkObjectResult;

        Assert.NotNull(result);
        Assert.Equal("Project added successfully", result.Value);

        var addedProject = dbContext.Projects.FirstOrDefault(p => p.Name == "New Project1");
        Assert.NotNull(addedProject);
        Assert.Equal("New Project Description", addedProject.Description);
        Assert.Equal(5000, addedProject.Budget);
    }

    [Fact]
    public void AddProject_ShouldReturnNotFound_WhenCompanyDoesNotExist()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var tokenGenerator = new TokenGenerator(_configuration);
        var passwordHasher = new PasswordHasher<Company>();
        var companyController = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);

        var projectDto = new ProjectDto
        {
            Name = "New Project",
            Description = "New Project Description",
            Budget = 5000,
            StartDate = DateTime.Now,
            EndDate = DateTime.Now.AddMonths(1),
            EmployeeIds = new List<string> { "EMP01" }
        };

        // Act
        var result = companyController.AddProject("999", projectDto) as NotFoundObjectResult;

        // Assert
        Assert.NotNull(result);
        Assert.Equal("Company not found", result.Value);
    }

    [Fact]
    public void AddProject_ShouldReturnNotFound_WhenEmployeeDoesNotExist()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var tokenGenerator = new TokenGenerator(_configuration);
        var passwordHasher = new PasswordHasher<Company>();
        var companyController = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);

        var projectDto = new ProjectDto
        {
            Name = "New Project",
            Description = "New Project Description",
            Budget = 5000,
            StartDate = DateTime.Now,
            EndDate = DateTime.Now.AddMonths(1),
            EmployeeIds = new List<string> { "NONEXISTENT_EMP" }
        };

        var result = companyController.AddProject("1", projectDto) as NotFoundObjectResult;
        
        Assert.NotNull(result);
        Assert.Equal("Employee with ID NONEXISTENT_EMP not found", result.Value);
    }

    [Fact]
    public void EditProjectTest()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var tokenGenerator = new TokenGenerator(_configuration);
        var passwordHasher = new PasswordHasher<Company>();
        var companyController = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);

        var projectDto = new ProjectDto
        {
            Name = "Updated Project",
            Description = "Updated Project Description",
            Budget = 10000,
            StartDate = DateTime.Now,
            EndDate = DateTime.Now.AddMonths(2)
        };

        // Act
        var result = companyController.EditProject("PROJ01", projectDto) as OkObjectResult;

        // Assert
        Assert.NotNull(result);
        Assert.Equal("Project updated successfully", result.Value);

        var updatedProject = dbContext.Projects.FirstOrDefault(p => p.ProjectId == "PROJ01");
        Assert.NotNull(updatedProject);
        Assert.Equal("Updated Project", updatedProject.Name);
        Assert.Equal("Updated Project Description", updatedProject.Description);
        Assert.Equal(10000, updatedProject.Budget);
    }

    [Fact]
    public void CancelSubscriptionTest()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var tokenGenerator = new TokenGenerator(_configuration);
        var passwordHasher = new PasswordHasher<Company>();
        var companyController = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);

        var result = companyController.CancelSubscription("1") as OkObjectResult;

        Assert.NotNull(result);
        Assert.Equal("Subscription cancelled successfully", result.Value);

        var company = dbContext.Companies.FirstOrDefault(c => c.CompanyID == "1");
        Assert.NotNull(company);
        Assert.Equal(SubscriptionPlan.None, company.Plan);
    }

    [Fact]
    public void ListAllProjectsFromCompany_ShouldReturnNotFound_WhenCompanyDoesNotExist()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext); // Ensure no company with ID "999" is seeded

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
        var result = controller.CreateCompany(companyDto) as OkObjectResult;

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
        var result = controller.CreateCompany(newCompanyDto) as BadRequestObjectResult;

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
        var result = controller.CreateCompany(companyDto) as BadRequestObjectResult;

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
        var controller = new CompanyController(dbContext, tokenGenerator, passwordHasher, passwordHasher);

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
        var result = controller.CreateCompany(companyDto) as BadRequestObjectResult;

        // Assert
        Assert.NotNull(result);
        Assert.IsType<BadRequestObjectResult>(result);
        Assert.Equal("Invalid email format.", result.Value);
    }
}