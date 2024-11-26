using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using moldme.Models;

namespace moldme.Models;


/// <summary>
/// Represents an employee.
/// </summary>
public class Employee
{
    /// <summary>
    /// Gets or sets the unique identifier for the employee.
    /// </summary>
    [Key]
    [StringLength(36)]
    [Required]  
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public string EmployeeId { get; set; }
        
    /// <summary>
    /// Gets or sets the name of the employee.
    /// </summary>
    [Required]
    [StringLength(64)]
    public string Name { get; set; }
      
    /// <summary>
    /// Gets or sets the profession of the employee.
    /// </summary>
    [Required]
    [StringLength(64)]
    public string Profession { get; set; }
      
    /// <summary>
    /// Gets or sets the tax identification number of the employee.
    /// </summary>
    [Required]
    [Range(100000000, 999999999)]
    public int NIF { get; set; }
       
    /// <summary>
    /// Gets or sets the email address of the employee.
    /// </summary>
    [Required]
    [StringLength(64)]
    public string Email { get; set; }
        
    /// <summary>
    /// Gets or sets the contact number of the employee.
    /// </summary>
    [Range(100000000, 999999999)]
    public int? Contact { get; set; }
    
    /// <summary>
    /// Gets or sets the password for the employee account.
    /// </summary>
    [Required]
    [StringLength(256)]
    public string Password { get; set; }
        
    /// <summary>
    /// Gets or sets the unique identifier for the company associated with the employee.
    /// </summary>
    [Required, StringLength(36)] public string CompanyId { get; set; }
    
    /// <summary>
    /// Gets or sets the company associated with the employee.
    /// </summary>
    [ForeignKey("CompanyId")] public Company Company { get; set; }
    
    /// <summary>
    /// Gets or sets the list of projects the employee is involved in.
    /// </summary>
    public List<Project> Projects { get; set; } = new List<Project>();
    
    /// <summary>
    /// Gets or sets the list of reviews the employee has performed.
    /// </summary>
    public List<Review> Reviews { get; set; } = new List<Review>();


}

