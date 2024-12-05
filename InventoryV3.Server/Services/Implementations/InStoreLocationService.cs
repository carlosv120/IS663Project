using Dapper;
using InventoryV3.Server.Models.Domain;
using InventoryV3.Server.Models.Requests;
using InventoryV3.Server.Services.Interfaces;
using Microsoft.Data.SqlClient;
using System.Data;
using System.Security.Cryptography.X509Certificates;

namespace InventoryV3.Server.Services.Implementations
{
    public class InStoreLocationService : IInStoreLocationService
    {
        private readonly IConfiguration _configuration;

        public InStoreLocationService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<(IEnumerable<InStoreLocation> Locations, int TotalCount)> GetAllInStoreLocationsAsync(int pageIndex, int pageSize)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@PageIndex", pageIndex);
            parameters.Add("@PageSize", pageSize);

            using var multi = await connection.QueryMultipleAsync(
                "dbo.InStoreLocations_SelectAll",
                parameters,
                commandType: System.Data.CommandType.StoredProcedure
            );

            // Retrieve the total count and list of locations
            var totalCount = await multi.ReadSingleAsync<int>();
            var locations = await multi.ReadAsync<InStoreLocation>();

            return (locations, totalCount);
        }

        public async Task<int> InsertInStoreLocationAsync(InStoreLocation location, int createdBy)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@LocationName", location.LocationName);
            parameters.Add("@Description", location.Description);
            parameters.Add("@Zone", location.Zone);
            parameters.Add("@SubZone", location.SubZone);
            parameters.Add("@Bin", location.Bin);
            parameters.Add("@CreatedBy", createdBy);
            parameters.Add("@LocationID", dbType: System.Data.DbType.Int32, direction: System.Data.ParameterDirection.Output);

            await connection.ExecuteAsync("dbo.InStoreLocations_Insert", parameters, commandType: System.Data.CommandType.StoredProcedure);

            // Retrieve the SupplierID from the output parameter
            return parameters.Get<int>("@LocationID");
        }

        public async Task UpdateInStoreLocationAsync(int locationId, InStoreLocationRequest locationRequest, int modifiedBy)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@LocationID", locationId);
            parameters.Add("@LocationName", locationRequest.LocationName);
            parameters.Add("@Description", locationRequest.Description);
            parameters.Add("@Zone", locationRequest.Zone);
            parameters.Add("@SubZone", locationRequest.SubZone);
            parameters.Add("@Bin", locationRequest.Bin);
            parameters.Add("@ModifiedBy", modifiedBy);

            var rowsAffected = await connection.ExecuteAsync("dbo.InStoreLocations_Update", parameters, commandType: CommandType.StoredProcedure);

            if (rowsAffected == 0)
            {
                throw new KeyNotFoundException($"In-store location with ID {locationId} not found.");
            }
        }

        public async Task SoftDeleteInStoreLocationAsync(int locationId, int modifiedBy)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@LocationID", locationId);
            parameters.Add("@ModifiedBy", modifiedBy);

            var rowsAffected = await connection.ExecuteAsync("dbo.InStoreLocations_Delete", parameters, commandType: CommandType.StoredProcedure);

            if (rowsAffected == 0)
            {
                throw new KeyNotFoundException($"In-store location with ID {locationId} not found.");
            }
        }


    }
}
