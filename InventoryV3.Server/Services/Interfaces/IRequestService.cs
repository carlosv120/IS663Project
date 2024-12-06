using InventoryV3.Server.Models.Requests;

namespace InventoryV3.Server.Services.Interfaces
{
    public interface IRequestService
    {
        Task<(IEnumerable<object> Requests, int TotalCount)> GetAllRequestsAsync(int pageIndex, int pageSize);

        Task<int> InsertRequestWithDetailsAsync(RequestInsertRequest request, int createdBy);

        Task UpdateRequestWithDetailsAsync(int requestId, RequestUpdateRequest request, int modifiedBy);

        Task SoftDeleteRequestAsync(int requestId, int modifiedBy);

    }
}
