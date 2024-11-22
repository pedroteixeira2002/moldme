using Microsoft.AspNetCore.Mvc;
using moldme.Models;

namespace moldme.Interface{
/// <summary>
/// Interface for Chat
/// </summary>
public interface IChat
{
    /// <summary>
    /// Creates a new chat for a specified project.
    /// </summary>
    /// <param name="projectId">The Unique Identification of the project.</param>
    /// <returns>
    /// Returns:
    /// - 201 Created: If the chat is created successfully.
    /// - 400 Bad Request: If the project ID is invalid.
    /// - 404 Not Found: If the specified project is not found.
    /// </returns>
    Task<ActionResult<Chat>> ChatCreate(string projectId);
    /// <summary>
    /// Deletes a specified chat.
    /// </summary>
    /// <param name="chatId">The Unique Identification of the chat to be deleted.</param>
    /// <returns>
    /// Returns:
    /// - 200 OK: If the chat is deleted successfully.
    /// - 400 Bad Request: If the chat ID is invalid.
    /// - 404 Not Found: If the specified chat is not found.
    /// </returns>
    IActionResult ChatDelete(string chatId);
}
}