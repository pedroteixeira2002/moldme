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

    [Fact]
    public void Employee_Properties_GetterSetter_WorksCorrectly()
    {
        // Arrange
        var employee = new Employee
        {
            EmployeeID = "E12345",
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
        Assert.Equal("E12345", employee.EmployeeID);
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

    //GetEmployeeById
    [Fact]
    public void GetEmployeeById_ReturnsEmployee_WhenEmployeeExists()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new EmployeeController(dbContext);

        // Act
        var result = controller.GetEmployeeById("1");

        // Assert
        var okResult = Assert.IsType<OkObjectResult>(result);
        var employee = Assert.IsType<Employee>(okResult.Value);
        Assert.Equal("1", employee.EmployeeID);
        Assert.Equal("John Doe", employee.Name);
    }

    //GetEmployeeById without employee
    [Fact]
    public void GetEmployeeById_ShouldReturnNotFound_WhenEmployeeDoesNotExist()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext);

        var controller = new EmployeeController(dbContext);

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
        Assert.Equal("No projects found for this employee.", notFoundResult.Value);
    }

    [Fact]
    public void GetEmployeeProjects_EmployeeExistsButNoProjects_ReturnsNotFound()
    {
        // Arrange
        var dbContext = GetInMemoryDbContext();
        SeedData(dbContext); // Seed data with employees but employee 2 has no projects

        var controller = new EmployeeController(dbContext);

        // Act
        var result = controller.GetEmployeeProjects("2").Result; // Employee with no projects

        // Assert
        var notFoundResult = Assert.IsType<NotFoundObjectResult>(result);
        Assert.Equal("No projects found for this employee.", notFoundResult.Value); // Expecting the NotFound message
    }
}