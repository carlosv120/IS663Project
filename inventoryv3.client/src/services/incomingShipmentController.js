import axios from "axios";
import { API_HOST_PREFIX, onGlobalSuccess, onGlobalError } from "./serviceHelpers";

const incomingShipmentService = {
    endpoint: `${API_HOST_PREFIX}/api/IncomingShipment`,
};

incomingShipmentService.getAll = (pageIndex, pageSize) => {
    const config = {
        method: "GET",
        url: `${incomingShipmentService.endpoint}?pageIndex=${pageIndex}&pageSize=${pageSize}`,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

incomingShipmentService.insert = (payload) => {
    const config = {
        method: "POST",
        url: incomingShipmentService.endpoint,
        data: payload,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

incomingShipmentService.update = (id, payload) => {
    const config = {
        method: "PUT",
        url: `${incomingShipmentService.endpoint}/${id}`,
        data: payload,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

incomingShipmentService.softDelete = (id) => {
    const config = {
        method: "DELETE",
        url: `${incomingShipmentService.endpoint}/${id}`,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

export default incomingShipmentService;
