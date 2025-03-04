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
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- Animate.css for animations -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'theme.css')}"/>
    <script>
        $(document).ready(function() {
            var csrfToken = $('meta[name="_csrf"]').attr('content');
            var rowsPerPage = 6;
            var currentPage = 1;
            var originalRows = $("#productTable tbody tr").clone(); // Store original rows
            var allRows = originalRows.clone(); // Working set of rows

            // Function to update pagination and table content
            function updatePagination() {
                var totalRows = allRows.length;
                var totalPages = Math.ceil(totalRows / rowsPerPage);

                // Validate currentPage
                if (totalPages === 0) currentPage = 1;
                if (currentPage > totalPages) currentPage = totalPages;
                if (currentPage < 1) currentPage = 1;

                // Calculate rows to display
                var start = (currentPage - 1) * rowsPerPage;
                var end = Math.min(start + rowsPerPage, totalRows);

                // Clear current table body and append only the rows for this page
                $("#productTable tbody").empty();
                for (var i = start; i < end; i++) {
                    $("#productTable tbody").append(allRows.eq(i).clone());
                }

                // Update pagination controls
                var pagination = $("#pagination");
                pagination.empty();
                if (totalRows > 0) {
                    pagination.append(
                        '<li class="page-item' + (currentPage === 1 ? ' disabled' : '') + '">' +
                        '<a class="page-link" href="#" data-page="' + (currentPage - 1) + '">Previous</a>' +
                        '</li>'
                    );
                    for (var i = 1; i <= totalPages; i++) {
                        pagination.append(
                            '<li class="page-item' + (i === currentPage ? ' active' : '') + '">' +
                            '<a class="page-link" href="#" data-page="' + i + '">' + i + '</a>' +
                            '</li>'
                        );
                    }
                    pagination.append(
                        '<li class="page-item' + (currentPage === totalPages ? ' disabled' : '') + '">' +
                        '<a class="page-link" href="#" data-page="' + (currentPage + 1) + '">Next</a>' +
                        '</li>'
                    );
                } else {
                    pagination.append('<li class="page-item disabled"><span class="page-link">No results</span></li>');
                }
            }

            // Pagination click handler
            $("#pagination").on("click", "a.page-link", function(e) {
                e.preventDefault();
                var page = $(this).data("page");
                if (page && page > 0 && page <= Math.ceil(allRows.length / rowsPerPage)) {
                    currentPage = page;
                    updatePagination();
                }
            });

            // Search functionality with sorting
            $("#searchInput").keyup(function() {
                var searchValue = $(this).val().toLowerCase().trim();
                if (searchValue === "") {
                    allRows = originalRows.clone(); // Reset to original rows when search is cleared
                } else {
                    allRows = originalRows.filter(function() {
                        return $(this).text().toLowerCase().includes(searchValue);
                    });
                }
                currentPage = 1;
                updatePagination();
            });

            // Sorting functionality for both table headers and search results
            $('th.sortable').click(function() {
                var index = $(this).index();
                var rowsArray = allRows.toArray().sort(function(a, b) {
                    var valA = $(a).children('td').eq(index).text().toLowerCase();
                    var valB = $(b).children('td').eq(index).text().toLowerCase();
                    return $.isNumeric(valA) && $.isNumeric(valB) ? valA - valB : valA.localeCompare(valB);
                });
                if ($(this).hasClass('asc')) {
                    rowsArray.reverse();
                    $(this).removeClass('asc').addClass('desc');
                } else {
                    $(this).removeClass('desc').addClass('asc');
                }
                $(this).siblings().removeClass('asc desc');
                allRows = $(rowsArray); // Update allRows with sorted array
                currentPage = 1;
                updatePagination();
            });

            // Initialize pagination
            updatePagination();

            // Modal and AJAX handlers with event delegation
            $(document).on("click", ".open-modal", function() {
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

            $(document).on("click", ".delete-product", function() {
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
        });
    </script>
</head>
<body class="${session.themeName ?: 'theme-default'}">
<div class="container mt-5">
    <div class="header text-center animate__animated animate__fadeInDown">
        <h2 class="fw-bold"><i class="fas fa-box-open"></i> Inventory Management</h2>
    </div>
    <br>
    <div id="success-message" class="alert alert-success" style="display: none;"></div>
    <div class="d-flex mb-3">
        <div class="search-container animate__animated animate__fadeInLeft">
            <i class="fas fa-search search-icon"></i>
            <input type="text" id="searchInput" class="form-control" placeholder="Search products" style="width: 300px;"/>
        </div>
    </div>
    <div class="d-flex justify-content-end mt-4">
        <g:if test="${session.permissions?.inventory?.canEdit}">
            <button class="btn btn-success btn-custom open-modal animate__animated animate__fadeInRight" data-action="add">
                <i class="fas fa-box-plus"></i> Add Product
            </button>
        </g:if>
    </div>

    <table class="table table-bordered mt-3 animate__animated animate__fadeInUp" id="productTable">
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
                <g:if test="${session.permissions?.inventory?.canEdit}">
                    <td>

                            <button class="btn btn-warning btn-sm open-modal" data-action="edit" data-id="${product.id}">
                    <i class="bi bi-pencil"></i> Edit
                        </button>
                </g:if>
                <g:if test="${session.permissions?.inventory?.canDelete}">
                    <button class="btn btn-danger btn-sm delete-product" data-id="${product.id}">
                        <i class="bi bi-trash"></i> Delete
                    </button>

                    </td>
                </g:if>
            </tr>
        </g:each>
        </tbody>
    </table>

    <!-- Pagination -->
    <nav aria-label="Page navigation">
        <ul class="pagination justify-content-center animate__animated animate__fadeIn" id="pagination"></ul>
    </nav>

    <!-- Modal for adding/editing a product -->
    <div class="modal fade" id="productModal" tabindex="-1" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content animate__animated animate__zoomIn">
                <div class="modal-header">
                    <h4 class="modal-title" id="modalTitle">Product Form</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">

                    <div id="form-errors" class="alert alert-danger" style="display: none;"></div>
                    <form id="productForm">
                        <input type="hidden" id="productId" name="id">
                        <div class="mb-3">
                            <label for="productName" class="form-label">Product Name</label>
                            <input type="text" id="productName" name="productName" class="form-control animate__animated animate__fadeIn" required>
                        </div>
                        <div class="mb-3">
                            <label for="productDescription" class="form-label">Product Description</label>
                            <input type="text" id="productDescription" name="productDescription" class="form-control animate__animated animate__fadeIn" required>
                        </div>
                        <div class="mb-3">
                            <label for="productSKU" class="form-label">Product SKU</label>
                            <input type="text" id="productSKU" name="productSKU" class="form-control animate__animated animate__fadeIn" required>
                        </div>
                        <div class="mb-3">
                            <label for="productBarcode" class="form-label">Product Barcode</label>
                            <input type="text" id="productBarcode" name="productBarcode" class="form-control animate__animated animate__fadeIn" required>
                        </div>
                        <div class="mb-3">
                            <label for="productPrice" class="form-label">Product Price</label>
                            <input type="number" step="0.01" id="productPrice" name="productPrice" class="form-control animate__animated animate__fadeIn" required>
                        </div>
                        <div class="mb-3">
                            <label for="productQuantity" class="form-label">Product Quantity</label>
                            <input type="number" id="productQuantity" name="productQuantity" class="form-control animate__animated animate__fadeIn" required>
                        </div>
                        <button type="button" id="saveProduct" class="btn btn-success animate__animated animate__fadeIn">Save</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>