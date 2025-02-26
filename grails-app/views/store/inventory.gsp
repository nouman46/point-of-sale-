<%@ page contentType="text/html;charset=UTF-8" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="layout" content="main" />
    <title>Inventory</title>
    <meta name="_csrf" content="${session['csrfToken']}" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
    body {
        background: linear-gradient(to right, #f8f9fa, #e9ecef);
        font-family: 'Poppins', sans-serif;
    }
    .header {
        background-color: #343a40;
        color: white;
        padding: 15px;
        border-radius: 10px;
    }
    .btn-custom {
        transition: all 0.3s ease-in-out;
    }
    .btn-custom:hover {
        transform: scale(1.05);
        box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
    }
    table {
        border-radius: 10px;
        overflow: hidden;
    }
    th, td {
        text-align: center;
        vertical-align: middle;
    }
    tr:hover {
        background-color: #f1f3f5;
        transition: background-color 0.3s ease;
    }
    .modal-content {
        border-radius: 15px;
    }
    th.sortable {
        cursor: pointer;
        position: relative;
    }
    th.sortable::after {
        content: '\25B4\25BE'; /* Up and down arrows */
        font-size: 10px;
        margin-left: 5px;
        opacity: 0.5;
    }
    th.sortable.asc::after {
        content: '\25B4'; /* Up arrow */
        opacity: 1;
    }
    th.sortable.desc::after {
        content: '\25BE'; /* Down arrow */
        opacity: 1;
    }
    </style>

    <script>
        $(document).ready(function() {
            var csrfToken = $('meta[name="_csrf"]').attr('content');
            var rowsPerPage = 5; // Number of rows per page
            var currentPage = 1;
            var allRows = $("#productTable tbody tr");

            // Search functionality
            $("#searchInput").keyup(function() {
                var searchValue = $(this).val().toLowerCase();
                allRows.each(function() {
                    var rowText = $(this).text().toLowerCase();
                    $(this).toggle(rowText.includes(searchValue));
                });
                updatePagination();
            });

            // Sorting functionality
            $('th.sortable').click(function() {
                var table = $(this).parents('table').eq(0);
                var rows = table.find('tbody tr:visible').toArray().sort(comparer($(this).index()));
                this.asc = !this.asc; // Toggle sort direction
                if (!this.asc) rows = rows.reverse();
                $(this).siblings().removeClass('asc desc'); // Clear other sort indicators
                $(this).addClass(this.asc ? 'asc' : 'desc'); // Set current sort indicator
                table.find('tbody').empty().append(rows);
                updatePagination();
            });

            function comparer(index) {
                return function(a, b) {
                    var valA = getCellValue(a, index), valB = getCellValue(b, index);
                    return $.isNumeric(valA) && $.isNumeric(valB) ? valA - valB : valA.toString().localeCompare(valB);
                };
            }

            function getCellValue(row, index) {
                return $(row).children('td').eq(index).text();
            }

            // Pagination functionality
            function updatePagination() {
                var visibleRows = $("#productTable tbody tr:visible");
                var totalRows = visibleRows.length;
                var totalPages = Math.ceil(totalRows / rowsPerPage);

                visibleRows.hide();
                var start = (currentPage - 1) * rowsPerPage;
                var end = start + rowsPerPage;
                visibleRows.slice(start, end).show();

                var pagination = $("#pagination");
                pagination.empty();
                if (totalPages > 1) {
                    // Previous button
                    pagination.append(
                        '<li class="page-item' + (currentPage === 1 ? ' disabled' : '') + '">' +
                        '<a class="page-link" href="#" data-page="' + (currentPage - 1) + '">Previous</a>' +
                        '</li>'
                    );
                    // Page numbers
                    for (var i = 1; i <= totalPages; i++) {
                        pagination.append(
                            '<li class="page-item' + (i === currentPage ? ' active' : '') + '">' +
                            '<a class="page-link" href="#" data-page="' + i + '">' + i + '</a>' +
                            '</li>'
                        );
                    }
                    // Next button
                    pagination.append(
                        '<li class="page-item' + (currentPage === totalPages ? ' disabled' : '') + '">' +
                        '<a class="page-link" href="#" data-page="' + (currentPage + 1) + '">Next</a>' +
                        '</li>'
                    );
                }
            }

            // Pagination click handler
            $("#pagination").on("click", "a.page-link", function(e) {
                e.preventDefault();
                var page = $(this).data("page");
                if (page && page > 0) {
                    currentPage = page;
                    updatePagination();
                }
            });

            // Initialize pagination on page load
            updatePagination();

            // Open modal for adding or editing a product
            $(".open-modal").click(function() {
                var action = $(this).data("action");
                var id = $(this).data("id");
                $("#productForm")[0].reset();
                $("#productId").val("");
                $("#form-errors").hide().empty();
                $("#success-message").hide();
                $("#modalTitle").text(action === "edit" ? "Edit Product" : "Add Product");
                $("#productModal").modal("show");

                if (action === "edit") {
                    $.ajax({
                        type: "GET",
                        url: "/store/showProduct/" + id,
                        dataType: "json",
                        success: function(data) {
                            $("#productId").val(data.id);
                            $("#productName").val(data.productName);
                            $("#productDescription").val(data.productDescription);
                            $("#productSKU").val(data.productSKU);
                            $("#productBarcode").val(data.productBarcode);
                            $("#productPrice").val(data.productPrice);
                            $("#productQuantity").val(data.productQuantity);
                        },
                        error: function(xhr) {
                            $("#form-errors").html("Error fetching product: " + (xhr.responseJSON?.message || xhr.statusText)).show();
                        }
                    });
                }
            });

            // Save product via AJAX
            $("#saveProduct").click(function(event) {
                event.preventDefault();
                $("#form-errors").hide().empty();
                $("#success-message").hide();

                var formData = $("#productForm").serialize();

                $.ajax({
                    url: "/store/saveProduct",
                    type: "POST",
                    data: formData,
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader('X-CSRF-TOKEN', csrfToken);
                    },
                    success: function(response) {
                        if (response.success) {
                            $("#success-message").html(response.message).show();
                            $("#productModal").modal("hide");
                            location.reload();
                        } else {
                            $("#form-errors").html(response.message).show();
                        }
                    },
                    error: function(xhr) {
                        $("#form-errors").html("Error: " + (xhr.responseJSON?.message || xhr.statusText)).show();
                    }
                });
            });

            // Delete product via AJAX
            $(".delete-product").click(function() {
                var id = $(this).data("id");
                if (confirm("Are you sure you want to delete this product?")) {
                    $.ajax({
                        type: "POST",
                        url: "/store/deleteProduct/" + id,
                        beforeSend: function(xhr) {
                            xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
                        },
                        success: function(response) {
                            if (response.success) {
                                alert(response.message);
                                location.reload();
                            } else {
                                alert("Failed to delete: " + response.message);
                            }
                        },
                        error: function(xhr) {
                            alert("Error: " + (xhr.responseJSON?.message || xhr.statusText));
                        }
                    });
                }
            });
        });
    </script>
