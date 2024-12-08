using Dapper;
using InventoryV3.Server.Models.Domain;
using InventoryV3.Server.Models.Requests;
using InventoryV3.Server.Services.Interfaces;
using Microsoft.Data.SqlClient;
using Newtonsoft.Json;
using System.Data;

namespace InventoryV3.Server.Services.Implementations
{
    public class InventoryItemService : IInventoryItemService
    {
        private readonly IConfiguration _configuration;

        public InventoryItemService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<(IEnumerable<InventoryItem> Items, int TotalCount)> GetAllInventoryItemsAsync(int pageIndex, int pageSize)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@PageIndex", pageIndex);
            parameters.Add("@PageSize", pageSize);

            using var multi = await connection.QueryMultipleAsync("dbo.InventoryItem_SelectAll", parameters, commandType: CommandType.StoredProcedure);

            var totalCount = await multi.ReadSingleAsync<int>();
            var items = await multi.ReadAsync<dynamic>();

            var parsedItems = items.Select(i =>
            {
                var details = string.IsNullOrEmpty((string)i.ItemDetails)
                    ? new List<InventoryItemDetail>()
                    : JsonConvert.DeserializeObject<List<InventoryItemDetail>>(i.ItemDetails.ToString());

                return new InventoryItem
                {
                    ItemID = i.ItemID,
                    StatusID = i.StatusID,
                    Name = i.Name,
                    Description = i.Description,
                    Category = i.Category,
                    Notes = i.Notes,
                    CreatedByFirstName = i.CreatedByFirstName,
                    CreatedByLastName = i.CreatedByLastName,
                    ModifiedByFirstName = i.ModifiedByFirstName,
                    ModifiedByLastName = i.ModifiedByLastName,
                    DateCreated = i.DateCreated,
                    DateModified = i.DateModified,
                    ItemDetails = details
                };
            });

            return (parsedItems, totalCount);
        }

        public async Task<int> InsertInventoryItemAsync(InventoryItemInsertRequest request, int createdBy)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            await connection.OpenAsync();

            var parameters = new DynamicParameters();
            parameters.Add("@StatusID", request.StatusID);
            parameters.Add("@Name", request.Name);
            parameters.Add("@Description", request.Description);
            parameters.Add("@Category", request.Category);
            parameters.Add("@Notes", request.Notes);
            parameters.Add("@CreatedBy", createdBy);

            // Convert ItemDetailList to JSON string
            var itemDetailJson = JsonConvert.SerializeObject(request.ItemDetailList);
            parameters.Add("@ItemDetailList", itemDetailJson);

            // Execute the stored procedure and retrieve the new ItemID
            var itemId = await connection.ExecuteScalarAsync<int>("dbo.InventoryItem_InsertWithDetails", parameters, commandType: CommandType.StoredProcedure);

            return itemId;
        }

        public async Task UpdateInventoryItemWithDetailsAsync(int itemId, InventoryItemUpdateRequest request, int modifiedBy)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            await connection.OpenAsync();

            var parameters = new DynamicParameters();
            parameters.Add("@ItemID", itemId);
            parameters.Add("@StatusID", request.StatusID);
            parameters.Add("@Name", request.Name);
            parameters.Add("@Description", request.Description);
            parameters.Add("@Category", request.Category);
            parameters.Add("@Notes", request.Notes);
            parameters.Add("@ModifiedBy", modifiedBy);

            // Convert ItemDetailList to JSON string
            var itemDetailJson = JsonConvert.SerializeObject(request.ItemDetailList);
            parameters.Add("@ItemDetailList", itemDetailJson);

            // Execute the stored procedure
            var rowsAffected = await connection.ExecuteAsync("dbo.InventoryItem_UpdateWithDetails", parameters, commandType: CommandType.StoredProcedure);

            if (rowsAffected == 0)
            {
                throw new KeyNotFoundException($"InventoryItem with ID {itemId} not found.");
            }
        }

        public async Task SoftDeleteInventoryItemAsync(int itemId, int modifiedBy)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            await connection.OpenAsync();

            var parameters = new DynamicParameters();
            parameters.Add("@ItemID", itemId);
            parameters.Add("@ModifiedBy", modifiedBy);

            try
            {
                await connection.ExecuteAsync("dbo.InventoryItem_Delete", parameters, commandType: CommandType.StoredProcedure);
            }
            catch (SqlException ex) when (ex.Number == 50000)
            {
                throw new InvalidOperationException(ex.Message); // Handle custom error from stored procedure
            }
        }


    }

}
