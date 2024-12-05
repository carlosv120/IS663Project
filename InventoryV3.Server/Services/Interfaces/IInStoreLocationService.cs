using InventoryV3.Server.Models.Domain;
using InventoryV3.Server.Models.Requests;

namespace InventoryV3.Server.Services.Interfaces
{
    public interface IInStoreLocationService
    {
        Task<(IEnumerable<InStoreLocation> Locations, int TotalCount)> GetAllInStoreLocationsAsync(int pageIndex, int pageSize);
        Task<int> InsertInStoreLocationAsync(InStoreLocation location, int createdBy);
        Task UpdateInStoreLocationAsync(int locationId, InStoreLocationRequest locationRequest, int modifiedBy);
        Task SoftDeleteInStoreLocationAsync(int locationId, int modifiedBy);

    }
}
