using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using moldme.Models;

namespace DefaultNamespace;

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
        
    [StringLength(6)]
    public string CompanyID { get; set; }

    [ForeignKey("CompanyID")]
    public Company Company { get; set; }
}

