namespace InventoryV3.Server.Models.Requests
{
    public class DispatchReceiverRequest
    {
        public string ReceiverName { get; set; }
        public string CompanyName { get; set; }
        public string ContactNumber { get; set; }
        public string Email { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string PostalCode { get; set; }
        public string Country { get; set; }
    }
}
