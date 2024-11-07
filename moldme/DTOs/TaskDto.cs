using System.ComponentModel.DataAnnotations;
using moldme.Models;

namespace moldme.DTOs;
public class TaskDto
{
    [Required(ErrorMessage = "TitleName is required")]
    [StringLength(64)]
    public String TitleName { get; set; }

    [Required(ErrorMessage = "Description is required")]
    [StringLength(256)]
    public String Description { get; set; }

    [Required]
    [DataType(DataType.Date)]
    public DateTime Date { get; set; }

    [Required]
    public Status Status { get; set; } 

    [Required(ErrorMessage = "ProjectId is required")]
    [StringLength(6)]
    public String ProjectId { get; set; }

    [Required(ErrorMessage = "EmployeeId is required")]
    [StringLength(6)]
    public String EmployeeId { get; set; }

    public String? FilePath { get; set; } 
}