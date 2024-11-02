using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;
using moldme.Models;

namespace moldme.Models;

public class Project
{
    [Key, StringLength(6)] public string ProjectId { get; set; }
    [Required, StringLength(64)] public string Name { get; set; }
    [Required, StringLength(256)] public string Description { get; set; }
    [Required, EnumDataType(typeof(Status))] public Status Status { get; set; }
    [Required, Column(TypeName = "decimal(18, 2)")] public decimal Budget { get; set; }
    [Required, DataType(DataType.DateTime)] public DateTime StartDate { get; set; }
    [Required, DataType(DataType.DateTime)] public DateTime EndDate { get; set; }
    [Required, StringLength(6)] public string CompanyId { get; set; }
    [ForeignKey("CompanyId")] public Company Company { get; set; }
    public List<Employee> Employees { get; set; } = new List<Employee>();
}