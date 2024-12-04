namespace InventoryV3.Server.Models.Domain
{
    public class Supplier
    {
        public int SupplierID { get; set; }
        public string Company { get; set; }
        public string MainContactName { get; set; }
        public string MainContactNumber { get; set; }
        public string MainContactEmail { get; set; }
        public bool IsActive { get; set; }
        public string CreatedByFirstName { get; set; }
        public string CreatedByLastName { get; set; }
        public string ModifiedByFirstName { get; set; }
        public string ModifiedByLastName { get; set; }
        public DateTime DateCreated { get; set; }
        public DateTime? DateModified { get; set; }
    }
}
