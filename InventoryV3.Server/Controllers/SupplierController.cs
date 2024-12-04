using InventoryV3.Server.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace InventoryV3.Server.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SupplierController : ControllerBase
    {
        private readonly ISupplierService _supplierService;

        public SupplierController(ISupplierService supplierService)
        {
            _supplierService = supplierService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAllSuppliers([FromQuery] int pageIndex = 1, [FromQuery] int pageSize = 10)
        {
            var (suppliers, totalCount) = await _supplierService.GetAllSuppliersAsync(pageIndex, pageSize);

            // Calculate total pages
            var totalPages = (int)Math.Ceiling(totalCount / (double)pageSize);

            var response = new
            {
                Metadata = new
                {
                    TotalCount = totalCount,
                    PageIndex = pageIndex,
                    PageSize = pageSize,
                    TotalPages = totalPages
                },
                Data = suppliers
            };

            return Ok(response);
        }
    }
}
