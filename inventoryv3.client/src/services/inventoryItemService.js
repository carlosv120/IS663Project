import axios from "axios";
import { API_HOST_PREFIX, onGlobalSuccess, onGlobalError } from "./serviceHelpers";

const inventoryItemService = {
    endpoint: `${API_HOST_PREFIX}/api/InventoryItem`,
};

inventoryItemService.getAll = (pageIndex, pageSize) => {
    const config = {
        method: "GET",
        url: `${inventoryItemService.endpoint}?pageIndex=${pageIndex}&pageSize=${pageSize}`,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

inventoryItemService.insert = (payload) => {
    const config = {
        method: "POST",
        url: inventoryItemService.endpoint,
        data: payload,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

inventoryItemService.update = (id, payload) => {
    const config = {
        method: "PUT",
        url: `${inventoryItemService.endpoint}/${id}`,
        data: payload,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

inventoryItemService.softDelete = (id) => {
    const config = {
        method: "DELETE",
        url: `${inventoryItemService.endpoint}/${id}`,
        withCredentials: true,
        crossdomain: true,
        headers: { "Content-Type": "application/json" },
    };

    return axios(config).then(onGlobalSuccess).catch(onGlobalError);
};

export default inventoryItemService;
