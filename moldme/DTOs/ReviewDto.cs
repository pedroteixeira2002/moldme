using System.ComponentModel.DataAnnotations;
using moldme.Models;

namespace moldme.DTOs;

public class ReviewDto
{
    [Required]
    [StringLength(256)]
    public string Comment { get; set; }

    [Required]
    public Stars Stars { get; set; }

    [Required]
    [MaxLength(6)]
    public string ReviewerId { get; set; }  

    [Required]
    [MaxLength(6)]
    public string ReviewedId { get; set; }  
}
