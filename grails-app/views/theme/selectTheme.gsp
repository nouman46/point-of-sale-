<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main" />
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'theme.css')}"/>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
    /* Base Styles */
    body {
        margin: 0;
        font-family: "Poppins", sans-serif;
        background: var(--background-color);
        color: var(--text-color);
        min-height: 100vh;
        overflow-x: hidden;
    }

    /* Main Content Container - Centered, with better padding and shadow */
    .main-content {
        max-width: 1200px; /* Increased width for a more spacious layout */
        margin: 60px auto; /* Reduced top margin for better balance */
        padding: 50px; /* Increased padding for a cleaner look */
        background: var(--box-bg);
        color: var(--box-text);
        border-left: 8px solid var(--box-border);
        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1); /* Softer shadow for professionalism */
        border-radius: 15px; /* Slightly larger border radius for modern look */
        transition: all 0.3s ease;
    }

    h1 {
        color: var(--text-color);
        text-align: center;
        margin-bottom: 50px; /* Increased spacing below title */
        font-weight: 700; /* Bolder font weight for emphasis */
        font-size: 2.8rem; /* Slightly larger title for impact */
        transition: color 0.3s ease;
        letter-spacing: -0.5px; /* Subtle letter spacing for readability */
    }

    /* Theme Grid - Improved spacing and responsiveness */
    .theme-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); /* Larger minimum card size for better visibility */
        gap: 40px; /* Increased gap for breathing room */
        padding: 0; /* Removed unnecessary padding */
        transition: all 0.3s ease;
    }

    /* Theme Cards - Enhanced styling for professionalism */
    .theme-card {
        padding: 40px; /* Increased padding for a roomier feel */
        border-radius: 12px; /* Slightly smaller radius for consistency */
        cursor: pointer;
        background: var(--box-bg);
        color: var(--box-text);
        border: 2px solid transparent;
        box-shadow: 0 8px 15px rgba(0, 0, 0, 0.05); /* Subtle shadow for a clean look */
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        text-align: center;
        height: 200px; /* Fixed height for uniformity */
    }

    .theme-card:hover {
        transform: translateY(-8px); /* Slightly larger hover lift for emphasis */
        box-shadow: 0 12px 25px rgba(0, 0, 0, 0.1); /* Softer hover shadow */
        border-color: var(--primary-color);
    }

    .theme-card.active {
        border: 2px solid var(--primary-color);
        box-shadow: 0 0 25px rgba(var(--primary-color-rgb), 0.2); /* Softer glow for active state */
        transform: scale(1.05);
    }

    .theme-title {
        margin: 0;
        color: var(--text-color);
        font-weight: 600; /* Slightly bolder for clarity */
        font-size: 1.5rem; /* Larger font size for better readability */
        transition: color 0.3s ease;
        line-height: 1.4; /* Improved line height for readability */
    }

    /* Active Theme Banner - Positioned and styled for elegance */
    .active-theme-banner {
        position: fixed;
        top: 20px;
        left: 50%;
        transform: translateX(-50%);
        background: var(--primary-color);
        color: var(--sidebar-text);
        padding: 12px 25px; /* Increased padding for a more polished look */
        border-radius: 25px; /* Larger radius for a softer appearance */
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1); /* Softer shadow */
        font-weight: 600; /* Bolder text for emphasis */
        animation: slideIn 0.5s ease;
        z-index: 1000;
        transition: all 0.3s ease;
    }

    @keyframes slideIn {
        from { top: -50px; opacity: 0; }
        to { top: 20px; opacity: 1; }
    }

    /* Modal Styling - Enhanced for professionalism */
    .modal-content {
        background: var(--box-bg);
        color: var(--box-text);
        border-radius: 15px; /* Larger radius for modern look */
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1); /* Softer shadow */
        animation: fadeIn 0.3s ease;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: scale(0.9); }
        to { opacity: 1; transform: scale(1); }
    }

    .modal-header {
        background: var(--sidebar-bg);
        color: var(--sidebar-text);
        border-bottom: none;
        border-radius: 15px 15px 0 0;
    }

    .btn-confirm {
        background: var(--primary-color);
        border: none;
        padding: 10px 25px; /* Larger padding for a bolder button */
        transition: background 0.3s ease, transform 0.3s ease;
    }

    .btn-confirm:hover {
        background: color-mix(in srgb, var(--primary-color) 80%, #000000 20%);
        transform: translateY(-3px); /* Slightly larger hover lift */
    }

    .btn-secondary {
        padding: 10px 25px; /* Consistent padding with confirm button */
    }
    </style>
</head>
<body class="${session.themeName ?: 'theme-default'}">
<div class="main-content">
    <h1>Select a Theme</h1>
    <div class="theme-grid">
        <div class="theme-card theme-default ${session.themeName == 'theme-default' ? 'active' : ''}" data-theme="default">
            <h3 class="theme-title">Default Theme</h3>
        </div>
        <div class="theme-card theme-dark ${session.themeName == 'theme-dark' ? 'active' : ''}" data-theme="dark">
            <h3 class="theme-title">Dark Theme</h3>
        </div>
        <div class="theme-card theme-blue-ocean ${session.themeName == 'theme-blue-ocean' ? 'active' : ''}" data-theme="blue-ocean">
            <h3 class="theme-title">Blue Ocean Theme</h3>
        </div>
        <div class="theme-card theme-warm-sunset ${session.themeName == 'theme-warm-sunset' ? 'active' : ''}" data-theme="warm-sunset">
            <h3 class="theme-title">Warm Sunset Theme</h3>
        </div>
    </div>
</div>

<!-- Active Theme Banner -->
<div class="active-theme-banner" id="activeThemeBanner" style="${session.themeName ? '' : 'display: none;'}">
    Active Theme: <span id="activeThemeName">
    ${session.themeName == 'theme-default' ? 'Default Theme' :
            session.themeName == 'theme-dark' ? 'Dark Theme' :
                    session.themeName == 'theme-blue-ocean' ? 'Blue Ocean Theme' :
                            session.themeName == 'theme-warm-sunset' ? 'Warm Sunset Theme' : 'None'}
</span>
</div>

<!-- Confirmation Modal -->
<div class="modal fade" id="themeModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Confirm Theme Change</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                Are you sure you want to switch to the <span id="newThemeName" style="color: var(--primary-color); font-weight: 600;"></span> theme?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
                <button type="button" class="btn btn-confirm" id="confirmTheme">Yes</button>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        let selectedTheme = '';

        $('.theme-card').click(function() {
            if (!$(this).hasClass('active')) {
                selectedTheme = $(this).data('theme'); // e.g., "default", "dark"
                const themeName = $(this).find('.theme-title').text(); // e.g., "Default Theme"
                $('#newThemeName').text(themeName);
                $('#themeModal').modal('show');
            }
        });

        $('#confirmTheme').click(function() {
            $.ajax({
                url: '${createLink(controller: "theme", action: "switchTheme")}',
                data: { theme: selectedTheme }, // Send raw theme name (e.g., "default")
                success: function(response) {
                    // Update UI before redirect
                    $('.theme-card').removeClass('active');
                    $(`.theme-card[data-theme="${selectedTheme}"]`).addClass('active');
                    const prefixedTheme = 'theme-' + selectedTheme; // Match controller's format
                    $('body').attr('class', prefixedTheme); // Apply prefixed theme to body
                    const themeNames = {
                        'default': 'Default Theme',
                        'dark': 'Dark Theme',
                        'blue-ocean': 'Blue Ocean Theme',
                        'warm-sunset': 'Warm Sunset Theme'
                    };
                    $('#activeThemeName').text(themeNames[selectedTheme]);
                    $('#activeThemeBanner').show();
                    $('#themeModal').modal('hide');
                    // Redirect to dashboard as per controller
                    window.location.href = '${createLink(controller: "dashboard", action: "dashboard")}';
                },
                error: function(xhr, status, error) {
                    alert('Error switching theme: ' + error);
                }
            });
        });
    });
</script>
</body>
</html>