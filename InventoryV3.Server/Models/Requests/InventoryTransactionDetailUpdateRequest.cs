namespace InventoryV3.Server.Models.Requests
{
    public class InventoryTransactionDetailUpdateRequest
    {
        public int SupplierID { get; set; }
        public string OrderNumber { get; set; }
        public int Quantity { get; set; }
        public string TrackingNumber { get; set; }
        public DateTime ExpectedArrivalDate { get; set; }
        public string Notes { get; set; }
    }

}
