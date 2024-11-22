using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace moldme.Models;

/// <summary>
/// Represents a company.
/// </summary>
public class Company
{
    /// <summary>
    /// Gets or sets the unique identifier for the company.
    /// </summary>
    [Key]
    [StringLength(6)]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public string CompanyID { get; set; }
    
    /// <summary>
    /// Gets or sets the name of the company.
    /// </summary>
    [Required]
    [StringLength(64)]
    public string Name { get; set; }
    
    /// <summary>
    /// Gets or sets the tax identification number of the company.
    /// </summary>
    [Required]
    [Range(100000000, 999999999)] 
    public int TaxId { get; set; }
        
    /// <summary>
    /// Gets or sets the address of the company.
    /// </summary>
    [Required]
    [StringLength(64)]
    public string Address { get; set; }
        
    /// <summary>
    /// Gets or sets the contact number of the company.
    /// </summary>
    [Required]
    [Range(100000000, 999999999)] 
    public int Contact { get; set; }
       
    /// <summary>
    /// Gets or sets the email address of the company.
    /// </summary>
    [Required]
    [StringLength(64)]
    public string Email { get; set; }
    
    /// <summary>
    /// Gets or sets the sector of the company.
    /// </summary>
    [Required]
    [StringLength(64)]
    public string Sector { get; set; }
        
    /// <summary>
    /// Gets or sets the subscription plan of the company.
    /// </summary>
    [Column("SubscriptionPlan")]
    public SubscriptionPlan Plan { get; set; }

    /// <summary>
    /// Gets or sets the password for the company account.
    /// </summary>
    [Required]
    [StringLength(256)] 
    public string Password { get; set; }
}






