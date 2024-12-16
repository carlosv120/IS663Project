import axios from "axios";
import { API_HOST_PREFIX, onGlobalSuccess, onGlobalError } from "./serviceHelpers";

const requestService = {
    endpoint: `${API_HOST_PREFIX}/api/Request`,
};

requestService.getAll = (pageIndex, pageSize) => {
    const config = {
        method: "GET",
        url: `${requestService.endpoint}?pageIndex=${pageIndex}&pageSize=${pageSize}`,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

requestService.insert = (payload) => {
    const config = {
        method: "POST",
        url: requestService.endpoint,
        data: payload,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

requestService.update = (id, payload) => {
    const config = {
        method: "PUT",
        url: `${requestService.endpoint}/${id}`,
        data: payload,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

requestService.softDelete = (id) => {
    const config = {
        method: "DELETE",
        url: `${requestService.endpoint}/${id}`,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

export default requestService;
