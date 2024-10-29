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

            var existingAssociation = dbContext.StaffOnProjects
                .FirstOrDefault(s => s.EmployeeId == employeeId && s.ProjectId == projectId);

            if (existingAssociation != null)
                return Conflict("Employee is already assigned to this project.");

            var employee = dbContext.Employees.FirstOrDefault(e => e.EmployeeID == employeeId);
            if (employee == null)
                return NotFound("Employee not found.");

            var project = dbContext.Projects.FirstOrDefault(p => p.ProjectId == projectId);
            if (project == null)
                return NotFound("Project not found.");

            var staffOnProject = new StaffOnProject
            {
                Id = Guid.NewGuid().ToString(),
                EmployeeId = employeeId,
                ProjectId = projectId
            };

            dbContext.StaffOnProjects.Add(staffOnProject);
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

            var staffOnProject = dbContext.StaffOnProjects
                .FirstOrDefault(s => s.EmployeeId == employeeId && s.ProjectId == projectId);

            if (staffOnProject == null)
                return NotFound("No record found for this employee in this project.");

            dbContext.StaffOnProjects.Remove(staffOnProject);
            dbContext.SaveChanges();

            return Ok("Employee removed from project successfully.");
        }
    }
}
