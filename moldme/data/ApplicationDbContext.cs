using Microsoft.EntityFrameworkCore;

namespace moldme.data;

public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options): base(options)
    {
    }
    
    
}