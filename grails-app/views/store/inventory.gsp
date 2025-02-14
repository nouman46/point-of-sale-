

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


    </style>


    <script>
        $(document).ready(function(){
            // Read CSRF token from meta tag
            var csrfToken = $('meta[name="_csrf"]').attr('content');

            // Handle search functionality
            $("#searchInput").keyup(function(){
                var searchValue = $(this).val().toLowerCase();
                $("#productTable tbody tr").each(function(){
                    var rowText = $(this).text().toLowerCase();
                    if(rowText.indexOf(searchValue) > -1) {
                        $(this).show();
                    } else {
                        $(this).hide();
                    }
                });
            });

            // Open modal for adding or editing a product
            $(".open-modal").click(function(){
                var action = $(this).data("action");
                var id = $(this).data("id");
                $("#productForm")[0].reset();  // Reset form
                $("#productId").val("");       // Clear hidden field
                $("#productModal").modal("show");  // Show modal

                // For edit, fetch existing product data
                if(action === "edit") {
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
                            alert("Error fetching product data: " + xhr.responseText);
                        }
                    });
                }
            });

            // Save product via AJAX
            $("#saveProduct").click(function(event){
                event.preventDefault();  // Prevent normal form submission

                $.ajax({
                    type: "POST",
                    url: "/store/saveProduct",
                    data: $("#productForm").serialize(),
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
                    },
                    success: function(response) {
                        alert("Product saved successfully!");
                        $("#productModal").modal("hide");
                        location.reload();
                    },
                    error: function(xhr) {
                        alert("Error saving product: " + xhr.responseText);
                    }
                });
            });

            // Delete product via AJAX
            $(".delete-product").click(function(){
                var id = $(this).data("id");
                if(confirm("Are you sure you want to delete this product?")) {
                    $.ajax({
                        type: "POST",
                        url: "/store/deleteProduct/" + id,
                        beforeSend: function(xhr) {
                            xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
                        },
                        success: function(response) {
                            alert("Product deleted successfully!");
                            location.reload();
                        },
                        error: function(xhr) {
                            alert("Error deleting product: " + xhr.responseText);
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
            <th>Product Name</th>
            <th>Product Description</th>
            <th>Product SKU</th>
            <th>Product Barcode</th>
            <th>Product Price</th>
            <th>Product Quantity</th>
            <th>Actions</th>
        </tr>
        </thead>

        <tbody>
        <g:each in="${productList}" var="product">
            <tr>
                <td>${product.productName}</td>
                <td>${product.productDescription}</td>
                <td>${product.productSKU}</td>
                <td>${product.productBarcode}</td>
                <td>${product.productPrice}</td>
                <td>${product.productQuantity}</td>

                <td>
                    <g:if test="${permissions?.canEdit}">
                    <button class="btn btn-warning btn-custom open-modal" data-action="edit" data-id="${product.id}">
                        <i class="fas fa-edit"></i></button>
                    </g:if>
                    <g:if test="${permissions?.canDelete}">
                    <button class="btn btn-danger btn-custom delete-user" data-id="${product.id}">
                        <i class="fas fa-trash"></i>
                    </button>
                    </g:if>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>

    <!-- Pagination -->
    <div class="d-flex justify-content-between">
        <!-- Back Button -->
        <a href="${createLink(controller: 'store', action: 'inventory', params: [page: currentPage - 1])}" class="btn btn-secondary"
            ${currentPage == 1 ? 'disabled' : ''}>Back</a>

        <!-- Next Button -->
        <a href="${createLink(controller: 'store', action: 'inventory', params: [page: currentPage + 1])}" class="btn btn-secondary"
            ${currentPage == totalPages ? 'disabled' : ''}>Next</a>
    </div>


    <!-- Modal for adding/editing a product -->
    <div class="modal fade" id="productModal" tabindex="-1" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Product Form</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
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
</body>
</html>
