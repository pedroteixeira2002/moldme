using System.Linq;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.Controllers;
using moldme.data;

namespace DefaultNamespace;

[ApiController]
[Route("api/[controller]")]
public class CompanyController : ControllerBase
{
    // Access to the database context
    private readonly ApplicationDbContext dbContext; 
    public CompanyController(ApplicationDbContext companyContext)
    {
        dbContext = companyContext;
    }

    [HttpPost("addProject")]
    public IActionResult AddProject(string companyID, [FromBody] Project project)
    {
        // Search for the companyID in the database
        var company = dbContext.Companies.FirstOrDefault(c => c.CompanyID == companyID);
        
        
        if (company == null)
            return NotFound("Company not found");
        
        // Associa o projeto à empresa através da chave estrangeira
        project.CompanyId = company.CompanyID;
        
        // Query the database
        dbContext.Projects.Add(project);
        // Save changes to the database
        dbContext.SaveChanges();

        return Ok("Project added successfully");
    }
    
    [HttpPut("EditProject/{projectID}")]
    public IActionResult EditProject(string ProjectId, [FromBody] Project updatedProject) 
    {
        var existingProject = dbContext.Projects.FirstOrDefault(p => p.ProjectId == ProjectId);

        if (existingProject == null) 
            return NotFound("Project not found");

        // Verifica se o projeto pertence à empresa correta (caso seja necessário)
        if (existingProject.CompanyId != updatedProject.CompanyId)
            return BadRequest("Project does not belong to the specified company.");

        // Atualiza os campos do projeto
        existingProject.Name = updatedProject.Name;
        existingProject.Description = updatedProject.Description;
        existingProject.Budget = updatedProject.Budget;
        existingProject.Status = updatedProject.Status;
        existingProject.StartDate = updatedProject.StartDate;
        existingProject.EndDate = updatedProject.EndDate;

        dbContext.SaveChanges();

        return Ok(existingProject);
    }
        
    [HttpGet("ViewProject/{projectID}")]
    public IActionResult ViewProject(string ProjectId)
        {
            var existingProject = dbContext.Projects.FirstOrDefault(p => p.ProjectId == ProjectId);

            if (existingProject == null)
            {
                return NotFound("Project not found");
            }

            return Ok(existingProject);
        }
        
    [HttpDelete("RemoveProject/{projectID}")]
    public IActionResult RemoveProject(string ProjectId) // Mudado para string se for VARCHAR no DB
        {
            var existingProject = dbContext.Projects.FirstOrDefault(p => p.ProjectId == ProjectId);

            if (existingProject == null)
            {
                return NotFound("Project not found");
            }

            dbContext.Projects.Remove(existingProject);
            dbContext.SaveChanges();
            return Ok("Project removed successfully");
        }
}


