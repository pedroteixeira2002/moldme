using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.data;
using moldme.DTOs;
using moldme.Interface;
using moldme.Models;

namespace moldme.Controllers;

/// <summary>
/// Project Controller
/// </summary>
[ApiController]
[Route("api/[controller]")]
public class ProjectController : ControllerBase, IProject
{
    /// <summary>
    /// Database context
    /// </summary>
    private readonly ApplicationDbContext _context;

    /// <summary>
    /// Constructor
    /// </summary>
    /// <param name="context"></param>
    public ProjectController(ApplicationDbContext context)
    {
        _context = context;
    }
    ///<inheritdoc cref="IProject.ProjectCreate(string,ProjectDto)"/>
    [Authorize]
    [HttpPost("addProject/{companyId}")]
    public IActionResult ProjectCreate(string companyId, [FromBody] ProjectDto projectDto)
    {
        var company = _context.Companies.FirstOrDefault(c => c.CompanyId == companyId);

        if (company == null)
            return NotFound("Company not found");

        var project = new Project
        {
            Name = projectDto.Name,
            Description = projectDto.Description,
            Status = Status.NEW,
            Budget = projectDto.Budget,
            StartDate = projectDto.StartDate,
            EndDate = projectDto.EndDate,
            CompanyId = company.CompanyId,
            Company = company
        };


        _context.Projects.Add(project);
        _context.SaveChanges();

        return Ok("Project added successfully");
    }

    ///<inheritdoc cref="IProject.ProjectUpdate(string,ProjectDto)"/>
    [Authorize]
    [HttpPut("editProject/{projectId}")]
    public IActionResult ProjectUpdate(string projectId, [FromBody] ProjectDto updatedProjectDto)
    {
        var existingProject = _context.Projects.FirstOrDefault(p => p.ProjectId == projectId);

        if (existingProject == null)
            return NotFound("Project not found");

        existingProject.Name = updatedProjectDto.Name;
        existingProject.Description = updatedProjectDto.Description;
        existingProject.Budget = updatedProjectDto.Budget;
        existingProject.Status = updatedProjectDto.Status;
        existingProject.StartDate = updatedProjectDto.StartDate;
        existingProject.EndDate = updatedProjectDto.EndDate;

        _context.SaveChanges();

        return Ok("Project updated successfully");
    }

    ///<inheritdoc cref="IProject.ProjectView(string)"/>
    [Authorize]
    [HttpGet("viewProject/{projectId}")]
    public IActionResult ProjectView(string projectId)
    {
        var existingProject = _context.Projects.FirstOrDefault(p => p.ProjectId == projectId);

        if (existingProject == null)
        {
            return NotFound("Project not found");
        }

        return Ok(existingProject);
    }

    ///<inheritdoc cref="IProject.ProjectRemove(string)"/>
    [Authorize]
    [HttpDelete("RemoveProject/{projectId}")]
    public IActionResult ProjectRemove(string projectId)
    {
        var existingProject = _context.Projects
            .Include(p => p.Employees) // Inclui associações com funcionários
            .FirstOrDefault(p => p.ProjectId == projectId);

        if (existingProject == null)
        {
            return NotFound("Project not found");
        }

        existingProject.Employees.Clear();
        _context.SaveChanges(); // Salvar antes de remover o projeto

        _context.Projects.Remove(existingProject);
        _context.SaveChanges();

        return Ok("Project removed successfully");
    }

    ///<inheritdoc cref="IProject.ProjectAssignEmployee(string,string)"/>
    [Authorize]
    [HttpPost("{projectId}/assignEmployee/{employeeId}")]
    public IActionResult ProjectAssignEmployee(string employeeId, string projectId)
    {
        if (string.IsNullOrWhiteSpace(employeeId))
            return BadRequest("Employee ID cannot be null or empty.");
        if (string.IsNullOrWhiteSpace(projectId))
            return BadRequest("Project ID cannot be null or empty.");

        var employee = _context.Employees
            .Include(e => e.Projects)
            .FirstOrDefault(e => e.EmployeeId == employeeId);

        if (employee == null)
            return NotFound("Employee not found.");

        var project = _context.Projects
            .Include(p => p.Employees)
            .FirstOrDefault(p => p.ProjectId == projectId);

        if (project == null)
            return NotFound("Project not found.");

        if (employee.Projects.Contains(project))
            return Conflict("Employee is already assigned to this project.");

        employee.Projects.Add(project);
        _context.SaveChanges();

        return Ok("Employee assigned to project successfully.");
    }

