using System.ComponentModel.DataAnnotations;
using moldme.Models;

namespace moldme.DTOs;

/// <summary>
/// Represents a data transfer object for a company.
/// </summary>
public class CompanyDto
{
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
    /// Gets or sets the email of the company.
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
    [Required]
    public SubscriptionPlan Plan { get; set; }

    /// <summary>
    /// Gets or sets the password for the company account.
    /// </summary>
    [Required]
    [StringLength(256)]
    public string Password { get; set; }
}