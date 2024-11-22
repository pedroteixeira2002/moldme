using System.ComponentModel.DataAnnotations;
using moldme.Models;
namespace moldme.DTOs
{
    /// <summary>
    /// Data transfer object for Project model.
    /// </summary>
    public class ProjectDto
    {
        /// <summary>
        /// Project's unique identifier.
        /// </summary>
        [Required]
        [StringLength(64)]
        public string Name { get; set; }

        /// <summary>
        /// Project's unique identifier.
        /// </summary>
        [Required]
        [StringLength(256)]
        public string Description { get; set; }

        /// <summary>
        /// Project's unique identifier.
        /// </summary>
        [Required]
        public Status Status { get; set; }

        /// <summary>
        /// Project's unique identifier.
        /// </summary>
        [Required]
        [Range(0.01, double.MaxValue, ErrorMessage = "Budget must be greater than zero.")]
        public decimal Budget { get; set; }

        /// <summary>
        /// Project's unique identifier.
        /// </summary>
        [Required]
        public DateTime StartDate { get; set; }

        /// <summary>
        /// Project's unique identifier.
        /// </summary>
        [Required]
        public DateTime EndDate { get; set; }
    }
}
