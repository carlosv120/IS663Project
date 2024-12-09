namespace InventoryV3.Server.Models.Requests
{
    public class IncomingShipmentUpdateRequest
    {
        public string Notes { get; set; }
        public List<IncomingShipmentDetailsUpdateRequest> ShipmentDetailList { get; set; }
    }

}
