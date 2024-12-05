using InventoryV3.Server.Models.Domain;

namespace InventoryV3.Server.Services.Interfaces
{
    public interface IPatientService
    {
        Task<(IEnumerable<Patient> Patients, int TotalCount)> GetAllPatientsAsync(int pageIndex, int pageSize);
    }
}
