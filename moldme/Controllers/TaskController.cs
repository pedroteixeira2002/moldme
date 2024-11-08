using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using moldme.data;
using moldme.DTOs;
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

        [Authorize]
        [HttpPost("addtask")]
        public IActionResult Create([FromBody] TaskDto taskDto)
        {
            if (taskDto == null)
            {
                return BadRequest("Task data is null");
            }

            if (string.IsNullOrEmpty(taskDto.TitleName) || 
                string.IsNullOrEmpty(taskDto.Description) || 
                string.IsNullOrEmpty(taskDto.ProjectId) || 
                string.IsNullOrEmpty(taskDto.EmployeeId))
            {
                return BadRequest("TitleName, Description, ProjectId, and EmployeeId are required");
            }

            var project = _context.Projects.FirstOrDefault(p => p.ProjectId == taskDto.ProjectId);
            if (project == null)
            {
                return NotFound("Project not found");
            }

            var employee = _context.Employees.FirstOrDefault(e => e.EmployeeID == taskDto.EmployeeId);
            if (employee == null)
            {
                return NotFound("Employee not found");
            }

            var task = new Task
            {
                TaskId = Guid.NewGuid().ToString().Substring(0, 6),
                TitleName = taskDto.TitleName,
                Description = taskDto.Description,
                Date = taskDto.Date,
                Status = taskDto.Status,
                ProjectId = taskDto.ProjectId,
                EmployeeId = taskDto.EmployeeId,
                FilePath = taskDto.FilePath
            };

            _context.Tasks.Add(task);
            _context.SaveChanges();

            return Ok("Task created successfully");
        }

        [Authorize]
        [HttpGet]
        public IActionResult GetAll()
        {
            var tasks = _context.Tasks.ToList();
            return Ok(tasks);
        }

        [Authorize]
        [HttpGet("{id}")]
        public IActionResult GetById(string id)
        {
            if (string.IsNullOrEmpty(id))
            {
                return BadRequest("Task ID is required");
            }

            var task = _context.Tasks.Find(id);
            if (task == null)
            {
                return NotFound("Task not found");
            }
            return Ok(task);
        }

        [Authorize]
        [HttpPut("editTask/{id}")]
        public IActionResult UpdateTask(string id, [FromBody] TaskDto updatedTaskDto)
        {
            if (updatedTaskDto == null)
            {
                return BadRequest("Task data is null");
            }

            if (string.IsNullOrEmpty(updatedTaskDto.TitleName) ||
                string.IsNullOrEmpty(updatedTaskDto.Description) ||
                string.IsNullOrEmpty(updatedTaskDto.ProjectId) ||
                string.IsNullOrEmpty(updatedTaskDto.EmployeeId))
            {
                return BadRequest("TitleName, Description, ProjectId, and EmployeeId are required");
            }

            var task = _context.Tasks.Find(id);
            if (task == null)
            {
                return NotFound("Task not found");
            }

            var project = _context.Projects.FirstOrDefault(p => p.ProjectId == updatedTaskDto.ProjectId);
            if (project == null)
            {
                return NotFound("Project not found");
            }

            var employee = _context.Employees.FirstOrDefault(e => e.EmployeeID == updatedTaskDto.EmployeeId);
            if (employee == null)
            {
                return NotFound("Employee not found");
            }

            task.TitleName = updatedTaskDto.TitleName;
            task.Description = updatedTaskDto.Description;
            task.Status = updatedTaskDto.Status;
            task.Date = updatedTaskDto.Date;
            task.FilePath = updatedTaskDto.FilePath;
            task.ProjectId = updatedTaskDto.ProjectId;
            task.EmployeeId = updatedTaskDto.EmployeeId;

            _context.SaveChanges();
            return Ok("Task updated successfully");
        }

        [Authorize]
        [HttpDelete("Delete/{id}")]
        public IActionResult DeleteTask(string id)
        {
            if (string.IsNullOrEmpty(id))
            {
                return BadRequest("Task ID is required");
            }

            var task = _context.Tasks.Find(id);
            if (task == null)
            {
                return NotFound("Task not found");
            }

            _context.Tasks.Remove(task);
            _context.SaveChanges();
            return Ok("Task deleted successfully");
        }
    }
}