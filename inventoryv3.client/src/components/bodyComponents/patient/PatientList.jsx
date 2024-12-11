import { Component } from "react";
import { Avatar, Box, Typography } from "@mui/material";
import { DataGrid } from "@mui/x-data-grid";
import patients from "./Patients";
export default class PatientList extends Component {
  render() {
    const columns = [
      {
        field: "id",
        headerName: "Patient ID",
        width: 90,
        description: "id of the product",
      },
      {
        field: "fullname",
        headerName: "Full Name",
        width: 200,
        description: "customer full name",
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
      */
      {
        field: "dob",
        headerName: "Date of Birth",
        width: 200,
        description: "the dates of birth of the patients",
      },
      {
        field: "email",
        headerName: "Email Address",
        width: 300,
        description: "the email address of the patients",
      },
      {
        field: "mobile",
        headerName: "Contact Number",
        width: 200,
        description: "total amount of the order",
      },
    ];
    const rows = patients;
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
