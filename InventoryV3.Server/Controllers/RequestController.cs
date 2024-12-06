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
    public class RequestController : ControllerBase
    {
        private readonly IRequestService _requestService;

        public RequestController(IRequestService requestService)
        {
            _requestService = requestService;
        }

        [HttpGet]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> GetAllRequests([FromQuery] int pageIndex = 1, [FromQuery] int pageSize = 10)
        {
            try
            {
                var (requests, totalCount) = await _requestService.GetAllRequestsAsync(pageIndex, pageSize);

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
                    Data = requests
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = ex.Message });
            }
        }

        [HttpPost]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> InsertRequest([FromBody] RequestInsertRequest request)
        {
            try
            {
                // Get UserID from JWT claims
                var userIdClaim = User.Claims.FirstOrDefault(c => c.Type == "UserID")?.Value;
                if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int createdBy))
                {
                    return Unauthorized(new { Message = "Invalid user authentication." });
                }

                // Call the service to insert the request
                var requestId = await _requestService.InsertRequestWithDetailsAsync(request, createdBy);

                return CreatedAtAction(nameof(InsertRequest), new { RequestID = requestId });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = ex.Message });
            }
        }

        [HttpPut("{id}")]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> UpdateRequest(int id, [FromBody] RequestUpdateRequest request)
        {
            try
            {
                // Get UserID from JWT claims
                var userIdClaim = User.Claims.FirstOrDefault(c => c.Type == "UserID")?.Value;
                if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int modifiedBy))
                {
                    return Unauthorized(new { Message = "Invalid user authentication." });
                }

                // Call the service to update the request
                await _requestService.UpdateRequestWithDetailsAsync(id, request, modifiedBy);

                return Ok(new { Message = "Request updated successfully." });
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

        [HttpDelete("{id}")]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> SoftDeleteRequest(int id)
        {
            try
            {
                // Get UserID from JWT claims
                var userIdClaim = User.Claims.FirstOrDefault(c => c.Type == "UserID")?.Value;
                if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int modifiedBy))
                {
                    return Unauthorized(new { Message = "Invalid user authentication." });
                }

                // Call the service to perform the soft delete
                await _requestService.SoftDeleteRequestAsync(id, modifiedBy);

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
