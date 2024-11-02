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
    [DataType(DataType.Date)]
    public DateTime date { get; set; }
        
    [Required]
    public Stars Stars { get; set; }
    
    // ID do Employee que fez a avaliação
    [ForeignKey("Reviewer")]
    public string ReviewerID { get; set; }
    
    public Employee Reviewer { get; set; }
    
    // ID do Employee que foi avaliado
    [ForeignKey("Reviewed")]
    public string ReviewedId { get; set; }
    
    public Employee Reviewed { get; set; }
}
