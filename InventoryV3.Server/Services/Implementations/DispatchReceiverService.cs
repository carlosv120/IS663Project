using Dapper;
using InventoryV3.Server.Models.Domain;
using InventoryV3.Server.Models.Requests;
using InventoryV3.Server.Services.Interfaces;
using Microsoft.Data.SqlClient;
using System.Data;

namespace InventoryV3.Server.Services.Implementations
{
    public class DispatchReceiverService : IDispatchReceiverService
    {
        private readonly IConfiguration _configuration;

        public DispatchReceiverService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<(IEnumerable<DispatchReceiver> DispatchReceivers, int TotalCount)> GetAllDispatchReceiversAsync(int pageIndex, int pageSize)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@PageIndex", pageIndex);
            parameters.Add("@PageSize", pageSize);

            using var multi = await connection.QueryMultipleAsync("dbo.DispatchReceiver_SelectAll", parameters, commandType: CommandType.StoredProcedure);

            // Retrieve total count and list of dispatch receivers
            var totalCount = await multi.ReadSingleAsync<int>();
            var dispatchReceivers = await multi.ReadAsync<DispatchReceiver>();

            return (dispatchReceivers, totalCount);
        }

        public async Task<int> InsertDispatchReceiverAsync(DispatchReceiver dispatchReceiver, int createdBy)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@ReceiverName", dispatchReceiver.ReceiverName);
            parameters.Add("@CompanyName", dispatchReceiver.CompanyName);
            parameters.Add("@ContactNumber", dispatchReceiver.ContactNumber);
            parameters.Add("@Email", dispatchReceiver.Email);
            parameters.Add("@Address", dispatchReceiver.Address);
            parameters.Add("@City", dispatchReceiver.City);
            parameters.Add("@State", dispatchReceiver.State);
            parameters.Add("@PostalCode", dispatchReceiver.PostalCode);
            parameters.Add("@Country", dispatchReceiver.Country);
            parameters.Add("@CreatedBy", createdBy);
            parameters.Add("@ReceiverID", dbType: System.Data.DbType.Int32, direction: System.Data.ParameterDirection.Output);

            await connection.ExecuteAsync("dbo.DispatchReceiver_Insert", parameters, commandType: System.Data.CommandType.StoredProcedure);

            // Retrieve the ReceiverID from the output parameter
            return parameters.Get<int>("@ReceiverID");
        }

        public async Task UpdateDispatchReceiverAsync(int receiverId, DispatchReceiverRequest receiverRequest, int modifiedBy)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@ReceiverID", receiverId);
            parameters.Add("@ReceiverName", receiverRequest.ReceiverName);
            parameters.Add("@CompanyName", receiverRequest.CompanyName);
            parameters.Add("@ContactNumber", receiverRequest.ContactNumber);
            parameters.Add("@Email", receiverRequest.Email);
            parameters.Add("@Address", receiverRequest.Address);
            parameters.Add("@City", receiverRequest.City);
            parameters.Add("@State", receiverRequest.State);
            parameters.Add("@PostalCode", receiverRequest.PostalCode);
            parameters.Add("@Country", receiverRequest.Country);
            parameters.Add("@ModifiedBy", modifiedBy);

            var rowsAffected = await connection.ExecuteAsync("dbo.DispatchReceiver_Update", parameters, commandType: CommandType.StoredProcedure);

            if (rowsAffected == 0)
            {
                throw new KeyNotFoundException($"Dispatch receiver with ID {receiverId} not found.");
            }
        }

        public async Task SoftDeleteDispatchReceiverAsync(int receiverId, int modifiedBy)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@ReceiverID", receiverId);
            parameters.Add("@ModifiedBy", modifiedBy);

            var rowsAffected = await connection.ExecuteAsync("dbo.DispatchReceiver_Delete", parameters, commandType: CommandType.StoredProcedure);

            if (rowsAffected == 0)
            {
                throw new KeyNotFoundException($"Dispatch receiver with ID {receiverId} not found.");
            }
        }

    }

}
