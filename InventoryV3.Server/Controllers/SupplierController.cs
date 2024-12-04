using InventoryV3.Server.Configurations;
using InventoryV3.Server.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace InventoryV3.Server.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class SupplierController : ControllerBase
    {
        private readonly ISupplierService _supplierService;

        public SupplierController(ISupplierService supplierService)
        {
            _supplierService = supplierService;
        }

        [HttpGet]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> GetAllSuppliers([FromQuery] int pageIndex = 1, [FromQuery] int pageSize = 10)
        {
            Console.WriteLine("GetAllSuppliers action started.");

            try
            {
                var (suppliers, totalCount) = await _supplierService.GetAllSuppliersAsync(pageIndex, pageSize);
                Console.WriteLine($"Suppliers retrieved: {suppliers.Count()}");

                var totalPages = (int)Math.Ceiling(totalCount / (double)pageSize);

                Console.WriteLine("GetAllSuppliers action completed.");

                return Ok(new
                {
                    Metadata = new
                    {
                        TotalCount = totalCount,
                        PageIndex = pageIndex,
                        PageSize = pageSize,
                        TotalPages = totalPages
                    },
                    Data = suppliers
                });
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception in GetAllSuppliers: {ex.Message}");
                return StatusCode(500, new { Message = ex.Message });
            }
        }

    }
}
