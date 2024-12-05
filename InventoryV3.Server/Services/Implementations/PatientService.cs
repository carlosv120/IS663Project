using Dapper;
using InventoryV3.Server.Models.Domain;
using InventoryV3.Server.Services.Interfaces;
using Microsoft.Data.SqlClient;

namespace InventoryV3.Server.Services.Implementations
{
    public class PatientService : IPatientService
    {
        private readonly IConfiguration _configuration;

        public PatientService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task<(IEnumerable<Patient> Patients, int TotalCount)> GetAllPatientsAsync(int pageIndex, int pageSize)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@PageIndex", pageIndex);
            parameters.Add("@PageSize", pageSize);

            using var multi = await connection.QueryMultipleAsync(
                "dbo.Patient_SelectAll",
                parameters,
                commandType: System.Data.CommandType.StoredProcedure
            );

            // Read the total count and patient list
            var totalCount = await multi.ReadSingleAsync<int>();
            var patients = await multi.ReadAsync<Patient>();

            return (patients, totalCount);
        }
    }
}
