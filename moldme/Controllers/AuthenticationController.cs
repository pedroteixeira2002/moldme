using moldme.DTOs;
using moldme.Models;
using Microsoft.AspNetCore.Mvc;
using moldme.Auth;
using moldme.data;
using Microsoft.AspNetCore.Identity;
using moldme.Interface;

namespace moldme.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthenticationController : ControllerBase,IAuthentication
{
    private readonly ApplicationDbContext _context;
    private readonly TokenGenerator _tokenGenerator;
    private readonly IPasswordHasher<Company> _companyPasswordHasher;
    private readonly IPasswordHasher<Employee> _employeePasswordHasher;

    public AuthenticationController(ApplicationDbContext context, TokenGenerator tokenGenerator, IPasswordHasher<Company> companyPasswordHasher, IPasswordHasher<Employee> employeePasswordHasher)
    {
        _context = context;
        _tokenGenerator = tokenGenerator; 
        _companyPasswordHasher = companyPasswordHasher; 
        _employeePasswordHasher = employeePasswordHasher;
    }
    
    ///<inheritdoc cref="IAuthentication.Login(LoginDto)"/>
    [HttpPost("login")]
    public IActionResult Login([FromBody] LoginDto request)
    {
        var user = _context.Companies.FirstOrDefault(c => c.Email == request.Email) ??
                   _context.Employees.FirstOrDefault(e => e.Email == request.Email) as dynamic;

        if (user == null) return Unauthorized("Invalid credentials.");
    
        var isPasswordValid = user is Company 
            ? _companyPasswordHasher.VerifyHashedPassword((Company)user, user.Password, request.Password)
            : _employeePasswordHasher.VerifyHashedPassword((Employee)user, user.Password, request.Password);

        if (isPasswordValid == PasswordVerificationResult.Failed) return Unauthorized("Invalid credentials.");

        var role = user is Company ? "Company" : "Employee";
        var token = _tokenGenerator.GenerateToken(request.Email, role);
        return Ok(new { access_token = token });
    }
}
