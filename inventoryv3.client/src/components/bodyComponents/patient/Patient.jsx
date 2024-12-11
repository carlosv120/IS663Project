import React, { Component } from "react";
import PatientList from "./PatientList";
import { Box, Typography } from "@mui/material";
export default class Patient extends Component {
  render() {
    return (
      <Box sx={{ m: 0, p: 3, width: "100%" }}>
        <Typography variant="h5" sx={{ m: 3, fontWeight: "bold" }}>
          Patients
        </Typography>
        <PatientList />
      </Box>
    );
  }
}
