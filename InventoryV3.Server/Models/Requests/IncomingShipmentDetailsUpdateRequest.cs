namespace InventoryV3.Server.Models.Requests
{
    public class IncomingShipmentDetailsUpdateRequest
    {
        public int RequestDetailID { get; set; }
        public int SupplierID { get; set; }
        public string SupplierInvoiceNumber { get; set; }
        public DateTime SupplierInvoiceDate { get; set; }
        public string OrderNumber { get; set; }
        public string TrackingNumber { get; set; }
        public DateTime ShipmentDate { get; set; }
        public DateTime ArrivalDate { get; set; }
        public int QuantityReceived { get; set; }
        public string BatchNumber { get; set; }
        public string SerialNumber { get; set; }
        public string Notes { get; set; }
    }

}
