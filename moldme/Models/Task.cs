using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace moldme.Models;

public class Task
{
    [Key, StringLength(6)] public String TaskId { get; set; }
    [Required, MaxLength(64)] public string TitleName { get; set; }
    [Required, MaxLength(256)] public string Description { get; set; }
    [Required, DataType(DataType.Date)] public DateTime Date { get; set; }
    [Required, EnumDataType(typeof(Status))] public Status Status { get; set; }
    [MaxLength(6)] public string ProjectId { get; set; }
    [ForeignKey("ProjectId")] public Project Project { get; set; }
    [Required, MaxLength(6)] public String EmployeeId { get; set; }
    [ForeignKey("EmployeeId")] public Employee Employee { get; set; }
    public string? FilePath { get; set; }
}