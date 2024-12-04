namespace moldme.DTOs;

public class RecoverPasswordDto
{
    /// <summary>
    /// Email of the user
    /// </summary>
    public string Email { get; set; }
    
    /// <summary>
    ///  New password of the user
    /// </summary>
    public string NewPassword { get; set; }
}