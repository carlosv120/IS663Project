import { Avatar, Typography } from "@mui/material";
import React from "react";

export default function Product({ productName }) {
  return (
    <>
      <Avatar
        alt="alt"
        // Placeholder avatar
        sx={{ width: 30, height: 30 }}
      >
        {productName?.charAt(0) || "A"}
      </Avatar>

      <Typography sx={{ mx: 3 }} variant="subtitle2">
        {productName || "Unknown"}
      </Typography>
    </>
  );
}
