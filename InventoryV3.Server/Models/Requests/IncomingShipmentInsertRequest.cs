namespace InventoryV3.Server.Models.Requests
{
    public class IncomingShipmentInsertRequest
    {
        public int RequestID { get; set; }
        public int TransactionID { get; set; }
        public string? Notes { get; set; }
        public List<IncomingShipmentDetailsInsertRequest> ShipmentDetailList { get; set; }
    }


}
