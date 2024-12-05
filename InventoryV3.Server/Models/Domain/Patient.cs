namespace InventoryV3.Server.Models.Domain
{
    public class Patient
    {
        public int PatientID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public DateTime DateOfBirth { get; set; }
        public string ContactNumber { get; set; }
        public string Email { get; set; }
        public string Address { get; set; } // Add this property
        public string City { get; set; } // Add this property
        public string State { get; set; } // Add this property
        public string PostalCode { get; set; } // Add this property
        public string Country { get; set; } // Add this property
        public string EmergencyContactName { get; set; } // Add this property
        public string EmergencyContactNumber { get; set; } // Add this property
        public string MedicalNotes { get; set; } // Add this property
        public bool IsActive { get; set; }
        public string CreatedByFirstName { get; set; }
        public string CreatedByLastName { get; set; }
        public string ModifiedByFirstName { get; set; }
        public string ModifiedByLastName { get; set; }
        public DateTime DateCreated { get; set; }
        public DateTime? DateModified { get; set; }
    }
}
