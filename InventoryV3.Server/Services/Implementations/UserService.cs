using Dapper;
using InventoryV3.Server.Models.Domain;
using InventoryV3.Server.Services.Interfaces;
using Microsoft.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace InventoryV3.Server.Services.Implementations
{
    public class UserService : IUserService
    {
        private readonly IConfiguration _configuration;

        public UserService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<User> AuthenticateAsync(string username, string password)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@Username", username);
            parameters.Add("@PasswordHash", CreatePasswordHash(password));

            return await connection.QuerySingleOrDefaultAsync<User>("dbo.Users_Authenticate", parameters, commandType: System.Data.CommandType.StoredProcedure );
        }


        public async Task<User> GetUserByIdAsync(int userId)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@UserID", userId);

            return await connection.QuerySingleOrDefaultAsync<User>( "dbo.Users_GetByID",  parameters, commandType: System.Data.CommandType.StoredProcedure);
        }


        public async Task<int> RegisterUserAsync(User user)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@Username", user.Username);
            parameters.Add("@PasswordHash", CreatePasswordHash(user.PasswordHash));
            parameters.Add("@FirstName", user.FirstName);
            parameters.Add("@LastName", user.LastName);
            parameters.Add("@Email", user.Email);
            parameters.Add("@Role", user.Role);
            parameters.Add("@CreatedBy", user.CreatedBy);
            parameters.Add("@ModifiedBy", user.ModifiedBy);
            parameters.Add("@UserID", dbType: System.Data.DbType.Int32, direction: System.Data.ParameterDirection.Output);

            await connection.ExecuteAsync( "dbo.Users_Register", parameters, commandType: System.Data.CommandType.StoredProcedure);

            return parameters.Get<int>("@UserID");
        }


        private static string CreatePasswordHash(string password)
        {
            using var sha256 = SHA256.Create();
            var hash = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
            return Convert.ToBase64String(hash);
        }

        private static bool VerifyPasswordHash(string password, string storedHash)
        {
            var hash = CreatePasswordHash(password);
            return hash == storedHash;
        }
    }
}
