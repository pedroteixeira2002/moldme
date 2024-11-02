using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using moldme.Models;

namespace moldme.Models;

public class Employee
{
    [Key]
    [StringLength(6)]
    [Required]
    public string EmployeeID { get; set; }
        
    [Required]
    [StringLength(64)]
    public string Name { get; set; }
        
    [Required]
    [StringLength(64)]
    public string Profession { get; set; }
        
    [Required]
    [Range(100000000, 999999999)]
    public int NIF { get; set; }
        
    [Required]
    [StringLength(64)]
    public string Email { get; set; }
        
    [Range(100000000, 999999999)]
    public int? Contact { get; set; }
        
    [Required]
    [StringLength(64)]
    public string Password { get; set; }
        
    [Required, StringLength(6)] public string CompanyId { get; set; }
    [ForeignKey("CompanyId")] public Company Company { get; set; }
    
    public List<Project> Projects { get; set; } = new List<Project>();
}

