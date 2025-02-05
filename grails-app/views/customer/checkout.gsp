<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main" />
    <title>Checkout Form</title>
</head>
<body>
<h1>Checkout</h1>
<g:form controller="customer" action="processCheckout">
    <fieldset>
        <legend>Customer Information</legend>
        <div>
            <label for="customerName">Customer Name:</label>
            <g:textField name="customerName" required="true" />
        </div>
    </fieldset>
    <fieldset>
        <legend>Select Products</legend>
    <!-- Allow three product selections -->
        <g:each in="${(0..2)}" var="i">
            <div style="border:1px solid #ccc; padding:5px; margin-bottom:5px;">
                <h4>Product ${i+1}</h4>
                <div>
                    <label for="productId[${i}]">Select Product:</label>
                    <g:select name="productId" from="${Product.list()}" optionKey="id" optionValue="productName" index="${i}" required="true" />
                </div>
                <div>
                    <label for="quantity[${i}]">Quantity:</label>
                    <g:textField name="quantity" value="1" index="${i}" required="true" />
                </div>
            </div>
        </g:each>
    </fieldset>
    <div>
        <g:submitButton name="checkout" value="Checkout" />
    </div>
</g:form>
</body>
</html>
