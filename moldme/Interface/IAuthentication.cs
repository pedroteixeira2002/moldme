using Microsoft.AspNetCore.Mvc;
using moldme.DTOs;

namespace moldme.Interface
{

    /// <summary>
    /// Interface for Authentication
    /// </summary>
    public interface IAuthentication
    {
        /// <summary>
        /// Authenticates a user and generates a token.
        /// </summary>
        /// <param name="request">The Data Transfer Object containing login credentials.</param>
        /// <returns>
        /// Returns:
        /// - 200 OK: If the login is successful.
        /// - 400 Bad Request: If the login credentials are invalid.
        /// - 401 Unauthorized: If the authentication fails.
        /// </returns>  
        IActionResult Login([FromBody] LoginDto request);
    }
}