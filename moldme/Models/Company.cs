using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using moldme.Models;

namespace DefaultNamespace;

public class Company
{
    
    [Key]
    [StringLength(6)]
    public string CompanyID { get; set; }
    [Required]
    [StringLength(64)]
    public string Name { get; set; }
        
    [Required]
    [Range(100000000, 999999999)] 
    public int TaxId { get; set; }
        
    [Required]
    [StringLength(64)]
    public string Address { get; set; }
        
    [Required]
    [Range(100000000, 999999999)] 
    public int Contact { get; set; }
        
    [Required]
    [StringLength(64)]
    public string Email { get; set; }
        
    [Required]
    [StringLength(64)]
    public string Sector { get; set; }
        
    [Required]
    [StringLength(20)]
    [Column("subscriptionPlan")]
    public SubscriptionPlan Plan { get; set; }

    [Required]
    [StringLength(64)] 
    public string Password { get; set; }
}






