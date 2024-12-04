using Dapper;
using InventoryV3.Server.Models.Domain;
using InventoryV3.Server.Services.Interfaces;
using Microsoft.Data.SqlClient;

namespace InventoryV3.Server.Services.Implementations
{
    public class SupplierService : ISupplierService
    {
        private readonly IConfiguration _configuration;

        public SupplierService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<(IEnumerable<Supplier> Suppliers, int TotalCount)> GetAllSuppliersAsync(int pageIndex, int pageSize)
        {
            Console.WriteLine("GetAllSuppliersAsync started.");

            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            await connection.OpenAsync();

            var parameters = new DynamicParameters();
            parameters.Add("@PageIndex", pageIndex);
            parameters.Add("@PageSize", pageSize);

            Console.WriteLine("Executing stored procedure.");

            using var multi = await connection.QueryMultipleAsync(
                "dbo.Suppliers_SelectAll",
                parameters,
                commandType: System.Data.CommandType.StoredProcedure
            );

            var totalCount = await multi.ReadSingleAsync<int>();
            var suppliers = await multi.ReadAsync<Supplier>();

            Console.WriteLine("GetAllSuppliersAsync completed.");

            return (suppliers, totalCount);
        }


    }
}
