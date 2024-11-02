namespace moldme.Models.DTOs
{
    public class EmployeeProfileDTO
    {
        public string EmployeeID { get; set; }
        
        public string Name { get; set; }
        
        public string Profession { get; set; }
        
        public string Email { get; set; }
        
        public int? Contact { get; set; }
        
        public CompanyProfileDto Company { get; set; } 
    }
}