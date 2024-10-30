using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace moldme.Models;

public class Review
{
    [Key]
    [StringLength(6)]
    public string ReviewID { get; set; }
        
    [Required]
    [StringLength(256)] 
    public string Comment { get; set; }
        
    [Required]
    public Stars Stars { get; set; }
    
    // Relacionamentos
    [ForeignKey("StaffID")]
    public Employee Reviewer { get; set; }

    [ForeignKey("ReviewedStaffID")]
    public Employee ReviewedEmployee { get; set; }
}
