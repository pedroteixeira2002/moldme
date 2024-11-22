namespace moldme.DTOs;

/// <summary>
/// Data transfer object for login
/// </summary>
public class LoginDto
{
    /// <summary>
    /// Email of the user
    /// </summary>
    public string Email { get; set; } = string.Empty; 
    
    /// <summary>
    /// Password of the user
    /// </summary>
    public string Password { get; set; } = string.Empty; 
}
