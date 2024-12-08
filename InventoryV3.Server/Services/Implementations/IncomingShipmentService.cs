using Dapper;
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



    }

}
