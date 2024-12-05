using InventoryV3.Server.Configurations;
using InventoryV3.Server.Models.Domain;
using InventoryV3.Server.Models.Requests;
using InventoryV3.Server.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace InventoryV3.Server.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class DispatchReceiverController : ControllerBase
    {
        private readonly IDispatchReceiverService _dispatchReceiverService;

        public DispatchReceiverController(IDispatchReceiverService dispatchReceiverService)
        {
            _dispatchReceiverService = dispatchReceiverService;
        }

        [HttpGet]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> GetAllDispatchReceivers([FromQuery] int pageIndex = 1, [FromQuery] int pageSize = 10)
        {
            try
            {
                var (dispatchReceivers, totalCount) = await _dispatchReceiverService.GetAllDispatchReceiversAsync(pageIndex, pageSize);

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
                    Data = dispatchReceivers
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = ex.Message });
            }
        }


        [HttpPost]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> InsertDispatchReceiver([FromBody] DispatchReceiverRequest dispatchReceiverRequest)
        {
            try
            {
                // Get UserID from JWT claims
                var userIdClaim = User.Claims.FirstOrDefault(c => c.Type == "UserID")?.Value;
                if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int createdBy))
                {
                    return Unauthorized(new { Message = "Invalid user authentication." });
                }

                // Map the request model to the domain model
                var dispatchReceiver = new DispatchReceiver
                {
                    ReceiverName = dispatchReceiverRequest.ReceiverName,
                    CompanyName = dispatchReceiverRequest.CompanyName,
                    ContactNumber = dispatchReceiverRequest.ContactNumber,
                    Email = dispatchReceiverRequest.Email,
                    Address = dispatchReceiverRequest.Address,
                    City = dispatchReceiverRequest.City,
                    State = dispatchReceiverRequest.State,
                    PostalCode = dispatchReceiverRequest.PostalCode,
                    Country = dispatchReceiverRequest.Country
                };

                var receiverId = await _dispatchReceiverService.InsertDispatchReceiverAsync(dispatchReceiver, createdBy);

                return CreatedAtAction(nameof(InsertDispatchReceiver), new { ReceiverID = receiverId });
            }
            catch (SqlException ex) when (ex.Number == 2627) // Unique constraint violation
            {
                return Conflict(new { Message = "A dispatch receiver with the same name and company already exists." });
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception in InsertDispatchReceiver: {ex.Message}");
                return StatusCode(500, new { Message = ex.Message });
            }
        }

        [HttpPut("{id}")]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> UpdateDispatchReceiver(int id, [FromBody] DispatchReceiverRequest receiverRequest)
        {
            try
            {
                // Get UserID from JWT claims
                var userIdClaim = User.Claims.FirstOrDefault(c => c.Type == "UserID")?.Value;
                if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int modifiedBy))
                {
                    return Unauthorized(new { Message = "Invalid user authentication." });
                }

                // Call the service to update the dispatch receiver
                await _dispatchReceiverService.UpdateDispatchReceiverAsync(id, receiverRequest, modifiedBy);

                return Ok(new { Message = "Dispatch receiver updated successfully." });
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(new { Message = ex.Message }); // 404 Not Found
            }
            catch (SqlException ex) when (ex.Number == 2627) // Unique constraint violation
            {
                return Conflict(new { Message = "A dispatch receiver with the same details already exists." });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = ex.Message }); // 500 Internal Server Error
            }
        }

        [HttpDelete("{id}")]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> SoftDeleteDispatchReceiver(int id)
        {
            try
            {
                // Get UserID directly from the JWT claims
                var userIdClaim = User.Claims.FirstOrDefault(c => c.Type == "UserID")?.Value;
                if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int modifiedBy))
                {
                    return Unauthorized(new { Message = "Invalid user authentication." });
                }

                // Call the service to soft delete the dispatch receiver
                await _dispatchReceiverService.SoftDeleteDispatchReceiverAsync(id, modifiedBy);

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
