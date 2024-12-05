using InventoryV3.Server.Models.Domain;
using InventoryV3.Server.Models.Requests;

namespace InventoryV3.Server.Services.Interfaces
{
    public interface IDispatchReceiverService
    {
        Task<(IEnumerable<DispatchReceiver> DispatchReceivers, int TotalCount)> GetAllDispatchReceiversAsync(int pageIndex, int pageSize);
        Task<int> InsertDispatchReceiverAsync(DispatchReceiver dispatchReceiver, int createdBy);
        Task UpdateDispatchReceiverAsync(int receiverId, DispatchReceiverRequest receiverRequest, int modifiedBy);
        Task SoftDeleteDispatchReceiverAsync(int receiverId, int modifiedBy);

    }
}
