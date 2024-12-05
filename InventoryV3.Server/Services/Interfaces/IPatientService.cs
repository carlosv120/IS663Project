using InventoryV3.Server.Models.Domain;
using InventoryV3.Server.Models.Requests;

namespace InventoryV3.Server.Services.Interfaces
{
    public interface IPatientService
    {
        Task<(IEnumerable<Patient> Patients, int TotalCount)> GetAllPatientsAsync(int pageIndex, int pageSize);
        Task<int> InsertPatientAsync(Patient patient, int createdBy);
        Task UpdatePatientAsync(int patientId, PatientRequest patientRequest, int modifiedBy);
        Task SoftDeletePatientAsync(int patientId, int modifiedBy);
    }
}
