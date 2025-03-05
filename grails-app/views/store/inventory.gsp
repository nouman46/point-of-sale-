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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'theme.css')}"/>
    <script>
        $(document).ready(function() {
            var csrfToken = $('meta[name="_csrf"]').attr('content');
            var rowsPerPage = 6;
            var currentPage = 1;
            var originalRows = $("#productTable tbody tr").clone();
            var allRows = originalRows.clone();

            function updatePagination() {
                var totalRows = allRows.length;
                var totalPages = Math.ceil(totalRows / rowsPerPage);
                if (totalPages === 0) currentPage = 1;
                if (currentPage > totalPages) currentPage = totalPages;
                if (currentPage < 1) currentPage = 1;

                var start = (currentPage - 1) * rowsPerPage;
                var end = Math.min(start + rowsPerPage, totalRows);

                $("#productTable tbody").empty();
                for (var i = start; i < end; i++) {
                    $("#productTable tbody").append(allRows.eq(i).clone());
                }

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

            $("#pagination").on("click", "a.page-link", function(e) {
                e.preventDefault();
                var page = $(this).data("page");
                if (page && page > 0 && page <= Math.ceil(allRows.length / rowsPerPage)) {
                    currentPage = page;
                    updatePagination();
                }
            });

            $("#searchInput").keyup(function() {
                var searchValue = $(this).val().toLowerCase().trim();
                if (searchValue === "") {
                    allRows = originalRows.clone();
                } else {
                    allRows = originalRows.filter(function() {
                        return $(this).text().toLowerCase().includes(searchValue);
                    });
                }
                currentPage = 1;
                updatePagination();
            });

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
                allRows = $(rowsArray);
                currentPage = 1;
                updatePagination();
            });

            updatePagination();

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
                $("#deleteProductId").val(id);
                $("#deleteModal").modal("show");
            });

            $("#confirmDelete").click(function() {
                var id = $("#deleteProductId").val();
                $.ajax({
                    type: "POST",
                    url: "/store/deleteProduct/" + id,
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
                    },
                    success: function(response) {
                        if (response.success) {
                            $("#deleteModal").modal("hide");
                            location.reload(); // Reload to show flash message
                        } else {
                            $("#delete-errors").html("Failed to delete: " + response.message).show();
                        }
                    },
                    error: function(xhr) {
                        $("#delete-errors").html("Error: " + (xhr.responseJSON?.message || xhr.statusText)).show();
                    }
                });
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
                            $("#productModal").modal("hide");
                            location.reload(); // Reload to show flash message
                        } else {
                            $("#form-errors").html(response.message).show();
                        }
                    },
                    error: function(xhr) {
                        $("#form-errors").html("Error: " + (xhr.responseJSON?.message || xhr.statusText)).show();
                    }
                });
            });

            // Show flash message if present
            <g:if test="${flash.message}">
            $("#success-message").html("${flash.message}").show();
            setTimeout(function() {
                $("#success-message").fadeOut();
            }, 5000);
            </g:if>
            <g:if test="${flash.error}">
            $("#form-errors").html("${flash.error}").show();
            setTimeout(function() {
                $("#form-errors").fadeOut();
            }, 5000);
            </g:if>
        });
    </script>
</head>
<body class="${session.themeName ?: 'theme-default'}">
<div class="container mt-5">
    <div class="header">
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
                <td>
                    <g:if test="${session.permissions?.inventory?.canEdit}">
                        <button class="btn btn-warning btn-sm open-modal" data-action="edit" data-id="${product.id}">
                            <i class="fas fa-pencil-alt"></i> Edit
                        </button>
                    </g:if>
                    <g:if test="${session.permissions?.inventory?.canDelete}">
                        <button class="btn btn-danger btn-sm delete-product" data-id="${product.id}">
                            <i class="fas fa-trash"></i> Delete
                        </button>
                    </g:if>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>

    <nav aria-label="Page navigation">
        <ul class="pagination justify-content-center animate__animated animate__fadeIn" id="pagination"></ul>
    </nav>

    <!-- Add/Edit Product Modal -->
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

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content animate__animated animate__zoomIn">
                <div class="modal-header">
                    <h4 class="modal-title">Confirm Deletion</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="delete-errors" class="alert alert-danger" style="display: none;"></div>
                    <p>Are you sure you want to delete this product?</p>
                    <input type="hidden" id="deleteProductId">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
                    <button type="button" id="confirmDelete" class="btn btn-danger">Yes</button>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>