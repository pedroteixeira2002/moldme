using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace moldme.Models;

public class Chat
{
    [Key, StringLength(6)] public String ChatId { get; set; }
    public List<Message> Messages { get; set; } = new List<Message>();
    [Required, MaxLength(6)] public String ProjectId { get; set; }
    
    [ForeignKey("ProjectId")] public Project Project { get; set; }
}