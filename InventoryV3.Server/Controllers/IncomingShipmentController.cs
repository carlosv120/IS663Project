using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using InventoryV3.Server.Services.Interfaces;
using InventoryV3.Server.Models.Requests;
using InventoryV3.Server.Configurations;
using Microsoft.Data.SqlClient;
using InventoryV3.Server.Services.Implementations;

namespace InventoryV3.Server.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class IncomingShipmentController : ControllerBase
    {
        private readonly IIncomingShipmentService _incomingShipmentService;

        public IncomingShipmentController(IIncomingShipmentService incomingShipmentService)
        {
            _incomingShipmentService = incomingShipmentService;
        }

        [HttpGet]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> GetAllIncomingShipments([FromQuery] int pageIndex = 1, [FromQuery] int pageSize = 10)
        {
            try
            {
                var (shipments, totalCount) = await _incomingShipmentService.GetAllIncomingShipmentsAsync(pageIndex, pageSize);

                var metadata = new
                {
                    TotalCount = totalCount,
                    PageIndex = pageIndex,
                    PageSize = pageSize,
                    TotalPages = (int)Math.Ceiling(totalCount / (double)pageSize)
                };

                return Ok(new { Metadata = metadata, Data = shipments });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = ex.Message });
            }
        }


        [HttpPost]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> InsertIncomingShipment([FromBody] IncomingShipmentInsertRequest request)
        {
            try
            {
                // Get UserID from JWT claims
                var userIdClaim = User.Claims.FirstOrDefault(c => c.Type == "UserID")?.Value;
                if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int createdBy))
                {
                    return Unauthorized(new { Message = "Invalid user authentication." });
                }

                // Call the service to insert the incoming shipment
                var incomingShipmentId = await _incomingShipmentService.InsertIncomingShipmentWithDetailsAsync(request, createdBy);

                return CreatedAtAction(nameof(InsertIncomingShipment), new { IncomingShipmentID = incomingShipmentId }, new { IncomingShipmentID = incomingShipmentId });
            }
            catch (SqlException ex) when (ex.Number == 2627) // Unique constraint violation
            {
                return Conflict(new { Message = "An incoming shipment with the same RequestID and TransactionID already exists." });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = ex.Message });
            }
        }

        [HttpPut("{id}")]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> UpdateIncomingShipment(int id, [FromBody] IncomingShipmentUpdateRequest request)
        {
            try
            {
                // Extract UserID from JWT claims
                var userIdClaim = User.Claims.FirstOrDefault(c => c.Type == "UserID")?.Value;
                if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int modifiedBy))
                {
                    return Unauthorized(new { Message = "Invalid user authentication." });
                }

                // Call the service to update the incoming shipment with details
                await _incomingShipmentService.UpdateIncomingShipmentWithDetailsAsync(id, request, modifiedBy);

                return Ok(new { Message = "Incoming shipment updated successfully." });
            }
            catch (SqlException ex) when (ex.Number == 2627) // Unique constraint violation
            {
                return Conflict(new { Message = "An incoming shipment detail with the same IncomingShipmentID and RequestDetailID already exists." });
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(new { Message = ex.Message });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = ex.Message });
            }
        }


        [HttpDelete("{id}")]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> SoftDeleteIncomingShipment(int id)
        {
            try
            {
                // Get UserID from JWT claims
                var userIdClaim = User.Claims.FirstOrDefault(c => c.Type == "UserID")?.Value;
                if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int modifiedBy))
                {
                    return Unauthorized(new { Message = "Invalid user authentication." });
                }

                // Call the service to soft delete the shipment
                await _incomingShipmentService.SoftDeleteIncomingShipmentAsync(id, modifiedBy);

                return NoContent(); // 204 No Content
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(new { Message = ex.Message }); // 404 Not Found
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = ex.Message });
            }
        }

    }


}
