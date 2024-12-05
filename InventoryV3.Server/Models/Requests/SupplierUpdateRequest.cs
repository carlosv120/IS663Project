namespace InventoryV3.Server.Models.Requests
{
    public class SupplierUpdateRequest
    {
        public int SupplierID { get; set; }
        public string Company { get; set; }
        public string MainContactName { get; set; }
        public string MainContactNumber { get; set; }
        public string MainContactEmail { get; set; }
    }
}
