<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main" />
    <title>Checkout</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .checkout-container { display: none; }
        .fade-in { animation: fadeInAnimation 0.5s ease-in-out; }
        @keyframes fadeInAnimation { from { opacity: 0; } to { opacity: 1; } }
        .error-message { color: red; font-size: 14px; margin-left: 10px; }
        .checkout-title { background-color: #000; color: #fff; padding: 25px; text-align: center; font-size: 30px; font-weight: bold; border-radius: 8px; box-shadow: 0px 4px 6px rgba(255, 255, 255, 0.1); margin-bottom: 20px; }
        .quantity-input { width: 70px; display: inline-block; }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container mt-4 checkout-container fade-in">
    <h1 class="text-center mb-4 checkout-title">🛒 Checkout</h1>

    <g:form id="checkoutForm">
        <div class="row">
            <div class="mb-3 w-50">
                <label class="form-label fw-bold">Customer Name:</label>
                <g:textField name="customerName" class="form-control" />
                <div id="customerNameError" class="error-message"></div>
            </div>
            <div class="mb-3 w-50">
                <label class="form-label fw-bold">Scan Barcode:</label>
                <input type="text" id="barcodeInput" class="form-control" placeholder="Scan barcode here..." autofocus>
                <button type="button" id="scanButton" class="btn btn-primary mt-2">➕ Add Product</button>
                <div id="barcodeError" class="error-message"></div>
            </div>
        </div>

        <input type="hidden" id="totalInput" name="total" value="0.00">

        <table class="table table-striped table-hover mt-4" id="itemsTable">
            <thead class="table-dark">
            <tr>
                <th>Product</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Subtotal</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody id="itemsBody"></tbody>
        </table>

        <div class="bg-light p-3 rounded">
            <h4 class="fw-bold d-inline">Total:</h4>
            <h4 id="total" class="text-success d-inline ms-2">0.00 PKR</h4>
        </div>

        <div class="row mt-3">
            <div class="mb-3 col-md-6">
                <label class="form-label fw-bold">Amount Received:</label>
                <input type="number" step="0.01" min="0" name="amountReceived" id="amountReceived" class="form-control" value="">
                <div id="amountReceivedError" class="error-message"></div>
            </div>
            <div class="mb-3 col-md-6">
                <label class="form-label fw-bold">Amount to be  returned :</label>
                <input type="number" step="0.01" readonly name="remainingAmount" id="remainingAmount" class="form-control" value="0.00">
            </div>
        </div>

        <button type="button" id="checkoutButton" class="btn btn-success btn-lg w-100 mt-3">✅ Complete Checkout</button>
        <button type="button" class="btn btn-primary mb-3" onclick="openNewCheckout()">🆕 New Checkout</button>
    </g:form>
</div>

<div class="modal fade" id="checkoutModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title">✅ Checkout Completed!</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body text-center">
                <p>Your order has been successfully placed.</p>
            </div>
            <div class="modal-footer">
                <button type="button" id="closeSuccess" class="btn btn-success" data-bs-dismiss="modal">OK</button>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        $(".checkout-container").fadeIn(400);

        $('#scanButton').click(function () {
            const barcode = $('#barcodeInput').val().trim();
            $.ajax({
                url: "/order/getProductByBarcode",
                data: { productBarcode: barcode },
                success: function (data) {
                    let newRow = $(data).hide();
                    $('#itemsBody').append(newRow);
                    newRow.fadeIn(400);
                    updateTotals();
                    $('#barcodeInput').val('').focus();
                },
                error: function (xhr) {
                    $("#barcodeError").text("❌ " + (xhr.responseText || "Product not found!"));
                }
            });
        });

        $(document).on('input', 'input[name="quantity"]', function () {
            let row = $(this).closest('tr');
            let price = parseFloat(row.find('.item-price').text()) || 0;
            let quantity = parseInt($(this).val()) || 1;
            let total = price * quantity;
            row.find('.item-total').text(total.toFixed(2) + " PKR");
            updateTotals();
        });

        $(document).on('click', '.remove-item', function () {
            let row = $(this).closest('tr');
            row.fadeOut(400, function () {
                $(this).remove();
                updateTotals();
            });
        });

        $('#amountReceived').on('input', function() {
            calculateRemaining();
        });

        $("#checkoutButton").click(function () {
            let customerName = $("input[name='customerName']").val().trim();
            let amountReceived = parseFloat($('#amountReceived').val()) || 0;
            let products = [];

            $("#itemsTable tbody tr").each(function () {
                let barcode = $(this).find(".product-barcode").text().trim();
                let quantity = $(this).find("input[name='quantity']").val().trim();
                if (barcode && quantity) {
                    products.push({ productBarcode: barcode, quantity: parseInt(quantity) });
                }
            });

            // Clear previous error messages
            $("#customerNameError").text("");
            $("#barcodeError").text("");
            $("#amountReceivedError").text("");
            $("#itemsBody .item-error").text("");

            $.ajax({
                type: "POST",
                url: "/order/saveOrder",
                contentType: "application/json",
                data: JSON.stringify({
                    customerName: customerName,
                    products: products,
                    amountReceived: amountReceived
                }),
                success: function (response) {
                    if (response.status === "success") {
                        const checkoutModal = new bootstrap.Modal(document.getElementById("checkoutModal"));
                        checkoutModal.show();
                        setTimeout(function() {
                            window.location.href = "/order/orderDetails/" + response.orderId;
                        }, 2000);
                        $("#checkoutForm")[0].reset();
                        $("#itemsBody").empty();
                        $("#total").text("0.00 PKR");
                        $("#remainingAmount").val("0.00");
                    } else {
                        // Display error based on the field
                        if (response.field === "customerName") {
                            $("#customerNameError").text("❌ " + response.message);
                        } else if (response.field === "products") {
                            $("#barcodeError").text("❌ " + response.message);
                        } else if (response.field === "stock" && response.productBarcode) {
                            let row = $("#itemsBody tr").filter(function() {
                                return $(this).find(".product-barcode").text().trim() === response.productBarcode;
                            });
                            if (row.length) {
                                row.find(".item-error").text("❌ " + response.message);
                            } else {
                                $("#barcodeError").text("❌ " + response.message);
                            }
                        } else if (response.field === "amountReceived") {
                            $("#amountReceivedError").text("❌ " + response.message);
                        } else {
                            $("#barcodeError").text("❌ " + response.message); // Fallback
                        }
                    }
                },
                error: function (xhr) {
                    $("#barcodeError").text("❌ " + (xhr.responseText || "Server error occurred."));
                }
            });
        });

        function updateTotals() {
            let subtotal = 0;
            $('.item-total').each(function () {
                subtotal += parseFloat($(this).text()) || 0;
            });
            $('#total').text(subtotal.toFixed(2) + " PKR");
            $('#totalInput').val(subtotal.toFixed(2));
            calculateRemaining();
        }

        function calculateRemaining() {
            let total = parseFloat($('#totalInput').val()) || 0;
            let received = parseFloat($('#amountReceived').val()) || 0;
            let remaining = received - total;
            $('#remainingAmount').val(remaining.toFixed(2));
        }
    });

    function openNewCheckout() {
        window.open("http://localhost:8080/order/checkout", "_blank");
    }
</script>
</body>
</html>