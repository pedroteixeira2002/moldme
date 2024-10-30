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
    private readonly ApplicationDbContext dbContext; 
    public CompanyController(ApplicationDbContext companyContext)
    {
        dbContext = companyContext;
    }

    [HttpPost("addProject")]
    public IActionResult AddProject(string companyID, [FromBody] Project project)
    {
        var company = dbContext.Companies.FirstOrDefault(c => c.CompanyID == companyID);
        
        
        if (company == null)
            return NotFound("Company not found");
        
        project.CompanyId = company.CompanyID;
        dbContext.Projects.Add(project);
        dbContext.SaveChanges();

        return Ok("Project added successfully");
    }
    
    [HttpPut("EditProject/{projectID}")]
    public IActionResult EditProject(string ProjectId, [FromBody] Project updatedProject) 
    {
        var existingProject = dbContext.Projects.FirstOrDefault(p => p.ProjectId == ProjectId);

        if (existingProject == null) 
            return NotFound("Project not found");
        
        if (existingProject.CompanyId != updatedProject.CompanyId)
            return BadRequest("Project does not belong to the specified company.");
        
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
    public IActionResult RemoveProject(string ProjectId)
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
    
    //criar um employee, editar , remover e listar todos os employees
    
    [HttpPost("AddEmployee/{companyID}")]
    public IActionResult AddEmployee(string companyID, [FromBody] Employee employee)
    {
        if (string.IsNullOrWhiteSpace(employee.EmployeeID))
            return BadRequest("EmployeeID is required and cannot be empty or whitespace");

        var company = dbContext.Companies.FirstOrDefault(c => c.CompanyID == companyID);

        if (company == null)
            return NotFound("Company not found");

        employee.CompanyID = company.CompanyID;

        dbContext.Employees.Add(employee);
        dbContext.SaveChanges();

        return Ok("Employee created successfully");
    }
    
    [HttpPut("EditEmployee/{companyID}/{employeeID}")]
    public IActionResult EditEmployee(string companyID, string employeeId, [FromBody] Employee updatedEmployee)
    {
        var existingEmployee = dbContext.Employees.FirstOrDefault(e => e.EmployeeID == employeeId && e.CompanyID == companyID);

        if (existingEmployee == null)
            return NotFound("Employee not found or does not belong to the specified company.");

        existingEmployee.Name = updatedEmployee.Name;
        existingEmployee.Profession = updatedEmployee.Profession;
        existingEmployee.NIF = updatedEmployee.NIF;
        existingEmployee.Email = updatedEmployee.Email;
        existingEmployee.Contact = updatedEmployee.Contact;
        existingEmployee.Password = updatedEmployee.Password;

        dbContext.SaveChanges();

        return Ok(existingEmployee);
    }
    
    [HttpDelete("RemoveEmployee/{companyID}/{employeeID}")]
    public IActionResult RemoveEmployee(string companyID, string employeeId)
    {
        var existingEmployee = dbContext.Employees.FirstOrDefault(e => e.EmployeeID == employeeId && e.CompanyID == companyID);

        if (existingEmployee == null)
        {
            return NotFound("Employee not found or does not belong to the specified company.");
        }

        dbContext.Employees.Remove(existingEmployee);
        dbContext.SaveChanges();

        return Ok("Employee removed successfully");
    }
        
    [HttpGet("ListAllEmployees/{companyID}")]
    public IActionResult ListAllEmployees(string companyID)
    {
        var employees = dbContext.Employees.Where(e => e.CompanyID == companyID).ToList();
        return Ok(employees);
    }
}


