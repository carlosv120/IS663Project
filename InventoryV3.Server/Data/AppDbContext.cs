using Microsoft.EntityFrameworkCore;
using InventoryV3.Server.Models.Domain;
using System.Collections.Generic;


namespace InventoryV3.Server.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        // Define a DbSet for each table
        public DbSet<User> Users { get; set; } // Add Users table
    }
}
