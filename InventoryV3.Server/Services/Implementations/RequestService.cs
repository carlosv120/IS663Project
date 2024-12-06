using Dapper;
using InventoryV3.Server.Models.Domain;
using InventoryV3.Server.Models.Requests;
using InventoryV3.Server.Services.Interfaces;
using Microsoft.Data.SqlClient;
using Newtonsoft.Json;
using System.Data;

namespace InventoryV3.Server.Services.Implementations
{
    public class RequestService : IRequestService
    {
        private readonly IConfiguration _configuration;

        public RequestService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<(IEnumerable<object> Requests, int TotalCount)> GetAllRequestsAsync(int pageIndex, int pageSize)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@PageIndex", pageIndex);
            parameters.Add("@PageSize", pageSize);

            using var multi = await connection.QueryMultipleAsync( "dbo.Request_SelectAll", parameters, commandType: CommandType.StoredProcedure);

            var totalCount = await multi.ReadSingleAsync<int>();
            var requests = await multi.ReadAsync<dynamic>();

            // Parse requestDetails JSON field for proper serialization
            var parsedRequests = requests.Select(r =>
            {
                var details = JsonConvert.DeserializeObject<List<RequestDetail>>(r.RequestDetails.ToString());
                return new
                {
                    r.RequestID,
                    r.AlertID,
                    r.DateRequested,
                    r.IsApproved,
                    r.DateApproved,
                    r.TransactionID,
                    r.RequestIsCompleted,
                    r.RequestNotes,
                    r.RequestIsActive,
                    r.CreatedByFirstName,
                    r.CreatedByLastName,
                    r.ModifiedByFirstName,
                    r.ModifiedByLastName,
                    r.DateCreated,
                    r.DateModified,
                    RequestDetails = details // Properly deserialize requestDetails
                };
            });

            return (parsedRequests, totalCount);
        }

        public async Task<int> InsertRequestWithDetailsAsync(RequestInsertRequest request, int createdBy)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@AlertID", request.AlertID);
            parameters.Add("@DateRequested", request.DateRequested ?? DateTime.UtcNow);
            parameters.Add("@Notes", request.Notes);
            parameters.Add("@CreatedBy", createdBy);

            // Convert RequestDetailList to JSON string
            var requestDetailJson = JsonConvert.SerializeObject(request.RequestDetailList);
            parameters.Add("@RequestDetailList", requestDetailJson);

            // Execute the stored procedure and retrieve the new RequestID
            var requestId = await connection.ExecuteScalarAsync<int>("dbo.Request_InsertWithDetails",parameters,commandType: CommandType.StoredProcedure);

            return requestId;
        }

        public async Task UpdateRequestWithDetailsAsync(int requestId, RequestUpdateRequest request, int modifiedBy)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@RequestID", requestId);
            parameters.Add("@AlertID", request.AlertID);
            parameters.Add("@Notes", request.Notes);
            parameters.Add("@ModifiedBy", modifiedBy);

            // Convert RequestDetailList to JSON string
            var requestDetailJson = JsonConvert.SerializeObject(request.RequestDetailList);
            parameters.Add("@RequestDetailList", requestDetailJson);

            var rowsAffected = await connection.ExecuteAsync("dbo.Request_UpdateWithDetails",parameters,commandType: CommandType.StoredProcedure);

            if (rowsAffected == 0)
            {
                throw new KeyNotFoundException($"Request with ID {requestId} not found.");
            }
        }

        public async Task SoftDeleteRequestAsync(int requestId, int modifiedBy)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@RequestID", requestId);
            parameters.Add("@ModifiedBy", modifiedBy);

            var rowsAffected = await connection.ExecuteAsync("dbo.Request_Delete", parameters, commandType: CommandType.StoredProcedure);

            if (rowsAffected == 0)
            {
                throw new KeyNotFoundException($"Request with ID {requestId} not found.");
            }
        }

    }
}
