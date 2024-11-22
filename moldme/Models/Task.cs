using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace moldme.Models;

/// <summary>
/// Represents a task.
/// </summary>
public class Task
{
    /// <summary>
    /// Gets or sets the unique identifier for the task.
    /// </summary>
    [Key, StringLength(6)]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public String TaskId { get; set; }

    /// <summary>
    /// Gets or sets the title of the task.
    /// </summary>
    [Required, MaxLength(64)]
    public string TitleName { get; set; }

    /// <summary>
    /// Gets or sets the description of the task.
    /// </summary>
    [Required, MaxLength(256)]
    public string Description { get; set; }

    /// <summary>
    /// Gets or sets the date of the task.
    /// </summary>
    [Required, DataType(DataType.Date)]
    public DateTime Date { get; set; }

    /// <summary>
    /// Gets or sets the status of the task.
    /// </summary>
    [Required, EnumDataType(typeof(Status))]
    public Status Status { get; set; }

    /// <summary>
    /// Gets or sets the unique identifier for the project associated with the task.
    /// </summary>
    [MaxLength(6)]
    public string ProjectId { get; set; }

    /// <summary>
    /// Gets or sets the project associated with the task.
    /// </summary>
    [ForeignKey("ProjectId")]
    public Project Project { get; set; }

    /// <summary>
    /// Gets or sets the unique identifier for the employee assigned to the task.
    /// </summary>
    [Required, MaxLength(6)]
    public String EmployeeId { get; set; }

    /// <summary>
    /// Gets or sets the employee assigned to the task.
    /// </summary>
    [ForeignKey("EmployeeId")]
    public Employee Employee { get; set; }

    /// <summary>
    /// Gets or sets the file of the task.
    /// </summary>
    [MaxLength(256)]
    public byte[]? FileContent { get; set; }
}