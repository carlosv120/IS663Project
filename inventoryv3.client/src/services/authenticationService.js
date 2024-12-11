import axios from "axios";
import { API_HOST_PREFIX, onGlobalSuccess, onGlobalError } from "./serviceHelpers";

const authenticationService = {
  endpoint: `${API_HOST_PREFIX}/api/Login/authenticate`,
};

/**
 * Sends login credentials to the backend and stores the JWT token in cookies.
 * @param {Object} payload - User credentials (username and passwordHash)
 * @returns {Promise<Object>} - Response data from the backend
 */
authenticationService.login = (payload) => {
    const config = {
      method: "POST",
      url: authenticationService.endpoint,
      data: payload,
      withCredentials: true, // Ensure cookies are sent and received
      crossdomain: true,
      headers: { "Content-Type": "application/json" },
    };
  
    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
  };

export default authenticationService;
