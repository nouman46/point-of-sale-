<!DOCTYPE html>
<html>
<head>
    <title>Order Details</title>
</head>
<body>
<h2>Order Details</h2>
<p><strong>Customer Name:</strong> ${order.customerName}</p>
<p><strong>Total Amount:</strong> ${order.totalAmount}</p>

<h3>Purchased Products:</h3>
<table>
    <tr>
        <th>Product Name</th>
        <th>Price</th>
        <th>Quantity</th>
        <th>Subtotal</th>
    </tr>
    <g:each in="${order.orderItems}" var="item">
        <tr>
            <td>${item.product.productName}</td>
            <td>${item.product.productPrice}</td>
            <td>${item.quantity}</td>
            <td>${item.product.productPrice * item.quantity}</td>
        </tr>
    </g:each>
</table>
</body>
</html>
