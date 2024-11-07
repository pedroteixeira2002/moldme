using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.Auth;
using moldme.data;
using moldme.DTOs;
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
        
        [Authorize]
        [HttpPost("addProject/{companyId}")]
        public IActionResult AddProject(string companyId, [FromBody] ProjectDto projectDto)
        {
            // Verifica se a empresa existe
            var company = dbContext.Companies.FirstOrDefault(c => c.CompanyID == companyId);

            if (company == null)
                return NotFound("Company not found");

            // Cria um novo objeto Project a partir do DTO
            var project = new Project
            {
                ProjectId = Guid.NewGuid().ToString().Substring(0, 6), // Gera um novo ID para o projeto (ou outra lógica que você queira usar)
                Name = projectDto.Name,
                Description = projectDto.Description,
                Status = projectDto.Status,
                Budget = projectDto.Budget,
                StartDate = projectDto.StartDate,
                EndDate = projectDto.EndDate,
                CompanyId = company.CompanyID,
                Employees = new List<Employee>()
            };

            // Verifica se os IDs dos empregados são válidos e associa os empregados ao projeto
            foreach (var employeeId in projectDto.EmployeeIds)
            {
                var employee = dbContext.Employees.FirstOrDefault(e => e.EmployeeID == employeeId);
                if (employee != null)
                {
                    project.Employees.Add(employee);
                }
                else
                {
                    // Se algum empregado não for encontrado, você pode decidir como tratar isso
                    return NotFound($"Employee with ID {employeeId} not found");
                }
            }

            // Adiciona o projeto ao contexto e salva as alterações
            dbContext.Projects.Add(project);
            dbContext.SaveChanges();

            return Ok("Project added successfully");
        }
        
        [Authorize]
        [HttpPut("EditProject/{projectId}")]
        public IActionResult EditProject(string projectId, [FromBody] ProjectDto updatedProjectDto)
        {
            // Obtém o projeto existente pelo ID
            var existingProject = dbContext.Projects.FirstOrDefault(p => p.ProjectId == projectId);

            // Verifica se o projeto existe
            if (existingProject == null)
                return NotFound("Project not found");

            // Atualiza os campos do projeto com os dados do DTO
            existingProject.Name = updatedProjectDto.Name;
            existingProject.Description = updatedProjectDto.Description;
            existingProject.Budget = updatedProjectDto.Budget;
            existingProject.Status = updatedProjectDto.Status;
            existingProject.StartDate = updatedProjectDto.StartDate;
            existingProject.EndDate = updatedProjectDto.EndDate;

            // Salva as alterações no banco de dados
            dbContext.SaveChanges();

            // Retorna o projeto atualizado
            return Ok(existingProject);
        }

        [Authorize]
        [HttpGet("ViewProject/{projectId}")]
        public IActionResult ViewProject(string projectId)
        {
            var existingProject = dbContext.Projects.FirstOrDefault(p => p.ProjectId == projectId);

            if (existingProject == null)
            {
                return NotFound("Project not found");
            }

            return Ok(existingProject);
        }

        [Authorize]
        [HttpDelete("RemoveProject/{projectId}")]
        public IActionResult RemoveProject(string projectId)
        {
            // Buscar o projeto, sem necessidade de incluir funcionários se não for usado
            var existingProject = dbContext.Projects
                .FirstOrDefault(p => p.ProjectId == projectId);

            if (existingProject == null)
            {
                return NotFound("Project not found");
            }

            // Remover o projeto. A exclusão em cascata deve cuidar das referências na tabela EmployeeProject
            dbContext.Projects.Remove(existingProject);
            dbContext.SaveChanges();

            return Ok("Project removed successfully");
        }
        
        [Authorize]
        [HttpPost("AddEmployee/{companyID}")]
        public IActionResult AddEmployee(string companyID, [FromBody] EmployeeDto employeeDto)
        {
            // Verifica se a empresa existe com o CompanyID fornecido
            var company = dbContext.Companies.FirstOrDefault(c => c.CompanyID == companyID);
            if (company == null)
                return NotFound("Company not found");

            // Verifica se o projeto existe com o ProjectId fornecido
            var project = dbContext.Projects.FirstOrDefault(p => p.ProjectId == employeeDto.ProjectId);
            if (project == null)
                return NotFound("Project not found");

            // Cria uma nova instância de Employee e define os valores necessários
            var employee = new Employee
            {
                EmployeeID = Guid.NewGuid().ToString().Substring(0, 6), // Gera um novo ID para o empregado
                Name = employeeDto.Name,
                Profession = employeeDto.Profession,
                NIF = employeeDto.Nif,
                Email = employeeDto.Email,
                Contact = employeeDto.Contact,
                Password = passwordHasher.HashPassword(null, employeeDto.Password),
                CompanyId = company.CompanyID
            };

            dbContext.Employees.Add(employee);
            project.Employees.Add(employee);

            try
            {
                dbContext.SaveChanges();
            }
            catch (Exception ex)
            {
                return StatusCode(500, "An error occurred while saving the employee: " + ex.Message);
            }

            return Ok("Employee created successfully");
        }

        [HttpPut("EditEmployee/{employeeID}")]
        public IActionResult EditEmployee(string companyID, string employeeId, [FromBody] EmployeeDto updatedEmployeeDto)
        {
            var existingEmployee =
                dbContext.Employees.FirstOrDefault(e => e.EmployeeID == employeeId && e.CompanyId == companyID);

            if (existingEmployee == null)
                return NotFound("Employee not found or does not belong to the specified company.");

            // Update the employee properties
            existingEmployee.Name = updatedEmployeeDto.Name;
            existingEmployee.Profession = updatedEmployeeDto.Profession;
            existingEmployee.NIF = updatedEmployeeDto.Nif;
            existingEmployee.Email = updatedEmployeeDto.Email;
            existingEmployee.Contact = updatedEmployeeDto.Contact;
            existingEmployee.Password = passwordHasher.HashPassword(null, updatedEmployeeDto.Password);

            dbContext.SaveChanges();

            // Return a success message instead of the employee object
            return Ok("Employee updated successfully");
        }
        
        [Authorize]
        [HttpDelete("RemoveEmployee/{employeeID}")]
        public IActionResult RemoveEmployee(string companyID, string employeeId)
        {
            var existingEmployee = dbContext.Employees.FirstOrDefault(e => e.EmployeeID == employeeId && e.CompanyId == companyID);

                if (existingEmployee == null)
                {
                    return NotFound("Employee not found or does not belong to the specified company.");
                }

                dbContext.Employees.Remove(existingEmployee);
                dbContext.SaveChanges();

            return Ok("Employee removed successfully");
        }
        
        [Authorize]
        [HttpGet("ListAllEmployees/{companyID}")]
        public IActionResult ListAllEmployees(string companyID)
        {
            var employees = dbContext.Employees.Where(e => e.CompanyId == companyID).ToList();
            if (!employees.Any())
            {
                return NotFound("No employees found for this company.");
            }
            return Ok(employees);
        }
        
        [Authorize]
        [HttpGet("ListPaymentHistory/{companyID}")]
        public IActionResult ListPaymentHistory(string companyID)
        {
            var existingCompany = dbContext.Companies.FirstOrDefault(c => c.CompanyID == companyID);
            if (existingCompany == null)
            {
                return NotFound("Company not found");
            }

            var payments = dbContext.Payments.Where(c => c.CompanyId == companyID).ToList();
            if (!payments.Any())
            {
                return NotFound("No payment history found for this company.");
            }

            return Ok(payments);
        }
        
        [Authorize]
        [HttpPut("UpgradePlan/{companyID}")]
        public IActionResult UpgradePlan(string companyID, SubscriptionPlan subscriptionPlan)
        {
            // Verificar se a empresa existe
            var existingCompany = dbContext.Companies.FirstOrDefault(c => c.CompanyID == companyID);
            if (existingCompany == null)
            {
                return NotFound("Company not found");
            }

            // Verificar se o plano já está ativo
            var atualPlan = existingCompany.Plan;
            if (subscriptionPlan == atualPlan)
            {
                return BadRequest("Subscription plan already upgraded");
            }

            // Atualizar o plano da empresa
            existingCompany.Plan = subscriptionPlan;
            dbContext.SaveChanges();

            // Registrar o pagamento do novo plano
            return SubscribePlan(companyID, subscriptionPlan);
        }
        
        [Authorize]
        [HttpPost("SubscribePlan/{companyID}")]
        public IActionResult SubscribePlan(string companyID, SubscriptionPlan subscriptionPlan)
        {
            // Verificar se a empresa existe
            var existingCompany = dbContext.Companies.FirstOrDefault(c => c.CompanyID == companyID);
            if (existingCompany == null)
            {
                return NotFound("Company not found");
            }

            // Obter o valor do plano automaticamente
            float value = SubscriptionPlanHelper.GetPlanPrice(subscriptionPlan);
            if (value == 0 && subscriptionPlan != SubscriptionPlan.None)
            {
                return BadRequest("Invalid subscription plan.");
            }

            // Criar um novo pagamento
            var newPayment = new Payment
            {
                PaymentID = Guid.NewGuid().ToString().Substring(0, 6),
                CompanyId = companyID,
                Date = DateTime.Now,
                Value = value,
                Plan = subscriptionPlan
            };

            // Adicionar o pagamento e salvar
            dbContext.Payments.Add(newPayment);
            dbContext.SaveChanges();

            return Ok($"Payment of {value} registered successfully for plan {subscriptionPlan}");
        }
        
        [Authorize]
        [HttpPut("CancelSubscription/{companyID}")]
        public IActionResult CancelSubscription(string companyID)
        {
            // Verificar se a empresa existe
            var existingCompany = dbContext.Companies.FirstOrDefault(c => c.CompanyID == companyID);
            if (existingCompany == null)
            {
                return NotFound("Company not found");
            }

            // Verificar se a empresa já está no plano None
            if (existingCompany.Plan == SubscriptionPlan.None)
            {
                return BadRequest("The subscription is already canceled.");
            }

            // Alterar o plano da empresa para None
            existingCompany.Plan = SubscriptionPlan.None;
            dbContext.SaveChanges();

            return Ok("Subscription successfully canceled.");
        }
        
        [Authorize]
        [HttpGet("ListAllProjects/{companyID}")]
        public async Task<IActionResult> ListAllProjectsFromCompany(string companyID)
        {
            // Verifica se a companhia existe
            var companyExists = await dbContext.Companies.AnyAsync(c => c.CompanyID == companyID);
            if (!companyExists)
            {
                return NotFound("Company not found");
            }

            //projetos associados à companhia
            var projects = await dbContext.Projects.Where(p => p.CompanyId == companyID).ToListAsync();

            // Verifica se há projetos
            if (!projects.Any())
            {
                return Ok("No projects found for this company");
            }

            //lista de projetos encontrados
            return Ok(projects);
        }
        
        [Authorize]
        [HttpGet("GetProjectById/{companyID}/{projectID}")]
        public async Task<IActionResult> GetProjectById(string companyID, string projectID)
        {
            var companyExists = await dbContext.Companies.AnyAsync(c => c.CompanyID == companyID);
            if (!companyExists)
            {
                return NotFound("Company not found");
            }
            var project = await dbContext.Projects.FirstOrDefaultAsync(p => p.ProjectId == projectID && p.CompanyId == companyID);
            
            if (project == null)
            {
                return NotFound("Project not found or does not belong to the specified company.");
            }
            return Ok(project);
        }
        
        
        [HttpPost("register")]
        public IActionResult CreateCompany([FromBody] CompanyDto companyDto)
        {
            // Verificar se os dados são válidos
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            // Validar formato do email
            if (!new EmailAddressAttribute().IsValid(companyDto.Email))
            {
                return BadRequest("Invalid email format.");
            }

            // Verificar se o email já está cadastrado
            if (dbContext.Companies.Any(c => c.Email == companyDto.Email))
            {
                return BadRequest("A company with this email already exists.");
            }

            // Validar plano de assinatura
            if (!Enum.IsDefined(typeof(SubscriptionPlan), companyDto.Plan))
            {
                return BadRequest("Invalid subscription plan.");
            }

            // Mapeia os dados da DTO para o modelo Company
            var company = new Company
            {
                CompanyID = Guid.NewGuid().ToString().Substring(0, 6), // Gerar um ID único de 6 caracteres
                Name = companyDto.Name,
                TaxId = companyDto.TaxId,
                Address = companyDto.Address,
                Contact = companyDto.Contact,
                Email = companyDto.Email,
                Sector = companyDto.Sector,
                Plan = companyDto.Plan,
                Password = companyPasswordHasher.HashPassword(null, companyDto.Password) // Hash da senha
            };

            // Salva a nova empresa no banco de dados
            dbContext.Companies.Add(company);
            dbContext.SaveChanges();

            // Gerar o Token JWT com função "Company"
            var token = tokenGenerator.GenerateToken(company.Email, "Company");
            SubscribePlan(company.CompanyID, company.Plan);
            
            // Retornar resposta de sucesso com token e mensagem
            return Ok(new { Token = token, Message = "Company registered successfully" });
        }
        
    }
}


