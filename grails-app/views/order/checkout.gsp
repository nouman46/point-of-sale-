<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main" />
    <title>Checkout</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom Styles -->
    <style>
        /* Page fade-in effect */
        body {
            display: none;
        }

        /* Fade-in animation */
        .fade-in {
            animation: fadeInAnimation 0.5s ease-in-out;
        }

        @keyframes fadeInAnimation {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        /* Error message styling */
        .error-message {
            color: red;
            font-size: 14px;
            margin-top: 5px;
        }
    </style>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- Bootstrap Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>

<div class="container mt-4 fade-in">
    <h1 class="text-center mb-4">🛒 Checkout</h1>

    <g:form id="checkoutForm">
        <!-- Customer Name -->
        <div class="mb-3">
            <label class="form-label fw-bold">Customer Name:</label>
            <g:textField name="customerName" class="form-control" />
            <div id="customerNameError" class="error-message"></div> <!-- Error display -->
        </div>

        <!-- Barcode Input -->
        <div class="mb-3">
            <label class="form-label fw-bold">Scan Barcode:</label>
            <div class="input-group">
                <input type="text" id="barcodeInput" class="form-control" placeholder="Scan barcode here..." autofocus>
                <button type="button" id="scanButton" class="btn btn-primary">➕ Add Product</button>
            </div>
            <div id="barcodeError" class="error-message"></div> <!-- Barcode error display -->
        </div>

        <input type="hidden" id="totalInput" name="total" value="0.00">

        <!-- Table for Products -->
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
            <tbody id="itemsBody">
            </tbody>
        </table>

        <!-- Total Section -->
        <div class="d-flex justify-content-between align-items-center bg-light p-3 rounded">
            <h4 class="fw-bold">Total:</h4>
            <h4 id="total" class="text-success">0.00 PKR</h4>
        </div>

        <!-- Checkout Button -->
        <button type="button" id="checkoutButton" class="btn btn-success btn-lg w-100 mt-3">✅ Complete Checkout</button>
    </g:form>
</div>

<!-- Checkout Confirmation Modal -->
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
        $("body").fadeIn(400);

        $('#scanButton').click(function () {
            const barcode = $('#barcodeInput').val();
            $("#barcodeError").text(""); // Clear previous error

            if (barcode) {
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
                    error: function () {
                        $("#barcodeError").text("❌ Product not found!"); // Show error below input
                    }
                });
            }
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

        $("#checkoutButton").click(function (event) {
            event.preventDefault();

            let customerName = $("input[name='customerName']").val().trim();
            let products = [];
            $("#customerNameError").text(""); // Clear previous errors
            $("#barcodeError").text("");

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

            if (!customerName) {
                $("#customerNameError").text("❌ Customer name is required.");
                return;
            }

            if (products.length === 0) {
                $("#barcodeError").text("❌ At least one product must be added.");
                return;
            }

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
                        const checkoutModal = new bootstrap.Modal(document.getElementById("checkoutModal"));
                        checkoutModal.show();

                        setTimeout(function() {
                            window.location.href = "/order/orderDetails/" + response.orderId;
                        }, 2000);

                        $("#checkoutForm")[0].reset();
                        $("#itemsBody").empty();
                        $("#total").text("0.00 PKR");
                    }
                },
                error: function (xhr) {
                    if (xhr.responseJSON && xhr.responseJSON.errors) {
                        xhr.responseJSON.errors.forEach(error => {
                            if (error.field === "customerName") {
                                $("#customerNameError").text("❌ " + error.message);
                            } else {
                                $("#barcodeError").text("❌ " + error.message);
                            }
                        });
                    }
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
        }
    });
</script>

</body>
</html>
