    namespace moldme.DTOs
{
    /// <summary>
    /// Represents a data transfer object for a company profile.
    /// </summary>
    public class CompanyProfileDto
    {
        /// <summary>
        /// Gets or sets the name of the company.
        /// </summary>
        public string Name { get; set; }
        
        /// <summary>
        /// Gets or sets the tax identification number of the company.
        /// </summary>
        public string Address { get; set; }
        
        /// <summary>
        /// Gets or sets the contact number of the company.
        /// </summary>
        public int Contact { get; set; }
        
        /// <summary>
        /// Gets or sets the email of the company.
        /// </summary>
        public string Email { get; set; }
        
        /// <summary>
        /// Gets or sets the sector of the company.
        /// </summary>
        public string Sector { get; set; }
    }
}