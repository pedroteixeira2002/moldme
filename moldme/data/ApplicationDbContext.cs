using DefaultNamespace;
using Microsoft.EntityFrameworkCore;
using moldme.Models;
using Task = moldme.Models.Task;

namespace moldme.data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
            
        }
        

        public DbSet<Company> Companies { get; set; }
        public DbSet<Project> Projects { get; set; }
        public DbSet<Payment> Payments { get; set; }
        public DbSet<Review> Reviews { get; set; }
        public DbSet<Task> Tasks { get; set; }
        public DbSet<Employee> Employees { get; set; }
        public DbSet<StaffOnProject> StaffOnProjects { get; set; }
       
        
    }
    
    
}