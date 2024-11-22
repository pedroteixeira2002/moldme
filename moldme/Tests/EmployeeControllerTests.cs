using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.Auth;
using moldme.Controllers;
using Xunit;
using moldme.data;
using moldme.DTOs;
using moldme.Models;

namespace moldme.Tests;

public class EmployeeControllerTests

{
    private readonly IConfiguration _configuration;

    public EmployeeControllerTests()
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

    // Método para adicionar dados teste ao DbContext em memória
    private void SeedData(ApplicationDbContext dbContext)
    {
        var company = new Company
        {
            CompanyID = "1",
            Name = "Company 1",
            Address = "Address 1",
            Email = "asdasd@gasd.com",
            Contact = 901237456,
            TaxId = 123456789,
            Sector = "1",
            Plan = SubscriptionPlan.Premium,
            Password = "123456"
        };

        var employeeWithProjects = new Employee
        {
            EmployeeId = "1",
            Name = "John Doe",
            Profession = "Software Developer",
            CompanyId = company.CompanyID,
            Email = "johndoe@example.com",
            Password = "password123",
            Projects = new List<Project>
            {
                new Project
                {
                    ProjectId = "1",
                    Name = "Project 1",
                    Description = "Description 1",
                    Budget = 1000,
                    Status = Status.INPROGRESS,
                    StartDate = DateTime.Now,
                    EndDate = DateTime.Now,
                    CompanyId = company.CompanyID
                },
                new Project
                {
                    ProjectId = "2",
                    Name = "Project 2",
                    Description = "Description 2",
                    Budget = 2000,
                    Status = Status.DONE,
                    StartDate = DateTime.Now,
                    EndDate = DateTime.Now,
                    CompanyId = company.CompanyID
                }
            }
        };

        var employeeWithoutProjects = new Employee
        {
            EmployeeId = "2",
            Name = "Jane Doe",
            Profession = "QA Engineer",
            CompanyId = company.CompanyID,
            Email = "janedoe@example.com",
            Password = "password123"
        };

        dbContext.Companies.Add(company);
        dbContext.Employees.Add(employeeWithProjects);
        dbContext.Employees.Add(employeeWithoutProjects);
        dbContext.SaveChanges();
    }

    [Fact]
    public void Employee_Properties_GetterSetter_WorksCorrectly()
    {
        // Arrange
        var employee = new Employee
        {
            EmployeeId = "E12345",
            Name = "John Doe",
            Profession = "Developer",
            NIF = 123456789,
            Email = "john.doe@example.com",
            Contact = 987654321,
            Password = "password123",
            CompanyId = "C12345",
            Company = new Company { CompanyID = "C12345", Name = "Tech Corp" }
        };

        // Act & Assert
        Assert.Equal("E12345", employee.EmployeeId);
        Assert.Equal("John Doe", employee.Name);
        Assert.Equal("Developer", employee.Profession);
        Assert.Equal(123456789, employee.NIF);
        Assert.Equal("john.doe@example.com", employee.Email);
        Assert.Equal(987654321, employee.Contact);
        Assert.Equal("password123", employee.Password);
        Assert.Equal("C12345", employee.CompanyId);
        Assert.Equal("Tech Corp", employee.Company.Name);

        // Test setters
        employee.Name = "Jane Doe";
        employee.Profession = "Manager";
        employee.NIF = 987654321;
        employee.Email = "jane.doe@example.com";
        employee.Contact = 123456789;
        employee.Password = "newpassword123";
        employee.CompanyId = "C67890";
        employee.Company = new Company { CompanyID = "C67890", Name = "New Tech Corp" };

        Assert.Equal("Jane Doe", employee.Name);
        Assert.Equal("Manager", employee.Profession);
        Assert.Equal(987654321, employee.NIF);
        Assert.Equal("jane.doe@example.com", employee.Email);
        Assert.Equal(123456789, employee.Contact);
        Assert.Equal("newpassword123", employee.Password);
        Assert.Equal("C67890", employee.CompanyId);
        Assert.Equal("New Tech Corp", employee.Company.Name);
    }

