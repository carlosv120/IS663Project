import React, { Component } from "react";
import { Dialog, DialogActions, DialogContent, DialogTitle, Button, TextField } from "@mui/material";

export default class AddSupplierModal extends Component {
  state = {
    id: this.props.editingSupplier ? this.props.editingSupplier.id : "",
    firstName: this.props.editingSupplier ? this.props.editingSupplier.firstName : "",
    lastName: this.props.editingSupplier ? this.props.editingSupplier.lastName : "",
    company: this.props.editingSupplier ? this.props.editingSupplier.company : "",
    mobile: this.props.editingSupplier ? this.props.editingSupplier.mobile : "",
    email: this.props.editingSupplier ? this.props.editingSupplier.email : "",
    is_active: this.props.editingSupplier ? this.props.editingSupplier.is_active : "Yes",
  };

  handleChange = (e) => {
    this.setState({ [e.target.name]: e.target.value });
  };

  handleSubmit = () => {
    const { id, firstName, lastName, company, mobile, email, is_active } = this.state;
    const supplier = { id, firstName, lastName, company, mobile, email, is_active };

    if (this.props.editingSupplier) {
      this.props.onUpdateSupplier(supplier);
    } else {
      this.props.onAddSupplier(supplier);
    }

    this.setState({
      id: "",
      firstName: "",
      lastName: "",
      company: "",
      mobile: "",
      email: "",
      is_active: "Yes",
    });
  };

  render() {
    const { isOpen, onClose } = this.props;
    const { id, firstName, lastName, company, mobile, email, is_active } = this.state;

    return (
      <Dialog open={isOpen} onClose={onClose}>
        <DialogTitle>{this.props.editingSupplier ? "Update Supplier" : "Add Supplier"}</DialogTitle>
        <DialogContent>
          <TextField
            label="Supplier ID"
            fullWidth
            value={id}
            name="id"
            onChange={this.handleChange}
            margin="normal"
          />
          <TextField
            label="First Name"
            fullWidth
            value={firstName}
            name="firstName"
            onChange={this.handleChange}
            margin="normal"
          />
          <TextField
            label="Last Name"
            fullWidth
            value={lastName}
            name="lastName"
            onChange={this.handleChange}
            margin="normal"
          />
          <TextField
            label="Company"
            fullWidth
            value={company}
            name="company"
            onChange={this.handleChange}
            margin="normal"
          />
          <TextField
            label="Mobile"
            fullWidth
            value={mobile}
            name="mobile"
            onChange={this.handleChange}
            margin="normal"
          />
          <TextField
            label="Email"
            fullWidth
            value={email}
            name="email"
            onChange={this.handleChange}
            margin="normal"
          />
          <TextField
            label="Active Status (Yes/No)"
            fullWidth
            value={is_active}
            name="is_active"
            onChange={this.handleChange}
            margin="normal"
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={onClose} color="primary">
            Cancel
          </Button>
          <Button onClick={this.handleSubmit} color="primary">
            {this.props.editingSupplier ? "Update" : "Add"}
          </Button>
        </DialogActions>
      </Dialog>
    );
  }
}
