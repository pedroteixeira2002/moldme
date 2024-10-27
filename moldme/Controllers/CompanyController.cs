using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.Controllers;

namespace DefaultNamespace;

[ApiController]
[Route("api/[controller]")]
public class CompanyController : Controller
{
    //Conexão com a base de dados
    private readonly DbContextOptions _repository;
    
    public CompanyController(DbContextOptions repository)
    {
        _repository = repository;
    }
    
    // public async 
    
    
    
    [HttpPost]
    public IActionResult AddProject(int companyId, Project project)
    {
        var company = _repository.GetCompany(companyId);

        if (company == null)
            return NotFound("Company not found");

        _repository.AddProject(companyId, project);
        _repository.SaveChanges();

        return Ok("Project added successfully");
    }
    
    
    // apenas exemplo falta a db
    [HttpPut("EditProject/{projectId}")]
    public IActionResult EditProject(int projectId, Project updatedProject)
    {
        var existingProject = _repository.GetProjectById(projectId);

        if (existingProject == null)
        {
            return NotFound("Project not found");
        }

        _repository.EditProject(projectId, updatedProject);
        _repository.SaveChanges();

        return Ok(existingProject);
    }
    [HttpGet("ViewProject/{projectId}")]
    public IActionResult ViewProject(int projectId)
    {
        var project = _repository.GetProjectById(projectId);

        if (project == null)
        {
            return NotFound("Project not found");
        }

        return Ok(project);
    }

    [HttpDelete("RemoveProject/{projectId}")]
    public IActionResult RemoveProject(int projectId)
    {
        var success = _repository.RemoveProject(projectId);

        if (!success)
        {
            return NotFound("Project not found");
        }

        _repository.SaveChanges();
        return Ok("Project removed successfully");
    }
    
}


