<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<!DOCTYPE html>
<html>
<head>

    <meta name="viewport" content="width=device-width, initial-scale=1">
    <asset:stylesheet src="main.css"/>
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
</head>
<body>

<div class="sidebar">
    <!-- Profile Section -->

    <!-- Navigation Links -->
    <a href="${createLink(controller: 'dashboard', action: 'index')}">
        <i class="fas fa-home"></i> Dashboard
    </a>

    <a href="${createLink(controller: 'store', action: 'inventory')}"
       onclick="return checkAccess('inventory');">
        <i class="fas fa-box"></i> Inventory
    </a>

    <a href="${createLink(controller: 'sales', action: 'index')}"
       onclick="return checkAccess('sales');">
        <i class="fas fa-shopping-cart"></i> Sales
    </a>

    <a href="${createLink(controller: 'checkout', action: 'checkout')}"
       onclick="return checkAccess('checkout');">
        <i class="fas fa-cash-register"></i> Checkout
    </a>

    <a href="${createLink(controller: 'settings', action: 'index')}"
       onclick="return checkAccess('settings');">
        <i class="fas fa-cog"></i> Settings
    </a>

    <a href="${createLink(controller: 'subscription', action: 'index')}"
       onclick="return checkAccess('subscription');">
        <i class="fas fa-credit-card"></i> Subscription
    </a>
    <a href="${createLink(controller: 'admin', action: 'userList')}"
       onclick="return checkAccess('userList');">
        <i class="fas fa-users"></i> User Management
    </a>

    <a href="/auth/logout" class="btn btn-danger mt-3" style="position: absolute; bottom: 20px; left: 20px;">
        <i class="fas fa-sign-out-alt"></i> Logout
    </a>

</div>

<script>
    function checkAccess(page) {
        var isAdmin = ${session.isAdmin ? 'true' : 'false'};
        var allowedPages = "${session.user?.allowedPages}".split(",");

        if (isAdmin || allowedPages.includes(page)) {
            return true; // Allow navigation
        } else {
            alert("You do not have permission to access this page.");
            return false; // Block navigation
        }
    }
</script>

</body>
</html>
