using InventoryV3.Server.Models.Domain;

namespace InventoryV3.Server.Services.Interfaces
{
    public interface IUserService
    {
        Task<User> AuthenticateAsync(string username, string password);
        Task<User> GetUserByIdAsync(int userId);
        Task<int> RegisterUserAsync(User user);
    }
}
