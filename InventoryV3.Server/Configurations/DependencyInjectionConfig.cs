using Microsoft.Extensions.DependencyInjection;
using InventoryV3.Server.Services.Interfaces;
using InventoryV3.Server.Services.Implementations;
using InventoryV3.Server.Data;
using Microsoft.EntityFrameworkCore;


namespace InventoryV3.Server.Configurations
{
    public static class DependencyInjectionConfig
    {
        public static IServiceCollection AddApplicationServices(this IServiceCollection services, IConfiguration configuration)
        {
            // Register DbContext with the connection string
            services.AddDbContext<AppDbContext>(options => options.UseSqlServer(configuration.GetConnectionString("DefaultConnection")));


            // Register services
            services.AddScoped<ITestService, TestService>();


            // Register SupplierService
            services.AddScoped<ISupplierService, SupplierService>();


            //Register UserService
            services.AddScoped<IUserService, UserService>();

            // Register the PatientService
            services.AddScoped<IPatientService, PatientService>();

            // Register The InStoreLocationService
            services.AddScoped<IInStoreLocationService, InStoreLocationService>();


            // Add more services here as needed
            return services;
        }
    }
}
