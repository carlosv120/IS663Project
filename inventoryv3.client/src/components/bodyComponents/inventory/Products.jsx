import { Typography } from "@mui/material";
import React from "react";
import Product from "./Product";
import { DataGrid } from "@mui/x-data-grid";
import productList from "./productList";

export default function Products() {
  const columns = [
    {
      field: "id",
      headerName: "Item ID",
      width: 90,
      description: "id of the product",
    },
    {
      field: "product",
      headerName: "Product",
      width: 250,
      description: "",
      renderCell: (cellData) => {
        const productName = cellData?.row?.product || "Unknown";
        return <Product productName={productName} />;
      },
    },
    {
      field: "details",
      headerName: "Description",
      width: 550,
      description: "category of the product",
    },
    {
      field: "price",
      headerName: "Price",
      width: 150,
      description: "price of the product",
      valueGetter: (params) => {
        const price = params?.row?.price;
        return price ? `$${price.toFixed(2)}` : "N/A";
      },
    },
    {
      field: "location_id",
      headerName: "In-Store Location ID",
      width: 150,
      description: "location id of the product",
    },
    {
      field: "supplier_id",
      headerName: "Supplier ID",
      width: 90,
      description: "id of the product supplier",
    },
    {
      field: "stock",
      headerName: "Stock",
      width: 200,
      description: "how many items in the stock",
      valueGetter: (params) => {
        const stock = params?.row?.stock;
        return stock !== undefined ? `${stock} pcs` : "N/A";
      },
    },
    {
      field: "reorder",
      headerName: "Reorder Level",
      width: 200,
      description: "if stock reaches this number, reorder from supplier",
      valueGetter: (params) => {
        const reorder = params?.row?.reorder;
        return reorder !== undefined ? `${reorder} pcs` : "N/A";
      },
    },
    {
      field: "exp_date",
      headerName: "Expiration Date",
      width: 150,
      description: "expiration date of the product",
    },
  ];

  const validatedProducts = productList.map((product) => ({
    ...product,
    price: product.price || 0, // Ensure a fallback price exists
    stock: product.stock || 0, // Ensure stock is defined
    reorder: product.reorder || 0, // Ensure reorder level is defined
  }));

  return (
    <div>
      <DataGrid
        sx={{ borderLeft: 0, borderRight: 0, borderRadius: 0 }}
        rows={validatedProducts}
        columns={columns}
        initialState={{
          pagination: {
            paginationModel: { page: 0, pageSize: 10 },
          },
        }}
        pageSizeOptions={[5, 10, 20]}
        checkboxSelection
      />
    </div>
  );
}
