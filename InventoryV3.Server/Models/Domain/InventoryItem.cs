namespace InventoryV3.Server.Models.Domain
{
    public class InventoryItem
    {
        public int ItemID { get; set; }
        public int StatusID { get; set; }
        public string Name { get; set; }
        public string? Description { get; set; }
        public string Category { get; set; }
        public string? Notes { get; set; }
        public string CreatedByFirstName { get; set; }
        public string CreatedByLastName { get; set; }
        public string ModifiedByFirstName { get; set; }
        public string ModifiedByLastName { get; set; }
        public DateTime DateCreated { get; set; }
        public DateTime DateModified { get; set; }
        public List<InventoryItemDetail> ItemDetails { get; set; } // Nested details
    }

}
