using System.ComponentModel.DataAnnotations;

namespace moldme.Models;

public class TodoTask
{
    [Key, MaxLength(6)]
    public int TaskId { get; set; }
    
    [Required, MaxLength(64)]
    public string TitleName { get; set; }
    
    [Required, MaxLength(256)]
    public string Description { get; set; }
    
    [Required, DataType(DataType.Date)]
    public DateTime Date { get; set; }
    
    [Required, EnumDataType(typeof(Status))]
    public Status Status { get; set; }
    
    public string? FilePath { get; set; }
}