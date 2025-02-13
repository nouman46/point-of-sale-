<%@ page contentType="text/html;charset=UTF-8" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="layout" content="main" />
    <title>User Management</title>
    <meta name="_csrf" content="${session['csrfToken']}" />
    <!-- Bootstrap & jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <!-- Custom Styles -->
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
            var csrfToken = $('meta[name="_csrf"]').attr('content');

            // Open modal for Add/Edit User
            $(".open-modal").click(function(){
                var action = $(this).data("action");
                var id = $(this).data("id");
                $("#userForm")[0].reset();
                $("#userId").val("");
                $("#userModal").modal("show");

                if(action === "edit") {
                    $.ajax({
                        type: "GET",
                        url: "/admin/showUser/" + id,
                        dataType: "json",
                        success: function(data) {
                            console.log("Fetched User Data:", data); // Debugging
                            $("#userId").val(data.id);
                            $("#username").val(data.username);
                            $("#password").val(data.password);
                            $("#role").val(data.role);

                            $("input[name='allowedPages']").each(function(){
                                $(this).prop("checked", data.allowedPages.includes($(this).val()));
                            });
                        },
                        error: function(xhr) {
                            console.error("Error fetching user data:", xhr.responseText);
                            alert("Error fetching user data: " + xhr.responseText);
                        }
                    });
                }
            });

            // Save User
            $("#saveUser").click(function(event){
                event.preventDefault();
                $.ajax({
                    type: "POST",
                    url: "/admin/saveUser",
                    data: $("#userForm").serialize(),
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
                    },
                    success: function(response) {
                        alert("User saved successfully!");
                        $("#userModal").modal("hide");
                        location.reload();
                    },
                    error: function(xhr) {
                        console.error("Error saving user:", xhr.responseText);
                        alert("Error saving user: " + xhr.responseText);
                    }
                });
            });

            // Delete User
            $(".delete-user").click(function(){
                var id = $(this).data("id");
                if (confirm("Are you sure you want to delete this user?")) {
                    $.ajax({
                        type: "POST",
                        url: "/admin/deleteUser/" + id,
                        beforeSend: function(xhr) {
                            xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
                        },
                        success: function(response) {
                            alert("User deleted successfully!");
                            location.reload();
                        },
                        error: function(xhr) {
                            console.error("Error deleting user:", xhr.responseText);
                            alert("Error deleting user: " + xhr.responseText);
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
        <h2 class="fw-bold"><i class="fas fa-users"></i> User Management</h2>
    </div>
    <div class="d-flex justify-content-end mt-4">
        <button class="btn btn-success btn-custom open-modal" data-action="add">
            <i class="fas fa-user-plus"></i> Add User
        </button>
    </div>

    <div class="table-responsive mt-4">
        <table class="table table-hover shadow-sm">
            <thead class="table-dark">
        <tr>
            <th>Username</th>
            <th>Allowed Pages</th>
            <th>Role</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <g:each var="user" in="${users}">
            <tr>
                <td>${user.username}</td>
                <td>${user.allowedPages ?: 'No pages assigned'}</td>
                <td>
                    <g:set var="userRole" value="${store.UserRole.findByUser(user)?.role?.name}"/>
                    ${userRole ?: 'No role assigned'}
                </td>
                <td>
                    <button class="btn btn-warning btn-custom open-modal" data-action="edit" data-id="${user.id}">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn btn-danger btn-custom delete-user" data-id="${user.id}">
                        <i class="fas fa-trash"></i>
                    </button>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
    </div>
</div>

<!-- User Form Modal -->
<div class="modal fade" id="userModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h4 class="modal-title">User Form</h4>

                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="userForm">
                        <input type="hidden" id="userId" name="id">
                        <div class="mb-3">
                            <label for="username" class="form-label">Username</label>
                            <input type="text" id="username" name="username" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" id="password" name="password" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label for="role" class="form-label">Role</label>
                            <select id="role" name="roleName" class="form-control">
                                <option value="Accountant">Accountant</option>
                                <option value="Cashier">Cashier</option>
                                <option value="Salesperson">Salesperson</option>
                                <option value="Admin">Admin</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Allowed Pages</label>
                            <g:each var="page" in="${['inventory', 'sales', 'checkout', 'settings', 'subscription']}">
                                <label class="me-2">
                                    <input type="checkbox" name="allowedPages" value="${page}"> ${page}
                                </label>
                            </g:each>
                        </div>

                        <button type="button" id="saveUser" class="btn btn-success"><i class="fas fa-save"></i> Save</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>
</body>
</html>