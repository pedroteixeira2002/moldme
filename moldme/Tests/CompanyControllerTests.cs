﻿using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.Controllers;
using moldme.data;
using Xunit;
using moldme.Models;
namespace moldme.Tests;
public class CompanyControllerTests
{
    [Fact]
    public void AddProjectTest()
    {
        // Arrange
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString()) // Utiliza um nome único para o banco de dados em memória
            .Options;

        using (var dbContext = new ApplicationDbContext(options))
        {
            // Adiciona uma empresa ao contexto de dados
            var company = new Company
            {
                CompanyID = "1",
                Name = "Company 1",
                Address = "Address 1",
                Email = "[email protected]",
                Contact = 123456789,
                TaxId = 123456789,
                Sector = "Sector 1",
                Plan = SubscriptionPlan.Premium,
                Password = "password"
            };

            dbContext.Companies.Add(company);
            dbContext.SaveChanges();

            // Cria uma instância do controlador com o contexto atual
            var controller = new CompanyController(dbContext);

            // Cria um projeto para ser adicionado
            var project = new Project
            {
                ProjectId = "1",
                Name = "Project 1",
                Description = "Description 1",
                Budget = 1000,
                Status = Status.INPROGRESS,
                StartDate = DateTime.Now,
                EndDate = DateTime.Now.AddDays(30),
                CompanyId = company.CompanyID // Associa explicitamente o projeto à empresa
            };

            // Act
            var result = controller.AddProject(company.CompanyID, project) as OkObjectResult;

            // Assert
            Assert.NotNull(result); // Verifica se o resultado não é nulo
            Assert.Equal("Project added successfully", result.Value); // Verifica a mensagem retornada

            // Verifica se o projeto foi adicionado corretamente ao banco de dados
            var addedProject = dbContext.Projects.FirstOrDefault(p => p.ProjectId == "1");
            Assert.NotNull(addedProject); // Verifica se o projeto foi encontrado
            Assert.Equal("1", addedProject.CompanyId); // Verifica se o projeto está associado à empresa correta
        }
    }

    [Fact]
    public void EditProjectTest()
    {
        // Arrange
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: "Edit_project_database")
            .Options;
 
        using (var dbContext = new ApplicationDbContext(options))
        {
            // Adiciona uma empresa e um projeto ao contexto de dados
            var company = new Company
            {
                CompanyID = "1",
                Name = "Company 1",
                Address = "Address 1",
                Email = "[email protected]",
                Contact = 123456789,
                TaxId = 123456789,
                Sector = "Sector 1",
                Plan = SubscriptionPlan.Premium,
                Password = "password"
            };

            var project = new Project
            {
                ProjectId = "1",
                Name = "Original Project",
                Description = "Original Description",
                Budget = 5000,
                Status = Status.INPROGRESS,
                StartDate = DateTime.Now,
                EndDate = DateTime.Now.AddDays(30),
                CompanyId = company.CompanyID
            };

            dbContext.Companies.Add(company);
            dbContext.Projects.Add(project);
            dbContext.SaveChanges();

            var controller = new CompanyController(dbContext);

            // Atualização do projeto
            var updatedProject = new Project
            {
                ProjectId = "1",
                Name = "Updated Project",
                Description = "Updated Description",
                Budget = 10000,
                Status = Status.DONE,
                StartDate = DateTime.Now.AddDays(-10),
                EndDate = DateTime.Now.AddDays(20),
                CompanyId = company.CompanyID
            };

            // Act
            var result = controller.EditProject("1", updatedProject) as OkObjectResult;

            // Assert
            Assert.NotNull(result);
            var updatedProjectFromDb = result.Value as Project;
            Assert.Equal("Updated Project", updatedProjectFromDb.Name);
            Assert.Equal(10000, updatedProjectFromDb.Budget);
            Assert.Equal(Status.DONE, updatedProjectFromDb.Status);
        }
    }
    
    
    // Adiconar employee
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
                Password = "password",
                CompanyID = company.CompanyID
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
            var result = controller.EditEmployee("1", updatedEmployee) as OkObjectResult;

            // Assert
            Assert.NotNull(result);
            var updatedEmployeeFromDb = result.Value as Employee;
            Assert.Equal("Updated Employee", updatedEmployeeFromDb.Name);
            Assert.Equal(987654321, updatedEmployeeFromDb.NIF);
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
            var result = controller.RemoveEmployee("1") as OkObjectResult;

            // Assert
            Assert.NotNull(result);
            Assert.Equal("Employee removed successfully", result.Value);

            var removedEmployee = dbContext.Employees.FirstOrDefault(e => e.EmployeeID == "1");
            Assert.Null(removedEmployee);
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
            var result = controller.ListAllEmployees() as OkObjectResult;

            // Assert
            Assert.NotNull(result);
            var employees = result.Value as List<Employee>;
            Assert.Equal(2, employees.Count);
        }
    }

    [Fact]
    public void ViewProjectTest()
        {
            var options = new DbContextOptionsBuilder<ApplicationDbContext>()
                .UseInMemoryDatabase(databaseName: "View_project_database")
                .Options;

            using (var dbContext = new ApplicationDbContext(options))
            {
                var project = new Project
                {
                    ProjectId = "1",
                    Name = "View Project",
                    Description = "View Description",
                    Budget = 3000,
                    Status = Status.INPROGRESS,
                    StartDate = DateTime.Now,
                    EndDate = DateTime.Now.AddDays(60),
                    CompanyId = "1"
                };

                dbContext.Projects.Add(project);
                dbContext.SaveChanges();

                var controller = new CompanyController(dbContext);
                
                var result = controller.ViewProject("1") as OkObjectResult;
                Assert.NotNull(result);
                var projectFromDb = result.Value as Project;
                Assert.Equal("View Project", projectFromDb.Name);
                Assert.Equal("View Description", projectFromDb.Description);
            }
        }

        [Fact]
        public void RemoveProjectTest()
        {
            var options = new DbContextOptionsBuilder<ApplicationDbContext>()
                .UseInMemoryDatabase(databaseName: "Remove_project_database")
                .Options;

            using (var dbContext = new ApplicationDbContext(options))
            {
                var project = new Project
                {
                    ProjectId = "1",
                    Name = "Remove Project",
                    Description = "To be removed",
                    Budget = 4000,
                    Status = Status.INPROGRESS,
                    StartDate = DateTime.Now,
                    EndDate = DateTime.Now.AddDays(45),
                    CompanyId = "1"
                };

                dbContext.Projects.Add(project);
                dbContext.SaveChanges();

                var controller = new CompanyController(dbContext);
                var result = controller.RemoveProject("1") as OkObjectResult;
                Assert.NotNull(result);
                Assert.Equal("Project removed successfully", result.Value);
                var removedProject = dbContext.Projects.FirstOrDefault(p => p.ProjectId == "1");
                Assert.Null(removedProject);
            }
        }
    }