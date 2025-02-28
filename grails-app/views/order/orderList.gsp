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

        /* Add cursor pointer for table headers */
        th {
            cursor: pointer;
        }

        /* Error message styling */
        .error-message {
            color: red;
            font-size: 0.875rem;
            display: none;
            position: absolute;
            top: -20px;
        }

        .form-group {
            position: relative;
        }

        /* Search box */
        #searchBox {
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

<div class="container mt-5 fade-in">
    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="fw-bold text-primary">📋 Sales Orders</h1>
    </div>

    <!-- Search Box -->
    <input type="text" id="searchBox" class="form-control mb-4" placeholder="Search by Order ID or Customer Name">

    <!-- Date Filter Form -->
    <form action="${createLink(controller: 'order', action: 'listOrders')}" method="get" id="orderFilterForm">
        <div class="row">
            <div class="col-md-4 form-group">
                <label for="startDate" class="form-label">📅 Start Date:</label>
                <input type="date" id="startDate" name="startDate" class="form-control" value="${params.startDate}"/>
                <span id="startDateError" class="error-message">Start Date is required</span>
            </div>
            <div class="col-md-4 form-group">
                <label for="endDate" class="form-label">📅 End Date:</label>
                <input type="date" id="endDate" name="endDate" class="form-control" value="${params.endDate}"/>
                <span id="endDateError" class="error-message">End Date is required</span>
            </div>
            <div class="col-md-4 d-flex align-items-end">
                <button type="submit" class="btn btn-primary" id="filterBtn">🔍 Filter Orders</button>
            </div>
        </div>
    </form>

    <!-- Orders Table -->
    <div class="table-responsive fade-in">
        <table class="table table-striped table-bordered shadow-sm" id="orderTable">
            <thead class="table-dark">
                <tr>
                    <th onclick="sortTable(0)">🆔 Order ID ↕</th>
                    <th onclick="sortTable(1)">👤 Customer Name ↕</th>
                    <th onclick="sortTable(2)">💰 Total Price ↕</th>
                    <th onclick="sortTable(3)">📅 Date ↕</th>
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
            <h4>Total Sales: <span class="text-success" id="totalSales">${totalSales} PKR</span></h4>
        </div>
    </div>
</div>

<!-- JavaScript for Animations, Date Validation, Table Sorting, and Search -->
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
        const startDateError = document.getElementById("startDateError");
        const endDateError = document.getElementById("endDateError");
        const filterBtn = document.getElementById("filterBtn");
        const searchBox = document.getElementById("searchBox");
        const totalSalesElement = document.getElementById("totalSales");
        const form = document.getElementById("orderFilterForm");

        // Hide errors initially
        startDateError.style.display = "none";
        endDateError.style.display = "none";

        // Form submission handler
        form.addEventListener("submit", function(event) {
            let isValid = true;
            const startDate = startDateInput.value;
            const endDate = endDateInput.value;

            // Reset error messages
            startDateError.style.display = "none";
            endDateError.style.display = "none";

            // Check if start date is empty
            if (!startDate) {
                startDateError.style.display = "inline";
                isValid = false;
            }

            // Check if end date is empty
            if (!endDate) {
                endDateError.style.display = "inline";
                isValid = false;
            }

            // If both dates are present, validate date range
            if (startDate && endDate) {
                const start = new Date(startDate);
                const end = new Date(endDate);
                if (end < start) {
                    endDateError.textContent = "End Date cannot be earlier than Start Date";
                    endDateError.style.display = "inline";
                    isValid = false;
                }
            }

            // Prevent form submission if validation fails
            if (!isValid) {
                event.preventDefault();
            }
        });

        function updateTotalSales() {
            let total = 0;
            const rows = document.querySelectorAll("#orderTable tbody tr");

            rows.forEach(row => {
                if (row.style.display !== "none") {
                    const amountText = row.cells[2].textContent.trim().replace(" PKR", "");
                    const amount = parseFloat(amountText);
                    if (!isNaN(amount)) {
                        total += amount;
                    }
                }
            });

            totalSalesElement.textContent = total + " PKR";
        }

        searchBox.addEventListener("keyup", function () {
            const filter = searchBox.value.toLowerCase();
            const rows = document.querySelectorAll("#orderTable tbody tr");

            rows.forEach(row => {
                const orderId = row.cells[0].textContent.toLowerCase();
                const customerName = row.cells[1].textContent.toLowerCase();
                row.style.display = orderId.includes(filter) || customerName.includes(filter) ? "" : "none";
            });

            updateTotalSales();
        });

        updateTotalSales();
    });

    // Table sorting function (if you want to keep it)
    function sortTable(n) {
        // [Your existing sortTable function can be added here if needed]
    }
</script>

</body>
</html>