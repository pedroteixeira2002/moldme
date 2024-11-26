using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.Auth;
using moldme.data;
using moldme.DTOs;
using moldme.Interface;
using moldme.Models;

namespace moldme.Controllers;

[ApiController]
[Route("api/[controller]")]
public class EmployeeController : ControllerBase, IEmployee

{
    private readonly ApplicationDbContext _context;
    private readonly TokenGenerator _tokenGenerator;
    private readonly IPasswordHasher<Employee> _employeePasswordHasher;

    public EmployeeController(ApplicationDbContext context, TokenGenerator tokenGenerator, IPasswordHasher<Employee> employeePasswordHasher)
    {
        _context = context;
        _tokenGenerator = tokenGenerator;
        _employeePasswordHasher = employeePasswordHasher;
    }

    ///<inheritdoc cref="IEmployee.EmployeeCreate(string, EmployeeDto)"/>
    
    [Authorize]
    [HttpPost("{companyId}/addEmployee")]
    public IActionResult EmployeeCreate(string companyId, [FromBody] EmployeeDto employeeDto)
    {
        var company = _context.Companies.FirstOrDefault(c => c.CompanyId == companyId);
        if (company == null)
            return NotFound("Company not found");

        var employee = new Employee
        {
            Name = employeeDto.Name,
            Profession = employeeDto.Profession,
            NIF = employeeDto.Nif,
            Email = employeeDto.Email,
            Contact = employeeDto.Contact,
            Password = _employeePasswordHasher.HashPassword(null, employeeDto.Password),
            CompanyId = company.CompanyId
        };

        _context.Employees.Add(employee);

        try
        {
            _context.SaveChanges();
        }
        catch (Exception ex)
        {
            return StatusCode(500, "An error occurred while saving the employee: " + ex.Message);
        }
        var token = _tokenGenerator.GenerateToken(employee.Email, "Employee");

        return Ok(new { Token = token, Message = "Employee created successfully" });
    }

    ///<inheritdoc cref="IEmployee.EmployeeUpdate(string, string, EmployeeDto)"/>
    [HttpPut("{companyId}/editEmployee/{employeeId}")]
    public IActionResult EmployeeUpdate(string companyId, string employeeId,
        [FromBody] EmployeeDto updatedEmployeeDto)
    {
        var existingCompany = _context.Companies.FirstOrDefault(c => c.CompanyId == companyId);

        if (existingCompany == null)
            return NotFound("Company not found");

        var existingEmployee =
            _context.Employees.FirstOrDefault(e => e.EmployeeId == employeeId && e.CompanyId == companyId);

        if (existingEmployee == null)
            return NotFound("Employee not found or does not belong to the specified company.");

        // Update the employee properties
        existingEmployee.Name = updatedEmployeeDto.Name;
        existingEmployee.Profession = updatedEmployeeDto.Profession;
        existingEmployee.NIF = updatedEmployeeDto.Nif;
        existingEmployee.Email = updatedEmployeeDto.Email;
        existingEmployee.Contact = updatedEmployeeDto.Contact;
        existingEmployee.Password = _employeePasswordHasher.HashPassword(null, updatedEmployeeDto.Password);


        _context.SaveChanges();

        // Return a success message instead of the employee object
        return Ok("Employee updated successfully");
    }

    ///<inheritdoc cref="IEmployee.EmployeeRemove(string, string)"/>
    [HttpDelete("{companyId}/removeEmployee/{employeeId}")]
    public IActionResult EmployeeRemove(string companyId, string employeeId)
    {
        var existingEmployee = _context.Employees
            .Include(e => e.Reviews)
            .FirstOrDefault(e => e.EmployeeId == employeeId && e.CompanyId == companyId);

        if (existingEmployee == null)
        {
            return NotFound("Employee not found or does not belong to the specified company.");
        }

        foreach (var review in existingEmployee.Reviews)
        {
            review.ReviewerId = null;
        }

        _context.Employees.Remove(existingEmployee);
        _context.SaveChanges();

        return Ok("Employee removed successfully");
    }

    /// <inheritdoc cref="IEmployee.EmployeeGetAllFromCompany"/>
    [Authorize]
    [HttpGet("{companyId}/listAllEmployees")]
    public IActionResult EmployeeGetAllFromCompany(string companyId)
    {
        var employees = _context.Employees.Where(e => e.CompanyId == companyId).ToList();
        if (!employees.Any())
        {
            return NotFound("No employees found for this company.");
        }

        return Ok(employees);
    }

    /// <inheritdoc cref="IEmployee.EmployeeGetById"/>
    [Authorize]
    [HttpGet("getEmployeeById/{employeeId}")]
    public IActionResult EmployeeGetById(string employeeId)
    {
        var employee = _context.Employees.Find(employeeId); // Adjust to your DbSet
        if (employee == null)
        {
            return NotFound("Employee not found");
        }

        return Ok(employee);
    }

    /// <inheritdoc cref="IEmployee.EmployeeGetProjects"/>
    [Authorize]
    [HttpGet("employees/{employeeId}/projects")]
    public async Task<IActionResult> EmployeeGetProjects(string employeeId)
    {
        var projects = await _context.Projects
            .Where(p => p.Employees.Any(e => e.EmployeeId == employeeId))
            .ToListAsync();

        if (!projects.Any())
        {
            return NotFound("No projects found for this employee.");
        }

        return Ok(projects);
    }
    
    /// <inheritdoc cref="IEmployee.EmployeeGetAll"/>
    [Authorize]
    [HttpGet("listAllEmployees")]
    public async Task<IActionResult> EmployeeGetAll()
    {
        var employees = await _context.Employees.ToListAsync();
        if (!employees.Any())
        {
            return NotFound("No employees found");
        }

        return Ok(employees);
    }
    
}