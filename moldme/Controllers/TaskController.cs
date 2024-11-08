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

        [HttpPost("addtask")]
        public IActionResult Create([FromBody] TaskDto taskDto)
        {
            if (taskDto == null)
            {
                return BadRequest("Task is null");
            }
    
            // Validação de existência do Projeto
            var project = _context.Projects.FirstOrDefault(p => p.ProjectId == taskDto.ProjectId);
            if (project == null)
            {
                return NotFound("Project not found");
            }

            // Validação de existência do Funcionário
            var employee = _context.Employees.FirstOrDefault(e => e.EmployeeID == taskDto.EmployeeId);
            if (employee == null)
            {
                return NotFound("Employee not found");
            }

            var task = new Task
            {
                TaskId = Guid.NewGuid().ToString().Substring(0, 6), // Gera um ID único de 6 caracteres
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

        // Read all
        [HttpGet]
        public IActionResult GetAll()
        {
            var tasks = _context.Tasks.ToList(); 
            return Ok(tasks);
        }

        // Read by ID
        [HttpGet("{id}")]
        public IActionResult GetById(String id)
        {
            var task = _context.Tasks.Find(id); 
            if (task == null)
            {
                return NotFound();
            }
            return Ok(task);
        }

        // Update
        [HttpPut("editTask/{id}")]
        public IActionResult Update(string id, [FromBody] TaskDto updatedTaskDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var task = _context.Tasks.Find(id);
            if (task == null)
            {
                return NotFound("Task not found");
            }

            // Atualiza as propriedades da tarefa com os dados do DTO
            task.TitleName = updatedTaskDto.TitleName;
            task.Description = updatedTaskDto.Description; 
            task.Status = updatedTaskDto.Status;
            task.Date = updatedTaskDto.Date;
            task.FilePath = updatedTaskDto.FilePath;

            _context.SaveChanges();
            return Ok("Task updated successfully");
        }

        // Delete
        [HttpDelete("Delete/{id}")]
        public IActionResult Delete(String id)
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