    ///<inheritdoc cref="IProject.ProjectRemoveEmployee(string,string)"/>
    [Authorize]
    [HttpDelete("{projectId}/removeEmployee/{employeeId}")]
    public IActionResult ProjectRemoveEmployee(string employeeId, string projectId)
    {
        if (string.IsNullOrWhiteSpace(employeeId))
            return BadRequest("Employee ID cannot be null or empty.");

        if (string.IsNullOrWhiteSpace(projectId))
            return BadRequest("Project ID cannot be null or empty.");

        var employee = _context.Employees
            .Include(e => e.Projects)
            .FirstOrDefault(e => e.EmployeeId == employeeId);

        if (employee == null)
            return NotFound("Employee not found.");

        var project = _context.Projects
            .Include(p => p.Employees)
            .FirstOrDefault(p => p.ProjectId == projectId);

        if (project == null)
            return NotFound("Project not found.");

        if (!employee.Projects.Contains(project))
            return NotFound("No record found for this employee in this project.");

        employee.Projects.Remove(project);
        _context.SaveChanges();

        return Ok("Employee removed from project successfully.");
    }
    
    ///<inheritdoc cref="IProject.ListAllProjectsFromCompany(string)"/>
    [Authorize]
    [HttpGet("{companyId}/listAllProjects")]
    public async Task<IActionResult> ListAllProjectsFromCompany(string companyId)
    {
        var companyExists = await _context.Companies.AnyAsync(c => c.CompanyId == companyId);
        if (!companyExists)
        {
            return NotFound("Company not found");
        }
            
        var projects = await _context.Projects.Where(p => p.CompanyId == companyId).ToListAsync();

        if (!projects.Any())
        {
            return Ok("No projects found for this company");
        }

        return Ok(projects);
    }
     
    ///<inheritdoc cref="IProject.GetProjectById(string,string)"/>
    [Authorize]
    [HttpGet("{companyId}/getProjectById/{projectId}")]
    public async Task<IActionResult> GetProjectById(string companyId, string projectId)
    {
        var companyExists = await _context.Companies.AnyAsync(c => c.CompanyId == companyId);
        if (!companyExists)
        {
            return NotFound("Company not found");
        }
        var project = await _context.Projects.FirstOrDefaultAsync(p => p.ProjectId == projectId && p.CompanyId == companyId);
            
        if (project == null)
        {
            return NotFound("Project not found or does not belong to the specified company.");
        }
        return Ok(project);
    }
    
    ///<inheritdoc cref="IProject.ProjectGetAllNew()"/>
    [Authorize]
    [HttpGet("listAllNewProjects")]
    public async Task<IActionResult> ProjectGetAllNew()
    {
        var projects = await _context.Projects.Where(p => p.Status == Status.NEW).ToListAsync();
        if (!projects.Any())
        {
            return NotFound("No projects found");
        }
        return Ok(projects);
    }
    [Authorize]
    [HttpGet("{projectId}/employees")]
    public IActionResult GetEmployeesByProject(string projectId)
    {
        if (string.IsNullOrWhiteSpace(projectId))
            return BadRequest("Project ID cannot be null or empty.");

        var project = _context.Projects
            .Include(p => p.Employees)
            .FirstOrDefault(p => p.ProjectId == projectId);

        if (project == null)
            return NotFound("Project not found.");

        var employees = project.Employees
            .Select(e => new
            {
                e.EmployeeId,
                e.Name,
                e.Profession,
                e.Email,
                e.Contact
            }).ToList();

        return Ok(employees);
    }

    
}