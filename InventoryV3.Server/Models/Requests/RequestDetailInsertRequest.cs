namespace InventoryV3.Server.Models.Requests
{
    public class RequestDetailInsertRequest
    {
        public int ItemID { get; set; }
        public int ItemDetailID { get; set; }
        public int Quantity { get; set; }
        public string Notes { get; set; }
    }
}
