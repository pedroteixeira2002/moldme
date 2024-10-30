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

        // Aceitar uma oferta de um projeto associado a uma empresa
        [HttpPut("acceptOffer/{offerId}")]
        public IActionResult AcceptOffer(string companyId, string projectId, string offerId)
        {
            // Search for the companyID in the database
            var company = dbContext.Companies.FirstOrDefault(c => c.CompanyID == companyId);

            if (company == null)
                return NotFound("Company not found");

            // Search for the projectID in the database
            var project = dbContext.Projects.FirstOrDefault(p => p.ProjectId == projectId);

            if (project == null)
                return NotFound("Project not found");

            // Search for the offerID in the database
            var offer = dbContext.Offers.FirstOrDefault(o => o.OfferId == offerId);

            if (offer == null)
                return NotFound("Offer not found");

            // Verifica se a oferta pertence à empresa correta
            if (offer.CompanyId != company.CompanyID)
                return BadRequest("Offer does not belong to the specified company.");

            // Verifica se a oferta pertence ao projeto correto
            if (offer.ProjectId != project.ProjectId)
                return BadRequest("Offer does not belong to the specified project.");

            offer.Status = Status.ACCEPTED; // Altera o status da oferta para aceite

            dbContext.SaveChanges();

            return Ok("Offer accepted successfully");
        }

        // Rejeitar uma oferta de um projeto associado a uma empresa
        [HttpPut("rejectOffer/{offerId}")]
        public IActionResult RejectOffer(string companyId, string projectId, string offerId)
        {
            // Search for the companyID in the database
            var company = dbContext.Companies.FirstOrDefault(c => c.CompanyID == companyId);

            if (company == null)
                return NotFound("Company not found");

            // Search for the projectID in the database
            var project = dbContext.Projects.FirstOrDefault(p => p.ProjectId == projectId);

            if (project == null)
                return NotFound("Project not found");

            // Search for the offerID in the database
            var offer = dbContext.Offers.FirstOrDefault(o => o.OfferId == offerId);

            if (offer == null)
                return NotFound("Offer not found");

            // Verifica se a oferta pertence à empresa correta
            if (offer.CompanyId != company.CompanyID)
                return BadRequest("Offer does not belong to the specified company.");

            // Verifica se a oferta pertence ao projeto correto
            if (offer.ProjectId != project.ProjectId)
                return BadRequest("Offer does not belong to the specified project.");

            offer.Status = Status.DENIED; // Altera o status da oferta para rejeitada

            dbContext.SaveChanges();

            return Ok("Offer rejected successfully");
        }
    }
}
