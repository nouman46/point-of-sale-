<!DOCTYPE html>
<html>
<head>
  <title>Role Management</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <style>
  body {
    background-color: #f4f4f4;
    font-family: "Poppins", sans-serif;
  }
  .container {
    margin-top: 30px;
  }
  .card {
    border-radius: 10px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  }
  </style>
</head>
<body>

<div class="container">
  <h2 class="text-center">Role Management</h2>

  <!-- Role Form -->
  <div class="card p-3 mb-3">
    <h5>Add/Edit Role</h5>
    <form id="roleForm">
      <input type="hidden" id="roleId">
      <div class="mb-2">
        <label>Role Name</label>
        <input type="text" id="roleName" class="form-control" required>
      </div>
      <button type="button" class="btn btn-primary" onclick="saveRole()">Save Role</button>
    </form>
  </div>

  <!-- Role Listing -->
  <div class="card p-3">
    <h5>Existing Roles</h5>
    <table class="table">
      <thead>
      <tr>
        <th>Role</th>
        <th>Actions</th>
      </tr>
      </thead>
      <tbody id="roleList">
      <!-- Roles will be dynamically populated here -->
      </tbody>
    </table>
  </div>

  <!-- Permissions Assignment -->
  <div class="card p-3 mt-3">
    <h5>Assign Permissions</h5>
    <form id="permissionForm">
      <select id="roleSelect" class="form-control mb-2">
        <option value="">Select Role</option>
      </select>
      <table class="table">
        <thead>
        <tr>
          <th>Page</th>
          <th>View</th>
          <th>Edit</th>
          <th>Delete</th>
        </tr>
        </thead>
        <tbody>
        <tr>
          <td>Inventory</td>
          <td><input type="checkbox" name="inventory_view"></td>
          <td><input type="checkbox" name="inventory_edit"></td>
          <td><input type="checkbox" name="inventory_delete"></td>
        </tr>
        <tr>
          <td>Sales</td>
          <td><input type="checkbox" name="sales_view"></td>
          <td><input type="checkbox" name="sales_edit"></td>
          <td><input type="checkbox" name="sales_delete"></td>
        </tr>
        </tbody>
      </table>
      <button type="button" class="btn btn-success" onclick="savePermissions()">Save Permissions</button>
    </form>
  </div>
</div>

<script>
  $(document).ready(function() {
    loadRoles();
  });

  function loadRoles() {
    $.get("/admin/getRoles", function(data) {
      console.log("Roles received:", data); // Debugging
      if (!Array.isArray(data)) {
        console.error("Invalid roles data received:", data);
        return;
      }

      let roleOptions = '<option value="">Select Role</option>';
      let roleRows = "";

      data.forEach(role => {
        roleOptions += `<option value="${role.id}">${role.roleName}</option>`;
        roleRows += `<tr>
                    <td>${role.roleName}</td>
                    <td>
                        <button class="btn btn-sm btn-warning" onclick="editRole(${role.id}, '${role.roleName}')">Edit</button>
                        <button class="btn btn-sm btn-danger" onclick="deleteRole(${role.id})">Delete</button>
                    </td>
                </tr>`;
      });

      $("#roleSelect").html(roleOptions);
      $("#roleList").html(roleRows);
    });


    $("#roleSelect").html(roleOptions);
      $("#roleList").html(roleRows);
    });
  }

  function saveRole() {
    let roleData = {
      id: $("#roleId").val(),
      roleName: $("#roleName").val()
    };

    $.post("/admin/saveRole", roleData, function(response) {
      alert(response.message);
      $("#roleForm")[0].reset();
      loadRoles();
    });
  }

  function editRole(id, name) {
    $("#roleId").val(id);
    $("#roleName").val(name);
  }

  function deleteRole(id) {
    if (confirm("Are you sure you want to delete this role?")) {
      $.post("/admin/deleteRole", { id: id }, function(response) {
        alert(response.message);
        loadRoles();
      });
    }
  }

  function savePermissions() {
    let roleId = $("#roleSelect").val();
    let permissions = {
      roleId: roleId,
      inventory: {
        canView: $("input[name='inventory_view']").is(":checked"),
        canEdit: $("input[name='inventory_edit']").is(":checked"),
        canDelete: $("input[name='inventory_delete']").is(":checked")
      },
      sales: {
        canView: $("input[name='sales_view']").is(":checked"),
        canEdit: $("input[name='sales_edit']").is(":checked"),
        canDelete: $("input[name='sales_delete']").is(":checked")
      }
    };

    $.post("/admin/savePermissions", permissions, function(response) {
      alert(response.message);
    });
  }
</script>
</body>
</html>
