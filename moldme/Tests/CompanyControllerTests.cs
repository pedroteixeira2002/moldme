using DefaultNamespace;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.data;
using Xunit;
using System;
using System.Linq;
using moldme.Models;

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
}
