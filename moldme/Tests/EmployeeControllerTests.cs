using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Moq;
using Xunit;
using DefaultNamespace;
using moldme.data;
using moldme.Models;
using Task = moldme.Models.Task;

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

        var employee = new Employee
        {
            EmployeeID = "1",
            Name = "John Doe",
            Profession = "Software Developer",
            CompanyID = company.CompanyID, 
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
                    EndDate = DateTime.Now.AddDays(30),
                    CompanyId = company.CompanyID
                },
                new Project
                {
                    ProjectId = "2",
                    Name = "Project 2",
                    Description = "Description 2",
                    Budget = 2000,
                    Status = Status.DONE,
                    StartDate = DateTime.Now.AddMonths(-2),
                    EndDate = DateTime.Now.AddMonths(-1),
                    CompanyId = company.CompanyID
                }
            }
        };

        dbContext.Companies.Add(company);
        dbContext.Employees.Add(employee);
        dbContext.SaveChanges();
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
    

}