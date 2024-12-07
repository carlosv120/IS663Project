using Azure.Core;
using Dapper;
using InventoryV3.Server.Models.Domain;
using InventoryV3.Server.Models.Requests;
using InventoryV3.Server.Services.Interfaces;
using Microsoft.Data.SqlClient;
using Newtonsoft.Json;
using System.Data;

namespace InventoryV3.Server.Services.Implementations
{
    public class InventoryTransactionService : IInventoryTransactionService
    {
        private readonly IConfiguration _configuration;

        public InventoryTransactionService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<(IEnumerable<InventoryTransaction> Transactions, int TotalCount)> GetAllTransactionsAsync(int pageIndex, int pageSize)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@PageIndex", pageIndex);
            parameters.Add("@PageSize", pageSize);

            using var multi = await connection.QueryMultipleAsync("dbo.InventoryTransaction_SelectAll", parameters, commandType: CommandType.StoredProcedure);

            var totalCount = await multi.ReadSingleAsync<int>();
            var transactions = await multi.ReadAsync<dynamic>();

            // Parse TransactionDetails JSON field for proper serialization
            var parsedTransactions = transactions.Select(t =>
            {
                var details = string.IsNullOrEmpty((string)t.TransactionDetails)
                    ? new List<InventoryTransactionDetail>()
                    : JsonConvert.DeserializeObject<List<InventoryTransactionDetail>>((string)t.TransactionDetails);

                return new InventoryTransaction
                {
                    TransactionID = t.TransactionID,
                    StatusID = t.StatusID,
                    IsRequest = t.IsRequest,
                    RequestID = t.RequestID,
                    TransactionNotes = t.TransactionNotes,
                    CreatedByFirstName = t.CreatedByFirstName,
                    CreatedByLastName = t.CreatedByLastName,
                    ModifiedByFirstName = t.ModifiedByFirstName,
                    ModifiedByLastName = t.ModifiedByLastName,
                    DateCreated = t.DateCreated,
                    DateModified = t.DateModified,
                    TransactionDetails = details
                };
            });

            return (parsedTransactions, totalCount);
        }

        public async Task<int> InsertInventoryTransactionAsync(InventoryTransactionInsertRequest request, int createdBy)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            await connection.OpenAsync();

            var parameters = new DynamicParameters();
            parameters.Add("@StatusID", request.StatusID);
            parameters.Add("@IsRequest", request.IsRequest);
            parameters.Add("@RequestID", request.RequestID);
            parameters.Add("@Notes", request.Notes);
            parameters.Add("@CreatedBy", createdBy);

            // Convert TransactionDetailList to JSON string
            var transactionDetailJson = JsonConvert.SerializeObject(request.TransactionDetailList);
            parameters.Add("@TransactionDetailList", transactionDetailJson);

            // Execute the stored procedure and retrieve the new TransactionID
            var transactionId = await connection.ExecuteScalarAsync<int>("dbo.InventoryTransaction_Insert",parameters, commandType: CommandType.StoredProcedure );

            return transactionId;
        }

        public async Task UpdateInventoryTransactionWithDetailsAsync(int transactionId, InventoryTransactionUpdateRequest request, int modifiedBy)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@TransactionID", transactionId);
            parameters.Add("@StatusID", request.StatusID);
            parameters.Add("@IsRequest", request.IsRequest);
            parameters.Add("@RequestID", request.RequestID);
            parameters.Add("@Notes", request.Notes);
            parameters.Add("@ModifiedBy", modifiedBy);

            var transactionDetailJson = JsonConvert.SerializeObject(request.TransactionDetails);
            parameters.Add("@TransactionDetailList", transactionDetailJson);

            var rowsAffected = await connection.ExecuteAsync(
                "dbo.InventoryTransaction_UpdateWithDetails",
                parameters,
                commandType: CommandType.StoredProcedure);

            if (rowsAffected == 0)
            {
                throw new KeyNotFoundException($"Transaction with ID {transactionId} not found.");
            }
        }

        public async Task SoftDeleteInventoryTransactionAsync(int transactionId, int modifiedBy)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@TransactionID", transactionId);
            parameters.Add("@ModifiedBy", modifiedBy);

            var rowsAffected = await connection.ExecuteScalarAsync<int>("dbo.InventoryTransaction_Delete", parameters, commandType: CommandType.StoredProcedure );

            if (rowsAffected == 0)
            {
                throw new KeyNotFoundException($"TransactionID with ID {transactionId} not found.");
            }
        }

    }
}
