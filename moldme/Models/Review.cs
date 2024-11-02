using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace moldme.Models;

public class Review
{
    [Key] [StringLength(6)] public string ReviewID { get; set; }
    [Required] [StringLength(256)] public string Comment { get; set; }
    [Required] [DataType(DataType.Date)] public DateTime date { get; set; }
    [Required] public Stars Stars { get; set; }
    [Required, MaxLength(6)] public String ReviewerId { get; set; }
    [ForeignKey("ReviewerId")] public Employee Reviewer { get; set; }
    [Required, MaxLength(6)] public string ReviewedId { get; set; }
    [ForeignKey("ReviewedId")] public Employee Reviewed { get; set; }
}