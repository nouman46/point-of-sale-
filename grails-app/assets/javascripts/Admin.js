
    document.addEventListener("DOMContentLoaded", function() {
    // Get the URLs from Grails before passing them to JavaScript
    var deleteUserUrl = "${createLink(controller: 'admin', action: 'deleteUser')}";
    var deleteRoleUrl = "${createLink(controller: 'admin', action: 'deleteRole')}";

    // Delete User with Confirmation
    document.querySelectorAll(".delete-user-btn").forEach(button => {
    button.addEventListener("click", function() {
    let userId = this.dataset.id;
    if (confirm("Are you sure you want to delete this user?")) {
    fetch(deleteUserUrl + "?id=" + userId, {
    method: "POST",  // Use POST for compatibility with Grails
    headers: {
    "X-HTTP-Method-Override": "DELETE"  // Override for DELETE
}
})
    .then(response => response.text())
    .then(data => {
    alert(data);
    location.reload();  // Reload page to reflect changes
})
    .catch(error => alert("Error deleting user: " + error));
}
});
});

    // Delete Role with Confirmation
    document.querySelectorAll(".delete-role-btn").forEach(button => {
    button.addEventListener("click", function() {
    let roleId = this.dataset.roleId;

    // Set the role ID in the delete form
    document.getElementById("deleteRoleId").value = roleId;

    // Show the Delete Role Modal
    new bootstrap.Modal(document.getElementById('deleteRoleModal')).show();
});
});

    // Populate Edit Role Modal
    document.querySelectorAll(".edit-role-btn").forEach(button => {
    button.addEventListener("click", function() {
    let roleId = this.dataset.roleId;
    let roleName = this.dataset.roleName;

    document.getElementById("editRoleId").value = roleId;
    document.getElementById("editRoleName").value = roleName;

    // Show the Edit Role Modal
    new bootstrap.Modal(document.getElementById('editRoleModal')).show();
});
});

    // Populate Edit User Modal
    document.querySelectorAll(".edit-user-btn").forEach(button => {
    button.addEventListener("click", function() {
    let userId = this.dataset.id;
    let username = this.dataset.username;
    let rolesData = this.dataset.roles || "";  // Default to an empty string if no roles
    let assignedRoles = rolesData.split(','); // Array of role IDs

    document.getElementById("editUserId").value = userId;
    document.getElementById("editUsername").value = username;

    // Check the checkboxes based on assigned roles
    document.querySelectorAll(".role-checkbox").forEach(checkbox => {
    checkbox.checked = assignedRoles.includes(checkbox.value);
});

    // Show the Edit User Modal
    new bootstrap.Modal(document.getElementById('editUserModal')).show();
});
});

    $(document).ready(function() {
    // Generic validation for forms
    function validateForm(form) {
    let isValid = true;
    let formData = new FormData(form);
    let roleName, username, password;
    let specialCharPattern = /[^a-zA-Z0-9\s]/;

    // Handle specific form cases
    if (form.id === "addUserForm" || form.id === "editUserForm") {
    username = $("#" + form.id + " input[name='username']").val().trim();
    password = $("#" + form.id + " input[name='password']").val().trim();

    // Username validation
    if (specialCharPattern.test(username)) {
    alert("Username cannot contain special characters!");
    isValid = false;
} else if (username.length < 3) {
    alert("Username must be at least 3 characters long!");
    isValid = false;
}

    // Password validation (if password is provided)
    if (password !== "") {
    if (password.length < 6) {
    alert("Password must be at least 6 characters long!");
    isValid = false;
}
    if (/\s/.test(password)) {
    alert("Password cannot contain spaces!");
    isValid = false;
}
}

    // Check if at least one role is selected for Edit User form
    if (form.id === "editUserForm") {
    let selectedRoles = [];
    $(".role-checkbox:checked").each(function() {
    selectedRoles.push($(this).val());
});
    if (selectedRoles.length === 0) {
    alert("Please select at least one role.");
    isValid = false;
}
}
}

    // Handle Add Role and Edit Role forms
    if (form.id === "addRoleForm" || form.id === "editRoleForm") {
    roleName = $("#" + form.id + " input[name='roleName']").val().trim();

    // Role name validation
    if (specialCharPattern.test(roleName)) {
    alert("Role Name cannot contain special characters!");
    isValid = false;
} else if (roleName.length < 3) {
    alert("Role Name must be at least 3 characters long!");
    isValid = false;
} else if (/\s/.test(roleName)) {
    alert("Role Name cannot contain spaces!");
    isValid = false;
}
}

    // If all validations pass, return true
    if (isValid) {
    form.submit();
}
}

    // Attach event listeners for form submissions
    $("form").on("submit", function(event) {
    event.preventDefault(); // Prevent default form submission
    validateForm(this); // Validate the form
});
});
});
