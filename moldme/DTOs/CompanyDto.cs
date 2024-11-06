using System.ComponentModel.DataAnnotations;
using moldme.Models;

namespace moldme.DTOs;

public class CompanyDto
{
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
    public SubscriptionPlan Plan { get; set; }

    [Required]
    [StringLength(256)] 
    public string Password { get; set; }
}
