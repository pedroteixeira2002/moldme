using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace moldme.Models;

public class Payment
{
    [Key] [StringLength(6)] public string PaymentID { get; set; }
    [Required, StringLength(6)] public string CompanyId { get; set; }
    [ForeignKey("CompanyId")] public Company Company { get; set; }
    [Required] [DataType(DataType.Date)] public DateTime Date { get; set; }
    [Required] public float Value { get; set; }
    [Required] public SubscriptionPlan Plan { get; set; }
}