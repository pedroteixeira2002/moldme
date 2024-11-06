using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.data;
using moldme.DTOs;
using moldme.Models;

namespace moldme.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EmployeeController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public EmployeeController(ApplicationDbContext context)
        {
            _context = context;
        }
        
        // List all employees
        [HttpGet("ListAllEmployees")]
        public IActionResult ListAllEmployees()
        {
            var employees = _context.Employees.ToList(); // List all employees
            return Ok(employees);
        }

        // Get employee by ID
        [HttpGet("GetEmployeeById/{employeeId}")]
        public IActionResult GetEmployeeById(string employeeId)
        {
            var employee = _context.Employees.Find(employeeId); // Adjust to your DbSet
            if (employee == null)
            {
                return NotFound("Employee not found");
            }

            return Ok(employee);
        }
        
        // Get employee projects
        [HttpGet("{employeeId}/projects")]
        public async Task<IActionResult> GetEmployeeProjects(string employeeId)
        {
            var projects = await _context.Projects
                .Where(p => p.Employees.Any(e => e.EmployeeID == employeeId))
                .ToListAsync();

            if (!projects.Any())
            {
                return NotFound("No projects found for this employee.");
            }

            return Ok(projects);
        }
    }
}

