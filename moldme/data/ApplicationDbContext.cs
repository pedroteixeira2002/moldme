using DefaultNamespace;
using Microsoft.EntityFrameworkCore;
using moldme.Models;

namespace moldme.data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
            
        }

        public DbSet<Company> Companies { get; set; }
        public DbSet<Project> Projects { get; set; }
        
        public DbSet<TodoTask> Tasks { get; set; }
        public DbSet<Employee> Employees { get; set; }
    }
}