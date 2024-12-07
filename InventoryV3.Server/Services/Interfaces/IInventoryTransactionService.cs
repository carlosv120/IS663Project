using InventoryV3.Server.Models.Domain;
using InventoryV3.Server.Models.Requests;

namespace InventoryV3.Server.Services.Interfaces
{
    public interface IInventoryTransactionService
    {
        Task<(IEnumerable<InventoryTransaction> Transactions, int TotalCount)> GetAllTransactionsAsync(int pageIndex, int pageSize);

        Task<int> InsertInventoryTransactionAsync(InventoryTransactionInsertRequest request, int createdBy);

        Task UpdateInventoryTransactionWithDetailsAsync(int transactionId, InventoryTransactionUpdateRequest request, int modifiedBy);

        Task SoftDeleteInventoryTransactionAsync(int transactionId, int modifiedBy);

    }
}
