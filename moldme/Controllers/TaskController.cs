using Microsoft.AspNetCore.Mvc;
using moldme.data;
using moldme.Models;
using Task = moldme.Models.Task;

namespace moldme.Controllers // Change from DefaultNamespace to your actual namespace
{
    [ApiController]
    [Route("api/[controller]")]
    public class TaskController : ControllerBase // Inherit from ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public TaskController(ApplicationDbContext context)
        {
            _context = context;
        }

        // Create
        [HttpPost("addtask")]
        public IActionResult Create([FromBody] Task task) // Use the renamed class
        {
            if (!ModelState.IsValid) // Validate the model
            {
                return BadRequest(ModelState);
            }

            _context.Tasks.Add(task); // Use the correct DbSet
            _context.SaveChanges();
            return CreatedAtAction(nameof(GetById), new { id = task.TaskId }, task);
        }

        // Read all
        [HttpGet]
        public IActionResult GetAll()
        {
            var tasks = _context.Tasks.ToList(); // Ensure to use the correct DbSet
            return Ok(tasks);
        }

        // Read by ID
        [HttpGet("{id}")]
        public IActionResult GetById(int id)
        {
            var task = _context.Tasks.Find(id); // Use the correct DbSet
            if (task == null)
            {
                return NotFound();
            }
            return Ok(task);
        }

        // Update
        [HttpPut("{id}")]
        public IActionResult Update(int id, [FromBody] Task updatedTask) // Ensure updated type is correct
        {
            if (!ModelState.IsValid) // Validate the model
            {
                return BadRequest(ModelState);
            }

            var task = _context.Tasks.Find(id); // Use the correct DbSet
            if (task == null)
            {
                return NotFound();
            }

            // Update properties
            task.TitleName = updatedTask.TitleName;
            task.Description = updatedTask.Description;
            task.Date = updatedTask.Date; // Ensure Date is updated
            task.Status = updatedTask.Status;

            _context.SaveChanges();
            return NoContent(); // 204 No Content
        }

        // Delete
        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var task = _context.Tasks.Find(id); // Use the correct DbSet
            if (task == null)
            {
                return NotFound();
            }
            _context.Tasks.Remove(task); // Use the correct DbSet
            _context.SaveChanges();
            return NoContent(); // 204 No Content
        }
    }
}
