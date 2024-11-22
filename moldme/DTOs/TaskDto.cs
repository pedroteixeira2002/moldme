using System.ComponentModel.DataAnnotations;
using moldme.Models;

namespace moldme.DTOs;
/// <summary>
/// Data Transfer Object for Task
/// </summary>
public class TaskDto
{
    /// <summary>
    /// Title of the task
    /// </summary>
    [Required(ErrorMessage = "TitleName is required")]
    [StringLength(64)]
    public String TitleName { get; set; }

    /// <summary>
    /// Description of the task
    /// </summary>
    [Required(ErrorMessage = "Description is required")]
    [StringLength(256)]
    public String Description { get; set; }

    /// <summary>
    /// Date of the task
    /// </summary>
    [Required]
    [DataType(DataType.Date)]
    public DateTime Date { get; set; }

    /// <summary>
    /// Status of the task
    /// </summary>
    [Required]
    public Status Status { get; set; } 
    
    /// <summary>
    /// File path of the task
    /// </summary>
    [StringLength(256)]
    public String? FilePath { get; set; } 
}