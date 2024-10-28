using Microsoft.AspNetCore.Mvc;
using moldme.data;
using moldme.Models;
using Task = moldme.Models.Task;

namespace moldme.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TaskController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public TaskController(ApplicationDbContext context)
        {
            _context = context;
        }

        // Create
        [HttpPost("addtask")]
        public IActionResult Create(Task task)
        {
            if (task == null)
            {
                return BadRequest("Task is null");
            }
            
            _context.Tasks.Add(task);
            _context.SaveChanges();

            return Ok("Task created successfully");
        }

        // Read all
        [HttpGet]
        public IActionResult GetAll()
        {
            var tasks = _context.Tasks.ToList(); 
            return Ok(tasks);
        }

        // Read by ID
        [HttpGet("{id}")]
        public IActionResult GetById(int id)
        {
            var task = _context.Tasks.Find(id); 
            if (task == null)
            {
                return NotFound();
            }
            return Ok(task);
        }

        // Update
        [HttpPut("{id}")]
        public IActionResult Update(int id, [FromBody] Task updatedTask)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var task = _context.Tasks.Find(id);
            if (task == null)
            {
                return NotFound();
            }

            task.TitleName = updatedTask.TitleName;
            task.Description = updatedTask.Description; 
            task.Status = updatedTask.Status;
            task.Date = updatedTask.Date;
            task.FilePath = updatedTask.FilePath;

            _context.SaveChanges();
            return Ok("Task updated successfully");
        }

        // Delete
        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var task = _context.Tasks.Find(id);
            if (task == null)
            {
                return NotFound();
            }
            _context.Tasks.Remove(task);
            _context.SaveChanges();
            return Ok("Task deleted successfully");
        }
    }
}
