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

        /* Error message styling */
        .error-message {
            color: red;
            font-size: 0.875rem;
            display: none; /* Initially hidden */
            position: absolute; /* Position it above the input */
            top: -20px; /* Adjust to position above the input */
        }

        .form-group {
            position: relative; /* Make sure the error message is positioned relative to this */
        }
    </style>
</head>
<body>

<div class="container mt-5 fade-in">
    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="fw-bold text-primary">📋 Sales Orders</h1>
    </div>

    <!-- Date Filter Form -->
    <form action="${createLink(controller: 'order', action: 'listOrders')}" method="get" id="orderFilterForm">
        <div class="row">
            <div class="col-md-4">
                <label for="startDate" class="form-label">📅 Start Date:</label>
                <input type="date" id="startDate" name="startDate" class="form-control" value="${params.startDate}"/>
            </div>
            <div class="col-md-4 form-group">
                <label for="endDate" class="form-label">📅 End Date:</label>
                <input type="date" id="endDate" name="endDate" class="form-control" value="${params.endDate}"/>
                <span id="endDateError" class="error-message">End Date cannot be earlier than Start Date.</span> <!-- Error message -->
            </div>
            <div class="col-md-4 d-flex align-items-end">
                <button type="submit" class="btn btn-primary" id="filterBtn">🔍 Filter Orders</button>
            </div>
        </div>
    </form>

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

        <!-- Total Sales Amount -->
        <div class="d-flex justify-content-end mt-3">
            <h4>Total Sales: <span class="text-success">${totalSales} PKR</span></h4>
        </div>
    </div>
</div>

<!-- JavaScript for Animations and Date Validation -->
<script>
    function animateOnView() {
        const observer = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add("visible");
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 0.3 });

        document.querySelectorAll(".fade-in, .fade-row").forEach(element => {
            observer.observe(element);
        });
    }

    document.addEventListener("DOMContentLoaded", function () {
        animateOnView();

        const startDateInput = document.getElementById("startDate");
        const endDateInput = document.getElementById("endDate");
        const errorMessage = document.getElementById("endDateError");
        const filterForm = document.getElementById("orderFilterForm");
        const filterBtn = document.getElementById("filterBtn");

        function validateDates() {
            const startDate = new Date(startDateInput.value);
            const endDate = new Date(endDateInput.value);

            // Validate only if endDate is completely entered
            if (endDateInput.value && endDate < startDate) {
                errorMessage.style.display = "inline"; // Show error message
                filterBtn.disabled = true; // Disable the submit button
            } else {
                errorMessage.style.display = "none"; // Hide error message if dates are valid
                filterBtn.disabled = false; // Enable the submit button
            }
        }

        endDateInput.addEventListener("change", validateDates);
        startDateInput.addEventListener("change", validateDates); // Also validate when start date changes
    });
</script>

</body>
</html>
