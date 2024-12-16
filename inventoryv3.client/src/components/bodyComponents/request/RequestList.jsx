import React, { Component } from "react";
import { Box, Button } from "@mui/material";
import { DataGrid } from "@mui/x-data-grid";
import AddRequestModal from "./AddRequestModal";
import requestsData from "./Requests"; // Assuming initial data is here

export default class RequestList extends Component {
  constructor(props) {
    super(props);
    this.state = {
      requests: requestsData, // Initialize with your data
      isAddRequestModalOpen: false,
      editingRequest: null, // Track the request being edited, if any
    };
  }

  // Open modal for adding a new request
  openAddRequestModal = () => {
    this.setState({ isAddRequestModalOpen: true, editingRequest: null });
  };

  // Open modal for editing an existing request
  openEditRequestModal = (request) => {
    this.setState({ isAddRequestModalOpen: true, editingRequest: request });
  };

  // Close the modal
  closeAddRequestModal = () => {
    this.setState({ isAddRequestModalOpen: false });
  };

  // Handle adding a new request
  handleAddRequest = (newRequest) => {
    this.setState((prevState) => ({
      requests: [...prevState.requests, newRequest], // Add new request to the list
      isAddRequestModalOpen: false, // Close the modal after adding
    }));
  };

  // Handle updating an existing request
  handleUpdateRequest = (updatedRequest) => {
    this.setState((prevState) => ({
      requests: prevState.requests.map((request) =>
        request.id === updatedRequest.id ? updatedRequest : request
      ),
      isAddRequestModalOpen: false, // Close the modal after updating
    }));
  };

  // Handle deleting a request
  handleDeleteRequest = (id) => {
    this.setState((prevState) => ({
      requests: prevState.requests.filter((request) => request.id !== id),
    }));
  };

  render() {
    const columns = [
      { field: "id", headerName: "Request ID", width: 150 },
      { field: "request_date", headerName: "Request Date", width: 200 },
      { field: "Item_Name", headerName: "Item Name", width: 150 },
      { field: "item_id", headerName: "Item ID", width: 150 },
      { field: "user_id", headerName: "User ID", width: 150 },
      { field: "quantity", headerName: "Quantity", width: 150 },
      {
        field: "actions",
        headerName: "Actions",
        width: 200,
        renderCell: (params) => (
          <Box sx={{ display: "flex", gap: 2 }}>
            <Button
              variant="contained"
              color="primary"
              size="small"
              onClick={() => this.openEditRequestModal(params.row)}
            >
              Edit
            </Button>
            <Button
              variant="contained"
              color="secondary"
              size="small"
              onClick={() => this.handleDeleteRequest(params.row.id)}
            >
              Delete
            </Button>
          </Box>
        ),
      },
    ];

    const rows = this.state.requests; // Data comes from state

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
        <br></br>
        <Button
          variant="contained"
          color="primary"
          onClick={this.openAddRequestModal}
        >
          Add Request
        </Button>
        <br></br>
        <br></br>
        <DataGrid
          sx={{
            borderLeft: 0,
            borderRight: 0,
            borderRadius: 0,
          }}
          rows={rows}
          columns={columns}
          pageSize={10}
          rowsPerPageOptions={[10, 20, 30]}
        />
        <AddRequestModal
          isOpen={this.state.isAddRequestModalOpen}
          onClose={this.closeAddRequestModal}
          onAddRequest={this.handleAddRequest} // Pass the handler for adding
          onUpdateRequest={this.handleUpdateRequest} // Pass the handler for updating
          editingRequest={this.state.editingRequest} // Pass the request being edited (if any)
        />
      </Box>
    );
  }
}
