namespace InventoryV3.Server.Models.Domain
{
    public class InventoryTransactionDetail
    {
        public int TransactionDetailID { get; set; }
        public int RequestDetailID { get; set; }
        public int SupplierID { get; set; }
        public string OrderNumber { get; set; }
        public int Quantity { get; set; }
        public string TrackingNumber { get; set; }
        public DateTime ExpectedArrivalDate { get; set; }
        public string DetailNotes { get; set; }
    }
}
