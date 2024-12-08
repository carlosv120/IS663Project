using InventoryV3.Server.Models.Requests;

namespace InventoryV3.Server.Services.Interfaces
{
    public interface IIncomingShipmentService
    {
        Task<int> InsertIncomingShipmentWithDetailsAsync(IncomingShipmentInsertRequest request, int createdBy);
    
    
    }

}
