using InventoryV3.Server.Models.Domain;
using InventoryV3.Server.Models.Requests;

namespace InventoryV3.Server.Services.Interfaces
{
    public interface IInventoryItemService
    {
        Task<(IEnumerable<InventoryItem> Items, int TotalCount)> GetAllInventoryItemsAsync(int pageIndex, int pageSize);
        Task<int> InsertInventoryItemAsync(InventoryItemInsertRequest request, int createdBy);
        Task UpdateInventoryItemWithDetailsAsync(int itemId, InventoryItemUpdateRequest request, int modifiedBy);
        Task SoftDeleteInventoryItemAsync(int itemId, int modifiedBy);
    }

}
