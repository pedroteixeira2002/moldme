using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DefaultNamespace;

    public class StaffOnProject
    {
        [Key]
        [StringLength(6)]
        [Required]
        public string Id { get; set; }
        [StringLength(6)]
        [ForeignKey("Staff")]
        [Required]
        public string EmployeeId { get; set; }
        [StringLength(6)]
        [ForeignKey("Project")]
        [Required]
        public string ProjectId { get; set; }

    }
