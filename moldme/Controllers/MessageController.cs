using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using moldme.data;
using moldme.DTOs;
using moldme.Models;
using moldme.hubs;

namespace moldme.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MessageController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly IHubContext<ChatHub> _chatHub;

        public MessageController(ApplicationDbContext context, IHubContext<ChatHub> chatHub)
        {
            _context = context;
            _chatHub = chatHub;
        }

        [Authorize]
        [HttpPost]
        public async Task<ActionResult<Message>> SendMessage([FromBody] MessageDto messageDto)
        {
            if (messageDto == null)
            {
                return BadRequest("Message data is null");
            }

            if (string.IsNullOrEmpty(messageDto.SenderId) || 
                string.IsNullOrEmpty(messageDto.ChatId) || 
                string.IsNullOrEmpty(messageDto.Text))
            {
                return BadRequest("SenderId, ChatId, and Text are required");
            }

            var chat = await _context.Chats.FindAsync(messageDto.ChatId);
            if (chat == null)
            {
                return NotFound("Chat not found");
            }

            var project = await _context.Projects.FindAsync(chat.ProjectId);
            if (project == null)
            {
                return NotFound("Project not found");
            }

            var employee = await _context.Employees.FindAsync(messageDto.SenderId);
            if (employee == null)
            {
                return NotFound("Employee not found");
            }

            var message = new Message
            {
                MessageId = Guid.NewGuid().ToString().Substring(0, 6),
                EmployeeId = messageDto.SenderId,
                Date = DateTime.UtcNow,
                Text = messageDto.Text,
                ChatId = messageDto.ChatId,
            };

            _context.Messages.Add(message);
            await _context.SaveChangesAsync();

            await _chatHub.Clients.All.SendAsync("ReceiveMessage", messageDto.SenderId, messageDto.Text);

            return CreatedAtAction(nameof(GetMessages), new { chatId = messageDto.ChatId }, message);
        }

        [Authorize]
        [HttpGet("{chatId}")]
        public async Task<ActionResult<IEnumerable<Message>>> GetMessages(string chatId)
        {
            if (string.IsNullOrEmpty(chatId))
            {
                return BadRequest("ChatId is required");
            }

            var chat = await _context.Chats.FindAsync(chatId);
            if (chat == null)
            {
                return NotFound("Chat not found");
            }

            var messages = await _context.Messages
                .Where(m => m.ChatId == chatId)
                .OrderBy(m => m.Date)
                .ToListAsync();

            return Ok(messages);
        }
    }
}