using InventoryV3.Server.Configurations;
using InventoryV3.Server.Models.Domain;
using InventoryV3.Server.Models.Requests;
using InventoryV3.Server.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace InventoryV3.Server.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class PatientController : ControllerBase
    {
        private readonly IPatientService _patientService;

        public PatientController(IPatientService patientService)
        {
            _patientService = patientService;
        }

        [HttpGet]
        [DynamicRoleAuthorize("Admin", "Manager")] 
        public async Task<IActionResult> GetAllPatients([FromQuery] int pageIndex = 1, [FromQuery] int pageSize = 10)
        {
            try
            {
                var (patients, totalCount) = await _patientService.GetAllPatientsAsync(pageIndex, pageSize);

                var totalPages = (int)Math.Ceiling(totalCount / (double)pageSize);

                return Ok(new
                {
                    Metadata = new
                    {
                        TotalCount = totalCount,
                        PageIndex = pageIndex,
                        PageSize = pageSize,
                        TotalPages = totalPages
                    },
                    Data = patients
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = ex.Message });
            }
        }

        [HttpPost]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> InsertPatient([FromBody] PatientRequest patientRequest)
        {
            try
            {
                // Get UserID from JWT claims
                var userIdClaim = User.Claims.FirstOrDefault(c => c.Type == "UserID")?.Value;
                if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int createdBy))
                {
                    return Unauthorized(new { Message = "Invalid user authentication." });
                }

                // Map the request model to the domain model
                var patient = new Patient
                {
                    FirstName = patientRequest.FirstName,
                    LastName = patientRequest.LastName,
                    DateOfBirth = patientRequest.DateOfBirth,
                    ContactNumber = patientRequest.ContactNumber,
                    Email = patientRequest.Email,
                    Address = patientRequest.Address,
                    City = patientRequest.City,
                    State = patientRequest.State,
                    PostalCode = patientRequest.PostalCode,
                    Country = patientRequest.Country,
                    EmergencyContactName = patientRequest.EmergencyContactName,
                    EmergencyContactNumber = patientRequest.EmergencyContactNumber,
                    MedicalNotes = patientRequest.MedicalNotes
                };

                var patientId = await _patientService.InsertPatientAsync(patient, createdBy);

                return CreatedAtAction(nameof(InsertPatient), new { PatientID = patientId });
            }
            catch (SqlException ex) when (ex.Number == 2627) // Unique constraint violation
            {
                return Conflict(new { Message = "A patient with the same name and date of birth already exists." });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = ex.Message });
            }
        }

        [HttpPut("{id}")]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> UpdatePatient(int id, [FromBody] PatientRequest patientRequest)
        {
            try
            {
                // Get the UserID from the JWT claims
                var userIdClaim = User.Claims.FirstOrDefault(c => c.Type == "UserID")?.Value;
                if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int modifiedBy))
                {
                    return Unauthorized(new { Message = "Invalid user authentication." });
                }

                // Call the service to update the patient
                await _patientService.UpdatePatientAsync(id, patientRequest, modifiedBy);

                return Ok(new { Message = "Patient updated successfully." });
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(new { Message = ex.Message }); // 404 Not Found
            }
            catch (SqlException ex) when (ex.Number == 2627) // Unique constraint violation
            {
                return Conflict(new { Message = "A patient with the same name and date of birth already exists." });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = ex.Message });
            }
        }


        [HttpDelete("{id}")]
        [DynamicRoleAuthorize("Admin", "Manager")]
        public async Task<IActionResult> SoftDeletePatient(int id)
        {
            try
            {
                // Get the UserID directly from the JWT claims
                var userIdClaim = User.Claims.FirstOrDefault(c => c.Type == "UserID")?.Value;
                if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int modifiedBy))
                {
                    return Unauthorized(new { Message = "Invalid user authentication." });
                }

                // Call the service to deactivate the patient
                await _patientService.SoftDeletePatientAsync(id, modifiedBy);

                return NoContent(); // 204 No Content
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


    }
}
