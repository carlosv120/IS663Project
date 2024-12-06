public class Request
{
    public int RequestID { get; set; }
    public int? AlertID { get; set; }
    public DateTime? DateRequested { get; set; }
    public bool IsApproved { get; set; }
    public DateTime? DateApproved { get; set; }
    public int? TransactionID { get; set; }
    public bool RequestIsCompleted { get; set; }
    public string RequestNotes { get; set; }
    public bool RequestIsActive { get; set; }
    public string CreatedByFirstName { get; set; }
    public string CreatedByLastName { get; set; }
    public string ModifiedByFirstName { get; set; }
    public string ModifiedByLastName { get; set; }
    public DateTime DateCreated { get; set; }
    public DateTime DateModified { get; set; }
    public string RequestDetails { get; set; } // JSON string for nested details
}
