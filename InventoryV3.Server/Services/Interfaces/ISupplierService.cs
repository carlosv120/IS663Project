using InventoryV3.Server.Models.Domain;

namespace InventoryV3.Server.Services.Interfaces
{
    public interface ISupplierService
    {
        Task<(IEnumerable<Supplier> Suppliers, int TotalCount)> GetAllSuppliersAsync(int pageIndex, int pageSize);
    }
}
