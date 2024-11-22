﻿using System.ComponentModel.DataAnnotations;
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
            var existingCompany = _context.Companies.FirstOrDefault(c => c.CompanyID == companyId);
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
            var existingCompany = _context.Companies.FirstOrDefault(c => c.CompanyID == companyId);
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
            // Verificar se a empresa existe
            var existingCompany = _context.Companies.FirstOrDefault(c => c.CompanyID == companyId);
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

            var newPayment = new Payment
            {
                PaymentID = Guid.NewGuid().ToString().Substring(0, 6),
                CompanyId = companyId,
                Date = DateTime.Now,
                Value = value,
                Plan = subscriptionPlan
            };

            // Adicionar o pagamento e salvar
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
            var existingCompany = _context.Companies.FirstOrDefault(c => c.CompanyID == companyId);
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
        [HttpPost("register")]
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
            SubscribePlan(company.CompanyID, company.Plan);
            
            return Ok(new { Token = token, Message = "Company registered successfully" });
        }
        
    }


