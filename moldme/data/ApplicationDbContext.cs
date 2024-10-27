using DefaultNamespace;
using Microsoft.EntityFrameworkCore;

namespace moldme.data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
            
        }

        public DbSet<Company> Companies { get; set; }
        public DbSet<Project> Projects { get; set; }
    }
}