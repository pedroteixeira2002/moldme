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
        var company = _context.Companies.FirstOrDefault(c => c.companyID == companyID);

        if (company == null)
            return NotFound("Company not found");

        // Adiciona o projeto à empresa
        company.projects.Add(project);
        _context.SaveChanges();

        return Ok("Project added successfully");
    }
        
        // Método para editar um projeto existente
        [HttpPut("EditProject/{projectID}")]
        public IActionResult EditProject(string projectID, Project updatedProject) // Mudado para string se for VARCHAR no DB
        {
            var existingProject = _context.Projects.FirstOrDefault(p => p.projectID == projectID);

            if (existingProject == null)
            {
                return NotFound("Project not found");
            }

            existingProject.name = updatedProject.name;
            existingProject.description = updatedProject.description;
            existingProject.budget = updatedProject.budget;
            existingProject.status = updatedProject.status;
            existingProject.startDate = updatedProject.startDate;
            existingProject.endDate = updatedProject.endDate;

            _context.SaveChanges();

            return Ok(existingProject);
        }
        
        // Método para visualizar os detalhes de um projeto
        [HttpGet("ViewProject/{projectID}")]
        public IActionResult ViewProject(string projectID) // Mudado para string se for VARCHAR no DB
        {
            var existingProject = _context.Projects.FirstOrDefault(p => p.projectID == projectID);

            if (existingProject == null)
            {
                return NotFound("Project not found");
            }

            return Ok(existingProject);
        }

        // Método para remover um projeto existente
        [HttpDelete("RemoveProject/{projectID}")]
        public IActionResult RemoveProject(string projectID) // Mudado para string se for VARCHAR no DB
        {
            var existingProject = _context.Projects.FirstOrDefault(p => p.projectID == projectID);

            if (existingProject == null)
            {
                return NotFound("Project not found");
            }

            _context.Projects.Remove(existingProject);
            _context.SaveChanges();
            return Ok("Project removed successfully");
        }
    }


