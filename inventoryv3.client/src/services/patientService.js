import axios from "axios";
import { API_HOST_PREFIX, onGlobalSuccess, onGlobalError } from "./serviceHelpers";

const patientService = {
    endpoint: `${API_HOST_PREFIX}/api/Patient`,
};

patientService.getAll = (pageIndex, pageSize) => {
    const config = {
        method: "GET",
        url: `${patientService.endpoint}?pageIndex=${pageIndex}&pageSize=${pageSize}`,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

patientService.insert = (payload) => {
    const config = {
        method: "POST",
        url: patientService.endpoint,
        data: payload,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

patientService.update = (id, payload) => {
    const config = {
        method: "PUT",
        url: `${patientService.endpoint}/${id}`,
        data: payload,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

patientService.softDelete = (id) => {
    const config = {
        method: "DELETE",
        url: `${patientService.endpoint}/${id}`,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

export default patientService;
