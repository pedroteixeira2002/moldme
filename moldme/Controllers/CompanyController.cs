using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using moldme.Auth;
using moldme.data;
using moldme.DTOs;
using moldme.Interface;
using moldme.Models;

namespace moldme.Controllers;

/// <summary>
/// Controller for Company
/// </summary>
    [ApiController]
    [Route("api/[controller]")]
    public class CompanyController : ControllerBase, ICompany
    {
        /// <summary>
        /// The database context
        /// </summary>
        private readonly ApplicationDbContext _context;
        /// <summary>
        /// The token generator
        /// </summary>
        private readonly TokenGenerator _tokenGenerator;
        /// <summary>
        /// The password hasher
        /// </summary>
        private readonly IPasswordHasher<Company> _companyPasswordHasher;
        
        /// <summary>
        /// Constructor for CompanyController
        /// </summary>
        /// <param name="context"></param>
        /// <param name="tokenGenerator"></param>
        /// <param name="companyPasswordHasher"></param>
        public CompanyController(ApplicationDbContext context, TokenGenerator tokenGenerator,
            IPasswordHasher<Company> companyPasswordHasher)
        {
            _context = context;
            _tokenGenerator = tokenGenerator;
            _companyPasswordHasher = companyPasswordHasher;
        }
        
        ///<inheritdoc cref="ICompany.CompanyCreate(CompanyDto)"/>
        [Authorize]
        [HttpGet("{companyId}/listPaymentHistory")]
        public IActionResult ListPaymentHistory(string companyId)
        {
            var existingCompany = _context.Companies.FirstOrDefault(c => c.CompanyId == companyId);
            if (existingCompany == null)
            {
                return NotFound("Company not found");
            }

            var payments = _context.Payments.Where(c => c.CompanyId == companyId).ToList();
            if (!payments.Any())
            {
                return NotFound("No payment history found for this company.");
            }

            return Ok(payments);
        }
        
        ///<inheritdoc cref="ICompany.UpgradePlan(string, SubscriptionPlan)"/>
        [Authorize]
        [HttpPut("{companyId}/upgradePlan")]
        public IActionResult UpgradePlan(string companyId, SubscriptionPlan subscriptionPlan)
        {
            var existingCompany = _context.Companies.FirstOrDefault(c => c.CompanyId == companyId);
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
            _context.SaveChanges();

            return SubscribePlan(companyId, subscriptionPlan);
        }
        
        ///<inheritdoc cref="ICompany.SubscribePlan(string, SubscriptionPlan)"/>
        [Authorize]
        [HttpPost("{companyId}/subscribePlan")]
        public IActionResult SubscribePlan(string companyId, SubscriptionPlan subscriptionPlan)
        {
            var existingCompany = _context.Companies.FirstOrDefault(c => c.CompanyId == companyId);
            if (existingCompany == null)
            {
                return NotFound("Company not found");
            }

            float value = SubscriptionPlanHelper.GetPlanPrice(subscriptionPlan);
            if (value == 0 && subscriptionPlan != SubscriptionPlan.None)
            {
                return BadRequest("Invalid subscription plan.");
            }

            var newPayment = new Payment
            {
                CompanyId = companyId,
                Date = DateTime.Now,
                Value = value,
                Plan = subscriptionPlan
            };

            _context.Payments.Add(newPayment);
            _context.SaveChanges();

            return Ok($"Payment of {value} registered successfully for plan {subscriptionPlan}");
        }
        
        ///<inheritdoc cref="ICompany.CancelSubscription(string)"/>
        [Authorize]
        [HttpPut("{companyId}/cancelSubscription")]
        public IActionResult CancelSubscription(string companyId)
        {
            // Verificar se a empresa existe
            var existingCompany = _context.Companies.FirstOrDefault(c => c.CompanyId == companyId);
            if (existingCompany == null)
            {
                return NotFound("Company not found");
            }

            if (existingCompany.Plan == SubscriptionPlan.None)
            {
                return BadRequest("The subscription is already canceled.");
            }

            existingCompany.Plan = SubscriptionPlan.None;
            _context.SaveChanges();

            return Ok("Subscription cancelled successfully");
        }
        
        ///<inheritdoc cref="ICompany.CompanyCreate(CompanyDto)"/>
        [HttpPost("/api/register")]
        public IActionResult CompanyCreate([FromBody] CompanyDto companyDto)
        {
            // Verificar se os dados são válidos
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (!new EmailAddressAttribute().IsValid(companyDto.Email))
            {
                return BadRequest("Invalid email format.");
            }

            if (_context.Companies.Any(c => c.Email == companyDto.Email))
            {
                return BadRequest("A company with this email already exists.");
            }

            if (!Enum.IsDefined(typeof(SubscriptionPlan), companyDto.Plan))
            {
                return BadRequest("Invalid subscription plan.");
            }

            var company = new Company
            {
                Name = companyDto.Name,
                TaxId = companyDto.TaxId,
                Address = companyDto.Address,
                Contact = companyDto.Contact,
                Email = companyDto.Email,
                Sector = companyDto.Sector,
                Plan = companyDto.Plan,
                Password = _companyPasswordHasher.HashPassword(null, companyDto.Password) 
            };

            _context.Companies.Add(company);
            _context.SaveChanges();

            var token = _tokenGenerator.GenerateToken(company.Email, "Company");
            SubscribePlan(company.CompanyId, company.Plan);
            
            return Ok(new { Token = token, Message = "Company registered successfully" });
        }
        
        [HttpGet("listAllCompanies")]
        public IActionResult ListAllCompanies()
        {
            var companies = _context.Companies.ToList();
            if (!companies.Any())
            {
                return NotFound("No companies found");
            }

            // Mapeie os dados para a DTO
            var response = companies.Select(c => new
            {
                c.CompanyId, // Inclui o ID aqui
                c.Name,
                c.TaxId,
                c.Address,
                c.Contact,
                c.Email,
                c.Sector,
                c.Plan
            });

            // Retorne as empresas como JSON
            return Ok(response);
        }
        [HttpGet("{companyId}/getCompanyById")]
        public IActionResult GetCompanyById(string companyId)
        {
            // Busca a empresa pelo ID no banco de dados
            var company = _context.Companies.FirstOrDefault(c => c.CompanyId == companyId);

            if (company == null)
            {
                return NotFound(new { Message = "Company not found" });
            }

            // Cria um objeto para retorno que inclui o ID
            var response = new
            {
                CompanyId = company.CompanyId,
                Name = company.Name,
                TaxId = company.TaxId,
                Address = company.Address,
                Contact = company.Contact, 
                Email = company.Email,
                Sector = company.Sector,
                Plan = company.Plan,
                
            };

            return Ok(response);
        }
        
        ///<inheritdoc cref="ICompany.CompanyGetById(string)"/>
        public IActionResult CompanyGetById(string companyId)
        {
            var existingCompany = _context.Companies.FirstOrDefault(c => c.CompanyId == companyId);
            if (existingCompany == null)
            {
                return NotFound("Company not found");
            }

            return Ok(existingCompany);
        }
        
        /// <summary>
        ///  Update company password by email
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        [HttpPut("/api/updatePasswordByEmail")]
        public IActionResult UpdatePasswordByEmail([FromBody] RecoverPasswordDto request)
        {
            var existingCompany = _context.Companies.FirstOrDefault(c => c.Email == request.Email);

            if (existingCompany == null)
            {
                return NotFound("Company not found");
            }

            existingCompany.Password = _companyPasswordHasher.HashPassword(null, request.NewPassword);
            _context.SaveChanges();

            return Ok("Password updated successfully");
        }
        
        /// <summary>
        /// Update company details by companyId
        /// </summary>
        /// <param name="companyId">The company ID</param>
        /// <param name="companyDto">The company data to update</param>
        /// <returns></returns>
        [Authorize]
        [HttpPut("{companyId}/updateCompany")]
        public IActionResult UpdateCompany(string companyId, [FromBody] CompanyDto companyDto)
        {
            // Verificar se os dados fornecidos são válidos
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            // Buscar a empresa no banco de dados pelo companyId
            var existingCompany = _context.Companies.FirstOrDefault(c => c.CompanyId == companyId);
            if (existingCompany == null)
            {
                return NotFound("Company not found");
            }

            // Verificar se o e-mail fornecido já existe para outra empresa
            if (_context.Companies.Any(c => c.Email == companyDto.Email && c.CompanyId != companyId))
            {
                return BadRequest("A company with this email already exists.");
            }

            // Atualizar os dados da empresa
            existingCompany.Name = companyDto.Name;
            existingCompany.TaxId = companyDto.TaxId;
            existingCompany.Address = companyDto.Address;
            existingCompany.Contact = companyDto.Contact;
            existingCompany.Email = companyDto.Email;
            existingCompany.Sector = companyDto.Sector;

            // Atualiza o plano se necessário
            if (Enum.IsDefined(typeof(SubscriptionPlan), companyDto.Plan))
            {
                existingCompany.Plan = companyDto.Plan;
            }

            // Atualiza a senha somente se uma nova senha for fornecida
            if (!string.IsNullOrEmpty(companyDto.Password))
            {
                existingCompany.Password = _companyPasswordHasher.HashPassword(null, companyDto.Password);
            }

            _context.SaveChanges();

            return Ok(new { Message = "Company updated successfully" });
        }
    }