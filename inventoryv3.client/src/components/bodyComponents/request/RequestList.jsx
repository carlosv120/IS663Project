import { Component } from "react";
import { Avatar, Box, Typography } from "@mui/material";
import { DataGrid } from "@mui/x-data-grid";
import requests from "./Requests";
export default class RequestList extends Component {
  render() {
    const columns = [
      {
        field: "id",
        headerName: "Request ID",
        width: 90,
        description: "id of the product",
      },
      {
        field: "request_date",
        headerName: "Date Requested",
        width: 200,
        description: "when request was made",
      },
      {
        field: "approved",
        headerName: "Approved",
        width: 100,
        description: "if request was approved",
      },
      {
        field: "approval_date",
        headerName: "Date Approved",
        width: 200,
        description: "when request was approved",
      },
      {
        field: "item_id",
        headerName: "Item ID",
        width: 90,
        description: "id of the product",
      },
      {
        field: "user_id",
        headerName: "Created By",
        width: 90,
        description: "id of the user",
      },
      {
        field: "quantity",
        headerName: "Quantity",
        width: 90,
        description: "quantity of item ordered",
      },
    ];
    const rows = requests;
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
