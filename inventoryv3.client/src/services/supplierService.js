import axios from "axios";
import { API_HOST_PREFIX, onGlobalSuccess, onGlobalError } from "./serviceHelpers";

const supplierService = {
    endpoint: `${API_HOST_PREFIX}/api/Supplier`,
};

supplierService.getAll = (pageIndex, pageSize) => {
    const config = {
        method: "GET",
        url: `${supplierService.endpoint}?pageIndex=${pageIndex}&pageSize=${pageSize}`,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

supplierService.insert = (payload) => {
    const config = {
        method: "POST",
        url: supplierService.endpoint,
        data: payload,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

supplierService.update = (id, payload) => {
    const config = {
        method: "PUT",
        url: `${supplierService.endpoint}/${id}`,
        data: payload,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

supplierService.softDelete = (id) => {
    const config = {
        method: "DELETE",
        url: `${supplierService.endpoint}/${id}`,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

export default supplierService;
