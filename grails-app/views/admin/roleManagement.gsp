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

<!-- Flash Messages -->
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
      <form action="${createLink(controller: 'admin', action: 'saveUser')}" method="post" class="mb-4">
        <div class="row">
          <div class="col-md-4">
            <input type="text" name="username" class="form-control" placeholder="Username" required>
          </div>
          <div class="col-md-4">
            <input type="password" name="password" class="form-control" placeholder="Password" required>
          </div>
          <div class="col-md-2">
            <input type="checkbox" name="isAdmin"> Admin
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
              <option value="">-- Select Role --</option>
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
          </tr>
        </g:each>
        </tbody>
      </table>
    </div>

    <!-- Roles Section -->
    <div class="tab-pane fade" id="roles">
      <h4>Add Role</h4>
      <form action="${createLink(controller: 'admin', action: 'saveRole')}" method="post" class="mb-4">
        <div class="row">
          <div class="col-md-8">
            <input type="text" name="roleName" class="form-control" placeholder="Role Name" required>
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
        </tr>
        </thead>
        <tbody>
        <g:each var="role" in="${assignRoles}">
          <tr>
            <td>${role.roleName}</td>
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
            <button type="submit" class="btn btn-primary">Save Permissions</button>
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

      <h4 class="mt-4">Current Permissions</h4>
      <table class="table table-bordered">
        <thead>
        <tr>
          <th>Role</th>
          <th>Page</th>
          <th>View</th>
          <th>Edit</th>
          <th>Delete</th>
        </tr>
        </thead>
        <tbody>
        <g:each var="permission" in="${permissions}">
          <tr>
            <td>${permission.assignRole.roleName}</td>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
