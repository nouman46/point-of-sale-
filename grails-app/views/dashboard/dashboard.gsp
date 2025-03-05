<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main" />
    <title>Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'theme.css')}"/>

</head>
<body class="${session.themeName ?: 'theme-default'}">

<div class="dashboard-container">
    <div class="dashboard-header">
        <i class="fas fa-chart-line"></i>
        Admin Dashboard
    </div>

    <div class="stats-container">
        <div class="stat-box barcode-filter">
            <i class="fas fa-barcode"></i>
            <h3>Filter by Barcode</h3>
            <input type="text" id="barcodeInput" placeholder="Enter Barcode">
            <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                <button onclick="filterByBarcode()">Filter</button>
                <button onclick="resetDashboard()">Reset</button>
            </div>
            <div id="barcodeError" class="hidden"></div>
        </div>
        <div class="stat-box total-orders" onclick="window.location.href='/order/listOrders'">
            <i class="fas fa-shopping-cart"></i>
            <h3>Total Orders</h3>
            <div class="count" id="ordersThisMonth">Loading...</div>
        </div>
        <div class="stat-box total-products" onclick="window.location.href='/store/inventory'">
            <i class="fas fa-boxes"></i>
            <h3>Total Products</h3>
            <div class="count" id="totalProducts">Loading...</div>
        </div>
        <div class="stat-box total-sales" onclick="window.location.href='/order/listOrders'">
            <i class="fas fa-dollar-sign"></i>
            <h3>Total Sales</h3>
            <div class="count" id="totalSales">Loading...</div>
        </div>
        <div class="stat-box filtered-orders hidden">
            <i class="fas fa-shopping-cart"></i>
            <h3>Orders with Product</h3>
            <div class="count" id="filteredOrders">0</div>
        </div>
        <div class="stat-box filtered-sales hidden">
            <i class="fas fa-dollar-sign"></i>
            <h3>Sales of Product</h3>
            <div class="count" id="filteredSales">RS 0.00</div>
        </div>

    </div>

    <div class="charts-wrapper">
        <div class="chart-box orders-trend-chart">
            <div class="chart-title">Orders Trend Over Time</div>
            <div style="margin-bottom: 15px; display: flex; align-items: center; justify-content: center; gap: 10px; flex-wrap: wrap;">
                <label for="yearSelect">Year:</label>
                <select id="yearSelect" onchange="loadOrdersTrend()">
                    <option value="">All Years</option>
                    <g:each in="${(2020..2028).toList()}" var="year">
                        <option value="${year}">${year}</option>
                    </g:each>
                </select>
                <label for="monthSelect">Month:</label>
                <select id="monthSelect" onchange="loadOrdersTrend()">
                    <option value="">All Months</option>
                    <option value="1">January</option>
                    <option value="2">February</option>
                    <option value="3">March</option>
                    <option value="4">April</option>
                    <option value="5">May</option>
                    <option value="6">June</option>
                    <option value="7">July</option>
                    <option value="8">August</option>
                    <option value="9">September</option>
                    <option value="10">October</option>
                    <option value="11">November</option>
                    <option value="12">December</option>
                </select>
            </div>
            <canvas id="ordersChart"></canvas>
        </div>
        <div class="chart-box ai-prediction-chart">
            <div class="chart-title">AI-Predicted Sales / Recommendations</div>
            <canvas id="aiPredictionChart"></canvas>
        </div>
        <div class="chart-box product-quantity-chart">
            <div class="chart-title">Product Quantity Distribution</div>
            <canvas id="productChart"></canvas>
        </div>
        <div class="chart-box filtered-product-chart hidden">
            <div class="chart-title">Filtered Product Quantity</div>
            <canvas id="filteredProductChart"></canvas>
        </div>
        <div class="chart-box filtered-orders-per-month hidden">
            <div class="chart-title">Orders Per Month for Filtered Product</div>
            <canvas id="ordersPerMonthChart"></canvas>
        </div>
        <div class="chart-box filtered-ai-prediction-chart hidden">
                        <div class="chart-title">AI Prediction for Filtered Product</div>
                        <canvas id="filteredAIPredictionChart"></canvas>
                    </div>
    </div>
</div>

