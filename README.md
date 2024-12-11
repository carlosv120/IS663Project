# IS663Project

# Inventory Management System

This project manages inventory transactions, incoming shipments, and related data. Below is an overview of the implemented features, stored procedures, API endpoints, and functionality.

---

## Features Implemented

### Incoming Shipments
- **Create Incoming Shipment**:
  - Inserts a new shipment along with shipment details.
  - Includes logic to update inventory stock and related tables.
- **Update Incoming Shipment**:
  - Updates an existing shipment's notes and modifies its details.
  - Adjusts inventory stock based on the quantity changes.
  - Prevents duplicate `RequestDetailID` entries per shipment.
- **Retrieve All Incoming Shipments**:
  - Retrieves a paginated list of active shipments with details in JSON format.
- **Soft Delete Incoming Shipment**:
  - Sets the `IsActive` field of a shipment and its details to `0`.

### Inventory Transactions
- **Create Inventory Transaction**:
  - Adds new inventory transactions with associated details.
- **Update Inventory Transaction**:
  - Updates an existing transaction and adjusts the inventory stock accordingly.
- **Retrieve All Inventory Transactions**:
  - Returns a paginated list of active inventory transactions with their details.
- **Soft Delete Inventory Transaction**:
  - Sets the `IsActive` field of a transaction and its details to `0`.

---

## Database Schema Changes

### IncomingShipment Table
- Added `IsActive` column (`BIT`, default `1`).

### IncomingShipmentDetails Table
- Added `IsActive` column (`BIT`, default `1`).
- Added a unique constraint to prevent duplicate `IncomingShipmentID` and `RequestDetailID` combinations.

### InventoryTransaction Table
- Added `IsActive` column (`BIT`, default `1`).

### InventoryTransactionDetails Table
- Added `IsActive` column (`BIT`, default `1`).

---

## Stored Procedures

### Incoming Shipment Procedures
1. **`IncomingShipment_InsertWithDetails`**
   - Inserts a new shipment and details while updating related inventory tables.
2. **`IncomingShipment_UpdateWithDetails`**
   - Updates shipment details or adds new ones.
   - Prevents duplicate `RequestDetailID` entries and adjusts stock accurately.
3. **`IncomingShipment_SelectAll`**
   - Retrieves paginated shipment records with nested JSON details.
4. **`IncomingShipment_Delete`**
   - Soft deletes a shipment and its details by setting `IsActive = 0`.

### Inventory Transaction Procedures
1. **`InventoryTransaction_InsertWithDetails`**
   - Adds a new inventory transaction and its details.
2. **`InventoryTransaction_UpdateWithDetails`**
   - Updates an inventory transaction and adjusts stock.
3. **`InventoryTransaction_SelectAll`**
   - Retrieves a paginated list of active inventory transactions with JSON details.
4. **`InventoryTransaction_Delete`**
   - Soft deletes an inventory transaction and its associated details.

---

## API Endpoints

### Incoming Shipment Endpoints
- `POST /api/IncomingShipment`: Inserts a new shipment with details.
- `PUT /api/IncomingShipment/{id}`: Updates shipment notes and modifies details.
- `GET /api/IncomingShipment`: Retrieves all shipments in a paginated format.
- `DELETE /api/IncomingShipment/{id}`: Soft deletes a shipment.

### Inventory Transaction Endpoints
- `POST /api/InventoryTransaction`: Creates a new inventory transaction.
- `PUT /api/InventoryTransaction/{id}`: Updates a transaction's details and notes.
- `GET /api/InventoryTransaction`: Retrieves a paginated list of inventory transactions.
- `DELETE /api/InventoryTransaction/{id}`: Soft deletes an inventory transaction.

---

## Models

### IncomingShipment

```csharp
public class IncomingShipment
{
    public int IncomingShipmentID { get; set; }
    public int RequestID { get; set; }
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
