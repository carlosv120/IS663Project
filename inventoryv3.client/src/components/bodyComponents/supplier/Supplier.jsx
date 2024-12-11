import React, { Component } from "react";
import SupplierList from "./SupplierList";
import { Box, Typography } from "@mui/material";
export default class Supplier extends Component {
  render() {
    return (
      <Box sx={{ m: 0, p: 3, width: "100%" }}>
        <Typography variant="h5" sx={{ m: 3, fontWeight: "bold" }}>
          Suppliers
        </Typography>
        <SupplierList />
      </Box>
    );
  }
}
