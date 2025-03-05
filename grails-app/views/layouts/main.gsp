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

    // Function to check access for a page
    function checkAccess(page) {
        if (isAdmin) return true; // Admin has full access
        var permission = pagePermissions[page];
        return permission && permission.canView;
    }

    // Handle sidebar link clicks for permission checking
    document.querySelectorAll('.sidebar a').forEach(link => {
        link.addEventListener('click', function(e) {
            const href = this.getAttribute('href');
            if (!href || href === '#') return; // Skip dummy links like Settings (dropdown triggers)
            const page = href.split('/')[2]; // Extract controller name
            if (!checkAccess(page)) {
                e.preventDefault();
                alert("You do not have access to this page.");
            }
        });
    });

    // Handle dropdown toggle (for Settings dropdown)
    document.querySelectorAll('.dropdown-toggle').forEach(dropdown => {
        dropdown.addEventListener('click', function(e) {
            e.preventDefault(); // Prevent default anchor behavior
            const dropdownMenu = this.nextElementSibling; // Get the dropdown menu
            const isExpanded = this.getAttribute('aria-expanded') === 'true';

            // Toggle dropdown visibility
            dropdownMenu.classList.toggle('show');
            this.setAttribute('aria-expanded', !isExpanded ? 'true' : 'false');

            // Close other dropdowns if open (optional for single open dropdown behavior)
            document.querySelectorAll('.dropdown-menu.show').forEach(menu => {
                if (menu !== dropdownMenu) {
                    menu.classList.remove('show');
                    menu.previousElementSibling.setAttribute('aria-expanded', 'false');
                }
            });
        });
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
        document.querySelectorAll('.dropdown').forEach(dropdown => {
            const toggle = dropdown.querySelector('.dropdown-toggle');
            const menu = dropdown.querySelector('.dropdown-menu');
            if (menu.classList.contains('show') && !dropdown.contains(e.target)) {
                menu.classList.remove('show');
                toggle.setAttribute('aria-expanded', 'false');
            }
        });
    });

    // Optional: Close dropdown when navigating away (e.g., clicking another sidebar link)
    document.querySelectorAll('.sidebar a:not(.dropdown-toggle)').forEach(link => {
        link.addEventListener('click', function() {
            document.querySelectorAll('.dropdown-menu.show').forEach(menu => {
                menu.classList.remove('show');
                menu.previousElementSibling.setAttribute('aria-expanded', 'false');
            });
        });
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>