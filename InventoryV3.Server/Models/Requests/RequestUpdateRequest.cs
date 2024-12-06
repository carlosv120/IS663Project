namespace InventoryV3.Server.Models.Requests
{
    public class RequestUpdateRequest
    {
        public int? AlertID { get; set; }
        public string Notes { get; set; }
        public List<RequestDetailUpdateRequest> RequestDetailList { get; set; }
    }
}
