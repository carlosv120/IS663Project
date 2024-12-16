import axios from "axios";
import { API_HOST_PREFIX, onGlobalSuccess, onGlobalError } from "./serviceHelpers";

const inventoryTransactionService = {
    endpoint: `${API_HOST_PREFIX}/api/InventoryTransaction`,
};

inventoryTransactionService.getAll = (pageIndex, pageSize) => {
    const config = {
        method: "GET",
        url: `${inventoryTransactionService.endpoint}?pageIndex=${pageIndex}&pageSize=${pageSize}`,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

inventoryTransactionService.insert = (payload) => {
    const config = {
        method: "POST",
        url: inventoryTransactionService.endpoint,
        data: payload,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

inventoryTransactionService.update = (id, payload) => {
    const config = {
        method: "PUT",
        url: `${inventoryTransactionService.endpoint}/${id}`,
        data: payload,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

inventoryTransactionService.softDelete = (id) => {
    const config = {
        method: "DELETE",
        url: `${inventoryTransactionService.endpoint}/${id}`,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

export default inventoryTransactionService;
