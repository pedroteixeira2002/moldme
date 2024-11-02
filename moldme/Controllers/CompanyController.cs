using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using moldme.Auth;
using moldme.data;
using moldme.Models;

namespace moldme.Controllers
{

    [ApiController]
    [Route("api/[controller]")]
    public class CompanyController : ControllerBase
    {
        private readonly ApplicationDbContext dbContext;
        private readonly TokenGenerator tokenGenerator;
        private readonly IPasswordHasher<Company> passwordHasher;
        private readonly IPasswordHasher<Company> companyPasswordHasher;
        

        public CompanyController(ApplicationDbContext dbContext, TokenGenerator tokenGenerator,IPasswordHasher<Company> companyPasswordHasher, IPasswordHasher<Company> passwordHasher)
        {
            this.dbContext = dbContext;
            this.tokenGenerator = tokenGenerator;
            this.passwordHasher = passwordHasher;
            this.companyPasswordHasher = companyPasswordHasher;
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
            var existingEmployee =
                dbContext.Employees.FirstOrDefault(e => e.EmployeeID == employeeId && e.CompanyID == companyID);

            if (existingEmployee == null)
                return NotFound("Employee not found or does not belong to the specified company.");

            // Update the employee properties
            existingEmployee.Name = updatedEmployee.Name;
            existingEmployee.Profession = updatedEmployee.Profession;
            existingEmployee.NIF = updatedEmployee.NIF;
            existingEmployee.Email = updatedEmployee.Email;
            existingEmployee.Contact = updatedEmployee.Contact;
            existingEmployee.Password = updatedEmployee.Password; // Ensure this is hashed if needed

            dbContext.SaveChanges();

            // Return a success message instead of the employee object
            return Ok("Employee updated successfully");
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
            if (!employees.Any())
            {
                return NotFound("No employees found for this company.");
            }
            return Ok(employees);
        }

        [HttpGet("ListPaymentHistory/{companyID}")]
        public IActionResult ListPaymentHistory(string companyID)
        {
            var existingCompany = dbContext.Companies.FirstOrDefault(c => c.CompanyID == companyID);
            if (existingCompany == null)
            {
                return NotFound("Company not found");
            }

            var payments = dbContext.Payments.Where(c => c.companyId == companyID).ToList();
            if (!payments.Any())
            {
                return NotFound("No payment history found for this company.");
            }

            return Ok(payments);
        }

        [HttpPut("UpgradePlan/{companyID}")]
        public IActionResult UpgradePlan(string companyID, SubscriptionPlan subscriptionPlan)
        {
            var existingCompany = dbContext.Companies.FirstOrDefault(c => c.CompanyID == companyID);
            if (existingCompany == null)
            {
                return NotFound("Company not found");
            }

            var atualPlan = existingCompany.Plan;
            if (subscriptionPlan == atualPlan)
            {
                return BadRequest("Subscription plan already upgraded");
            }

            existingCompany.Plan = subscriptionPlan;
            dbContext.SaveChanges();

            return Ok($"Subscription plan updated to {subscriptionPlan}");

        }

        [HttpGet("ListAllProjects/{companyID}")]
        public IActionResult ListAllProjectsFromCompany(string companyID)
        {
            // Verifica se a companhia existe
            var companyExists = dbContext.Companies.Any(c => c.CompanyID == companyID);
            if (!companyExists)
            {
                return NotFound("Company not found");
            }

            //projetos associados à companhia
            var projects = dbContext.Projects.Where(p => p.CompanyId == companyID).ToList();

            // Verifica se há projetos
            if (projects.Count == 0)
            {
                return Ok("No projects found for this company");
            }

            //lista de projetos encontrados
            return Ok(projects);
        }
        
        [HttpGet("GetProjectById/{companyID}/{projectID}")]
        public IActionResult GetProjectById(string companyID, string projectID)
        {
            var companyExists = dbContext.Companies.Any(c => c.CompanyID == companyID);
            if (!companyExists)
            {
                return NotFound("Company not found");
            }
            var project = dbContext.Projects.FirstOrDefault(p => p.ProjectId == projectID && p.CompanyId == companyID);
            if (project == null)
            {
                return NotFound("Project not found or does not belong to the specified company.");
            }
            return Ok(project);
        }

        [HttpPost("register")]
        public IActionResult CreateCompany([FromBody] Company company)
        {   if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            
            // Validate email format
            if (!new EmailAddressAttribute().IsValid(company.Email))
            {
                
                return BadRequest("Invalid email format.");
            }

            // Check if the email already exists
            if (dbContext.Companies.Any(c => c.Email == company.Email))
            {
                return BadRequest("A company with this email already exists.");
            }

            // Validate Subscription Plan
            if (!Enum.IsDefined(typeof(SubscriptionPlan), company.Plan))
            {
                return BadRequest("Invalid subscription plan.");
            }

            company.Password = companyPasswordHasher.HashPassword(company, company.Password);

            dbContext.Companies.Add(company);
            dbContext.SaveChanges();

            // Generate JWT Token with role
            var token = tokenGenerator.GenerateToken(company.Email, "Company");
            

            return Ok(new { Token = token, Message = "Company registered successfully" });
            
        }
    }
}


