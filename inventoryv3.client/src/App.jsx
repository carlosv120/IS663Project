import './assets/styles/links.css';

import { ThemeProvider, CssBaseline, createTheme } from "@mui/material";
import { UilReceipt, UilBox, UilTruck, UilCheckCircle } from '@iconscout/react-unicons';

import RootComponent from "./components/RootComponent";
import RootPage from "./components/RootPage";
import DataTable from "./test/DataTable";
import Hello from "./test/Hello";

import {
  Route,
  createBrowserRouter,
  createRoutesFromElements,
  RouterProvider,
} from "react-router-dom";

import Home from "./components/bodyComponents/home/Home";
import Inventory from "./components/bodyComponents/inventory/Inventory";
import Patient from "./components/bodyComponents/patient/Patient";
import Revenue from "./components/bodyComponents/revenue/Revenue";
import Supplier from "./components/bodyComponents/supplier/Supplier";
import Request from "./components/bodyComponents/request/Request";
import Growth from "./components/bodyComponents/growth/Growth";
import Report from "./components/bodyComponents/report/Report";
import Setting from "./components/bodyComponents/Settings/Setting";
import Order from "./components/bodyComponents/order/Order";
import User from "./components/bodyComponents/user/User";

function App() {
  const theme = createTheme({
    spacing: 4,
    palette: {
      mode: "light",
      // Customize your palette here if needed
    },
    typography: {
      fontFamily: '"Inter", Arial, sans-serif',
    },
    components: {
      MuiCssBaseline: {
        styleOverrides: {
          '@global': {
            '@font-face': {
              fontFamily: 'Inter',
              fontStyle: 'normal',
              fontWeight: 400,
              src: `url('./assets/fonts/Inter.ttf') format('truetype')`,
            },
          },
        },
      },
    },
  });

  const router = createBrowserRouter(
    createRoutesFromElements(
      <Route path="/" element={<RootComponent />}>
        <Route index element={<RootPage />} />
        <Route path="/home" element={<Home />} />
        <Route path="/inventory" element={<Inventory />} />
        <Route path="/orders" element={<Order />} />
        <Route path="/users" element={<User />} />
        <Route path="/patients" element={<Patient />} />
        <Route path="/revenue" element={<Revenue />} />
        <Route path="/suppliers" element={<Supplier />} />
        <Route path="/requests" element={<Request />} />
        <Route path="/growth" element={<Growth />} />
        <Route path="/reports" element={<Report />} />
        <Route path="/settings" element={<Setting />} />
      </Route>
    )
  );

  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <RouterProvider router={router} />
    </ThemeProvider>
  );
}

export default App;
