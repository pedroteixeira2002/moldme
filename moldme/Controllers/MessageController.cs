using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.data;
using moldme.DTOs;
using moldme.Models;

namespace moldme.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MessageController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public MessageController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/Message/{chatId}
        [Authorize]
        [HttpGet("{chatId}")]
        public async Task<ActionResult<IEnumerable<Message>>> GetMessages(String chatId)
        {
            var messages = await _context.Messages
                .Where(m => m.ChatId == chatId)
                .OrderBy(m => m.Date)
                .ToListAsync();

            return Ok(messages);
        }

        // POST: api/Message
        [Authorize]
        [HttpPost]
        public async Task<ActionResult<Message>> SendMessage([FromBody] MessageDto messageDto)
        {
            //var chat = await _context.Chats.FindAsync(messageDto.ChatId);
            //var sender = await _context.Employees.FindAsync(messageDto.EmployeeId);

            if (messageDto.ChatId == null || messageDto.EmployeeId == null)
                return BadRequest("Chat or sender not found.");

            var message = new Message
            {
                MessageId = messageDto.MessageId,
                EmployeeId = messageDto.EmployeeId,
                Date = DateTime.UtcNow,
                ChatId = messageDto.ChatId,
                Text = messageDto.Text
            };

            _context.Messages.Add(message);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetMessages), new { chatId = messageDto.ChatId }, message);
        }
        
        // DELETE: api/Message/{messageId}
        [Authorize]
        [HttpDelete("{messageId}")]
        public async Task<ActionResult> DeleteMessage(String messageId)
        {
            var message = await _context.Messages.FindAsync(messageId);
            if (message == null)
                return NotFound("Message not found.");

            _context.Messages.Remove(message);
            await _context.SaveChangesAsync();

            return Ok("Message deleted successfully");
        }
    }
}