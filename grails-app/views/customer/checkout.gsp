<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Checkout</title>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
        $(document).ready(function () {
            // Initialize total price
            let totalPrice = 0;

            // Function to add product row and update total price
            function addProductRow(product) {
                let productRow = `
                    <tr data-product-id="${product.id}">
                        <td>${product.productName}</td>
                        <td>${product.productDescription || 'N/A'}</td>
                        <td>${product.productSKU}</td>
                        <td>${product.productPrice}</td>
                        <td>${product.productQuantity}</td>
                        <td><input type="number" name="quantity_${product.id}" value="1" min="1" max="${product.productQuantity}" class="quantity-input"></td>
                        <td><button class="remove-product-btn">Remove</button></td>
                    </tr>
                `;
                // Add product row to table
                $('#product-list tbody').append(productRow);

                // Update total price
                totalPrice += product.productPrice;
                updateTotalPrice();
            }

            // Update total price function
            function updateTotalPrice() {
                $('#totalPrice').text('Total Price: ' + totalPrice.toFixed(2));
            }

            // Scan product by barcode
            $('#barcodeInput').on('change', function () {
                let barcode = $(this).val();
                if (barcode) {
                    $.ajax({
                        url: '/customer/getProductByBarcode',
                        type: 'GET',
                        data: { barcode: barcode },
                        dataType: 'json',
                        success: function (response) {
                            if (response.success && response.product) {
                                addProductRow(response.product);
                            } else {
                                alert('Product not found!');
                            }
                        },
                        error: function () {
                            alert('Error scanning product.');
                        }
                    });
                }
            });

            // Remove product from the table
            $(document).on('click', '.remove-product-btn', function () {
                let row = $(this).closest('tr');
                let productId = row.data('product-id');
                let productPrice = parseFloat(row.find('td:nth-child(4)').text());
                totalPrice -= productPrice;
                row.remove();
                updateTotalPrice();
            });
        });
    </script>
</head>
<body>

<div class="content scaffold-list" role="main">
    <h1>Checkout</h1>

    <g:form controller="customer" action="processCheckout">
        <fieldset>
            <legend>Customer Information</legend>
            <div>
                <label for="customerName">Customer Name:</label>
                <g:textField name="customerName" required="true"/>
            </div>
        </fieldset>

        <fieldset>
            <legend>Scan Products</legend>
            <div>
                <label for="barcodeInput">Scan Barcode:</label>
                <input type="text" id="barcodeInput" name="barcodeInput" />
            </div>
            <table id="product-list">
                <thead>
                <tr>
                    <th>Product Name</th>
                    <th>Description</th>
                    <th>SKU</th>
                    <th>Price</th>
                    <th>Available Quantity</th>
                    <th>Order Quantity</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <!-- Products will be dynamically added here -->
                </tbody>
            </table>
        </fieldset>

        <div>
            <div id="totalPrice">Total Price: 0.00</div>
            <g:submitButton name="checkout" value="Checkout"/>
        </div>
    </g:form>
</div>

</body>
</html>
