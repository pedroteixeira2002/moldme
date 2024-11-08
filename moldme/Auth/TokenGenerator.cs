using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;

namespace moldme.Auth;

public class TokenGenerator
{
    private readonly IConfiguration _configuration;
    private readonly SymmetricSecurityKey _key;

    public TokenGenerator(IConfiguration configuration)
    {
        _configuration = configuration;
        var keyString = _configuration["Jwt:Key"]; // Ensure this key is at least 32 characters long.
        _key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(keyString));
    }

    public string GenerateToken(string email, string role)
    {
        // Your token generation logic...
        var claims = new[]
        {
            new Claim(ClaimTypes.Email, email),
            new Claim(ClaimTypes.Role, role)
        };

        var creds = new SigningCredentials(_key, SecurityAlgorithms.HmacSha256);
        var token = new JwtSecurityToken(
            issuer: _configuration["Jwt:Issuer"],
            audience: _configuration["Jwt:Audience"],
            claims: claims,
            expires: DateTime.Now.AddDays(20),
            signingCredentials: creds);

        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}
