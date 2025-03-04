<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main" />
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'theme.css')}"/>
    <title>Order Management</title>

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">


</head>
<body class="${session.themeName ?: 'theme-default'}">
<div class="order-container fade-in">
    <!-- Header -->
    <div class="page-header">
        <h1>
            <span class="me-2">📋</span>Order Management Dashboard
        </h1>
    </div>

    <!-- Filter Form -->
    <form action="${createLink(controller: 'order', action: 'listOrders')}" method="get" class="filter-form">
        <div class="row g-3 align-items-end">
            <div class="col-md-4">
                <label for="startDate" class="form-label">Start Date</label>
                <input type="date" id="startDate" name="startDate" class="form-control" value="${params.startDate}"/>
                <span id="startDateError" class="error-message">Please select a start date</span>
            </div>
            <div class="col-md-4">
                <label for="endDate" class="form-label">End Date</label>
                <input type="date" id="endDate" name="endDate" class="form-control" value="${params.endDate}"/>
                <span id="endDateError" class="error-message">Please select an end date</span>
            </div>
            <div class="col-md-4">
                <button type="submit" class="btn btn-professional w-100">
                    <span class="me-2">🔍</span>Apply Filters
                </button>
            </div>
        </div>
    </form>

    <!-- Search -->
    <div class="search-container">
        <input type="text" id="searchBox" class="form-control" placeholder="Search by Order ID or Customer Name...">
    </div>

    <!-- Orders Table -->
    <div class="table-responsive">
        <table class="table order-table">
            <thead>
            <tr>
                <th onclick="sortTable(0)">Order ID</th>
                <th onclick="sortTable(1)">Customer</th>
                <th onclick="sortTable(2)">Total</th>
                <th onclick="sortTable(3)">Date</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <g:each var="order" in="${orders}" status="index">
                <tr class="fade-in" style="transition-delay: ${index * 0.1}s;">
                    <td>#${order.id}</td>
                    <td>${order.customerName}</td>
                    <td class="text-success fw-medium">${order.totalAmount} PKR</td>
                    <td>${order.dateCreated?.toLocalDateTime()?.format(java.time.format.DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm"))}</td>
                    <td>
                        <a href="${createLink(controller: 'order', action: 'orderDetails', id: order.id)}"
                           class="btn btn-info btn-professional btn-sm">
                            <span class="me-1">📄</span>Details
                        </a>
                    </td>
                </tr>
            </g:each>
            </tbody>
        </table>
    </div>

    <!-- Total Sales -->
    <div class="total-sales">
        Total Sales: <span id="totalSales" class="text-success">${totalSales} PKR</span>
    </div>
</div>

<!-- JavaScript -->
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const startDateInput = document.getElementById("startDate");
        const endDateInput = document.getElementById("endDate");
        const startDateError = document.getElementById("startDateError");
        const endDateError = document.getElementById("endDateError");
        const searchBox = document.getElementById("searchBox");
        const totalSalesElement = document.getElementById("totalSales");

        // Form Validation
        document.querySelector(".filter-form").addEventListener("submit", function(e) {
            let isValid = true;
            startDateError.style.display = "none";
            endDateError.style.display = "none";

            if (!startDateInput.value) {
                startDateError.style.display = "block";
                isValid = false;
            }
            if (!endDateInput.value) {
                endDateError.style.display = "block";
                isValid = false;
            }
            if (startDateInput.value && endDateInput.value) {
                if (new Date(endDateInput.value) < new Date(startDateInput.value)) {
                    endDateError.textContent = "End date must be after start date";
                    endDateError.style.display = "block";
                    isValid = false;
                }
            }
            if (!isValid) e.preventDefault();
        });

        // Search Functionality
        function updateDisplay() {
            const filter = searchBox.value.toLowerCase();
            const rows = document.querySelectorAll(".order-table tbody tr");
            let total = 0;

            rows.forEach(row => {
                const orderId = row.cells[0].textContent.toLowerCase().replace("#", "");
                const customer = row.cells[1].textContent.toLowerCase();
                const isVisible = orderId.includes(filter) || customer.includes(filter);
                row.style.display = isVisible ? "" : "none";

                if (isVisible) {
                    const amount = parseFloat(row.cells[2].textContent.replace(" PKR", ""));
                    total += amount;
                }
            });

            totalSalesElement.textContent = total.toFixed(2) + " PKR";
        }

        searchBox.addEventListener("input", updateDisplay);
        updateDisplay();
    });

    // Simple sort function (optional, can be expanded)
    function sortTable(n) {
        let table = document.querySelector(".order-table");
        let rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
        switching = true;
        dir = "asc";

        while (switching) {
            switching = false;
            rows = table.rows;

            for (i = 1; i < (rows.length - 1); i++) {
                shouldSwitch = false;
                x = rows[i].getElementsByTagName("TD")[n];
                y = rows[i + 1].getElementsByTagName("TD")[n];

                if (dir == "asc") {
                    if (n === 2) { // Numeric sort for Total
                        if (parseFloat(x.textContent.replace(" PKR", "")) > parseFloat(y.textContent.replace(" PKR", ""))) {
                            shouldSwitch = true;
                            break;
                        }
                    } else { // String sort for others
                        if (x.textContent.toLowerCase() > y.textContent.toLowerCase()) {
                            shouldSwitch = true;
                            break;
                        }
                    }
                } else if (dir == "desc") {
                    if (n === 2) {
                        if (parseFloat(x.textContent.replace(" PKR", "")) < parseFloat(y.textContent.replace(" PKR", ""))) {
                            shouldSwitch = true;
                            break;
                        }
                    } else {
                        if (x.textContent.toLowerCase() < y.textContent.toLowerCase()) {
                            shouldSwitch = true;
                            break;
                        }
                    }
                }
            }

            if (shouldSwitch) {
                rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                switching = true;
                switchcount++;
            } else {
                if (switchcount == 0 && dir == "asc") {
                    dir = "desc";
                    switching = true;
                }
            }
        }
    }
</script>
</body>
</html>