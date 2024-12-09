using Dapper;
using InventoryV3.Server.Models.Domain;
using InventoryV3.Server.Models.Requests;
using InventoryV3.Server.Services.Interfaces;
using Microsoft.Data.SqlClient;
using Newtonsoft.Json;
using System.Data;

namespace InventoryV3.Server.Services.Implementations
{
    public class IncomingShipmentService : IIncomingShipmentService
    {
        private readonly IConfiguration _configuration;

        public IncomingShipmentService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<(IEnumerable<IncomingShipment> Shipments, int TotalCount)> GetAllIncomingShipmentsAsync(int pageIndex, int pageSize)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@PageIndex", pageIndex);
            parameters.Add("@PageSize", pageSize);

            using var multi = await connection.QueryMultipleAsync("dbo.IncomingShipment_SelectAll", parameters, commandType: CommandType.StoredProcedure);

            var totalCount = await multi.ReadSingleAsync<int>();
            var shipments = await multi.ReadAsync<dynamic>();

            // Parse ShipmentDetails JSON field for proper serialization
            var parsedShipments = shipments.Select(s =>
            {
                var details = string.IsNullOrEmpty((string)s.ShipmentDetails)
                    ? new List<IncomingShipmentDetail>()
                    : JsonConvert.DeserializeObject<List<IncomingShipmentDetail>>((string)s.ShipmentDetails);

                return new IncomingShipment
                {
                    IncomingShipmentID = s.IncomingShipmentID,
                    RequestID = s.RequestID,
                    TransactionID = s.TransactionID,
                    Notes = s.Notes,
                    CreatedByFirstName = s.CreatedByFirstName,
                    CreatedByLastName = s.CreatedByLastName,
                    ModifiedByFirstName = s.ModifiedByFirstName,
                    ModifiedByLastName = s.ModifiedByLastName,
                    DateCreated = s.DateCreated,
                    DateModified = s.DateModified,
                    ShipmentDetails = details
                };
            });

            return (parsedShipments, totalCount);
        }

        public async Task<int> InsertIncomingShipmentWithDetailsAsync(IncomingShipmentInsertRequest request, int createdBy)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            await connection.OpenAsync();

            var parameters = new DynamicParameters();
            parameters.Add("@RequestID", request.RequestID);
            parameters.Add("@TransactionID", request.TransactionID);
            parameters.Add("@Notes", request.Notes);
            parameters.Add("@CreatedBy", createdBy);

            // Convert ShipmentDetailList to JSON string
            var shipmentDetailJson = JsonConvert.SerializeObject(request.ShipmentDetailList);
            Console.WriteLine("Serialized ShipmentDetailList JSON: " + shipmentDetailJson); // Log JSON
            parameters.Add("@ShipmentDetailList", shipmentDetailJson);

            // Execute the stored procedure and retrieve the new IncomingShipmentID
            var incomingShipmentID = await connection.ExecuteScalarAsync<int>("dbo.IncomingShipment_InsertWithDetails", parameters, commandType: CommandType.StoredProcedure);

            return incomingShipmentID;
        }

        public async Task UpdateIncomingShipmentWithDetailsAsync(int incomingShipmentID, IncomingShipmentUpdateRequest request, int modifiedBy)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            await connection.OpenAsync();

            // Prepare parameters for the stored procedure
            var parameters = new DynamicParameters();
            parameters.Add("@IncomingShipmentID", incomingShipmentID);
            parameters.Add("@Notes", request.Notes);
            parameters.Add("@ShipmentDetailList", JsonConvert.SerializeObject(request.ShipmentDetailList));
            parameters.Add("@ModifiedBy", modifiedBy);

            // Execute the stored procedure
            var affectedRows = await connection.ExecuteAsync("dbo.IncomingShipment_UpdateWithDetails", parameters, commandType: CommandType.StoredProcedure);

            // Validate result
            if (affectedRows == 0)
            {
                throw new KeyNotFoundException($"Incoming shipment with ID {incomingShipmentID} not found.");
            }
        }

        public async Task SoftDeleteIncomingShipmentAsync(int incomingShipmentId, int modifiedBy)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@IncomingShipmentID", incomingShipmentId);
            parameters.Add("@ModifiedBy", modifiedBy);

            var rowsAffected = await connection.ExecuteScalarAsync<int>("dbo.IncomingShipment_Delete", parameters, commandType: CommandType.StoredProcedure);

            if (rowsAffected == 0)
            {
                throw new KeyNotFoundException($"IncomingShipment with ID {incomingShipmentId} not found or already inactive.");
            }
        }



    }

}
