using InventoryV3.Server.Services.Interfaces;

namespace InventoryV3.Server.Services.Implementations
{
    public class TestService : ITestService
    {
        public string GetTestMessage()
        {
            return "This is a test message.";
        }
    }
}
