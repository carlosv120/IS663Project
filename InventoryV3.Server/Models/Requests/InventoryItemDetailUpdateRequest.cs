namespace InventoryV3.Server.Models.Requests
{
    public class InventoryItemDetailUpdateRequest
    {
        public int InStoreLocationID { get; set; }
        public int StatusID { get; set; }
        public int SupplierID { get; set; }
        public string? Manufacturer { get; set; }
        public string? Size { get; set; }
        public string? Color { get; set; }
        public string? Capacity { get; set; }
        public string? Gauge { get; set; }
        public string? Material { get; set; }
        public int QuantityInStock { get; set; }
        public string? UnitOfMeasurement { get; set; }
        public int? ReorderLevel { get; set; }
        public decimal? CostPerUnit { get; set; }
        public decimal? SellingPricePerUnit { get; set; }
        public DateTime? ExpirationDate { get; set; }
        public string? Barcode { get; set; }
        public string? Notes { get; set; }
    }
}
