using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using moldme.data;
using moldme.Interface;
using moldme.Models;

namespace moldme.Controllers;

    [ApiController]
    [Route("api/[controller]")]
    public class ChatController : ControllerBase, IChat
    {
        private readonly ApplicationDbContext _context;

        public ChatController(ApplicationDbContext context)
        {
            _context = context;
        }

        ///<inheritdoc cref="IChat.ChatCreate(string)"/>
        [HttpPost("createChat")]
        public async Task<ActionResult<Chat>> ChatCreate(String ProjectId)
        {
            if (ProjectId.IsNullOrEmpty())
                return BadRequest("Project Id is required");

            Project Project = _context.Projects.Find(ProjectId);

            if (Project == null)
                return NotFound("Project not found");

            Chat chat = new Chat();
            chat.ProjectId = ProjectId;
            //chat.Project = Project;

            _context.Chats.Add(chat);
            _context.SaveChanges();

            return Ok("Chat created successfully");
        }

        ///<inheritdoc cref="IChat.ChatDelete(string)"/>
        [HttpDelete("deleteChat/{ChatId}")]
        public IActionResult ChatDelete(String ChatId)
        {
            if (ChatId.IsNullOrEmpty())
                return BadRequest("Chat Id is required");

            var chat = _context.Chats.Find(ChatId);
            if (chat == null)
                return NotFound();
            
            _context.Chats.Remove(chat);
            _context.SaveChanges();

            return Ok("Chat deleted successfully");
        }
    }