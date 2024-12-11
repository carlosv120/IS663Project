import React, { createContext, useState, useEffect } from "react";

export const AuthContext = createContext();

export function AuthProvider({ children }) {
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  useEffect(() => {
    // Check if the backend-set cookie exists
    const token = getCookie("AuthToken");
    setIsAuthenticated(!!token); // Update authentication state based on token presence
  }, []);

  const login = () => {
    setIsAuthenticated(true); // Update state after login
  };

  const logout = () => {
    // The backend should handle clearing the cookie (e.g., via a logout endpoint)
    setIsAuthenticated(false);
  };

  const getCookie = (name) => {
    // Read cookies set by the backend
    const match = document.cookie.match(new RegExp(`(^| )${name}=([^;]+)`));
    return match ? match[2] : null;
  };

  return (
    <AuthContext.Provider value={{ isAuthenticated, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}
