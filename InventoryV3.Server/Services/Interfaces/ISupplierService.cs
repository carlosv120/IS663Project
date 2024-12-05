using InventoryV3.Server.Models.Domain;
using InventoryV3.Server.Models.Requests;

namespace InventoryV3.Server.Services.Interfaces
{
    public interface ISupplierService
    {
        Task<(IEnumerable<Supplier> Suppliers, int TotalCount)> GetAllSuppliersAsync(int pageIndex, int pageSize);

        Task<int> InsertSupplierAsync(Supplier supplier, int createdBy);

        Task UpdateSupplierAsync(int supplierId, SupplierRequest supplierRequest, int modifiedBy);

        Task SoftDeleteSupplierAsync(int supplierId, int modifiedBy);

    }
}
