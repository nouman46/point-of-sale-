<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main" />
    <title>Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js"></script> <!-- Icons -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- jQuery for AJAX -->

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 20px;
        }

        .dashboard-header {
            display: flex;
            align-items: center;
            gap: 15px;
            background: #1e1e2d;
            padding: 15px;
            border-radius: 8px;
            color: white;
            font-size: 22px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .dashboard-header i {
            font-size: 28px;
        }

        .stats-container {
            display: flex;
            justify-content: space-between;
            width: 100%;
            gap: 20px;
            margin-bottom: 20px;
        }

        .box {
            background: white;
            padding: 25px;
            border-radius: 10px;
            text-align: center;
            flex: 1;
            min-width: 220px;
            cursor: pointer;
            transition: all 0.3s ease-in-out;
            color: #333;
            display: flex;
            flex-direction: column;
            align-items: center;
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
            border-left: 8px solid transparent;
        }

        .box:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2);
        }

        .box i {
            font-size: 35px;
            margin-bottom: 10px;
            color: #007bff;
        }

        .box h3 {
            font-size: 18px;
            font-weight: 600;
        }

        .box .count {
            font-size: 30px;
            font-weight: bold;
            margin-top: 5px;
            color: #222;
        }

        .box.total-orders { border-left-color: #e74c3c; }
        .box.total-products { border-left-color: #3498db; }
        .box.total-sales { border-left-color: #2ecc71; }

        .charts-wrapper {
            display: flex;
            justify-content: space-around;
            width: 100%;
            flex-wrap: wrap;
            margin-top: 20px;
        }

        .chart-box {
            width: 45%;
            max-width: 500px;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
        }

        .chart-box canvas {
            width: 100% !important;
            height: 300px !important;
        }

        @media (max-width: 1024px) {
            .charts-wrapper {
                flex-direction: column;
                align-items: center;
            }
            .chart-box {
                width: 80%;
            }
        }

        @media (max-width: 768px) {
            .stats-container { flex-direction: column; }
            .chart-box { width: 100%; max-width: none; }
        }
    </style>
</head>
<body>

    <div class="dashboard-header">
        <i class="fas fa-chart-line"></i>
        <h1>Admin Dashboard</h1>
    </div>

    <div class="stats-container">
        <div class="box total-orders" onclick="window.location.href='/order/listOrders'">
            <i class="fas fa-shopping-cart"></i>
            <h3>Total Orders</h3>
            <div class="count" id="ordersThisMonth">Loading...</div>
        </div>

        <div class="box total-products" onclick="window.location.href='/store/inventory'">
            <i class="fas fa-boxes"></i>
            <h3>Total Products</h3>
            <div class="count" id="totalProducts">Loading...</div>
        </div>

        <div class="box total-sales" onclick="window.location.href='/order/listOrders'">
            <i class="fas fa-dollar-sign"></i>
            <h3>Total Sales</h3>
            <div class="count" id="totalSales">Loading...</div>
        </div>
    </div>

    <div class="charts-wrapper">
        <div class="chart-box">
            <div class="chart-title">Orders Trend Over Time</div>
            <canvas id="ordersChart"></canvas>
        </div>
        <div class="chart-box">
            <div class="chart-title">Product Quantity Distribution</div>
            <canvas id="productChart"></canvas>
        </div>
    </div>

    <script>
        let ordersChartInstance = null;
        let productChartInstance = null;

        $(document).ready(function() {
            loadDashboardData();
            loadOrdersTrend();
            loadProductQuantities();
        });

        function destroyChart(chartInstance) {
            if (chartInstance) {
                chartInstance.destroy();
            }
        }

        function loadDashboardData() {
            $.ajax({
                url: '/dashboard/getOrdersData',
                type: 'GET',
                dataType: 'json',
                success: function(data) {
                    $("#ordersThisMonth").text(data.ordersThisMonth ?? 0);
                    $("#totalProducts").text(data.totalProducts ?? 0);
                    $("#totalSales").text("RS " + (data.totalSales ?? 0).toFixed(2));
                },
                error: function() {
                    console.error("Error fetching dashboard data.");
                }
            });
        }

        function loadOrdersTrend() {
            $.ajax({
                url: '/dashboard/getOrdersTrend',
                type: 'GET',
                dataType: 'json',
                success: function(data) {
                    let labels = data.map(item => item.date);
                    let values = data.map(item => item.count);

                    destroyChart(ordersChartInstance);

                    let ctx = document.getElementById("ordersChart").getContext("2d");
                    ordersChartInstance = new Chart(ctx, {
                        type: 'line',
                        data: {
                            labels: labels,
                            datasets: [{
                                label: 'Orders Over Time',
                                data: values,
                                borderColor: '#3498db',
                                backgroundColor: 'rgba(52, 152, 219, 0.2)',
                                borderWidth: 2,
                                tension: 0.3,
                                fill: true,
                                pointRadius: 5,  // Increases the point size
                                pointHitRadius: 10 // Expands the hoverable area
                            }]

                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                tooltip: {
                                    mode: 'nearest',
                                    intersect: false // Allows hovering even when not exactly on the point
                                }
                            }
                        }

                    });
                }
            });
        }

        function loadProductQuantities() {
            $.ajax({
                url: '/dashboard/getProductQuantities',
                type: 'GET',
                dataType: 'json',
                success: function(data) {
                    let labels = data.map(item => item.name);
                    let values = data.map(item => item.quantity);

                    destroyChart(productChartInstance);

                    let ctx = document.getElementById("productChart").getContext("2d");
                    productChartInstance = new Chart(ctx, {
                        type: 'doughnut',
                        data: {
                            labels: labels,
                            datasets: [{
                                data: values,
                                backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4CAF50', '#FF9800']
                            }]
                        },
                        options: { responsive: true, maintainAspectRatio: false }
                    });
                }
            });
        }
    </script>
</body>
</html>
