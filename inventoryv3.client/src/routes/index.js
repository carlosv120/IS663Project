import { createBrowserRouter, createRoutesFromElements, Route, Navigate } from "react-router-dom";
import RootComponent from "../components/RootComponent";
import LoginPage from "../components/LoginPage";
import ProtectedRoute from "../components/ProtectedRoute";
import Home from "../components/bodyComponents/home/Home";
import Inventory from "../components/bodyComponents/inventory/Inventory";
import Patient from "../components/bodyComponents/patient/Patient";
import Order from "../components/bodyComponents/order/Order";

const router = createBrowserRouter(
  createRoutesFromElements(
    <>
      {/* Public Route */}
      <Route path="/login" element={<LoginPage />} />

      {/* Protected Routes */}
      <Route
        path="/"
        element={
          <ProtectedRoute>
            <RootComponent />
          </ProtectedRoute>
        }
      >
        <Route index element={<Navigate to="/home" replace />} />
        <Route path="/home" element={<Home />} />
        <Route path="/inventory" element={<Inventory />} />
        <Route path="/patients" element={<Patient />} />
        <Route path="/orders" element={<Order />} />
      </Route>
    </>
  )
);

export default router;