<script>
    let ordersChartInstance = null;
    let productChartInstance = null;
    let filteredProductChartInstance = null;
    let ordersPerMonthChartInstance = null;
    let aiPredictionChartInstance = null;
    let filteredAIPredictionChartInstance = null;

    $(document).ready(function() {
        loadDashboardData();
        loadOrdersTrend();
        loadProductQuantities();
        loadAIPredictions();
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
        let year = $("#yearSelect").val();
        let month = $("#monthSelect").val();

        console.log("Selected Year:", year);  // Log selected year
        console.log("Selected Month:", month); // Log selected month

        $.ajax({
            url: '/dashboard/getOrdersTrend',
            type: 'GET',
            data: { year: year, month: month },
            dataType: 'json',
            success: function(data) {
                console.log("Response Data:", data); // Log the response from the server

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
                            pointRadius: 5,
                            pointHitRadius: 10
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: { beginAtZero: true, ticks: { stepSize: 0.5 } }
                        },
                        plugins: {
                            tooltip: { mode: 'nearest', intersect: false }
                        }
                    }
                });
            },
            error: function(xhr, status, error) {
                console.error("Error fetching orders trend:", error);
                console.error("Status:", status);
                console.error("Response:", xhr.responseText);
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
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { display: false },
                            tooltip: {
                                callbacks: {
                                    label: function(tooltipItem) {
                                        let index = tooltipItem.dataIndex;
                                        return labels[index] + ": " + values[index];
                                    }
                                }
                            }
                        }
                    }
                });
            },
            error: function(xhr, status, error) {
                console.error("Error fetching product quantity data:", error);
            }
        });
    }

    function loadFilteredProductQuantity(barcode) {
        destroyChart(filteredProductChartInstance);
        let ctx = document.getElementById("filteredProductChart").getContext("2d");

        $.ajax({
            url: '/dashboard/getProductDataByBarcode',
            type: 'GET',
            data: { barcode: barcode },
            dataType: 'json',
            success: function(data) {
                let productName = data.productName || 'Unknown Product';
                let quantity = data.quantity || 0;

                destroyChart(filteredProductChartInstance);
                filteredProductChartInstance = new Chart(ctx, {
                    type: 'doughnut',
                    data: {
                        labels: [productName],
                        datasets: [{
                            data: [quantity],
                            backgroundColor: ['#FF6384']
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { display: false },
                            tooltip: {
                                callbacks: {
                                    label: function(tooltipItem) {
                                        return productName + ": " + quantity;
                                    }
                                }
                            }
                        }
                    }
                });
            },
            error: function(xhr, status, error) {
                console.error("Error fetching filtered product quantity:", error);
                destroyChart(filteredProductChartInstance);
                filteredProductChartInstance = new Chart(ctx, {
                    type: 'doughnut',
                    data: {
                        labels: ['Error Loading Data'],
                        datasets: [{
                            data: [1],
                            backgroundColor: ['#FF4444']
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { display: false },
                            tooltip: { enabled: false }
                        }
                    }
                });
            }
        });
    }

    function filterByBarcode() {
        let barcode = $("#barcodeInput").val().trim();
        $("#barcodeError").addClass("hidden").text(""); // Clear previous errors

        if (!barcode) {
            $("#barcodeError").text("Please enter a barcode.").removeClass("hidden");
            return;
        }

        $.ajax({
            url: '/dashboard/getProductDataByBarcode',
            type: 'GET',
            data: { barcode: barcode },
            dataType: 'json',
            success: function(data) {
                // Hide default charts
                $(".total-orders").addClass("hidden");
                $(".total-products").addClass("hidden");
                $(".total-sales").addClass("hidden");
                $(".orders-trend-chart").addClass("hidden");
                $(".product-quantity-chart").addClass("hidden");
                $(".ai-prediction-chart").addClass("hidden");

                // Show filtered data
                if (data.totalOrders || data.totalSales || data.quantity) {
                    $(".filtered-orders").removeClass("hidden");
                    $(".filtered-sales").removeClass("hidden");
                    $(".filtered-product-chart").removeClass("hidden");

                    $("#filteredOrders").text(data.totalOrders || 0);
                    $("#filteredSales").text("RS " + (data.totalSales || 0).toFixed(2));
                    loadFilteredProductQuantity(barcode);
                    loadFilteredAIPrediction(barcode); // Load the AI prediction chart
                } else {
                    $(".filtered-orders").addClass("hidden");
                    $(".filtered-sales").addClass("hidden");
                    $(".filtered-product-chart").addClass("hidden");
                    $(".filtered-ai-prediction-chart").addClass("hidden");
                }
            },
            error: function(xhr) {
                if (xhr.status === 400) {
                    $("#barcodeError").text("Barcode is required.").removeClass("hidden");
                } else if (xhr.status === 403) {
                    $("#barcodeError").text("Unauthorized access. Please log in.").removeClass("hidden");
                } else if (xhr.status === 404) {
                    $("#barcodeError").text("Product not found ").removeClass("hidden");
                } else {
                    $("#barcodeError").text("An unexpected error occurred. Please try again.").removeClass("hidden");
                }
                $(".filtered-ai-prediction-chart").addClass("hidden");
            }
        });
    }

    function loadAIPredictions() {
        console.log("Attempting to fetch AI predictions...");
        $.ajax({
            url: '/dashboard/getAIPredictions',
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                console.log("AI Predictions Data:", data);
                if (!data || data.length === 0) {
                    console.warn("No prediction data available.");
                    destroyChart(aiPredictionChartInstance);
                    let ctx = document.getElementById("aiPredictionChart").getContext("2d");
                    aiPredictionChartInstance = new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: ['No Data'],
                            datasets: [{
                                label: 'Predicted Sales (Units)',
                                data: [0],
                                backgroundColor: 'rgba(200, 200, 200, 0.6)'
                            }]
                        },
                        options: { responsive: true, maintainAspectRatio: false }
                    });
                    return;
                }

                let labels = data.map(item => item.productName); // Product names for x-axis
                let predictedSales = data.map(item => item.predictedSales);
                let recommendation = data.map(item => item.shouldBuy ? 1 : 0);

                destroyChart(aiPredictionChartInstance);

                let ctx = document.getElementById("aiPredictionChart").getContext("2d");
                aiPredictionChartInstance = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: labels, // Show product names on x-axis
                        datasets: [
                            {
                                label: 'Predicted Sales (Units)',
                                data: predictedSales,
                                backgroundColor: 'rgba(75, 192, 192, 0.6)',
                                borderColor: 'rgba(75, 192, 192, 1)',
                                borderWidth: 1
                            },

                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            x: {
                                display: true // Show x-axis with product names
                            },
                            y: { beginAtZero: true, title: { display: true, text: 'Predicted Sales' } },
                            y2: {
                                position: 'right',
                                beginAtZero: true,
                                max: 1,
                                ticks: { stepSize: 1 },
                                title: { display: true, text: 'Buy Recommendation' }
                            }
                        },
                        plugins: {
                            tooltip: {
                                mode: 'index',
                                intersect: false,
                                callbacks: {
                                    title: function(tooltipItems) {
                                        // Show only the product name in the tooltip
                                        return labels[tooltipItems[0].dataIndex];
                                    },
                                    label: function() {
                                        // Return nothing to hide Predicted Sales and Recommendation
                                        return '';
                                    }
                                }
                            }
                        }
                    }
                });
            },
            error: function(xhr, status, error) {
                console.error("Error fetching AI predictions:", status, error);
                console.log("Response Text:", xhr.responseText);
            }
        });
    }

        function loadFilteredAIPrediction(barcode) {
            destroyChart(filteredAIPredictionChartInstance);
            let ctx = document.getElementById("filteredAIPredictionChart").getContext("2d");

            $.ajax({
                url: '/dashboard/getAIPredictionByBarcode',
                type: 'GET',
                data: { barcode: barcode },
                dataType: 'json',
                success: function(data) {
                    console.log("Filtered AI Prediction Data:", data);

                    let productName = data.productName || 'Unknown Product';
                    let predictedSales = data.predictedSales || 0;
                    let currentStock = data.currentStock || 0;

                    destroyChart(filteredAIPredictionChartInstance);
                    filteredAIPredictionChartInstance = new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: [productName],
                            datasets: [
                                {
                                    label: 'Predicted Sales (Units)',
                                    data: [predictedSales],
                                    backgroundColor: 'rgba(75, 192, 192, 0.6)',
                                    borderColor: 'rgba(75, 192, 192, 1)',
                                    borderWidth: 1
                                },
                                {
                                    label: 'Current Stock',
                                    data: [currentStock],
                                    backgroundColor: 'rgba(54, 162, 235, 0.6)',
                                    borderColor: 'rgba(54, 162, 235, 1)',
                                    borderWidth: 1
                                }
                            ]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            scales: {
                                x: { display: true },
                                y: {
                                    beginAtZero: true,
                                    title: { display: true, text: 'Units' },
                                    suggestedMax: Math.max(predictedSales, currentStock) * 1.2
                                }
                            },
                            plugins: {
                                tooltip: {
                                    mode: 'index',
                                    intersect: false,
                                    callbacks: {
                                        title: function(tooltipItems) {
                                            return productName;
                                        },
                                        label: function(tooltipItem) {
                                            return ''; // No extra labels
                                        }
                                    }
                                }
                            }
                        }
                    });

                    console.log("Chart Datasets After Creation:", filteredAIPredictionChartInstance.data.datasets);

                    // Show the chart
                    $(".filtered-ai-prediction-chart").removeClass("hidden");
                },
                error: function(xhr, status, error) {
                    console.error("Error fetching filtered AI prediction:", error);
                    destroyChart(filteredAIPredictionChartInstance);
                    filteredAIPredictionChartInstance = new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: ['Error'],
                            datasets: [{
                                label: 'Predicted Sales',
                                data: [0],
                                backgroundColor: '#FF4444'
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                tooltip: {
                                    callbacks: {
                                        title: function() {
                                            return 'Error';
                                        },
                                        label: function() {
                                            return '';
                                        }
                                    }
                                }
                            }
                        }
                    });
                    $(".filtered-ai-prediction-chart").removeClass("hidden");
                }
            });
        }

    function resetDashboard() {
        $("#barcodeInput").val("");
        $(".total-orders").removeClass("hidden");
        $(".total-products").removeClass("hidden");
        $(".total-sales").removeClass("hidden");
        $(".orders-trend-chart").removeClass("hidden");
        $(".product-quantity-chart").removeClass("hidden");
        $(".ai-prediction-chart").removeClass("hidden");
        $(".filtered-orders").addClass("hidden");
        $(".filtered-ai-prediction-chart").addClass("hidden");
        $(".filtered-sales").addClass("hidden");
        $(".filtered-product-chart").addClass("hidden");
        $("#filteredOrders").text("0");
        $("#filteredSales").text("RS 0.00");
        loadDashboardData();
        destroyChart(filteredProductChartInstance);
        destroyChart(filteredAIPredictionChartInstance);
        loadAIPredictions();
    }

</script>
</body>
</html>