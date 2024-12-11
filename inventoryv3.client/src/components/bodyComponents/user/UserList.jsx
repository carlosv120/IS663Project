import { Component } from "react";
import { Avatar, Box, Typography } from "@mui/material";
import { DataGrid } from "@mui/x-data-grid";
import users from "./Users";
export default class UserList extends Component {
  render() {
    const columns = [
      {
        field: "id",
        headerName: "User ID",
        width: 90,
        description: "unique id of user",
      },
      {
        field: "username",
        headerName: "Username",
        width: 300,
        description: "name of user",
      },
      {
        field: "fullname",
        headerName: "Full Name",
        width: 200,
        description: "full name of user",
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
        field: "role",
        headerName: "Role",
        width: 300,
        description: "company role of user",
      },
      {
        field: "email",
        headerName: "Email Address",
        width: 300,
        description: "email address of user",
      },
      {
        field: "mobile",
        headerName: "Phone Number",
        width: 300,
        description: "phone number of user",
      },
      {
        field: "last_log",
        headerName: "Last Login",
        width: 230,
        description: "last time a user logged in",
      },
      {
        field: "is_active",
        headerName: "Active",
        width: 90,
        description: "is the user active",
      },
    ];
    const rows = users;
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
