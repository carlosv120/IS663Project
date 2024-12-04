using InventoryV3.Server.Models;
using Microsoft.AspNetCore.Mvc;

namespace InventoryV3.Server.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TestController : ControllerBase
    {
        [HttpGet("ping")]
        public IActionResult Ping()
        {
            return Ok("Pong"); // Respond with a simple text message
        }

        [HttpGet("status")]
        public IActionResult Status()
        {
            var status = new TestStatus
            {
                ApiStatus = "Running",
                Time = DateTime.UtcNow
            };
            return Ok(status); // Respond with JSON data
        }

    }
}
