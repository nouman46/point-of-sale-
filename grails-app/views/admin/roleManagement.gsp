<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="layout" content="main" />
    <title>Role Management</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-4">
    <h2 class="text-center mb-4">Role Management</h2>
<!-- Flash messages -->
    <g:if test="${flash.message}">
        <div class="alert alert-success">${flash.message}</div>
    </g:if>
    <g:if test="${flash.error}">
        <div class="alert alert-danger">${flash.error}</div>
    </g:if>


<!-- Tabs Navigation -->
    <ul class="nav nav-tabs" id="roleTabs">
        <li class="nav-item">
            <a class="nav-link active" data-bs-toggle="tab" href="#users">Users</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" data-bs-toggle="tab" href="#roles">Roles</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" data-bs-toggle="tab" href="#permissions">Permissions</a>
        </li>
    </ul>

    <div class="tab-content mt-3">
        <!-- Users Section -->
        <div class="tab-pane fade show active" id="users">
            <h4>Add User</h4>
            <form id="addUserForm" action="${createLink(controller: 'admin', action: 'saveUser')}" method="POST" class="mb-4">
                <div class="row">
                    <div class="col-md-4">
                        <input type="text" id="addUsername" name="username" class="form-control" placeholder="Username" required>
                    </div>
                    <div class="col-md-4">
                        <input type="password" id="addPassword" name="password" class="form-control" placeholder="Password" required>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-success">Add User</button>
                    </div>
                </div>
            </form>

            <h4>Assign Role to User</h4>
            <form action="${createLink(controller: 'admin', action: 'assignRole')}" method="post">
                <div class="row">
                    <div class="col-md-5">
                        <select name="userId" class="form-select" required>
                            <option value="">Select User</option>
                            <g:each var="user" in="${users}">
                                <option value="${user.id}">${user.username}</option>
                            </g:each>
                        </select>
                    </div>
                    <div class="col-md-5">
                        <select name="roleId" class="form-select" required>
                            <option value="">Select Role</option>
                            <g:each in="${roles}" var="role">
                                <option value="${role.id}">${role.roleName}</option>
                            </g:each>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary">Assign</button>
                    </div>
                </div>
            </form>

        <h4 class="mt-4">User List</h4>
        <table class="table table-bordered">
            <thead>
            <tr>
                <th>Username</th>
                <th>Role(s)</th>
                <th>Edit</th>
                <th>Delete</th>
            </tr>
            </thead>
            <tbody>
            <g:each var="user" in="${users}">
                <tr>
                    <td>${user.username}</td>
                    <td>
                        <g:each var="role" in="${user.assignRole}">
                            <span class="badge bg-info">${role.roleName}</span>
                        </g:each>
                    </td>
                    <td>
                    <!-- Conditionally display Edit button if user is not assigned 'ADMIN' role -->
                        <g:if test="${!user.assignRole*.roleName.contains('ADMIN') && session.permissions?.roleManagement?.canEdit}">
                            <button class="btn btn-warning btn-sm edit-user-btn" data-id="${user.id}" data-username="${user.username}" data-roles="${user.assignRole*.id.join(',')}">
                                ✏️ Edit
                            </button>
                        </g:if>
                    </td>
                    <td>
                    <!-- Conditionally display Delete button if user is not assigned 'ADMIN' role -->
                        <g:if test="${!user.assignRole*.roleName.contains('ADMIN') && session.permissions?.roleManagement?.canDelete}">
                            <button class="btn btn-danger btn-sm delete-user-btn" data-id="${user.id}">
                                ❌ Delete
                            </button>
                        </g:if>
                    </td>
                </tr>
            </g:each>
            </tbody>
        </table>

    </div>

        <!-- Roles Section -->
        <div class="tab-pane fade" id="roles">
            <h4>Add Role</h4>
            <form id="addRoleForm" action="${createLink(controller: 'admin', action: 'saveRole')}" method="POST" class="mb-4">
                <div class="row">
                    <div class="col-md-8">
                        <input type="text" id="addRoleName" name="roleName" class="form-control" placeholder="Role Name" required>
                    </div>
                    <div class="col-md-4">
                        <button type="submit" class="btn btn-success">Add Role</button>
                    </div>
                </div>
            </form>

            <h4>Existing Roles</h4>
            <table class="table table-bordered">
                <thead>
                <tr>
                    <th>Role Name</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <g:each var="role" in="${roles}">
                    <tr>
                        <td>${role.roleName}</td>
                        <td>
                            <g:if test="${session.permissions?.roleManagement?.canEdit}">
                            <button class="btn btn-warning btn-sm edit-role-btn" data-role-id="${role.id}" data-role-name="${role.roleName}">
                                ✏️ Edit
                            </button>
                            </g:if>
                    <g:if test="${session.permissions?.roleManagement?.canDelete}">
                            <button class="btn btn-danger btn-sm delete-role-btn" data-role-id="${role.id}">
                                ❌ Delete
                            </button>
                    </g:if>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>

        <!-- Permissions Section -->
        <div class="tab-pane fade" id="permissions">
            <h4>Assign Permissions to Role</h4>
            <form action="${createLink(controller: 'admin', action: 'assignPermission')}" method="post">
                <div class="row">
                    <div class="col-md-6">
                        <select name="roleId" id="roleDropdown" class="form-control">
                            <option value="">-- Select Role --</option>
                            <g:each in="${roles}" var="role">
                                <option value="${role.id}">${role.roleName}</option>
                            </g:each>
                        </select>
                    </div>
                    <div class="col-md-6">