</head>
<body>
<div class="container mt-5">
    <div class="header text-center">
        <h2 class="fw-bold"><i class="fas fa-things"></i> Inventory Management</h2>
    </div>
    <br>
    <div class="d-flex mb-3">
        <input type="text" id="searchInput" class="form-control" placeholder="Search products" style="width: 300px;"/>
    </div>
    <div class="d-flex justify-content-end mt-4">
        <button class="btn btn-success btn-custom open-modal" data-action="add">
            <i class="fas fa-user-plus"></i> Add Product
        </button>
    </div>

    <table class="table table-bordered mt-3" id="productTable">
        <thead>
        <tr>
            <th class="sortable">Product Name</th>
            <th class="sortable">Product Description</th>
            <th class="sortable">Product SKU</th>
            <th class="sortable">Product Barcode</th>
            <th class="sortable">Product Price</th>
            <th class="sortable">Product Quantity</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${products}" var="product">
            <tr>
                <td>${product.productName}</td>
                <td>${product.productDescription}</td>
                <td>${product.productSKU}</td>
                <td>${product.productBarcode}</td>
                <td>${product.productPrice}</td>
                <td>${product.productQuantity}</td>
                <td>
                    <g:if test="${session.permissions?.inventory?.canEdit}">
                        <button class="btn btn-warning btn-sm open-modal" data-action="edit" data-id="${product.id}">
                            <i class="bi bi-pencil"></i> Edit
                        </button>
                    </g:if>
                    <g:if test="${session.permissions?.inventory?.canDelete}">
                        <button class="btn btn-danger btn-sm delete-product" data-id="${product.id}">
                            <i class="bi bi-trash"></i> Delete
                        </button>
                    </g:if>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>

    <!-- Pagination -->
    <nav aria-label="Page navigation">
        <ul class="pagination justify-content-center" id="pagination"></ul>
    </nav>

    <!-- Modal for adding/editing a product -->
    <div class="modal fade" id="productModal" tabindex="-1" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="modalTitle">Product Form</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="success-message" class="alert alert-success" style="display: none;"></div>
                    <div id="form-errors" class="alert alert-danger" style="display: none;"></div>
                    <form id="productForm">
                        <input type="hidden" id="productId" name="id">
                        <div class="mb-3">
                            <label for="productName" class="form-label">Product Name</label>
                            <input type="text" id="productName" name="productName" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label for="productDescription" class="form-label">Product Description</label>
                            <input type="text" id="productDescription" name="productDescription" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label for="productSKU" class="form-label">Product SKU</label>
                            <input type="text" id="productSKU" name="productSKU" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label for="productBarcode" class="form-label">Product Barcode</label>
                            <input type="text" id="productBarcode" name="productBarcode" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label for="productPrice" class="form-label">Product Price</label>
                            <input type="number" step="0.01" id="productPrice" name="productPrice" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label for="productQuantity" class="form-label">Product Quantity</label>
                            <input type="number" id="productQuantity" name="productQuantity" class="form-control" required>
                        </div>
                        <button type="button" id="saveProduct" class="btn btn-success">Save</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>