    [Fact]
    public void ListAllEmployees_ReturnsAllEmployees()
    {
        // Arrange
        var tokenGenerator = new TokenGenerator(_configuration); // Use _configuration directly
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);
        var passwordHasher = new PasswordHasher<Employee>();
        var controller = new EmployeeController(dbContext, tokenGenerator,passwordHasher);

        
        // Act
        var result = controller.EmployeeListAll(companyId:"1");

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result);
        var employees = Assert.IsType<List<Employee>>(okResult.Value);
        Assert.Equal(2, employees.Count);
        Assert.Contains(employees, e => e.EmployeeId == "1" && e.Name == "John Doe");
        Assert.Contains(employees, e => e.EmployeeId == "2" && e.Name == "Jane Doe");
    }

    //GetEmployeeById
    [Fact]
    public void GetEmployeeById_ReturnsEmployee_WhenEmployeeExists()
    {
        var passwordHasher = new PasswordHasher<Employee>();
        var tokenGenerator = new TokenGenerator(_configuration); // Use _configuration directly
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new EmployeeController(dbContext,tokenGenerator,passwordHasher);

        // Act
        var result = controller.GetEmployeeById("1");

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result);
        var employee = Assert.IsType<Employee>(okResult.Value);
        Assert.Equal("1", employee.EmployeeId);
        Assert.Equal("John Doe", employee.Name);
    }

    //GetEmployeeById without employee
    [Fact]
    public void GetEmployeeById_ShouldReturnNotFound_WhenEmployeeDoesNotExist()
    {
        // Arrange
        var tokenGenerator = new TokenGenerator(_configuration); // Use _configuration directly
        var passwordHasher = new PasswordHasher<Employee>();
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new EmployeeController(dbContext,tokenGenerator, passwordHasher);

        // Act
        var result = controller.GetEmployeeById("999"); // Non-existent employee ID

        // Assert
        var notFoundResult = Assert.IsType<NotFoundObjectResult>(result);
        Assert.Equal("Employee not found", notFoundResult.Value);
    }


    [Fact]
    public void GetEmployeeProjects_ReturnsProjectsForEmployee()
    {
        // insere dados teste no DbContext em memória
        var tokenGenerator = new TokenGenerator(_configuration); // Use _configuration directly
        var passwordHasher = new PasswordHasher<Employee>();
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        // Configura o controller
        var controller = new EmployeeController(dbContext,tokenGenerator,passwordHasher);

        // Executa o método
        var result = controller.GetEmployeeProjects("1").Result;

        // Verifica se o resultado
        var okResult = Assert.IsType<OkObjectResult>(result);

        // Converte o resultado em uma lista de projetos
        var projects = Assert.IsType<List<Project>>(okResult.Value);

        // Valida que existem 2 projetos
        Assert.Equal(2, projects.Count);
        Assert.Contains(projects, p => p.ProjectId == "1" && p.Name == "Project 1");
        Assert.Contains(projects, p => p.ProjectId == "2" && p.Name == "Project 2");
    }

    [Fact]
    public void GetEmployeeProjects_EmployeeDoesNotExist_ReturnsNotFound()
    {
        // Arrange
        var tokenGenerator = new TokenGenerator(_configuration); // Use _configuration directly
        var passwordHasher = new PasswordHasher<Employee>();
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new EmployeeController(dbContext,tokenGenerator, passwordHasher);

        // Act
        var result = controller.GetEmployeeProjects("999").Result; // Non-existent employee ID

        // Assert
        var notFoundResult = Assert.IsType<NotFoundObjectResult>(result);
        Assert.Equal("No projects found for this employee.", notFoundResult.Value);
    }

    [Fact]
    public void GetEmployeeProjects_EmployeeExistsButNoProjects_ReturnsNotFound()
    {
        // Arrange
        var tokenGenerator = new TokenGenerator(_configuration); // Use _configuration directly
        var passwordHasher = new PasswordHasher<Employee>();
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext); // Seed data with employees but employee 2 has no projects

        var controller = new EmployeeController(dbContext,tokenGenerator,passwordHasher);

        // Act
        var result = controller.GetEmployeeProjects("2").Result; // Employee with no projects

        // Assert
        var notFoundResult = Assert.IsType<NotFoundObjectResult>(result);
        Assert.Equal("No projects found for this employee.", notFoundResult.Value); // Expecting the NotFound message
    }
    
    [Fact]
    public void AddEmployeeTest()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext(); // Get a new DbContext for the test
        SeedData(dbContext); // Seed any necessary data (if applicable)

        // Assuming _configuration is already defined in your test class and contains your JWT key
        var tokenGenerator = new TokenGenerator(_configuration); // Use _configuration directly
        var passwordHasher = new PasswordHasher<Employee>();

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
        };
        

        var employeeController = new EmployeeController(dbContext,tokenGenerator,passwordHasher);

        // Act
        var result = employeeController.EmployeeCreate(company.CompanyID, employeeDto) as OkObjectResult;

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
            EmployeeId = "E1", // Ensure a unique ID for the employee
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
        var passwordHasher = new PasswordHasher<Employee>();
        var controller = new EmployeeController(dbContext, tokenGenerator, passwordHasher);

        // Act
        var result = controller.EmployeeRemove(company.CompanyID, employee.EmployeeId) as OkObjectResult;

        // Assert
        Assert.NotNull(result); // Ensure that the result is not null
        Assert.Equal("Employee removed successfully", result.Value); // Check that the response message is correct

        // Verify that the employee was actually removed from the database
        var removedEmployee = dbContext.Employees.FirstOrDefault(e => e.EmployeeId == employee.EmployeeId);
        Assert.Null(removedEmployee); // Assert that the removed employee is null
    }

    [Fact]
    public void EditEmployeeTest()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext(); // Create a new DbContext for the test
        var tokenGenerator = new TokenGenerator(_configuration);
        var passwordHasher = new PasswordHasher<Employee>();
        var controller = new EmployeeController(dbContext, tokenGenerator, passwordHasher);

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
            EmployeeId = "1", // Unique ID
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
            controller.EmployeeUpdate(company.CompanyID, employee.EmployeeId, updatedEmployeeDto) as OkObjectResult;

        // Assert
        Assert.NotNull(result); // Check that the result is not null
        Assert.Equal("Employee updated successfully", result.Value); // Verify the success message

        // Fetch the updated employee from the database
        var updatedEmployeeFromDb = dbContext.Employees.FirstOrDefault(e => e.EmployeeId == employee.EmployeeId);
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
        var passwordHasher = new PasswordHasher<Employee>();
        var controller = new EmployeeController(dbContext, tokenGenerator, passwordHasher);

        var company = new Company
        {
            CompanyID = "21", // Use a unique ID
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
            EmployeeId = "11",
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
            EmployeeId = "21",
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
        var result = controller.EmployeeListAll(company.CompanyID) as OkObjectResult;

        // Assert
        Assert.NotNull(result);
        Assert.IsType<OkObjectResult>(result);

        var employees = result.Value as List<Employee>;
        Assert.NotNull(employees);
        Assert.Equal(2, employees.Count);
    }

}