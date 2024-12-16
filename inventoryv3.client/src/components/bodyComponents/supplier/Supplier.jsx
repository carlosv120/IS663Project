import React, { Component } from "react";
import SupplierList from "./SupplierList";
import { Box, Typography, Button } from "@mui/material";
import AddSupplierModal from "./AddSupplierModal";

export default class Suppliers extends Component {
  state = {
    suppliers: [],
    isModalOpen: false,
    editingSupplier: null,
  };

  handleAddSupplierClick = () => {
    this.setState({ isModalOpen: true });
  };

  handleCloseModal = () => {
    this.setState({ isModalOpen: false, editingSupplier: null });
  };

  handleAddSupplier = (newSupplier) => {
    this.setState((prevState) => ({
      suppliers: [...prevState.suppliers, newSupplier],
      isModalOpen: false,
    }));
  };

  handleUpdateSupplier = (updatedSupplier) => {
    this.setState((prevState) => ({
      suppliers: prevState.suppliers.map((supplier) =>
        supplier.id === updatedSupplier.id ? updatedSupplier : supplier
      ),
      isModalOpen: false,
    }));
  };

  handleDeleteSupplier = (supplierId) => {
    this.setState((prevState) => ({
      suppliers: prevState.suppliers.filter((supplier) => supplier.id !== supplierId),
    }));
  };

  render() {
    return (
      <Box>
        <Typography variant="h5" sx={{ m: 6, fontWeight: "bold" }}>
          Supplier
        </Typography>
        <SupplierList 
          suppliers={this.state.suppliers}
          onEditSupplier={(supplier) => this.setState({ editingSupplier: supplier, isModalOpen: true })}
          onDeleteSupplier={this.handleDeleteSupplier}
        />
        <AddSupplierModal
          isOpen={this.state.isModalOpen}
          onClose={this.handleCloseModal}
          onAddSupplier={this.handleAddSupplier}
          editingSupplier={this.state.editingSupplier}
          onUpdateSupplier={this.handleUpdateSupplier}
        />
      </Box>
    );
  }
}
