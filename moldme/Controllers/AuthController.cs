using Microsoft.AspNetCore.Identity.Data;
using moldme.DTOs;
using moldme.Models;

namespace moldme.Controllers;

using Microsoft.AspNetCore.Mvc;
using moldme.Auth;
using moldme.data;
using Microsoft.AspNetCore.Identity;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly ApplicationDbContext dbContext;
    private readonly TokenGenerator tokenGenerator;
    private readonly IPasswordHasher<Company> companyPasswordHasher;
    private readonly IPasswordHasher<Employee> employeePasswordHasher;

    public AuthController(ApplicationDbContext dbContext, TokenGenerator tokenGenerator, IPasswordHasher<Company> companyPasswordHasher, IPasswordHasher<Employee> employeePasswordHasher)
    {
        this.dbContext = dbContext;
        this.tokenGenerator = tokenGenerator;
        this.companyPasswordHasher = companyPasswordHasher;
        this.employeePasswordHasher = employeePasswordHasher;
    }

    [HttpPost("login")]
    public IActionResult Login([FromBody] LoginDto request)
    {
        var user = dbContext.Companies.FirstOrDefault(c => c.Email == request.Email) ??
                   dbContext.Employees.FirstOrDefault(e => e.Email == request.Email) as dynamic;

        if (user == null) return Unauthorized("Invalid credentials.");
    
        var isPasswordValid = user is Company 
            ? companyPasswordHasher.VerifyHashedPassword((Company)user, user.Password, request.Password)
            : employeePasswordHasher.VerifyHashedPassword((Employee)user, user.Password, request.Password);

        if (isPasswordValid == PasswordVerificationResult.Failed) return Unauthorized("Invalid credentials.");

        var role = user is Company ? "Company" : "Employee";
        var token = tokenGenerator.GenerateToken(request.Email, role);
        return Ok(new { access_token = token });
    }
}
