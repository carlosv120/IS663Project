import axios from "axios";
import { API_HOST_PREFIX, onGlobalSuccess, onGlobalError } from "./serviceHelpers";

const dispatchReceiverService = {
    endpoint: `${API_HOST_PREFIX}/api/DispatchReceiver`,
};

dispatchReceiverService.getAll = (pageIndex, pageSize) => {
    const config = {
        method: "GET",
        url: `${dispatchReceiverService.endpoint}?pageIndex=${pageIndex}&pageSize=${pageSize}`,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

dispatchReceiverService.insert = (payload) => {
    const config = {
        method: "POST",
        url: dispatchReceiverService.endpoint,
        data: payload,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

dispatchReceiverService.update = (id, payload) => {
    const config = {
        method: "PUT",
        url: `${dispatchReceiverService.endpoint}/${id}`,
        data: payload,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

dispatchReceiverService.softDelete = (id) => {
    const config = {
        method: "DELETE",
        url: `${dispatchReceiverService.endpoint}/${id}`,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

export default dispatchReceiverService;
