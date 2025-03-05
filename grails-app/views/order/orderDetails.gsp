<!DOCTYPE html>
<html>
<head>
    <title>Order Details</title>
    <meta name="layout" content="main" />

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <!-- Custom CSS for Smooth Animations -->
    <style>
        /* Smooth Fade-in Animation */
        .fade-in {
            opacity: 0;
            transform: translateY(20px);
            transition: opacity 0.6s ease-in-out, transform 0.6s ease-in-out;
        }

        .fade-in.visible {
            opacity: 1;
            transform: translateY(0);
        }

        /* Hover effect on rows */
        .table tbody tr {
            transition: background-color 0.3s ease-in-out;
        }

        .table tbody tr:hover {
            background-color: #f1f1f1;
        }

        /* Smooth Button Hover Effect */
        .btn {
            transition: all 0.3s ease-in-out;
        }

        .btn:hover {
            transform: scale(1.05);
        }

        /* Hide sidebar, URL bar, and buttons when printing */
        @media print {
            body * {
                visibility: hidden;
            }
            .printable-content, .printable-content * {
                visibility: visible;
            }
            .printable-content {
                position: absolute;
                left: 0;
                top: 0;
                width: 100%;
            }
            .no-print {
                display: none !important;
            }
            @page {
                margin: 0;
            }
        }
    </style>
</head>
<body>

<div class="container mt-5 fade-in printable-content">
    <!-- Order Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="fw-bold text-primary">🛒 Order Details</h1>
        <button class="btn btn-primary btn-lg no-print" onclick="printOrder()">🖨️ Print</button>
    </div>

    <!-- Order Summary Card -->
    <div class="card shadow-sm mb-4 fade-in">
        <div class="card-body">
            <h5 class="card-title text-secondary fw-bold">Customer Information</h5>
             <div class="ms-5 pb-3">
                <img src="${createLink(controller: 'setting', action: 'displayLogo')}"  style="width: 60px; height: 60px;" alt="Logo" class="logo"/>
            </div>

            <p><strong>👤 Customer Name:</strong> ${order.customerName}</p>
            <p><strong>📅 Order Date:</strong> ${order.dateCreated?.toLocalDateTime()?.format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"))}</p>
            <p class="text-success fw-bold"><strong>💰 Total Price:</strong> ${order.totalAmount} PKR</p>
            <p class="text-primary fw-bold"><strong>💵 Amount Received:</strong> ${order.amountReceived} PKR</p>
            <p class="text-danger fw-bold"><strong>➖ Amount Returned:</strong> ${order.remainingAmount} PKR</p>
        </div>
    </div>

    <!-- Order Items Table -->
    <div class="table-responsive fade-in">
        <table class="table table-striped table-bordered shadow-sm">
            <thead class="table-dark">
            <tr>
                <th>📦 Product Name</th>
                <th>💲 Item Price</th>
                <th>🔢 Quantity</th>
                <th>📊 Subtotal</th>
            </tr>
            </thead>
            <tbody>
            <g:each var="item" in="${orderItems}">
                <tr>
                    <td>${item.productName}</td>
                    <td class="text-success fw-bold">${item.price} PKR</td>
                    <td class="text-center">${item.quantity}</td>
                    <td class="text-danger fw-bold">${item.subtotal} PKR</td>
                </tr>
            </g:each>
            </tbody>
        </table>
    </div>


</div>

<!-- JavaScript for triggering animations dynamically and print function -->
<script>
    // Function to trigger animations when elements come into view
    function animateOnView() {
        const observer = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add("visible");
                    observer.unobserve(entry.target); // Stop observing once animated
                }
            });
        }, { threshold: 0.3 });

        document.querySelectorAll(".fade-in").forEach(element => {
            observer.observe(element);
        });
    }

    // Function to print only the order details without URL
    function printOrder() {
        window.print();
    }

    // Run animation trigger when navigating via AJAX or normal load
    document.addEventListener("DOMContentLoaded", animateOnView);
    document.addEventListener("turbo:load", animateOnView); // Works with Turbo (optional)
</script>

</body>
</html>