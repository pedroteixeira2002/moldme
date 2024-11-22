using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using moldme.data;
using moldme.DTOs;
using moldme.Interface;
using moldme.Models;

namespace moldme.Controllers;

[Route("api/[controller]")]
[ApiController]
public class MessageController : ControllerBase, IMessage
{
    private readonly ApplicationDbContext _context;

    public MessageController(ApplicationDbContext context)
    {
        _context = context;
    }

    ///<inheritdoc cref="IMessage.GetMessages(string)"/>
    [HttpGet("{chatId}")]
    public async Task<ActionResult<IEnumerable<Message>>> GetMessages(string chatId)
    {
        var messages = await _context.Messages
            .Where(m => m.ChatId == chatId)
            .OrderBy(m => m.Date)
            .ToListAsync();

        return Ok(messages);
    }

    ///<inheritdoc cref="IMessage.SendMessage(MessageDto,string,string)"/>
    [HttpPost("{chatId}/sendMessage")]
    public async Task<ActionResult<Message>> SendMessage([FromBody] MessageDto messageDto, string chatId,
        string employeeId)
    {
        if (chatId.IsNullOrEmpty() || employeeId.IsNullOrEmpty())
            return BadRequest("ChatId or EmployeeId not found.");

        var chat = await _context.Chats.FindAsync(chatId);
        var sender = await _context.Employees.FindAsync(employeeId);

        if (chat == null || sender == null)
            return NotFound("Chat or sender not found.");

        var message = new Message
        {
            EmployeeId = employeeId,
            ChatId = chatId,
            Employee = sender,
            Chat = chat,
            Date = DateTime.UtcNow,
            Text = messageDto.Text
        };

        _context.Messages.Add(message);
        await _context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetMessages), new { chatId }, message);
    }

    ///<inheritdoc cref="IMessage.DeleteMessage(string)"/>
    [HttpDelete("deleteMessage/{messageId}")]
    public async Task<ActionResult> DeleteMessage(string messageId)
    {
        var message = await _context.Messages.FindAsync(messageId);
        if (message == null)
            return NotFound("Message not found.");

        _context.Messages.Remove(message);
        await _context.SaveChangesAsync();

        return Ok("Message deleted successfully");
    }
}