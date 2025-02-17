<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main" />
    <title>Order List</title>

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <!-- Custom CSS for Animations -->
    <style>
    /* Smooth fade-in effect */
    .fade-in {
        opacity: 0;
        transform: translateY(20px);
        transition: opacity 0.6s ease-in-out, transform 0.6s ease-in-out;
    }

    .fade-in.visible {
        opacity: 1;
        transform: translateY(0);
    }

    /* Row Animation */
    .fade-row {
        opacity: 0;
        transform: translateY(15px);
        transition: opacity 0.5s ease-in-out, transform 0.5s ease-in-out;
    }

    .fade-row.visible {
        opacity: 1;
        transform: translateY(0);
    }

    /* Table row hover effect */
    .table tbody tr {
        transition: background-color 0.3s ease-in-out;
    }

    .table tbody tr:hover {
        background-color: #f8f9fa;
    }

    /* Smooth Button Hover Effect */
    .btn {
        transition: all 0.3s ease-in-out;
    }

    .btn:hover {
        transform: scale(1.05);
    }
    </style>
</head>
<body>

<div class="container mt-5 fade-in">
    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="fw-bold text-primary">📋 Sales Orders</h1>
    </div>

    <!-- Orders Table -->
    <div class="table-responsive fade-in">
        <table class="table table-striped table-bordered shadow-sm">
            <thead class="table-dark">
            <tr>
                <th>🆔 Order ID</th>
                <th>👤 Customer Name</th>
                <th>💰 Total Price</th>
                <th>📅 Date</th>
                <th>🔍 Action</th>
            </tr>
            </thead>
            <tbody>
            <g:each var="order" in="${orders}" status="index">
                <tr class="fade-row" style="transition-delay: ${index * 0.1}s;">
                    <td>${order.id}</td>
                    <td>${order.customerName}</td>
                    <td class="fw-bold text-success">${order.totalAmount} PKR</td>
                    <td>${order.dateCreated?.toLocalDateTime()?.format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"))}</td>
                    <td>
                        <a href="${createLink(controller: 'order', action: 'orderDetails', id: order.id)}"
                           class="btn btn-info btn-sm">
                            📄 View Details
                        </a>
                    </td>
                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
</div>

<!-- JavaScript for Animations -->
<script>
    function animateOnView() {
        const observer = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add("visible");
                    observer.unobserve(entry.target); // Stop observing once animated
                }
            });
        }, { threshold: 0.3 });

        document.querySelectorAll(".fade-in, .fade-row").forEach(element => {
            observer.observe(element);
        });
    }

    // Run animation trigger when navigating via AJAX or normal load
    document.addEventListener("DOMContentLoaded", animateOnView);
    document.addEventListener("turbo:load", animateOnView); // Works with Turbo (optional)
</script>

</body>
</html>
