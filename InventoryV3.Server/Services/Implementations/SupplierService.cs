using Dapper;
using InventoryV3.Server.Models.Domain;
using InventoryV3.Server.Models.Requests;
using InventoryV3.Server.Services.Interfaces;
using Microsoft.Data.SqlClient;
using System.Data;

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

        public async Task<int> InsertSupplierAsync(Supplier supplier, int createdBy)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@Company", supplier.Company);
            parameters.Add("@MainContactName", supplier.MainContactName);
            parameters.Add("@MainContactNumber", supplier.MainContactNumber);
            parameters.Add("@MainContactEmail", supplier.MainContactEmail);
            parameters.Add("@CreatedBy", createdBy);
            parameters.Add("@SupplierID", dbType: System.Data.DbType.Int32, direction: System.Data.ParameterDirection.Output);

            await connection.ExecuteAsync("dbo.Suppliers_Insert", parameters, commandType: System.Data.CommandType.StoredProcedure);

            // Retrieve the SupplierID from the output parameter
            return parameters.Get<int>("@SupplierID");
        }

        public async Task UpdateSupplierAsync(int supplierId, SupplierRequest supplierRequest, int modifiedBy)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@SupplierID", supplierId);
            parameters.Add("@Company", supplierRequest.Company);
            parameters.Add("@MainContactName", supplierRequest.MainContactName);
            parameters.Add("@MainContactNumber", supplierRequest.MainContactNumber);
            parameters.Add("@MainContactEmail", supplierRequest.MainContactEmail);
            parameters.Add("@ModifiedBy", modifiedBy);

            var rowsAffected = await connection.ExecuteAsync(
                "dbo.Suppliers_Update",
                parameters,
                commandType: CommandType.StoredProcedure
            );

            if (rowsAffected == 0)
            {
                throw new KeyNotFoundException($"Supplier with ID {supplierId} not found.");
            }
        }

        public async Task SoftDeleteSupplierAsync(int supplierId, int modifiedBy)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@SupplierID", supplierId);
            parameters.Add("@ModifiedBy", modifiedBy);

            var rowsAffected = await connection.ExecuteAsync(
                "dbo.Suppliers_Delete",
                parameters,
                commandType: System.Data.CommandType.StoredProcedure
            );

            if (rowsAffected == 0)
            {
                throw new KeyNotFoundException($"Supplier with ID {supplierId} not found.");
            }
        }

    }
}
