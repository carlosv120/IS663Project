namespace InventoryV3.Server.Models.Domain
{
    public class InventoryTransaction
    {
        public int TransactionID { get; set; }
        public int StatusID { get; set; }
        public bool IsRequest { get; set; }
        public int? RequestID { get; set; }
        public string TransactionNotes { get; set; }
        public string CreatedByFirstName { get; set; }
        public string CreatedByLastName { get; set; }
        public string ModifiedByFirstName { get; set; }
        public string ModifiedByLastName { get; set; }
        public DateTime DateCreated { get; set; }
        public DateTime DateModified { get; set; }
        public List<InventoryTransactionDetail> TransactionDetails { get; set; }
    }
}
