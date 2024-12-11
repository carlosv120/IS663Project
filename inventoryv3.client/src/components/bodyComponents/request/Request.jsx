import React, { Component } from "react";
import RequestList from "./RequestList";
import { Box, Typography } from "@mui/material";
export default class Request extends Component {
  render() {
    return (
      <Box sx={{ m: 0, p: 3, width: "100%" }}>
        <Typography variant="h5" sx={{ m: 3, fontWeight: "bold" }}>
          Requests
        </Typography>
        <RequestList />
      </Box>
    );
  }
}
