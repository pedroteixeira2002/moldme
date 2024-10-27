using Microsoft.AspNetCore.Mvc;
using Task = moldme.Models.Task;

namespace moldme.Controllers;

[ApiController]
[Route("api/[controller]")]
public class TaskController : Controller
{
    private readonly MoldmeContext _context;

    public TaskController(MoldmeContext context)
    {
        _context = context;
    }

    // Create
    [HttpPost]
    public IActionResult Create([FromBody] Task task)
    {
        _context.Taskings.Add(task);
        _context.SaveChanges();
        return CreatedAtAction(nameof(GetById), new { id = task.TaskId }, task);
    }

    // Read all
    [HttpGet]
    public IActionResult GetAll()
    {
        return Ok(_context.Taskings.ToList());
    }

    // Read by ID
    [HttpGet("{id}")]
    public IActionResult GetById(int id)
    {
        var tasking = _context.Taskings.Find(id);
        if (tasking == null)
        {
            return NotFound();
        }
        return Ok(tasking);
    }
    // Update
    [HttpPut("{id}")]
    public IActionResult Update(int id, [FromBody] Task updatedTask)
    {
        var tasking = _context.Taskings.Find(id);
        if (tasking == null)
        {
            return NotFound();
        }

        tasking.TitleName = updatedTask.TitleName;
        tasking.Description = updatedTask.Description;
        tasking.Status = updatedTask.Status;

        _context.SaveChanges();
        return NoContent();
    }

    // Delete
    [HttpDelete("{id}")]
    public IActionResult Delete(int id)
    {
        var tasking = _context.Taskings.Find(id);
        if (tasking == null)
        {
            return NotFound();
        }
        _context.Taskings.Remove(tasking);
        _context.SaveChanges();
        return NoContent();
    }
}