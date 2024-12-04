using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace moldme.Models;

/// <summary>
/// Represents a message in a chat.
/// </summary>
public class Message
{
    /// <summary>
    /// Gets or sets the unique identifier for the message.
    /// </summary>
    [Key, MaxLength(36)]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public string MessageId { get; set; }

    /// <summary>
    /// Gets or sets the date and time when the message was sent.
    /// </summary>
    [Required]
    public DateTime Date { get; set; }

    /// <summary>
    /// Gets or sets the text content of the message.
    /// </summary>
    [Required, MaxLength(512)]
    public string Text { get; set; }

    /// <summary>
    /// Gets or sets the unique identifier for the employee who sent the message.
    /// </summary>
    [Required, MaxLength(36)]
    public String EmployeeId { get; set; }

    /// <summary>
    /// Gets or sets the employee who sent the message.
    /// </summary>
    //[ForeignKey("EmployeeId")] public Employee Employee { get; set; }

    /// <summary>
    /// Gets or sets the unique identifier for the chat associated with the message.
    /// </summary>
    [Required, MaxLength(36)] 
    public String ChatId { get; set; }

    /// <summary>
    /// Gets or sets the chat associated with the message.
    /// </summary>
    //[ForeignKey("ChatId")] public Chat Chat { get; set; }
}