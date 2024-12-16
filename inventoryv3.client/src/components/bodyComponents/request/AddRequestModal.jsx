import React, { Component } from "react";
import { Dialog, DialogActions, DialogContent, DialogTitle, Button, TextField } from "@mui/material";

export default class AddRequestModal extends Component {
  state = {
    id: this.props.editingRequest ? this.props.editingRequest.id : "",
    request_date: this.props.editingRequest ? this.props.editingRequest.request_date : "",
    item_id: this.props.editingRequest ? this.props.editingRequest.item_id : "",
    user_id: this.props.editingRequest ? this.props.editingRequest.user_id : "",
    quantity: this.props.editingRequest ? this.props.editingRequest.quantity : "",
  };

  handleChange = (e) => {
    this.setState({ [e.target.name]: e.target.value });
  };

  handleSubmit = () => {
    const { id, request_date,Item_Name, item_id, user_id, quantity } = this.state;
    const request = { id, request_date,Item_Name, item_id, user_id, quantity };

    if (this.props.editingRequest) {
      this.props.onUpdateRequest(request); // Update existing request
    } else {
      this.props.onAddRequest(request); // Add new request
    }

    // Reset state after submission
    this.setState({
      id: "",
      request_date: "",
      Item_Name: "",
      item_id: "",
      user_id: "",
      quantity: "",
    });
  };

  render() {
    const { isOpen, onClose } = this.props;
    const { id, request_date, Item_Name, item_id, user_id, quantity } = this.state;

    return (
      <Dialog open={isOpen} onClose={onClose}>
        <DialogTitle>{this.props.editingRequest ? "Update Request" : "Add Request"}</DialogTitle>
        <DialogContent>
        <TextField
            label="Request ID"
            fullWidth
            value={id}
            name="id"
            onChange={this.handleChange}
            margin="normal"
          />
          <TextField
            label="Request Date"
            type="date"
            fullWidth
            value={request_date}
            name="request_date"
            onChange={this.handleChange}
            InputLabelProps={{
              shrink: true,
            }}
            margin="normal"
          />
          <TextField
            label="Item Name"
            fullWidth
            value={Item_Name}
            name="Item_Name"
            onChange={this.handleChange}
            margin="normal"
          />
          <TextField
            label="Item ID"
            fullWidth
            value={item_id}
            name="item_id"
            onChange={this.handleChange}
            margin="normal"
          />
          <TextField
            label="User ID"
            fullWidth
            value={user_id}
            name="user_id"
            onChange={this.handleChange}
            margin="normal"
          />
          <TextField
            label="Quantity"
            fullWidth
            value={quantity}
            name="quantity"
            onChange={this.handleChange}
            margin="normal"
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={onClose} color="primary">
            Cancel
          </Button>
          <Button onClick={this.handleSubmit} color="primary">
            {this.props.editingRequest ? "Update" : "Add"}
          </Button>
        </DialogActions>
      </Dialog>
    );
  }
}
