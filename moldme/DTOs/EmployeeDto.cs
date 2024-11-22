using System.ComponentModel.DataAnnotations;

namespace moldme.DTOs;

/// <summary>
/// Represents a data transfer object for an employee.
/// </summary>
public class EmployeeDto
{
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
    public int Nif { get; set; }

    /// <summary>
    /// Gets or sets the email of the employee.
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
    /// Gets or sets the password of the employee.
    /// </summary>
    [Required]
    [StringLength(256)]
    public string Password { get; set; }
}