import axios from "axios";

// Enable credentials (cookies) to be sent with every request
axios.defaults.withCredentials = true;

// Add interceptors for logging and global error handling
axios.interceptors.request.use((config) => {
  config.withCredentials = true; // Include credentials in every request
  return config;
});

/**
 * Handles successful responses globally.
 * Extracts and returns the data from the response.
 */
const onGlobalSuccess = (response) => response.data;

/**
 * Handles errors globally.
 * Returns a rejected promise with the error object.
 */
const onGlobalError = (err) => Promise.reject(err);

const API_HOST_PREFIX = process.env.REACT_APP_API_HOST_PREFIX || "https://localhost:7034";

export { onGlobalError, onGlobalSuccess, API_HOST_PREFIX };
