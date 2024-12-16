import React, { Component } from "react";
import { Box, Button } from "@mui/material";
import { DataGrid } from "@mui/x-data-grid";
import AddPatientModal from "./AddPatientModal"; // Import the AddPatientModal component
import patientsList from "./Patients"; // Assuming initial patient data is here

export default class PatientList extends Component {
  constructor(props) {
    super(props);
    this.state = {
      patients: patientsList, // Initialize with your patient data
      isAddPatientModalOpen: false,
      editingPatient: null, // Track the patient being edited, if any
    };
  }

  // Open modal for adding a new patient
  openAddPatientModal = () => {
    this.setState({ isAddPatientModalOpen: true, editingPatient: null });
  };

  // Open modal for editing an existing patient
  openEditPatientModal = (patient) => {
    this.setState({ isAddPatientModalOpen: true, editingPatient: patient });
  };

  // Close the modal
  closeAddPatientModal = () => {
    this.setState({ isAddPatientModalOpen: false });
  };

  // Handle adding a new patient
  handleAddPatient = (newPatient) => {
    this.setState((prevState) => ({
      patients: [...prevState.patients, newPatient], // Add new patient to the list
      isAddPatientModalOpen: false, // Close the modal after adding
    }));
  };

  // Handle updating an existing patient
  handleUpdatePatient = (updatedPatient) => {
    this.setState((prevState) => ({
      patients: prevState.patients.map((patient) =>
        patient.id === updatedPatient.id ? updatedPatient : patient
      ),
      isAddPatientModalOpen: false, // Close the modal after updating
    }));
  };

  // Handle deleting a patient
  handleDeletePatient = (id) => {
    this.setState((prevState) => ({
      patients: prevState.patients.filter((patient) => patient.id !== id),
    }));
  };

  render() {
    const columns = [
      {
        field: "id",
        headerName: "Patient ID",
        width: 90,
      },
      {
        field: "fullname",
        headerName: "Full Name",
        width: 200,
        renderCell: (params) => (
          <Box sx={{ display: "flex", alignItems: "center" }}>
              {`${params.row.firstName || ""} ${params.row.lastName || ""}`}
          </Box>
        ),
      },
      {
        field: "dob",
        headerName: "Date of Birth",
        width: 150,
      },
      {
        field: "email",
        headerName: "Email Address",
        width: 250,
      },
      {
        field: "mobile",
        headerName: "Contact Number",
        width: 180,
      },
      {
        field: "actions",
        headerName: "Actions",
        width: 180,
        renderCell: (params) => (
          <Box sx={{ display: "flex", gap: 2 }}>
            <Button
              variant="contained"
              color="primary"
              size="small"
              onClick={() => this.openEditPatientModal(params.row)}
            >
              Edit
            </Button>
            <Button
              variant="contained"
              color="secondary"
              size="small"
              onClick={() => this.handleDeletePatient(params.row.id)}
            >
              Delete
            </Button>
          </Box>
        ),
      },
    ];

    const rows = this.state.patients; // Data comes from state

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
        <Button
          variant="contained"
          color="primary"
          onClick={this.openAddPatientModal}
          sx={{ mb: 2 }}
        >
          Add Patient
        </Button>
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
        <AddPatientModal
          open={this.state.isAddPatientModalOpen}
          onClose={this.closeAddPatientModal}
          onAddPatient={this.handleAddPatient}
          onUpdatePatient={this.handleUpdatePatient}
          editingPatient={this.state.editingPatient}
        />
      </Box>
    );
  }
}
