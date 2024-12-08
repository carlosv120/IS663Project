using Microsoft.AspNetCore.Mvc;
using InventoryV3.Server.Services.Interfaces;
using InventoryV3.Server.Configurations;
using InventoryV3.Server.Models.Requests;

namespace InventoryV3.Server.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class InventoryItemController : ControllerBase
    {
        private readonly IInventoryItemService _inventoryItemService;

        public InventoryItemController(IInventoryItemService inventoryItemService)
        {
            _inventoryItemService = inventoryItemService;
        }

        [HttpGet]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> GetAllInventoryItems([FromQuery] int pageIndex = 1, [FromQuery] int pageSize = 10)
        {
            try
            {
                var (items, totalCount) = await _inventoryItemService.GetAllInventoryItemsAsync(pageIndex, pageSize);

                return Ok(new
                {
                    TotalCount = totalCount,
                    PageIndex = pageIndex,
                    PageSize = pageSize,
                    Items = items
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = ex.Message });
            }
        }


        [HttpPost]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> InsertInventoryItem([FromBody] InventoryItemInsertRequest request)
        {
            try
            {
                // Get UserID from JWT claims
                var userIdClaim = User.Claims.FirstOrDefault(c => c.Type == "UserID")?.Value;
                if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int createdBy))
                {
                    return Unauthorized(new { Message = "Invalid user authentication." });
                }

                // Call the service to insert the inventory item
                var itemId = await _inventoryItemService.InsertInventoryItemAsync(request, createdBy);

                return CreatedAtAction(nameof(InsertInventoryItem), new { ItemID = itemId });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = ex.Message });
            }
        }

        [HttpPut("{id}")]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> UpdateInventoryItem(int id, [FromBody] InventoryItemUpdateRequest request)
        {
            try
            {
                // Get UserID from JWT claims
                var userIdClaim = User.Claims.FirstOrDefault(c => c.Type == "UserID")?.Value;
                if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int modifiedBy))
                {
                    return Unauthorized(new { Message = "Invalid user authentication." });
                }

                // Call the service to update the inventory item
                await _inventoryItemService.UpdateInventoryItemWithDetailsAsync(id, request, modifiedBy);

                return Ok(new { Message = "Inventory item updated successfully." });
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

        [HttpDelete("{id}")]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> DeleteInventoryItem(int id)
        {
            try
            {
                // Get UserID from JWT claims
                var userIdClaim = User.Claims.FirstOrDefault(c => c.Type == "UserID")?.Value;
                if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int modifiedBy))
                {
                    return Unauthorized(new { Message = "Invalid user authentication." });
                }

                // Call the service to soft delete the inventory item
                await _inventoryItemService.SoftDeleteInventoryItemAsync(id, modifiedBy);

                return NoContent(); // 204 No Content
            }
            catch (KeyNotFoundException)
            {
                return NotFound(new { Message = $"Inventory item with ID {id} not found." }); // 404 Not Found
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = ex.Message }); // 500 Internal Server Error
            }
        }


    }


}
