namespace InventoryV3.Server.Models.Requests
{
    public class InventoryItemUpdateRequest
    {
        public int StatusID { get; set; }
        public string Name { get; set; }
        public string? Description { get; set; }
        public string Category { get; set; }
        public string? Notes { get; set; }
        public List<InventoryItemDetailUpdateRequest> ItemDetailList { get; set; }
    }
}
