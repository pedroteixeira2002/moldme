namespace moldme.DTOs
{
    /// <summary>
    /// Represents a data transfer object for an employee profile.
    /// </summary>
    public class EmployeeProfileDTO
    {
        /// <summary>
        /// Gets or sets the name of the employee.
        /// </summary>
        public string Name { get; set; }
        
        /// <summary>
        /// Gets or sets the profession of the employee.
        /// </summary>
        public string Profession { get; set; }
        
        /// <summary>
        /// Gets or sets the tax identification number of the employee.
        /// </summary>
        public string Email { get; set; }
        
        /// <summary>
        /// Gets or sets the email of the employee.
        /// </summary>
        public int? Contact { get; set; }
        
        /// <summary>
        /// Gets or sets the contact number of the employee.
        /// </summary>
        public CompanyProfileDto Company { get; set; } 
    }
}