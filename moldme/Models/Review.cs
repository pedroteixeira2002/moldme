using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace moldme.Models;

public class Review
{
    /// <summary>
    /// Gets or sets the unique identifier for the review.
    /// </summary>
    [Key]
    [StringLength(6)]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public string ReviewID { get; set; }

    /// <summary>
    /// Gets or sets the comment of the review.
    /// </summary>
    [Required]
    [StringLength(256)]
    public string Comment { get; set; }

    /// <summary>
    /// Gets or sets the date when the review was made.
    /// </summary>
    [Required]
    [DataType(DataType.Date)]
    public DateTime date { get; set; }

    /// <summary>
    /// Gets or sets the star rating of the review.
    /// </summary>
    [Required]
    public Stars Stars { get; set; }

    /// <summary>
    /// Gets or sets the unique identifier for the employee who wrote the review.
    /// </summary>
    [Required, MaxLength(6)]
    public String ReviewerId { get; set; }

    /// <summary>
    /// Gets or sets the employee who wrote the review.
    /// </summary>
    [ForeignKey("ReviewerId")]
    public Employee Reviewer { get; set; }

    /// <summary>
    /// Gets or sets the unique identifier for the employee being reviewed.
    /// </summary>
    [Required, MaxLength(6)]
    public string ReviewedId { get; set; }

    /// <summary>
    /// Gets or sets the employee being reviewed.
    /// </summary>
    [ForeignKey("ReviewedId")]
    public Employee Reviewed { get; set; }
}