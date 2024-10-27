using System.Linq;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.Controllers;
using moldme.data;

namespace DefaultNamespace;

[ApiController]
[Route("api/[controller]")]
public class CompanyController : Controller
{
    private readonly ApplicationDbContext _context;
    public CompanyController(ApplicationDbContext context)
    {
        _context = context;
    }

    [HttpPost("addProject")]
    public IActionResult AddProject(string companyID, [FromBody] Project project)
    {
        var company = _context.Companies.FirstOrDefault(c => c.CompanyID == companyID);

        if (company == null)
            return NotFound("Company not found");
        
        company.Projects.Add(project);
        _context.SaveChanges();

        return Ok("Project added successfully");
    }
    
        [HttpPut("EditProject/{projectID}")]
        public IActionResult EditProject(string ProjectId, Project updatedProject) 
        {
            var existingProject = _context.Projects.FirstOrDefault(p => p.ProjectId == ProjectId);

            if (existingProject == null)
            {
                return NotFound("Project not found");
            }

            existingProject.Name = updatedProject.Name;
            existingProject.Description = updatedProject.Description;
            existingProject.Budget = updatedProject.Budget;
            existingProject.Status = updatedProject.Status;
            existingProject.StartDate = updatedProject.StartDate;
            existingProject.EndDate = updatedProject.EndDate;

            _context.SaveChanges();

            return Ok(existingProject);
        }
        
        [HttpGet("ViewProject/{projectID}")]
        public IActionResult ViewProject(string ProjectId)
        {
            var existingProject = _context.Projects.FirstOrDefault(p => p.ProjectId == ProjectId);

            if (existingProject == null)
            {
                return NotFound("Project not found");
            }

            return Ok(existingProject);
        }
        
        [HttpDelete("RemoveProject/{projectID}")]
        public IActionResult RemoveProject(string ProjectId) // Mudado para string se for VARCHAR no DB
        {
            var existingProject = _context.Projects.FirstOrDefault(p => p.ProjectId == ProjectId);

            if (existingProject == null)
            {
                return NotFound("Project not found");
            }

            _context.Projects.Remove(existingProject);
            _context.SaveChanges();
            return Ok("Project removed successfully");
        }
    }


