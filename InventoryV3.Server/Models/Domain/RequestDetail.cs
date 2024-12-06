namespace InventoryV3.Server.Models.Domain
{
    public class RequestDetail
    {
        public int RequestDetailID { get; set; }
        public int ItemID { get; set; }
        public int ItemDetailID { get; set; }
        public int Quantity { get; set; }
        public bool IsCompleted { get; set; }
        public string Notes { get; set; }
    }
}
