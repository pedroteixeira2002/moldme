using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using moldme.data;
using moldme.DTOs;
using moldme.Interface;
using Task = moldme.Models.Task;

namespace moldme.Controllers;

/// <summary>
/// Task Controller
/// </summary>
[ApiController]
[Route("api/[controller]")]
public class TaskController : ControllerBase, ITask
{
    /// <summary>
    /// Database context
    /// </summary>
    private readonly ApplicationDbContext _context;

    /// <summary>
    /// Constructor for Task Controller
    /// </summary>
    /// <param name="context"></param>
    public TaskController(ApplicationDbContext context)
    {
        _context = context;
    }

    ///<inheritdoc cref="ITask.TaskCreate(TaskDto,string,string)"/>
    [HttpPost("createTask")]
    public IActionResult TaskCreate([FromBody] TaskDto taskDto, string projectId, string employeeId)
    {
        if (taskDto == null)
        {
            return BadRequest("Task is null");
        }

        var project = _context.Projects.FirstOrDefault(p => p.ProjectId == projectId);
        if (project == null)
        {
            return NotFound("Project not found");
        }

        var employee = _context.Employees.FirstOrDefault(e => e.EmployeeId == employeeId);
        if (employee == null)
        {
            return NotFound("Employee not found");
        }

        byte[] fileContent = null;

        if (!string.IsNullOrEmpty(taskDto.FilePath))
        {
            if (System.IO.File.Exists(taskDto.FilePath))
            {
                try
                {
                    var fileInfo = new FileInfo(taskDto.FilePath);

                    const long maxFileSize = 10 * 1024 * 1024; // 10 MB
                    if (fileInfo.Length > maxFileSize)
                    {
                        return BadRequest("File size exceeds the maximum allowed limit of 10 MB.");
                    }

                    fileContent = System.IO.File.ReadAllBytes(taskDto.FilePath);
                }
                catch (Exception ex)
                {
                    return StatusCode(500, "An internal server error occurred.");
                }
            }
            else
            {
                return NotFound($"The file at path '{taskDto.FilePath}' was not found.");
            }
        }

        var task = new Task
        {
            TitleName = taskDto.TitleName,
            Description = taskDto.Description,
            Date = taskDto.Date,
            Status = taskDto.Status,
            ProjectId = projectId,
            EmployeeId = employeeId,
            Employee = employee,
            Project = project
        }; 
        if (fileContent != null)
        {
            task.FileContent = fileContent;
            task.FileName = Path.GetFileName(taskDto.FilePath);
            task.MimeType = GetMimeType(taskDto.FilePath);
        }

        _context.Tasks.Add(task);
        _context.SaveChanges();

        return Ok("Task created successfully");
    }

    ///<inheritdoc cref="ITask.TaskGetAll(string)"/>
    [HttpGet("project/{projectId}/tasks")]
    public IActionResult TaskGetAll(string projectId)
    {
        if (projectId.IsNullOrEmpty())
            return BadRequest("Project ID is null");

        var project = _context.Projects.FirstOrDefault(p => p.ProjectId == projectId);
        if (project == null)
            return NotFound("Project not found");

        var tasks = _context.Tasks.ToList().FindAll(t => t.ProjectId == projectId);
        return Ok(tasks);
    }

    ///<inheritdoc cref="ITask.TaskGetById(string)"/>
    [HttpGet("task/{taskId}")]
    public IActionResult TaskGetById(String taskId)
    {
        var task = _context.Tasks.Find(taskId);
        if (task == null)
        {
            return NotFound();
        }

        return Ok(task);
    }

    ///inheritdoc cref="ITask.TaskGetFile(string)"/>
    [HttpGet("task/{taskId}/file")]
    public IActionResult TaskGetFile(string taskId)
    {
        var task = _context.Tasks.Find(taskId);
        if (task == null || string.IsNullOrEmpty(task.FileName))
        {
            return NotFound("Task or file not found");
        }

        var fileName = task.FileName;
        var mimeType = task.MimeType;


        return File(task.FileContent, mimeType, fileName);
    }

    private string GetMimeType(string filePath)
    {
        var extension = Path.GetExtension(filePath).ToLowerInvariant();
        return extension switch
        {
            ".jpg" or ".jpeg" => "image/jpeg",
            ".png" => "image/png",
            ".gif" => "image/gif",
            ".pdf" => "application/pdf",
            ".doc" or ".docx" => "application/msword",
            ".txt" => "text/plain",
            _ => "application/octet-stream", // Default for unknown types
        };
    }

    ///<inheritdoc cref="ITask.TaskUpdate(string, TaskDto)"/>
    [HttpPut("updateTask/{taskId}")]
    public IActionResult TaskUpdate(string taskId, [FromBody] TaskDto updatedTaskDto)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        var task = _context.Tasks.Find(taskId);
        if (task == null)
        {
            return NotFound("Task not found");
        }

        task.TitleName = updatedTaskDto.TitleName;
        task.Description = updatedTaskDto.Description;
        task.Status = updatedTaskDto.Status;
        task.Date = updatedTaskDto.Date;

        _context.SaveChanges();
        return Ok("Task updated successfully");
    }

    ///<inheritdoc cref="ITask.TaskDelete(string)"/>
    [HttpDelete("delete/{taskId}")]
    public IActionResult TaskDelete(string taskId)
    {
        var task = _context.Tasks.Find(taskId);
        if (task == null)
        {
            return NotFound();
        }

        _context.Tasks.Remove(task);
        _context.SaveChanges();
        return Ok("Task deleted successfully");
    }
}