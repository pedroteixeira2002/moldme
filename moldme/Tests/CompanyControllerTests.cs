using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.Controllers;
using moldme.data;
using moldme.Models;
using Xunit;
namespace moldme.Tests;

public class CompanyControllerTests
{ 
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
        //dbContext.Projects.RemoveRange(dbContext.Projects);

        dbContext.Companies.Add(company);
        dbContext.Employees.Add(employee);
        dbContext.Projects.Add(project);
        dbContext.Payments.Add(payment);
        dbContext.SaveChanges();
    }

    [Fact]
    public void AddProjectTest_ShouldReturnOk_WhenProjectIsValid()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);
        
        var companyController = new CompanyController(dbContext);
        
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
            var dbContext = GetInMemoryDbContext();
            SeedData(dbContext);
            
            var companyController = new CompanyController(dbContext);
            
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
    public void AddEmployeeTest()
    {
        // Arrange
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;

        using (var dbContext = new ApplicationDbContext(options))
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

            dbContext.Companies.Add(company);
            dbContext.SaveChanges();

            var controller = new CompanyController(dbContext);

            var employee = new Employee
            {
                EmployeeID = "1",
                Name = "Employee 1",
                Profession = "Profession 1",
                NIF = 123456789,
                Email = "employee@example.com",
                Contact = 987654321,
                Password = "password"
            };

            // Act
            var result = controller.AddEmployee(company.CompanyID, employee) as OkObjectResult;

            // Assert
            Assert.NotNull(result);
            Assert.Equal("Employee created successfully", result.Value);

            var addedEmployee = dbContext.Employees.FirstOrDefault(e => e.EmployeeID == "1");
            Assert.NotNull(addedEmployee);
            Assert.Equal("1", addedEmployee.CompanyID);
        }
    }


    [Fact]
    public void RemoveEmployeeTest()
    {
        // Arrange
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: "Remove_employee_database")
            .Options;

        using (var dbContext = new ApplicationDbContext(options))
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
                EmployeeID = "1",
                Name = "Employee 1",
                Profession = "Profession 1",
                NIF = 123456789,
                Email = "employee@example.com",
                Contact = 987654321,
                Password = "password",
                CompanyID = company.CompanyID
            };

            dbContext.Companies.Add(company);
            dbContext.Employees.Add(employee);
            dbContext.SaveChanges();

            var controller = new CompanyController(dbContext);

            // Act
            var result = controller.RemoveEmployee(company.CompanyID, employee.EmployeeID) as OkObjectResult;

            // Assert
            Assert.NotNull(result);
            Assert.Equal("Employee removed successfully", result.Value);

            var removedEmployee = dbContext.Employees.FirstOrDefault(e => e.EmployeeID == "1");
            Assert.Null(removedEmployee);
        }
    }

[Fact]
    public void EditEmployeeTest()
    {
        // Arrange
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: "Edit_employee_database")
            .Options;

        using (var dbContext = new ApplicationDbContext(options))
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
                EmployeeID = "1",
                Name = "Original Employee",
                Profession = "Original Profession",
                NIF = 123456789,
                Email = "employee@example.com",
                Contact = 987654321,
                Password = "password",
                CompanyID = company.CompanyID
            };

            dbContext.Companies.Add(company);
            dbContext.Employees.Add(employee);
            dbContext.SaveChanges();

            var controller = new CompanyController(dbContext);

            var updatedEmployee = new Employee
            {
                EmployeeID = "1",
                Name = "Updated Employee",
                Profession = "Updated Profession",
                NIF = 987654321,
                Email = "updated@example.com",
                Contact = 123456789,
                Password = "newpassword",
                CompanyID = company.CompanyID
            };

            // Act
            var result = controller.EditEmployee(company.CompanyID, "1", updatedEmployee) as OkObjectResult;

            // Assert
            Assert.NotNull(result);
            var updatedEmployeeFromDb = result.Value as Employee;
            Assert.Equal("Updated Employee", updatedEmployeeFromDb.Name);
            Assert.Equal(987654321, updatedEmployeeFromDb.NIF);
        }
    }

 [Fact]
    public void ListAllEmployeesTest()
    {
        // Arrange
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: "List_all_employees_database")
            .Options;

        using (var dbContext = new ApplicationDbContext(options))
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
                EmployeeID = "1",
                Name = "Employee 1",
                Profession = "Profession 1",
                NIF = 123456789,
                Email = "employee1@example.com",
                Contact = 987654321,
                Password = "password",
                CompanyID = company.CompanyID
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
                CompanyID = company.CompanyID
            };

            dbContext.Companies.Add(company);
            dbContext.Employees.Add(employee1);
            dbContext.Employees.Add(employee2);
            dbContext.SaveChanges();

            var controller = new CompanyController(dbContext);

            // Act
            var result = controller.ListAllEmployees(company.CompanyID) as OkObjectResult;

            // Assert
            Assert.NotNull(result);
            var employees = result.Value as List<Employee>;
            Assert.Equal(2, employees.Count);
        }
    }


    [Fact]
    public void ViewProjectTest_ShouldReturnOk_WhenProjectExists()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);
        
        var companyController = new CompanyController(dbContext);
        
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
        
        var companyController = new CompanyController(dbContext);
        
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
        SeedData(dbContext); // Seed the initial data
        
        var companyController = new CompanyController(dbContext);

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
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);
        
        var companyController = new CompanyController(dbContext);
    
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
        
        var companyController = new CompanyController(dbContext);
        
        var result = companyController.UpgradePlan("1", SubscriptionPlan.Premium) as BadRequestObjectResult;

        Assert.NotNull(result);
        Assert.Equal("Subscription plan already upgraded", result.Value);
    }

    [Fact]
    public void UpgradePlan_ShouldReturnNotFound_WhenCompanyDoesNotExist()
    {
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);
        
        var companyController = new CompanyController(dbContext);
        
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
        
        var companyController = new CompanyController(dbContext);
        
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

        var companyController = new CompanyController(dbContext);

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
    
        var companyController = new CompanyController(dbContext);
    
        // Remove todos os projetos para simular
        dbContext.Projects.RemoveRange(dbContext.Projects);
        dbContext.SaveChanges();

        // Act
        var result = companyController.ListAllProjectsFromCompany("1") as OkObjectResult;

        // Assert
        Assert.NotNull(result);
        Assert.Equal("No projects found for this company", result.Value);
    }
}
