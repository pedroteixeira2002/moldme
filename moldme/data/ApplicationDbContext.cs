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
        public DbSet<Chat> Chats { get; set; }
        public DbSet<Message> Messages { get; set; }
        public DbSet<Offer> Offers { get; set; }
        
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Employee>()
                .HasMany(e => e.Projects)
                .WithMany(p => p.Employees)
                .UsingEntity<Dictionary<string, object>>(
                    "EmployeeProject",
                    j => j
                        .HasOne<Project>()
                        .WithMany()
                        .HasForeignKey("ProjectsProjectId")
                        .OnDelete(DeleteBehavior.Cascade), // Prevent deletion if there are related entries
                    j => j
                        .HasOne<Employee>()
                        .WithMany()
                        .HasForeignKey("EmployeesEmployeeId")
                        .OnDelete(DeleteBehavior.Cascade) // Prevent deletion if there are related entries
                );
            modelBuilder.Entity<Employee>()
                .HasMany(e => e.Reviews) // One Employee has many Reviews
                .WithOne(r => r.Reviewer) // One Review belongs to one Employee
                .HasForeignKey(r => r.ReviewerId) // The foreign key is ReviewerId in Review
                .OnDelete(DeleteBehavior.SetNull);
        }
    }
}