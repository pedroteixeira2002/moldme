using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using moldme.data;
using moldme.Models;

namespace moldme.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ChatController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public ChatController(ApplicationDbContext context)
        {
            _context = context;
        }
        [Authorize]
        [HttpPost("newchat")]
        public async Task<ActionResult<Chat>> CreateChat([FromBody] Chat chat)
        {
            if (chat == null)
            {
                return BadRequest("Chat is null");
            }

            // Validate ProjectId
            var project = await _context.Projects.FindAsync(chat.ProjectId);
            if (project == null)
            {
                return NotFound("Project not found");
            }

            // Validate unique ChatId
            var existingChat = await _context.Chats.FindAsync(chat.ChatId);
            if (existingChat != null)
            {
                return Conflict("Chat with the same ID already exists");
            }

            _context.Chats.Add(chat);
            await _context.SaveChangesAsync();

            return Ok("Chat created successfully");
        }
        [Authorize]
        [HttpDelete("remove/{id}")]
        public async Task<IActionResult> DeleteChat(string id)
        {
            if (string.IsNullOrEmpty(id))
            {
                return BadRequest("Chat ID is null or empty");
            }

            var chat = await _context.Chats.FindAsync(id);
            if (chat == null)
            {
                return NotFound("Chat not found");
            }

            _context.Chats.Remove(chat);
            await _context.SaveChangesAsync();

            return Ok("Chat deleted successfully");
        }
    }
}