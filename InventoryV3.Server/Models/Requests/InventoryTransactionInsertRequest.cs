namespace InventoryV3.Server.Models.Requests
{
    public class InventoryTransactionInsertRequest
    {
        public int StatusID { get; set; }
        public bool IsRequest { get; set; }
        public int? RequestID { get; set; } // Nullable in case IsRequest is false
        public string Notes { get; set; }
        public List<InventoryTransactionDetailInsertRequest> TransactionDetailList { get; set; }
    }
}
