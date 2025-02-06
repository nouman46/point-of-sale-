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
    <a href="${createLink(controller: 'store', action: 'inventory')}">
        <i class="fas fa-box"></i> Inventory
    </a>
    <a href="${createLink(controller: 'sales', action: 'index')}">
        <i class="fas fa-shopping-cart"></i> Sales
    </a>
    <a href="${createLink(controller: 'checkout', action: 'checkout')}">
        <i class="fas fa-cash-register"></i> Checkout
    </a>
    <a href="${createLink(controller: 'settings', action: 'index')}">
        <i class="fas fa-cog"></i> Settings
    </a>
    <a href="${createLink(controller: 'subscription', action: 'index')}">
        <i class="fas fa-credit-card"></i> Subscription
    </a>
</div>

</body>
</html>
