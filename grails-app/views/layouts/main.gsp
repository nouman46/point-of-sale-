<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
    body {
        margin: 0;
        font-family: "Poppins", sans-serif;
        background: #f4f4f4;
        display: flex;
    }
    .sidebar {
        width: 250px;
        height: 100vh;
        background: #1e1e2d;
        position: fixed;
        left: 0;
        top: 0;
        padding-top: 20px;
        transition: all 0.3s;
        overflow: hidden;
    }
    .sidebar a {
        display: flex;
        align-items: center;
        padding: 15px 20px;
        color: white;
        text-decoration: none;
        font-size: 16px;
        transition: 0.3s;
    }
    .sidebar a i {
        margin-right: 10px;
        font-size: 18px;
    }
    .sidebar a:hover {
        background: #323247;
        padding-left: 25px;
    }
    .logout-btn {
        position: absolute;
        bottom: 20px;
        left: 20px;
        width: 80%;
        background: #ff4d4d;
        padding: 10px;
        text-align: center;
        border-radius: 5px;
        color: white;
        font-weight: bold;
    }
    .logout-btn:hover {
        background: #ff6666;
    }
    /* Main content area */
    .main-content {
        margin-left: 250px; /* Adjust content to move right of the sidebar */
        padding: 20px;
        width: calc(100% - 250px); /* Make it fill remaining space */
        transition: margin-left 0.3s ease;
    }
    </style>
</head>
<body>

<g:layoutHead/>
<g:if test="${session.user}">
    <div class="sidebar">
        <a href="${createLink(controller: 'dashboard', action: 'index')}"><i class="fas fa-home"></i> Dashboard</a>
        <a href="${createLink(controller: 'store', action: 'inventory')}" onclick="return checkAccess('inventory');"><i class="fas fa-box"></i> Inventory</a>
        <a href="${createLink(controller: 'order', action: 'listOrders')}" onclick="return checkAccess('listOrders');">
            <i class="fas fa-shopping-cart"></i> Sales
        </a>
        <a href="${createLink(controller: 'order', action: 'checkout')}" onclick="return checkAccess('checkout');"><i class="fas fa-cash-register"></i> Checkout</a>
        <a href="${createLink(controller: 'settings', action: 'settings')}" onclick="return checkAccess('settings');"><i class="fas fa-cog"></i> Settings</a>
        <a href="${createLink(controller: 'subscription', action: 'subscription')}" onclick="return checkAccess('subscription');"><i class="fas fa-credit-card"></i> Subscription</a>
        <a href="${createLink(controller: 'admin', action: 'roleManagement')}" onclick="return checkAccess('roleManagement');"><i class="fas fa-users"></i> User Management</a>
        <a href="${createLink(controller: 'auth', action: 'logout')}" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>
</g:if>

<!-- Main Content Area -->
<div class="main-content">
    <g:layoutBody/>
</div>

<script>
    var userRoles = ${raw(session.roles as grails.converters.JSON)};
    var pagePermissions = ${raw(session.permissions as grails.converters.JSON)};

    function checkAccess(page, action) {
        console.log("Checking access for:", page, "Roles:", userRoles, "Permissions:", pagePermissions);

        if (userRoles.includes("Admin")) {
            return true; // Admin has full access
        }

        var permission = pagePermissions[page];

        if (!permission) {
            alert("You do not have access to this page.");
            return false;
        }

        if (action === "edit" && !permission.canEdit) {
            alert("You do not have permission to edit.");
            return false;
        }

        if (action === "delete" && !permission.canDelete) {
            alert("You do not have permission to delete.");
            return false;
        }

        return true;
    }

    function confirmLogout() {
        if (confirm("Are you sure you want to logout?")) {
            window.location.href = "/auth/logout";
        }
    }
</script>
</body>
</html>
