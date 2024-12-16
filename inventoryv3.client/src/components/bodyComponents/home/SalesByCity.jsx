import React from "react";
import { Box } from "@mui/material";
import ApexCharts from "react-apexcharts";

export default function SalesByCity() {
  const donutOption = {
    labels: ["Hackensack", "New York City", "Passaic", "Newark"],
    legend: {
      position: "right",
      fontSize: "16",

      customLegendItems: [
        "Hackensack <b>22.3%</b>",
        "New York City <b>37.9%</b>",
        "Passaic <b>9.0%</b>",
        "Newark <b>22.8%</b>",
      ],
      //   const total = data.reduce((sum, value) => sum + value, 0);
      // const percentages = data.map(value => ((value / total) * 100).toFixed(2) + '%');
    },
    title: {
      text: "Sales By City",
    },
  };
  const donutSeries = [44, 55, 13, 33];

  return (
    <Box
      sx={{
        margin: 4,
        bgcolor: "white",
        borderRadius: 1,
        padding: 3,
        height: "100%",
      }}
    >
      <ApexCharts
        options={donutOption}
        series={donutSeries}
        type="pie"
        width="100%"
      />
    </Box>
  );
}
