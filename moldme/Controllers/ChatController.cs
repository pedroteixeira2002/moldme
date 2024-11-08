using Microsoft.AspNetCore.Mvc;
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

        // Create
        [HttpPost]
        public async Task<ActionResult<Chat>> CreateChat(Chat chat)
        {
            _context.Chats.Add(chat);
            _context.SaveChanges();

            return Ok("Chat created successfully");
        }

        // Delete
        [HttpDelete("{id}")]
        public IActionResult Delete(String id)
        {
            var chat = _context.Chats.Find(id);
            if (chat == null)
            {
                return NotFound();
            }

            _context.Chats.Remove(chat);
            _context.SaveChanges();

            return Ok("Chat deleted successfully");
        }
    }
    
}