<g:if test="${session.permissions?.roleManagement?.canEdit}">
                        <button type="submit" class="btn btn-primary">Save Permissions</button>
</g:if>
                    </div>
                </div>

                <table class="table table-bordered mt-3">
                    <thead>
                    <tr>
                        <th>Page</th>
                        <th>View</th>
                        <th>Edit</th>
                        <th>Delete</th>
                    </tr>
                    </thead>
                    <tbody>
                    <g:each var="page" in="${pages}">
                        <tr>
                            <td>
                                <input type="hidden" name="pages" value="${page}"/> ${page}
                            </td>
                            <td><input type="checkbox" name="canView_${page}"></td>
                            <td><input type="checkbox" name="canEdit_${page}"></td>
                            <td><input type="checkbox" name="canDelete_${page}"></td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </form>

            <g:set var="groupedPermissions" value="${permissions.groupBy { it.assignRole.roleName }}" />

            <div class="accordion" id="permissionsAccordion">
                <g:each var="entry" in="${groupedPermissions}" status="index">
                    <div class="accordion-item">
                        <h2 class="accordion-header" id="heading${index}">
                            <button class="accordion-button ${index == 0 ? '' : 'collapsed'}" type="button" data-bs-toggle="collapse"
                                    data-bs-target="#collapse${index}" aria-expanded="${index == 0 ? 'true' : 'false'}"
                                    aria-controls="collapse${index}">
                                ${entry.key} <!-- Role Name -->
                            </button>
                        </h2>
                        <div id="collapse${index}" class="accordion-collapse collapse ${index == 0 ? 'show' : ''}"
                             aria-labelledby="heading${index}" data-bs-parent="#permissionsAccordion">
                            <div class="accordion-body">
                                <table class="table table-bordered">
                                    <thead>
                                    <tr>
                                        <th>Page</th>
                                        <th>View</th>
                                        <th>Edit</th>
                                        <th>Delete</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <g:each var="permission" in="${entry.value}">
                                        <tr>
                                            <td>${permission.pageName}</td>
                                            <td>${permission.canView ? '✅' : '❌'}</td>
                                            <td>${permission.canEdit ? '✅' : '❌'}</td>
                                            <td>${permission.canDelete ? '✅' : '❌'}</td>
                                        </tr>
                                    </g:each>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </g:each>
            </div>
        </div>
    </div>

    <!-- Edit User Modal -->
    <div class="modal fade" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editUserModalLabel">Edit User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editUserForm" action="${createLink(controller: 'admin', action: 'editUser')}" method="POST">
                        <input type="hidden" id="editUserId" name="userId">
                        <div class="mb-3">
                            <label for="editUsername" class="form-label">Username</label>
                            <input type="text" class="form-control" id="editUsername" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="editRole" class="form-label">Roles</label>
                            <div id="editRoles">
                                <g:each in="${roles}" var="role">
                                    <div class="form-check">
                                        <input class="form-check-input role-checkbox" type="checkbox" name="roles" value="${role.id}" id="role_${role.id}">
                                        <label class="form-check-label" for="role_${role.id}">
                                            ${role.roleName}
                                        </label>
                                    </div>
                                </g:each>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="editPassword" class="form-label">Password (Optional)</label>
                            <input type="password" class="form-control" id="editPassword" name="password">
                            <div class="form-text">Leave blank to keep the current password</div>
                        </div>
                        <button type="submit" class="btn btn-primary">Save changes</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Role Modal -->
    <div class="modal fade" id="editRoleModal" tabindex="-1" aria-labelledby="editRoleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editRoleModalLabel">Edit Role</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editRoleForm" action="${createLink(controller: 'admin', action: 'editRole')}" method="POST">
                        <input type="hidden" id="editRoleId" name="id">
                        <div class="mb-3">
                            <label for="editRoleName" class="form-label">Role Name</label>
                            <input type="text" class="form-control" id="editRoleName" name="roleName">
                        </div>
                        <button type="submit" class="btn btn-primary">Save changes</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Role Modal -->
    <div class="modal fade" id="deleteRoleModal" tabindex="-1" aria-labelledby="deleteRoleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteRoleModalLabel">Delete Role</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="${createLink(controller: 'admin', action: 'deleteRole')}" method="post">
                        <input type="hidden" name="id" id="deleteRoleId">
                        <p>Are you sure you want to delete this role?</p>
                        <button type="submit" class="btn btn-danger">Yes, Delete</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var deleteUserUrl = "${createLink(controller: 'admin', action: 'deleteUser')}";
            var deleteRoleUrl = "${createLink(controller: 'admin', action: 'deleteRole')}";

            document.querySelectorAll(".delete-user-btn").forEach(button => {
                button.addEventListener("click", function () {
                    let userId = this.dataset.id;
                    if (confirm("Are you sure you want to delete this user?")) {
                        fetch(deleteUserUrl + "?id=" + userId, {
                            method: "POST",
                            headers: {
                                "X-HTTP-Method-Override": "DELETE"
                            }
                        })
                            .then(response => response.text())
                            .then(data => {
                                alert(data);
                                location.reload();
                            })
                            .catch(error => alert("Error deleting user: " + error));
                    }
                });
            });

            document.querySelectorAll(".delete-role-btn").forEach(button => {
                button.addEventListener("click", function () {
                    let roleId = this.dataset.roleId;
                    document.getElementById("deleteRoleId").value = roleId;
                    new bootstrap.Modal(document.getElementById('deleteRoleModal')).show();
                });
            });

            document.querySelectorAll(".edit-role-btn").forEach(button => {
                button.addEventListener("click", function () {
                    let roleId = this.dataset.roleId;
                    let roleName = this.dataset.roleName;
                    document.getElementById("editRoleId").value = roleId;
                    document.getElementById("editRoleName").value = roleName;
                    new bootstrap.Modal(document.getElementById('editRoleModal')).show();
                });
            });

            document.querySelectorAll(".edit-user-btn").forEach(button => {
                button.addEventListener("click", function () {
                    let userId = this.dataset.id;
                    let username = this.dataset.username;
                    let rolesData = this.dataset.roles || "";
                    let assignedRoles = rolesData.split(',');

                    document.getElementById("editUserId").value = userId;
                    document.getElementById("editUsername").value = username;

                    document.querySelectorAll(".role-checkbox").forEach(checkbox => {
                        checkbox.checked = assignedRoles.includes(checkbox.value);
                    });

                    new bootstrap.Modal(document.getElementById('editUserModal')).show();
                });
            });
        });
    </script>

</body>
</html>