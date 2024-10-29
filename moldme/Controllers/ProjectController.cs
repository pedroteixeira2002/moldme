using System.Linq;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.data;
using moldme.Models;

namespace moldme.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProjectController : ControllerBase
    {
        private readonly ApplicationDbContext dbContext;

        public ProjectController(ApplicationDbContext context)
        {
            dbContext = context;
        }

        [HttpPost("assign-employee")]
        public IActionResult AssignEmployee(string employeeId, string projectId)
        {
            if (string.IsNullOrWhiteSpace(employeeId))
                return BadRequest("Employee ID cannot be null or empty.");
            if (string.IsNullOrWhiteSpace(projectId))
                return BadRequest("Project ID cannot be null or empty.");
            
            var employee = dbContext.Employees
                .Include(e => e.Projects)
                .FirstOrDefault(e => e.EmployeeID == employeeId);
            
            if (employee == null)
                return NotFound("Employee not found.");

            var project = dbContext.Projects
                .Include(p => p.Employees)
                .FirstOrDefault(p => p.ProjectId == projectId);
            
            if (project == null)
                return NotFound("Project not found.");
            
            if (employee.Projects.Contains(project))
                return Conflict("Employee is already assigned to this project.");
            
            employee.Projects.Add(project);
            dbContext.SaveChanges();

            return Ok("Employee assigned to project successfully.");
        }


        [HttpDelete("remove-employee")]
        public IActionResult RemoveEmployee(string employeeId, string projectId)
        {
            if (string.IsNullOrWhiteSpace(employeeId))
                return BadRequest("Employee ID cannot be null or empty.");
            
            if (string.IsNullOrWhiteSpace(projectId))
                return BadRequest("Project ID cannot be null or empty.");

            var employee = dbContext.Employees
                .Include(e => e.Projects)
                .FirstOrDefault(e => e.EmployeeID == employeeId);
            
            if (employee == null)
                return NotFound("Employee not found.");

            var project = dbContext.Projects
                .Include(p => p.Employees)
                .FirstOrDefault(p => p.ProjectId == projectId);
            
            if (project == null)
                return NotFound("Project not found.");

            if (!employee.Projects.Contains(project))
                return NotFound("No record found for this employee in this project.");

            employee.Projects.Remove(project);
            dbContext.SaveChanges();

            return Ok("Employee removed from project successfully.");
        }
    }
}
