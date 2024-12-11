import { Avatar, Box, Button, Modal, Typography } from "@mui/material";
import { DataGrid } from "@mui/x-data-grid";
import React, { Component } from "react";
import OrderModal from "./OrderModal";
import orders from "./listOrders";

export default class OrderList extends Component {
  handlOrderDetail = (order) => {
    console.log("The order is:", order);
    this.setState({ order: order, open: true });
  };

  handleClose = () => {
    this.setState({ open: false });
  };

  constructor(props) {
    super(props);
    this.state = {
      order: {},
      open: false,
    };
  }

  render() {
    const columns = [
      {
        field: "id",
        headerName: "ID",
        width: 90,
        description: "ID of the order",
      },
      {
        field: "fullname",
        headerName: "Full Name",
        width: 400,
        description: "Customer's full name",
        renderCell: (params) => {
          if (!params || !params.row || !params.row.customer) return "N/A";
          const { firstName = "Unknown", lastName = "" } = params.row.customer;
          return (
            <>
              <Avatar alt="name" sx={{ width: 30, height: 30 }}>
                {firstName[0] || "?"}
              </Avatar>
              <Typography variant="subtitle2" sx={{ mx: 3 }}>
                {`${firstName} ${lastName}`}
              </Typography>
            </>
          );
        },
      },
      {
        field: "mobile",
        headerName: "Mobile",
        width: 400,
        description: "Customer's phone number",
        valueGetter: (params) => {
          if (!params || !params.row || !params.row.customer) return "N/A";
          return params.row.customer.mobile || "N/A";
        },
      },
      {
        field: "total",
        headerName: "Total Amount",
        width: 300,
        description: "Total amount of the order",
        valueGetter: () => 300, // Example hardcoded value
      },
      {
        field: "details",
        headerName: "Order Details",
        width: 300,
        description: "Details of the order",
        renderCell: (params) => {
          if (!params || !params.row) return null;
          const order = params.row;
          return (
            <Button
              variant="contained"
              sx={{ bgcolor: "#504099" }}
              onClick={() => this.handlOrderDetail(order)}
            >
              Order Details
            </Button>
          );
        },
      },
    ];

    const validatedOrders = (orders || []).map((order) => ({
      ...order,
      customer: order.customer || { firstName: "Unknown", lastName: "", mobile: "N/A" }, // Fallback for missing customer
      products: order.products || [], // Fallback for missing products
    }));

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
          rows={validatedOrders}
          columns={columns}
          initialState={{
            pagination: {
              paginationModel: { page: 0, pageSize: 10 },
            },
          }}
          pageSizeOptions={[15, 20, 30]}
          rowSelection={false}
        />
        <Modal open={this.state.open} onClose={this.handleClose}>
          <Box>
            <OrderModal order={this.state.order} />
          </Box>
        </Modal>
      </Box>
    );
  }
}
