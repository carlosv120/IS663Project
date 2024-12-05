namespace InventoryV3.Server.Models.Requests
{
    public class InStoreLocationRequest
    {
        public string LocationName { get; set; }
        public string Description { get; set; }
        public string Zone { get; set; }
        public string SubZone { get; set; }
        public string Bin { get; set; }
    }
}
