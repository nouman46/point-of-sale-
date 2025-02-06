<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <asset:stylesheet src="checkout.css"/>
    <title>Checkout Page</title>

    <script>
        let cartItems = [];

        function fetchProductDetails() {
            var barcode = document.getElementById('barcode').value;
            fetch('/checkout/getProductDetails?barcode=' + barcode)
                .then(response => response.json())
                .then(data => {
                    let existingItem = cartItems.find(item => item.barcode === barcode);
                    if (existingItem) {
                        existingItem.quantity += 1; // Increment quantity if item already exists
                    } else {
                        cartItems.push({
                            barcode: barcode,
                            name: data.name,
                            price: data.price,
                            quantity: 1,
                            image: data.image
                        });
                    }

                    updateProductList();
                    updateTotal();
                });
        }

        function updateProductList() {
            const productList = document.getElementById('productList');
            productList.innerHTML = ''; // Clear previous list

            cartItems.forEach(item => {
                productList.innerHTML += `
                    <div class="order-item">
                        <div class="item-info">
                            <img src="${item.image || '/default-image.jpg'}" alt="${item.name}">
                            <div class="item-details">
                                <strong>${item.name}</strong>
                            </div>
                        </div>
                        <div class="quantity">
                            <label>Qty:</label>
                            <input type="number" min="1" value="${item.quantity}" onchange="updateQuantity('${item.barcode}', this.value)">
                        </div>
                        <strong>$${(item.price * item.quantity).toFixed(2)}</strong>
                    </div>`;
            });
        }

        function updateTotal() {
            const total = cartItems.reduce((sum, item) => sum + item.price * item.quantity, 0);
            document.querySelector('.total span:last-child').textContent = `$${total.toFixed(2)}`;
        }

        function updateQuantity(barcode, newQuantity) {
            const item = cartItems.find(item => item.barcode === barcode);
            if (item) {
                item.quantity = newQuantity;
                updateProductList();
                updateTotal();
            }
        }
    </script>
</head>
<body>
<div class="container">
    <h2>Checkout</h2>

    <div class="customer-section">
        <label for="customerName">Customer Name</label>
        <input type="text" id="customerName" name="customerName" placeholder="Enter customer name" required>
    </div>

    <div class="order-details">
        <h3>Order Details</h3>
        <label for="barcode">Enter Product Barcode</label>
        <input type="text" id="barcode" oninput="fetchProductDetails()" placeholder="Scan or enter barcode">
        <div id="productList"></div>
    </div>

    <div class="total">
        <span>Total</span>
        <span>$0.00</span>
    </div>

    <div class="payment-section">
        <h3>Confirm Payment</h3>
        <g:form controller="checkout" action="processPayment" method="POST">
            <input type="hidden" name="items" id="cartItemsJson">
            <input type="hidden" name="totalAmount" id="totalAmount">
            <button type="submit" onclick="document.getElementById('cartItemsJson').value = JSON.stringify(cartItems);
            document.getElementById('totalAmount').value = document.querySelector('.total span:last-child').textContent.replace('$', '');">
                Proceed to Payment
            </button>
        </g:form>
    </div>
</div>
</body>
</html>
