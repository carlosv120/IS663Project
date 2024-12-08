using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using InventoryV3.Server.Services.Interfaces;
using InventoryV3.Server.Models.Requests;
using InventoryV3.Server.Configurations;
using Microsoft.Data.SqlClient;

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

    }


}
