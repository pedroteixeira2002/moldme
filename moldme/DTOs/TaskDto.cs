using System.ComponentModel.DataAnnotations;
using moldme.Models;

public class TaskDto
{
    [Required]
    [StringLength(64)]
    public string TitleName { get; set; }

    [Required]
    [StringLength(256)]
    public string Description { get; set; }

    [Required]
    [DataType(DataType.Date)]
    public DateTime Date { get; set; }

    [Required]
    public Status Status { get; set; } // Supondo que Status é um enum

    [Required]
    [StringLength(6)]
    public string ProjectId { get; set; }

    [Required]
    [StringLength(6)]
    public string EmployeeId { get; set; }

    public string? FilePath { get; set; } // Este campo é opcional
}