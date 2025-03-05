<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'theme.css')}"/>
    <g:layoutHead/>
    <style>
    /* No additional styles needed here; theme.css handles it */
    </style>
</head>
<body class="${session.themeName ?: 'theme-default'}">

<g:if test="${session.user}">
    <div class="sidebar">
        <div class="main-nav">
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
                <div class="dropdown">
                    <a href="#"><i class="fas fa-cog"></i> Settings</a>
                    <div class="dropdown-menu">
                        <g:if test="${session.isAdmin || session.permissions['subscription']?.canView}">
                            <a href="${createLink(controller: 'setting', action: 'index')}"><i class="fas fa-credit-card"></i> Profile</a>
                        </g:if>
                        <g:if test="${session.isAdmin || session.permissions['roleManagement']?.canView}">
                            <a href="${createLink(controller: 'admin', action: 'roleManagement')}"><i class="fas fa-users"></i> Role Management</a>
                        </g:if>
                        <a href="${createLink(controller: 'theme', action: 'selectTheme')}"><i class="fas fa-paint-brush"></i> Change Theme</a>
                    </div>
                </div>
            </g:if>
        </div>
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
        return permission && permission.canView;
    }

    document.querySelectorAll('.sidebar a').forEach(link => {
        link.addEventListener('click', function(e) {
            const href = this.getAttribute('href');
            if (!href || href === '#') return; // Skip dummy links like Settings
            const page = href.split('/')[2]; // Extract controller name
            if (!checkAccess(page)) {
                e.preventDefault();
                alert("You do not have access to this page.");
            }
        });
    });
</script>
</body>
</html>