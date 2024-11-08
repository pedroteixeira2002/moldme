using System.ComponentModel.DataAnnotations;
using moldme.Models;
namespace moldme.DTOs
{
    public class ProjectDto
    {
        [Required]
        [StringLength(64)]
        public string Name { get; set; }

        [Required]
        [StringLength(256)]
        public string Description { get; set; }

        [Required]
        public Status Status { get; set; }

        [Required]
        [Range(0.01, double.MaxValue, ErrorMessage = "Budget must be greater than zero.")]
        public decimal Budget { get; set; }

        [Required]
        public DateTime StartDate { get; set; }

        [Required]
        public DateTime EndDate { get; set; }

        [Required]
        public string CompanyId { get; set; }

        
        public List<string> EmployeeIds { get; set; } = new List<string>();
    }
}
