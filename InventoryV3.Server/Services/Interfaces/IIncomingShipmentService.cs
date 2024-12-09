using InventoryV3.Server.Models.Domain;
using InventoryV3.Server.Models.Requests;

namespace InventoryV3.Server.Services.Interfaces
{
    public interface IIncomingShipmentService
    {
        Task<(IEnumerable<IncomingShipment> Shipments, int TotalCount)> GetAllIncomingShipmentsAsync(int pageIndex, int pageSize);
        Task<int> InsertIncomingShipmentWithDetailsAsync(IncomingShipmentInsertRequest request, int createdBy);
        Task UpdateIncomingShipmentWithDetailsAsync(int incomingShipmentID, IncomingShipmentUpdateRequest request, int modifiedBy);
        Task SoftDeleteIncomingShipmentAsync(int incomingShipmentId, int modifiedBy);
    }

}
