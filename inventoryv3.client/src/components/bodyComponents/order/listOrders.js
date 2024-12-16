import productList from "../inventory/productList";
import users from "../user/Users";

const orders = [
  {
    id: 1,
    products: [
      { quantity: 5, product: productList[2] },
      { quantity: 1, product: productList[4] },
      { quantity: 8, product: productList[6] },
      { quantity: 5, product: productList[8] },
    ],
    customer: users[2],
    total: 842,
  },
  {
    id: 2,
    products: [
      { quantity: 2, product: productList[3] },
      { quantity: 9, product: productList[5] },
      { quantity: 3, product: productList[7] },
    ],
    customer: users[4],
    total: 3753.00,
  },
  {
    id: 3,
    products: [
      { quantity: 2, product: productList[4] },
      { quantity: 9, product: productList[5] },
      { quantity: 3, product: productList[9] },
    ],
    customer: users[1],
    total: 484.00,
  },
  {
    id: 4,
    products: [
      { quantity: 2, product: productList[1] },
      { quantity: 9, product: productList[5] },
      { quantity: 3, product: productList[0] },
    ],
    customer: users[0],
    total: 8524.00,
  },
  {
    id: 5,
    products: [
      { quantity: 2, product: productList[4] },
      { quantity: 9, product: productList[5] },
      { quantity: 3, product: productList[1] },
    ],
    customer: users[7],
    total: 678.00,
  },
];

export default orders;
