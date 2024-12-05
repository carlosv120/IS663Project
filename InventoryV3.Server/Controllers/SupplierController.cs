using InventoryV3.Server.Configurations;
using InventoryV3.Server.Models.Domain;
using InventoryV3.Server.Models.Requests;
using InventoryV3.Server.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Security.Claims;

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

        [HttpPost]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> InsertSupplier([FromBody] SupplierRequest supplierRequest)
        {
            Console.WriteLine("InsertSupplier action started.");

            try
            {
                string userIdClaim = User.FindFirst("UserID")?.Value
                                     ?? User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

                if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int createdBy))
                {
                    Console.WriteLine("UserID claim not found or invalid.");
                    return Unauthorized(new { Message = "Invalid user authentication." });
                }

                Console.WriteLine($"Authenticated UserID: {createdBy}");

                var supplier = new Supplier
                {
                    Company = supplierRequest.Company,
                    MainContactName = supplierRequest.MainContactName,
                    MainContactNumber = supplierRequest.MainContactNumber,
                    MainContactEmail = supplierRequest.MainContactEmail
                };

                var supplierId = await _supplierService.InsertSupplierAsync(supplier, createdBy);
                Console.WriteLine($"Supplier inserted with ID: {supplierId}");

                return CreatedAtAction(nameof(InsertSupplier), new { SupplierID = supplierId }, new { SupplierID = supplierId });
            }
            catch (SqlException ex) when (ex.Number == 2627) // Unique constraint violation
            {
                return Conflict(new { Message = "A supplier with the same name already exists." });
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception in InsertSupplier: {ex.Message}");
                return StatusCode(500, new { Message = ex.Message });
            }
        }

        [HttpPut]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> UpdateSupplier([FromBody] SupplierUpdateRequest supplierRequest)
        {
            try
            {
                // Get the UserID directly from the JWT claims
                var userIdClaim = User.Claims.FirstOrDefault(c => c.Type == "UserID")?.Value;
                if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int modifiedBy))
                {
                    return Unauthorized(new { Message = "Invalid user authentication." });
                }

                // Call the service to update the supplier
                await _supplierService.UpdateSupplierAsync(supplierRequest, modifiedBy);

                return Ok(new { Message = "Supplier updated successfully." });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = ex.Message });
            }
        }

        [HttpDelete("{id}")]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> SoftDeleteSupplier(int id)
        {
            try
            {
                // Get the UserID from the JWT claims
                var userIdClaim = User.Claims.FirstOrDefault(c => c.Type == "UserID")?.Value;
                if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int modifiedBy))
                {
                    return Unauthorized(new { Message = "Invalid user authentication." });
                }

                // Call the service to perform the soft delete
                await _supplierService.SoftDeleteSupplierAsync(id, modifiedBy);

                return NoContent(); // 204 No Content
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(new { Message = ex.Message }); // 404 Not Found
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = ex.Message }); // 500 Internal Server Error
            }
        }


    }
}
