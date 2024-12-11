import productList from "../inventory/productList";

const customer = {
  firstName: "Test",
  lastName: "User",
  position: "Software Engineer",
  mobile: "+212 6 51 88 61 51",
};

const orders = [
  {
    id: 1,
    products: [
      { quantity: 5, product: productList[0] },
      { quantity: 5, product: productList[1] },
      { quantity: 5, product: productList[2] },
    ],
    customer: customer,
  },
  {
    id: 2,
    products: [
      { quantity: 5, product: productList[1] },
      { quantity: 5, product: productList[1] },
      { quantity: 5, product: productList[2] },
    ],
    customer: customer,
  },
  // Add the remaining orders here...
];

export default orders;
