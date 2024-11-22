using System.ComponentModel.DataAnnotations;
using moldme.Models;

namespace moldme.DTOs;

/// <summary>
/// Data transfer object for the review model.
/// </summary>
public class ReviewDto
{
    /// <summary>
    /// The id of the review.
    /// </summary>
    [Required]
    [StringLength(256)]
    public string Comment { get; set; }

    /// <summary>
    /// The stars of the review.
    /// </summary>
    [Required] public Stars Stars { get; set; }
}
