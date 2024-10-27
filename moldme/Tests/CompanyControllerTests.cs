using DefaultNamespace;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.data;
using Xunit;
using System;
using System.Linq;

public class CompanyControllerTests
{
    private readonly CompanyController _controller;
    private readonly ApplicationDbContext _context;

    public CompanyControllerTests()
    {
        // Configurando o InMemoryDatabase
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: "TestDatabase")
            .Options;

        _context = new ApplicationDbContext(options);
        _controller = new CompanyController(_context);
        
        // Criando uma empresa inicial para teste
        var initialCompany = new Company
        {
            companyID = "1",  // Ajustado para string, alinhando com VARCHAR(6)
            name = "Test Company",
            taxid = 123456789,
            address = "123 Test Street",
            contact = 987654321,
            email = "test@company.com",
            sector = "IT",
            password = "password"
        };

        _context.Companies.Add(initialCompany);
        _context.SaveChanges();
    }

    [Fact]
    public void CreateProject_ShouldAddProjectToCompany()
    {
        var project = new Project
        {
            projectID = "PR001",  // Ajustado para string
            name = "Test Project",
            description = "A test project",
            budget = 1000,
            status = "Open",
            startDate = DateTime.Now,
            endDate = DateTime.Now.AddMonths(1),
            companyID = "1"  // Certifique-se de que o ID da empresa seja igual ao da empresa inicial
        };
        
        var result = _controller.AddProject("1", project) as OkObjectResult;

        Assert.NotNull(result);
        Assert.Equal(200, result.StatusCode);

        // Incluindo projetos para verificar se foi adicionado corretamente
        var company = _context.Companies.Include(c => c.projects).FirstOrDefault(c => c.companyID == "1");
        Assert.NotNull(company);
        Assert.Single(company.projects);
        Assert.Equal("Test Project", company.projects[0].name);
    }

    [Fact]
    public void EditProject_ShouldUpdateProjectDetails()
    {
        var initialProject = new Project
        {
            projectID = "PR002",  // Ajustado para string
            name = "Old Project Name",
            description = "Old Description",
            budget = 500,
            status = "Open",
            startDate = DateTime.Now,
            endDate = DateTime.Now.AddMonths(1),
            companyID = "1"
        };

        _context.Projects.Add(initialProject);
        _context.SaveChanges();

        // Criando um projeto atualizado com o mesmo ID
        var updatedProject = new Project
        {
            projectID = initialProject.projectID, // Garantir que é o mesmo ID
            name = "Updated Project Name",
            description = "Updated Description",
            budget = 2000,
            status = "Open",
            startDate = DateTime.Now,
            endDate = DateTime.Now.AddMonths(2)
        };
        
        var result = _controller.EditProject(initialProject.projectID, updatedProject) as OkObjectResult;

        Assert.NotNull(result);
        Assert.Equal(200, result.StatusCode);

        var project = _context.Projects.FirstOrDefault(p => p.projectID == initialProject.projectID);
        Assert.NotNull(project);
        Assert.Equal("Updated Project Name", project.name);
        Assert.Equal("Updated Description", project.description);
        Assert.Equal(2000, project.budget);
        Assert.Equal("Open", project.status);
    }

    [Fact]
    public void ViewProject_ShouldReturnProjectDetails()
    {
        var project = new Project
        {
            projectID = "PR003",  // Ajustado para string
            name = "Viewable Project",
            description = "A project to view",
            budget = 1500,
            status = "Open",
            startDate = DateTime.Now,
            endDate = DateTime.Now.AddMonths(1),
            companyID = "1"
        };

        _context.Projects.Add(project);
        _context.SaveChanges();
        
        var result = _controller.ViewProject(project.projectID) as OkObjectResult;
        
        Assert.NotNull(result);
        Assert.Equal(200, result.StatusCode);
        
        var returnedProject = result.Value as Project;
        Assert.NotNull(returnedProject);
        Assert.Equal("Viewable Project", returnedProject.name);
        Assert.Equal("A project to view", returnedProject.description);
        Assert.Equal(1500, returnedProject.budget);
        Assert.Equal("Open", returnedProject.status);
    }
}
