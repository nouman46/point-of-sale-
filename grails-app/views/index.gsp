<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Start Checkout</title>
</head>
<body>
<h1>Start Checkout</h1>
<g:form controller="checkout" action="startCheckout">
    <label for="customerName">Customer Name:</label>
    <g:textField name="customerName" />
    <g:submitButton name="startCheckout" value="Start Checkout" />
</g:form>
</body>
</html>
