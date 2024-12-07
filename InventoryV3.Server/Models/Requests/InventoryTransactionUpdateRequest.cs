namespace InventoryV3.Server.Models.Requests
{
    public class InventoryTransactionUpdateRequest
    {
        public int StatusID { get; set; }
        public bool IsRequest { get; set; }
        public int RequestID { get; set; }
        public string Notes { get; set; }
        public List<InventoryTransactionDetailUpdateRequest> TransactionDetails { get; set; }
    }


}
