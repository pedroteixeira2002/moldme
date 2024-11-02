using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace moldme.Models;

public class Message
{
    [Key, MaxLength(6)] public String MessageId { get; set; }
    [Required] public DateTime Date { get; set; }
    [Required, MaxLength(512)] public string Text { get; set; }
    [Required, MaxLength(6)] public String EmployeeId { get; set; }
    [ForeignKey("EmployeeId")] public Employee Employee { get; set; }
    [Required, MaxLength(6)] public String ChatId { get; set; }
    [ForeignKey("ChatId")] public Chat Chat { get; set; }
}