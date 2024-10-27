using DefaultNamespace;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace moldme.data;

public class MoldmeContext : DbContext
{
    public MoldmeContext(DbContextOptions<MoldmeContext> options): base(options)
    { }
    
    public DbSet<Company> Companies { get; set; }
    
    
}