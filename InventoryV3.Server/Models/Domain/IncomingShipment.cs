namespace InventoryV3.Server.Models.Domain
{
    public class IncomingShipment
    {
        public int IncomingShipmentID { get; set; }
        public int? RequestID { get; set; }
        public int TransactionID { get; set; }
        public string Notes { get; set; }
        public string CreatedByFirstName { get; set; }
        public string CreatedByLastName { get; set; }
        public string ModifiedByFirstName { get; set; }
        public string ModifiedByLastName { get; set; }
        public DateTime DateCreated { get; set; }
        public DateTime DateModified { get; set; }
        public List<IncomingShipmentDetail> ShipmentDetails { get; set; }
    }
}
