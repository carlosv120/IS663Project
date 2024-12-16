import React, { Component } from "react";
import RequestList from "./RequestList";
import { Box, Typography, Button } from "@mui/material";
import AddRequestModal from "./AddRequestModal"; // A new component to add requests

export default class Request extends Component {
  state = {
    requests: [], // The list of requests
    isModalOpen: false, // To control modal visibility
    editingRequest: null, // Store the request that is being edited
  };

  // Toggle AddRequestModal
  handleAddRequestClick = () => {
    this.setState({ isModalOpen: true });
  };

  handleCloseModal = () => {
    this.setState({ isModalOpen: false, editingRequest: null });
  };

  handleAddRequest = (newRequest) => {
    this.setState((prevState) => ({
      requests: [...prevState.requests, newRequest],
      isModalOpen: false,
    }));
  };

  handleUpdateRequest = (updatedRequest) => {
    this.setState((prevState) => ({
      requests: prevState.requests.map((request) =>
        request.id === updatedRequest.id ? updatedRequest : request
      ),
      isModalOpen: false,
      editingRequest: null,
    }));
  };

  handleDeleteRequest = (requestId) => {
    this.setState((prevState) => ({
      requests: prevState.requests.filter((request) => request.id !== requestId),
    }));
  };

  render() {
    return (
      <Box sx={{ m: 0, p: 3, width: "100%" }}>
        <Typography variant="h5" sx={{ m: 3, fontWeight: "bold" }}>
          Requests
        </Typography>
        <RequestList
          requests={this.state.requests}
          onEditRequest={this.handleUpdateRequest}
          onDeleteRequest={this.handleDeleteRequest}
        />
        <AddRequestModal
          isOpen={this.state.isModalOpen}
          onClose={this.handleCloseModal}
          onAddRequest={this.handleAddRequest}
          editingRequest={this.state.editingRequest}
          onUpdateRequest={this.handleUpdateRequest}
        />
      </Box>
    );
  }
}
