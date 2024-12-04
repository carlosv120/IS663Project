using InventoryV3.Server.Models.Domain;
using InventoryV3.Server.Models.Requests;
using InventoryV3.Server.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace InventoryV3.Server.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UserController : ControllerBase
    {
        private readonly IUserService _userService;

        public UserController(IUserService userService)
        {
            _userService = userService;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterRequest registerRequest)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var user = new User
            {
                Username = registerRequest.Username,
                PasswordHash = registerRequest.PasswordHash,
                FirstName = registerRequest.FirstName,
                LastName = registerRequest.LastName,
                Email = registerRequest.Email,
                Role = registerRequest.Role,
                CreatedBy = 1, // Default value for now
                ModifiedBy = 1 // Default value for now
            };

            try
            {
                var userId = await _userService.RegisterUserAsync(user);
                return CreatedAtAction(nameof(GetById), new { id = userId }, new { UserID = userId });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = $"An error occurred while creating the user: {ex.Message}" });
            }
        }

        [HttpGet("{id:int}")]
        public async Task<IActionResult> GetById(int id)
        {
            var user = await _userService.GetUserByIdAsync(id);
            if (user == null)
            {
                return NotFound(new { Message = "User not found." });
            }

            return Ok(user);
        }
    }
}
