using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace moldme.Models;

/// <summary>
/// Represents a chat within a project.
/// </summary>
public class Chat
{
    /// <summary>
    /// Gets or sets the unique identifier for the chat.
    /// </summary>
    [Key, StringLength(6)]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public String ChatId { get; set; }
    
    /// <summary>
    /// Gets or sets the list of messages in the chat.
    /// </summary>
    public List<Message> Messages { get; set; } = new List<Message>();
    
    /// <summary>
    /// Gets or sets the unique identifier for the project associated with the chat.
    /// </summary>
    [Required, MaxLength(6)] public String ProjectId { get; set; }
    
    /// <summary>
    /// Gets or sets the project associated with the chat.
    /// </summary>
    [ForeignKey("ProjectId")] public Project Project { get; set; }
}