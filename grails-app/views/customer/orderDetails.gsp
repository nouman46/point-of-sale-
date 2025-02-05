<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main" />
    <title>Order Details</title>
    <script type="text/javascript">
        window.onload = function() {
            var summary = "Order Placed Successfully!\n" +
                "Customer: ${customer.customerName}\n" +
                "Total Price: ${customer.totalPrice}\n\n" +
                "Details:\n";
            <g:each in="${customer.purchasedItems}" var="item">
            summary += "${item.productName} - Qty: ${item.quantity}, Total: ${item.totalItemPrice}\n";
            </g:each>
            alert(summary);
        }
    </script>
</head>
<body>
<h1>Order Details</h1>
<p>The order details are also shown in a pop-up alert.</p>
<table>
    <thead>
    <tr>
        <th>Product Name</th>
        <th>Description</th>
        <th>SKU</th>
        <th>Barcode</th>
        <th>Unit Price</th>
        <th>Quantity</th>
        <th>Total</th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${customer.purchasedItems}" var="item">
        <tr>
            <td>${item.productName}</td>
            <td>${item.productDescription}</td>
            <td>${item.productSKU}</td>
            <td>${item.productBarcode}</td>
            <td>${item.unitPrice}</td>
            <td>${item.quantity}</td>
            <td>${item.totalItemPrice}</td>
        </tr>
    </g:each>
    </tbody>
</table>
<h3>Total Price: ${customer.totalPrice}</h3>
</body>
</html>
