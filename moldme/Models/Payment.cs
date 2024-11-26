using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace moldme.Models;

/// <summary>
/// Represents a payment made by a company.
/// </summary>
public class Payment
{
    /// <summary>
    /// Gets or sets the unique identifier for the payment.
    /// </summary>
    [Key]
    [StringLength(36)]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public string PaymentId { get; set; }

    /// <summary>
    /// Gets or sets the unique identifier for the company making the payment.
    /// </summary>
    [Required, StringLength(36)] 
    public string CompanyId { get; set; }
    
    /// <summary>
    /// Gets or sets the company making the payment.
    /// </summary>
    [ForeignKey("CompanyId")] 
    public Company Company { get; set; }

    /// <summary>
    /// Gets or sets the date when the payment was made.
    /// </summary>
    [Required]
    [DataType(DataType.Date)]
    public DateTime Date { get; set; }

    /// <summary>
    /// Gets or sets the value of the payment.
    /// </summary>
    [Required]
    public float Value { get; set; }

    /// <summary>
    /// Gets or sets the subscription plan associated with the payment.
    /// </summary>
    [Required]
    public SubscriptionPlan Plan { get; set; }
}