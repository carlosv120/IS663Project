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
            try
            {
                var (suppliers, totalCount) = await _supplierService.GetAllSuppliersAsync(pageIndex, pageSize);

                var totalPages = (int)Math.Ceiling(totalCount / (double)pageSize);

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
                return StatusCode(500, new { Message = ex.Message });
            }
        }

        [HttpPost]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> InsertSupplier([FromBody] SupplierRequest supplierRequest)
        {
            try
            {
                var userIdClaim = User.Claims.FirstOrDefault(c => c.Type == "UserID")?.Value;
                if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int createdBy))
                {
                    return Unauthorized(new { Message = "Invalid user authentication." });
                }

                var supplier = new Supplier
                {
                    Company = supplierRequest.Company,
                    MainContactName = supplierRequest.MainContactName,
                    MainContactNumber = supplierRequest.MainContactNumber,
                    MainContactEmail = supplierRequest.MainContactEmail
                };

                var supplierId = await _supplierService.InsertSupplierAsync(supplier, createdBy);

                return CreatedAtAction(nameof(InsertSupplier), new { SupplierID = supplierId });
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

        [HttpPut("{id}")]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> UpdateSupplier(int id, [FromBody] SupplierRequest supplierRequest)
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
                await _supplierService.UpdateSupplierAsync(id, supplierRequest, modifiedBy);

                return Ok(new { Message = "Supplier updated successfully." });
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(new { Message = ex.Message }); // 404 Not Found
            }
            catch (SqlException ex) when (ex.Number == 2627) // Unique constraint violation
            {
                return Conflict(new { Message = "A supplier with the same name already exists." });
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
