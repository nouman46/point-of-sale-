<!DOCTYPE html>
<html>
<head>
    <title>POS LOGIN</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS for animations and styling -->
    <style>
    body {
        background-color: #f8f9fa;
        font-family: Arial, sans-serif;
    }

    .login-container {
        max-width: 1200px;
        margin: 50px auto;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        padding: 40px;
    }

    .left-section {
        padding: 40px;
        background-color: #f8f9fa;
        border-radius: 10px 0 0 10px;
        color: #333;
    }

    .right-section {
        padding: 40px;
        background-color: #fff;
        border-radius: 0 10px 10px 0;
    }

    .form-label {
        font-weight: bold;
        color: #333;
    }

    .form-control {
        border-radius: 8px; /* Larger, rounded corners */
        border: 2px solid #ced4da; /* Thicker border for prominence */
        padding: 16px 40px 16px 16px; /* Increased padding for larger fields and eye icon */
        font-size: 1.2rem; /* Larger text for fields */
        background-color: #f0f8ff; /* Light blue background to match the image */
        transition: 0.3s;
        width: 100%; /* Ensure full width */
    }

    .form-control:focus {
        border-color: #007bff; /* Blue border on focus */
        box-shadow: 0 0 8px rgba(0, 123, 255, 0.3); /* Subtle blue glow on focus */

    }

    .btn-primary {
        background-color: #28a745;
        border-color: #28a745;
        font-weight: bold;
        padding: 14px 30px; /* Larger button */
        font-size: 1.2rem; /* Larger text for button */
        border-radius: 8px; /* Larger, rounded corners */
        width: 100%; /* Full width */
    }

    .btn-primary:hover {
        background-color: #218838;
        border-color: #218838;
    }

    .logo {
        font-size: 2.5rem;
        color: #1a2b49;
        font-weight: bold;
        margin-bottom: 20px;
    }

    .feature-icon {
        font-size: 1.5rem;
        color: #1a2b49;
        margin-right: 10px;
    }

    /* Animation for fade-in */
    .fade-in {
        animation: fadeIn 1.5s ease-in-out;
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* Style for password eye icon inside the field */
    .password-toggle {
        position: absolute;
        top: 70%;
        right: 15px; /* Fixed distance from the right edge inside the field */
        transform: translateY(-50%);
        cursor: pointer;
        color: #666;
        z-index: 10; /* Ensure it stays above the input */
    }

    /* Responsive adjustments */
    @media (max-width: 768px) {
        .login-container {
            margin: 20px;
        }

        .row {
            flex-direction: column;
        }

        .left-section, .right-section {
            border-radius: 10px;
            padding: 20px;
        }

        .form-control, .btn-primary {
            font-size: 1rem; /* Slightly smaller on mobile */
            padding: 12px;
        }

        .btn-primary {
            padding: 12px 20px;
        }
    }

    </style>
</head>
<body>
<div class="container login-container fade-in">
    <div class="row">
        <!-- Left Section (Description and Features) -->
        <div class="col-md-6 left-section">
            <div class="logo">Smart POS System</div>
            <h2>Energized your Business!</h2>
            <p>Sign in and start managing your account</p>
        </div>

        <!-- Right Section (Login Form) -->
        <div class="col-md-6 d-flex justify-content-center align-items-center">
            <div class="login-card">
                <h3 class="mb-4">Sign in</h3>
                <g:if test="${flash.message}">
                    <div class="alert alert-danger">${flash.message}</div>
                </g:if>
                <form action="${createLink(controller: 'auth', action: 'login')}" method="post">
                    <div class="mb-4">
                        <label for="username" class="form-label">Username</label>
                        <input type="text" name="username" class="form-control" placeholder="Username" required>
                    </div>
                    <div class="mb-4 position-relative">
                        <label for="password" class="form-label">Password</label>
                        <input type="password" name="password" class="form-control" placeholder="Password" required>
                        <span class="password-toggle" id="togglePassword">
                            <i class="bi bi-eye-slash"></i>
                        </span>
                    </div>
                    <div class="mb-4 form-check">
                        <input type="checkbox" class="form-check-input" id="rememberMe" name="rememberMe">
                        <label class="form-check-label" for="rememberMe">Remember me</label>
                        
                    </div>
                    <button type="submit" class="btn btn-primary">SIGN IN</button>
                </form>
                <p class="mt-3">No account? <a href="${createLink(controller: 'storeOwner', action: 'register')}" class="signup-link">Sign up!</a></p>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS and Popper.js -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
<!-- JavaScript for password toggle -->
<script>
    document.getElementById('togglePassword').addEventListener('click', function() {
        const passwordInput = document.querySelector('input[name="password"]');
        const icon = this.querySelector('i');
        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            icon.classList.remove('bi-eye-slash');
            icon.classList.add('bi-eye');
        } else {
            passwordInput.type = 'password';
            icon.classList.remove('bi-eye');
            icon.classList.add('bi-eye-slash');
        }
    });
</script>
</body>
</html>