using Dapper;
using InventoryV3.Server.Models.Domain;
using InventoryV3.Server.Models.Requests;
using InventoryV3.Server.Services.Interfaces;
using Microsoft.Data.SqlClient;
using System.Data;

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

            using var multi = await connection.QueryMultipleAsync("dbo.Patient_SelectAll", parameters, commandType: System.Data.CommandType.StoredProcedure);

            // Read the total count and patient list
            var totalCount = await multi.ReadSingleAsync<int>();
            var patients = await multi.ReadAsync<Patient>();

            return (patients, totalCount);
        }

        public async Task<int> InsertPatientAsync(Patient patient, int createdBy)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@FirstName", patient.FirstName);
            parameters.Add("@LastName", patient.LastName);
            parameters.Add("@DateOfBirth", patient.DateOfBirth);
            parameters.Add("@ContactNumber", patient.ContactNumber);
            parameters.Add("@Email", patient.Email);
            parameters.Add("@Address", patient.Address);
            parameters.Add("@City", patient.City);
            parameters.Add("@State", patient.State);
            parameters.Add("@PostalCode", patient.PostalCode);
            parameters.Add("@Country", patient.Country);
            parameters.Add("@EmergencyContactName", patient.EmergencyContactName);
            parameters.Add("@EmergencyContactNumber", patient.EmergencyContactNumber);
            parameters.Add("@MedicalNotes", patient.MedicalNotes);
            parameters.Add("@CreatedBy", createdBy);
            parameters.Add("@PatientID", dbType: System.Data.DbType.Int32, direction: System.Data.ParameterDirection.Output);

            await connection.ExecuteAsync("dbo.Patient_Insert", parameters, commandType: System.Data.CommandType.StoredProcedure);

            // Retrieve the SupplierID from the output parameter
            return parameters.Get<int>("@PatientID");
        }

        public async Task UpdatePatientAsync(int patientId, PatientRequest patientRequest, int modifiedBy)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@PatientID", patientId);
            parameters.Add("@FirstName", patientRequest.FirstName);
            parameters.Add("@LastName", patientRequest.LastName);
            parameters.Add("@DateOfBirth", patientRequest.DateOfBirth);
            parameters.Add("@ContactNumber", patientRequest.ContactNumber);
            parameters.Add("@Email", patientRequest.Email);
            parameters.Add("@Address", patientRequest.Address);
            parameters.Add("@City", patientRequest.City);
            parameters.Add("@State", patientRequest.State);
            parameters.Add("@PostalCode", patientRequest.PostalCode);
            parameters.Add("@Country", patientRequest.Country);
            parameters.Add("@EmergencyContactName", patientRequest.EmergencyContactName);
            parameters.Add("@EmergencyContactNumber", patientRequest.EmergencyContactNumber);
            parameters.Add("@MedicalNotes", patientRequest.MedicalNotes);
            parameters.Add("@ModifiedBy", modifiedBy);

            var rowsAffected = await connection.ExecuteAsync("dbo.Patient_Update", parameters, commandType: CommandType.StoredProcedure);

            if (rowsAffected == 0)
            {
                throw new KeyNotFoundException($"Patient with ID {patientId} not found.");
            }
        }

        public async Task SoftDeletePatientAsync(int patientId, int modifiedBy)
        {
            using var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection"));
            connection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@PatientID", patientId);
            parameters.Add("@ModifiedBy", modifiedBy);

            var rowsAffected = await connection.ExecuteAsync("dbo.Patient_Delete", parameters, commandType: CommandType.StoredProcedure);

            if (rowsAffected == 0)
            {
                throw new KeyNotFoundException($"Patient with ID {patientId} not found.");
            }
        }

    }
}
