using Microsoft.AspNetCore.Mvc;
using moldme.DTOs;
using moldme.Models;

namespace moldme.Interface
{
    /// <summary>
    /// Interface for Message
    /// </summary>
    public interface IMessage
    {
        
        /// <summary>
        /// Retrieves all messages for a specific chat.
        /// </summary>
        /// <param name="chatId">The Unique Identification of the chat whose messages are to be retrieved.</param>
        /// <returns>
        /// Returns:
        /// - 200 OK: If the messages are found.
        /// - 404 Not Found: If the specified chat is not found.
        /// </returns>
        Task<ActionResult<IEnumerable<Message>>> GetMessages(String chatId);
       
        /// <summary>
        /// Sends a message in a specific chat.
        /// </summary>
        /// <param name="messageDto">The Data Transfer Object of the Message.</param>
        /// <param name="chatId">The Unique Identification of the chat where the message will be sent.</param>
        /// <param name="employeeId">The Unique Identification of the employee sending the message.</param>
        /// <returns>
        /// Returns:
        /// - 201 Created: If the message is sent successfully.
        /// - 400 Bad Request: If the chat ID or employee ID is invalid.
        /// - 404 Not Found: If the specified chat or employee is not found.
        /// </returns>
        Task<ActionResult<Message>> SendMessage([FromBody] MessageDto messageDto, String ChatId, String EmployeeId);
      
        /// <summary>
        /// Deletes a specific message.
        /// </summary>
        /// <param name="messageId">The Unique Identification of the message to be deleted.</param>
        /// <returns>
        /// Returns:
        /// - 200 OK: If the message is deleted successfully.
        /// - 404 Not Found: If the specified message is not found.
        /// </returns>
        Task<ActionResult> DeleteMessage(String messageId);
    }
}