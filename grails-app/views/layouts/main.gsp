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
    .main-content {
        margin-left: 250px;
        padding: 20px;
        width: calc(100% - 250px);
        transition: margin-left 0.3s ease;
    }
    </style>
</head>
<body>

<g:layoutHead/>
<g:if test="${session.user}">
    <div class="sidebar">
        <g:if test="${session.isAdmin || session.permissions['dashboard']?.canView}">
            <a href="${createLink(controller: 'dashboard', action: 'dashboard')}"><i class="fas fa-home"></i> Dashboard</a>
        </g:if>
        <g:if test="${session.isAdmin || session.permissions['inventory']?.canView}">
            <a href="${createLink(controller: 'store', action: 'inventory')}"><i class="fas fa-box"></i> Inventory</a>
        </g:if>
        <g:if test="${session.isAdmin || session.permissions['listOrders']?.canView}">
            <a href="${createLink(controller: 'order', action: 'listOrders')}"><i class="fas fa-shopping-cart"></i> Sales</a>
        </g:if>
        <g:if test="${session.isAdmin || session.permissions['checkout']?.canView}">
            <a href="${createLink(controller: 'order', action: 'checkout')}"><i class="fas fa-cash-register"></i> Checkout</a>
        </g:if>
        <g:if test="${session.isAdmin || session.permissions['settings']?.canView}">
            <a href="${createLink(controller: 'setting', action: 'index')}"><i class="fas fa-cog"></i> Settings</a>
        </g:if>
        <g:if test="${session.isAdmin || session.permissions['subscription']?.canView}">
            <a href="${createLink(controller: 'subscription', action: 'subscription')}"><i class="fas fa-credit-card"></i> Subscription</a>
        </g:if>
        <g:if test="${session.isAdmin || session.permissions['roleManagement']?.canView}">
            <a href="${createLink(controller: 'admin', action: 'roleManagement')}"><i class="fas fa-users"></i> User Management</a>
        </g:if>
        <a href="${createLink(controller: 'auth', action: 'logout')}" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>
</g:if>

<!-- Main Content Area -->
<div class="main-content">
    <g:layoutBody/>
</div>

<script>
    var isAdmin = ${session.isAdmin ?: false};
    var pagePermissions = ${raw(session.permissions as grails.converters.JSON)};

    function checkAccess(page) {
        if (isAdmin) return true; // Admin has full access

        var permission = pagePermissions[page];
        if (!permission || !permission.canView) {
            alert("You do not have access to this page.");
            return false;
        }
        return true;
    }
</script>

</body>
</html>
