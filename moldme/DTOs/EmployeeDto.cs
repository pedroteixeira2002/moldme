using System.ComponentModel.DataAnnotations;

namespace moldme.DTOs;

public class EmployeeDto
{
    [Required]
    [StringLength(64)]
    public string Name { get; set; }

    [Required]
    [StringLength(64)]
    public string Profession { get; set; }

    [Required]
    [Range(100000000, 999999999)]
    public int Nif { get; set; }

    [Required]
    [StringLength(64)]
    public string Email { get; set; }

    [Range(100000000, 999999999)]
    public int? Contact { get; set; }

    [Required]
    [StringLength(64)]
    public string Password { get; set; }

    [Required]
    public string ProjectId { get; set; }
}