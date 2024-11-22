using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;
using moldme.Models;

namespace moldme.Models;

/// <summary>
/// Represents a project.
/// </summary>
public class Project
{
    /// <summary>
    /// Gets or sets the unique identifier for the project.
    /// </summary>
    [Key, StringLength(6)]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public string ProjectId { get; set; }

    /// <summary>
    /// Gets or sets the name of the project.
    /// </summary>
    [Required, StringLength(64)]
    public string Name { get; set; }

    /// <summary>
    /// Gets or sets the description of the project.
    /// </summary>
    [Required, StringLength(256)]
    public string Description { get; set; }

    /// <summary>
    /// Gets or sets the status of the project.
    /// </summary>
    [Required, EnumDataType(typeof(Status))]
    public Status Status { get; set; }

    /// <summary>
    /// Gets or sets the budget of the project.
    /// </summary>
    [Required, Column(TypeName = "decimal(18, 2)")]
    public decimal Budget { get; set; }

    /// <summary>
    /// Gets or sets the start date of the project.
    /// </summary>
    [Required, DataType(DataType.DateTime)]
    public DateTime StartDate { get; set; }

    /// <summary>
    /// Gets or sets the end date of the project.
    /// </summary>
    [Required, DataType(DataType.DateTime)]
    public DateTime EndDate { get; set; }

    /// <summary>
    /// Gets or sets the unique identifier for the company associated with the project.
    /// </summary>
    [Required, StringLength(6)]
    public string CompanyId { get; set; }

    /// <summary>
    /// Gets or sets the company associated with the project.
    /// </summary>
    [ForeignKey("CompanyId")]
    public Company Company { get; set; }

    /// <summary>
    /// Gets or sets the list of employees involved in the project.
    /// </summary>
    public List<Employee> Employees { get; set; } = new List<Employee>();

    /// <summary>
    /// Gets or sets the list of tasks associated with the project.
    /// </summary>
    public List<Task> Tasks { get; set; } = new List<Task>();

    /// <summary>
    /// Gets or sets the chat associated with the project.
    /// </summary>
    public Chat Chat { get; set; }
}