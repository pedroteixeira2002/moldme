using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.Controllers;
using Xunit;
using moldme.data;
using moldme.Models;

namespace moldme.Tests;

public class EmployeeControllerTests
{
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
            EmployeeID = "1",
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
            EmployeeID = "2",
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
    
    // Testa o método AddEmploye
    [Fact]
    public void AddEmployee_AddsNewEmployeeToDatabase()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new EmployeeController(dbContext);
        var newEmployee = new Employee
        {
            EmployeeID = "3",
            Name = "New Employee",
            Profession = "Designer",
            CompanyId = "1",
            Email = "newemployee@example.com",
            Password = "newpassword123"
        };

        // Act
        var result = controller.AddEmployee(newEmployee);

        // Assert
        var createdAtActionResult = Assert.IsType<CreatedAtActionResult>(result);
        var addedEmployee = Assert.IsType<Employee>(createdAtActionResult.Value);
        Assert.Equal("3", addedEmployee.EmployeeID);
        Assert.Equal("New Employee", addedEmployee.Name);
        Assert.Equal("Designer", addedEmployee.Profession);
        Assert.Equal("1", addedEmployee.CompanyId);
        Assert.Equal("newemployee@example.com", addedEmployee.Email);

        // Verify the employee was added to the database
        var employeeInDb = dbContext.Employees.Find("3");
        Assert.NotNull(employeeInDb);
        Assert.Equal("New Employee", employeeInDb.Name);
    }
    //AddEmployeeShouldReturnBadRequestWhenEmployeeIsNull
    [Fact]
    public void AddEmployee_ShouldReturnBadRequestWhenEmployeeIsNull()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new EmployeeController(dbContext);

        // Act
        var result = controller.AddEmployee(null);

        // Assert
        var badRequestResult = Assert.IsType<BadRequestObjectResult>(result);
        Assert.Equal("Employee data is required", badRequestResult.Value);
    }
    
    //EditEmployee
    [Fact]
    public void EditEmployee_UpdatesEmployeeInDatabase()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new EmployeeController(dbContext);
        var updatedEmployee = new Employee
        {
            EmployeeID = "1",
            Name = "John Smith",
            Profession = "Senior Software Developer",
            CompanyId = "1",
            Email = "johnsmith@example.com",
            Password = "newpassword123"
        };

        // Act
        var result = controller.EditEmployee("1", updatedEmployee);

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result);
        var employeeInDb = dbContext.Employees.Find("1");
        Assert.NotNull(employeeInDb);
        Assert.Equal("John Smith", employeeInDb.Name);
        Assert.Equal("Senior Software Developer", employeeInDb.Profession);
        Assert.Equal("johnsmith@example.com", employeeInDb.Email);
    }
    
    //EditEmployeeShouldReturnBadRequestWhenEmployeeDoesNotExist
    [Fact]
    public void EditEmployee_ShouldReturnBadRequestWhenEmployeeDoesNotExist()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new EmployeeController(dbContext);
        var updatedEmployee = new Employee
        {
            EmployeeID = "999", // Non-existent employee ID
            Name = "Non Existent",
            Profession = "Non Existent Profession",
            CompanyId = "1",
            Email = "nonexistent@example.com",
            Password = "nonexistentpassword"
        };

        // Act
        var result = controller.EditEmployee("999", updatedEmployee);

        // Assert
        var notFoundResult = Assert.IsType<NotFoundObjectResult>(result);
        Assert.Equal("Employee not found", notFoundResult.Value);
    }
    
    //RemoveEmployee
    
    // RemoveEmployeebyId
    [Fact]
    public void RemoveEmployeeById_RemovesEmployeeFromDatabase()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new EmployeeController(dbContext);

        // Act
        var result = controller.RemoveEmployee("1");

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal("Employee with ID 1 removed successfully", okResult.Value);

        // Verify the employee was removed from the database
        var employeeInDb = dbContext.Employees.Find("1");
        Assert.Null(employeeInDb);
    }
    
    //ListAllEmployees
    [Fact]
    public void ListAllEmployees_ReturnsAllEmployees()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new EmployeeController(dbContext);

        // Act
        var result = controller.ListAllEmployees();

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result);
        var employees = Assert.IsType<List<Employee>>(okResult.Value);
        Assert.Equal(2, employees.Count);
        Assert.Contains(employees, e => e.EmployeeID == "1" && e.Name == "John Doe");
        Assert.Contains(employees, e => e.EmployeeID == "2" && e.Name == "Jane Doe");
    }
    
  
    
    
    
    
    [Fact]
    public void GetEmployeeProjects_ReturnsProjectsForEmployee()
    {
        // insere dados teste no DbContext em memória
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);
        
        // Configura o controller
        var controller = new EmployeeController(dbContext);

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
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);
        
        var controller = new EmployeeController(dbContext);

        // Act
        var result = controller.GetEmployeeProjects("999").Result; // Non-existent employee ID

        // Assert
        var notFoundResult = Assert.IsType<NotFoundObjectResult>(result);
        Assert.Equal("Employee with ID 999 not found.", notFoundResult.Value);
    }

    [Fact]
    public void GetEmployeeProjects_EmployeeExistsButNoProjects_ReturnsEmptyList()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new EmployeeController(dbContext);

        // Act
        var result = controller.GetEmployeeProjects("2").Result; // Employee with no projects

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result);
        var projects = Assert.IsType<List<Project>>(okResult.Value);
        Assert.Empty(projects);
    }

}