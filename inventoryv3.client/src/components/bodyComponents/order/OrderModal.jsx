import { DeleteOutline } from "@mui/icons-material";
import {
  Box,
  Button,
  IconButton,
  Paper,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Typography,
} from "@mui/material";
import React from "react";

export default function OrderModal({ order = {} }) {
  const products = order.products || []; // Fallback to empty array

  const handleDeleteProductFromOrder = (orderId, productId) => {
    console.log("Delete product:", productId, "from order:", orderId);
  };

  const tableRows = products.map((orderProduct, index) => {
    const product = orderProduct.product || {}; // Handle undefined product
    return (
      <TableRow key={index}>
        <TableCell>{product.name || "Unknown Product"}</TableCell>
        <TableCell>{orderProduct.quantity || 0}</TableCell>
        <TableCell>{product.stock || "Out of Stock"}</TableCell>
        <TableCell>
          <IconButton
            onClick={() =>
              handleDeleteProductFromOrder(order.id, product.id)
            }
          >
            <DeleteOutline color="error" />
          </IconButton>
        </TableCell>
      </TableRow>
    );
  });

  return (
    <Box
      sx={{
        position: "absolute",
        left: "50%",
        top: "50%",
        transform: "translate(-50%, -50%)",
        width: "50%",
        bgcolor: "white",
        borderRadius: 2,
        boxShadow: 24,
        p: 4,
      }}
    >
      <Box sx={{ color: "black", display: "flex", flexDirection: "column" }}>
        <Typography variant="h6" sx={{ m: 3 }}>
          Order List
        </Typography>
        <TableContainer sx={{ marginBottom: 3 }}>
          <Table>
            <TableHead>
              <TableRow>
                <TableCell>Product Name</TableCell>
                <TableCell>Quantity</TableCell>
                <TableCell>Stock Availability</TableCell>
                <TableCell>Actions</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>{tableRows}</TableBody>
          </Table>
        </TableContainer>
      </Box>
    </Box>
  );
}
