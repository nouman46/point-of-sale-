<!DOCTYPE html>
<html>
<head>
    <title>Checkout</title>
    <asset:stylesheet src="checkout.css"/>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
    /* Modal Styles */
    .modal {
        display: none; /* Initially hidden */
        position: fixed;
        z-index: 1000;
        left: 50%;
        top: 50%;
        transform: translate(-50%, -50%);
        background-color: white;
        padding: 20px;
        box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
        border-radius: 10px;
        text-align: center;
        width: 350px;
        transition: all 0.3s ease-in-out;
    }
    .modal-content {
        padding: 20px;
    }
    .modal-overlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        z-index: 999;
    }
    .close {
        float: right;
        cursor: pointer;
        font-size: 22px;
        font-weight: bold;
    }
    </style>
</head>
<body>

<div class="container">
    <h1>Checkout</h1>

    <g:form id="checkoutForm">
        <!-- Customer Name -->
        <div class="form-group">
            <label>Customer Name:</label>
            <g:textField name="customerName" class="form-control" required="true"/>
        </div>

        <!-- Barcode Input -->
        <div class="form-group">
            <label>Scan Barcode:</label>
            <div class="input-group">
                <input type="text" id="barcodeInput" class="form-control" placeholder="Scan barcode here..." autofocus>
                <div class="input-group-append">
                    <button type="button" id="scanButton" class="btn btn-primary add-item-btn">
                        ➕ Add Product
                    </button>
                </div>
            </div>
        </div>

        <input type="hidden" id="totalInput" name="total" value="0.00">

        <!-- Table for Products -->
        <table class="table" id="itemsTable">
            <thead>
            <tr>
                <th>Product</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Subtotal</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody id="itemsBody">
            <!-- Items will be dynamically inserted here -->
            </tbody>
        </table>

        <!-- Total Section -->
        <div class="total-section">
            <div class="row">
                <div class="col-md-6 offset-md-6">
                    <div class="d-flex justify-content-between font-weight-bold">
                        <span>Total:</span>
                        <span id="total">0.00 PKR</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Checkout Button -->
        <button type="button" id="checkoutButton" class="btn btn-success btn-lg btn-block mt-4 checkout-btn">
            ✅ Complete Checkout
        </button>
    </g:form>
</div>

<!-- Checkout Confirmation Modal -->
<div class="modal-overlay"></div> <!-- Background overlay -->
<div id="checkoutModal" class="modal">
    <div class="modal-content">
        <span class="close">&times;</span>
        <h2>✅ Checkout Completed!</h2>
        <p>Your order has been successfully placed.</p>
        <button type="button" id="closeSuccess" class="btn btn-success">OK</button>
    </div>
</div>

<script>
    $(document).ready(function () {
        // Fetch product when barcode is scanned
        $('#scanButton').click(function () {
            const barcode = $('#barcodeInput').val();
            if (barcode) {
                $.ajax({
                    url: "/order/getProductByBarcode",
                    data: { productBarcode: barcode },
                    success: function (data) {
                        console.log("✅ Product fetched:", data);
                        $('#itemsBody').append(data);
                        updateTotals();
                        $('#barcodeInput').val('').focus();
                    },
                    error: function () {
                        alert("❌ Product not found!");
                    }
                });
            }
        });

        // Update subtotal & total when quantity changes
        $(document).on('input', 'input[name="quantity"]', function () {
            let row = $(this).closest('tr');
            let price = parseFloat(row.find('.item-price').text()) || 0;
            let quantity = parseInt($(this).val()) || 1;
            let total = price * quantity;

            row.find('.item-total').text(total.toFixed(2) + " PKR");
            updateTotals();
        });

        // Remove item from list
        $(document).on('click', '.remove-item', function () {
            $(this).closest('tr').remove();
            updateTotals();
        });

        // Handle Checkout Button Click
        $("#checkoutButton").click(function (event) {
            event.preventDefault(); // Prevent page reload

            let customerName = $("input[name='customerName']").val();
            let products = [];

            // Collect product data
            $("#itemsTable tbody tr").each(function () {
                let barcodeElement = $(this).find(".product-barcode");
                let quantityInput = $(this).find("input[name='quantity']");

                if (barcodeElement.length && quantityInput.length) {
                    let barcode = barcodeElement.text().trim();
                    let quantity = quantityInput.val().trim();

                    if (barcode && quantity && !isNaN(quantity)) {
                        products.push({ productBarcode: barcode, quantity: parseInt(quantity) });
                    }
                }
            });

            console.log("Collected Products:", products);

            if (products.length === 0) {
                alert("❌ No products added to checkout.");
                return;
            }

            console.log("Data being sent to backend:", {
                customerName: customerName,
                products: products
            });

            // Send data to backend
            $.ajax({
                type: "POST",
                url: "/order/saveOrder",
                contentType: "application/json",
                data: JSON.stringify({
                    customerName: customerName,
                    products: products
                }),
                success: function (response) {
                    if (response.status === "success") {
                        $(".modal-overlay").fadeIn(); // Show overlay
                        $("#checkoutModal").fadeIn(); // Show modal

                        setTimeout(function () {
                            $(".modal-overlay").fadeOut();
                            $("#checkoutModal").fadeOut();
                        }, 3000); // Auto-hide modal after 3 seconds

                        $("#checkoutForm")[0].reset(); // Reset form
                        $("#itemsBody").empty(); // Clear table
                        $("#total").text("0.00 PKR"); // Reset total price
                    } else {
                        alert("❌ Error: " + response.message);
                    }
                },
                error: function () {
                    alert("❌ Something went wrong. Please try again.");
                }
            });
        });

        // Close modal
        $(".close, #closeSuccess").click(function () {
            $(".modal-overlay").fadeOut();
            $("#checkoutModal").fadeOut();
        });

        // Update total price
        function updateTotals() {
            let subtotal = 0;
            $('.item-total').each(function () {
                subtotal += parseFloat($(this).text()) || 0;
            });

            $('#total').text(subtotal.toFixed(2) + " PKR");
            $('#totalInput').val(subtotal.toFixed(2));
        }
    });
</script>

</body>
</html>
