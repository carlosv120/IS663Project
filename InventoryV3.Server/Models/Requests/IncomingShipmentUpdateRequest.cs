namespace InventoryV3.Server.Models.Requests
{
    public class IncomingShipmentUpdateRequest
    {
        public int IncomingShipmentID { get; set; }
        public string Notes { get; set; }
        public List<IncomingShipmentDetailsUpdateRequest> ShipmentDetailList { get; set; }
    }

}
