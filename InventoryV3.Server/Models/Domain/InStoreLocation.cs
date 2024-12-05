namespace InventoryV3.Server.Models.Domain
{
    public class InStoreLocation
    {
        public int LocationID { get; set; }
        public string LocationName { get; set; }
        public string Description { get; set; }
        public string Zone { get; set; }
        public string SubZone { get; set; }
        public string Bin { get; set; }
        public bool IsActive { get; set; }
        public string CreatedByFirstName { get; set; }
        public string CreatedByLastName { get; set; }
        public string ModifiedByFirstName { get; set; }
        public string ModifiedByLastName { get; set; }
        public DateTime DateCreated { get; set; }
        public DateTime DateModified { get; set; }
    }
}
