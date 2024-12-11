import { Component } from "react";
import { Avatar, Box, Typography } from "@mui/material";
import { DataGrid } from "@mui/x-data-grid";
import suppliers from "./Suppliers";
export default class SupplierList extends Component {
  render() {
    const columns = [
      {
        field: "id",
        headerName: "Supplier ID",
        width: 90,
        description: "id of the supplier",
      },
      {
        field: "company",
        headerName: "Company",
        width: 300,
        description: "supplier company",
      },
      {
        field: "fullname",
        headerName: "Main Contact Name",
        width: 200,
        description: "full name of contact",
        renderCell: (params) => {
          return (
            <>
              <Avatar
                alt="name"
                variant="square"
                sx={{ borderRadius: 1, width: 30, height: 30 }}
              >
                Z
              </Avatar>
              <Typography variant="subtitle2" sx={{ mx: 3 }}>
                {`${params.row.firstName || ""} ${params.row.lastName || ""} `}
              </Typography>
            </>
          );
        },
      },
      /*
      {
        field: "orderNumber",
        headerName: "Number Of Order",
        width: 200,
        description: "number of order that the customer made",
        valueGetter: (params) => params.row.orders.length,
      },
      {
        field: "total",
        headerName: "Total Amount",
        width: 300,
        description: "total amount of the order",
        valueGetter: (params) => {
          const total = 300;
          return total;
        },
      },
      {
        field: "orderHistory",
        headerName: "Order Details",
        width: 300,
        description: "the details of the order",
        valueGetter: (params) => {
          const history = "03/01/2027";
          return history;
        },
      },
      */
      {
        field: "email",
        headerName: "Main Contact Email",
        width: 300,
        description: "main contact email for supplier",
      },
      {
        field: "mobile",
        headerName: "Main Contact Number",
        width: 300,
        description: "main contact number for supplier",
      },
      {
        field: "is_active",
        headerName: "Active",
        width: 90,
        description: "is the supplier active",
      },
    ];
    const rows = suppliers;
    return (
      <Box
        sx={{
          margin: 3,
          bgcolor: "white",
          borderRadius: 2,
          padding: 3,
          height: "100%",
        }}
      >
        <DataGrid
          sx={{
            borderLeft: 0,
            borderRight: 0,
            borderRadius: 0,
          }}
          rows={rows}
          columns={columns}
          initialState={{
            pagination: {
              paginationModel: { page: 0, pageSize: 10 },
            },
          }}
          pageSizeOptions={[15, 20, 30]}
          rowSelection={false}
        />
        <Box></Box>
      </Box>
    );
  }
}
