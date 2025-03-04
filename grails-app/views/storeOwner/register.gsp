<!DOCTYPE html>
<html>
<head>
    <title>Store Owner Registration</title>
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

    .signup-container {
        max-width: 1200px;
        margin: 50px auto;
        padding: 20px;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
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
    .form-control:focus {
        border-color: #007bff; /* Blue border on focus */
        box-shadow: 0 0 8px rgba(0, 123, 255, 0.3); /* Subtle blue glow on focus */

    }

    .form-control {
        border-radius: 5px;
        border: 1px solid #ced4da;
    }

    .btn-primary {
        background-color: #28a745;
        border-color: #28a745;
        font-weight: bold;
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

    /* Responsive adjustments */
    @media (max-width: 768px) {
        .signup-container {
            margin: 20px;
        }

        .row {
            flex-direction: column;
        }

        .left-section, .right-section {
            border-radius: 10px;
            padding: 20px;
        }
    }
    </style>
</head>
<body>
<div class="container signup-container fade-in">
    <div class="row">
        <!-- Left Section (Description and Features) -->
        <div class="col-md-6 left-section">
            <div class="logo">Smart POS System</div>
            <h2>All what you need to manage your business in one software!</h2>
            <p>Enerpize covers more than 50 different industries. From Invoicing, Sales, Finance, Accounting, and Inventory to managing Clients, your Services and Products, to assigning and tracking tasks and projects to your team, managing Human Resources, Attendance and Payroll.</p>
            <p>All customized according to your industry!</p>
            <div class="mt-4">
                <div class="d-flex align-items-center mb-2"><i class="bi bi-lightning feature-icon"></i> Sales</div>
                <div class="d-flex align-items-center mb-2"><i class="bi bi-lightning feature-icon"></i> Accounting</div>
                <div class="d-flex align-items-center mb-2"><i class="bi bi-lightning feature-icon"></i> Operations</div>
                <div class="d-flex align-items-center mb-2"><i class="bi bi-lightning feature-icon"></i> Inventory</div>

            </div>
        </div>

        <!-- Right Section (Signup Form) -->
        <div class="col-md-6 right-section">
            <h3 class="mb-4">Sign up</h3>
            <g:if test="${flash.message}">
                <div class="alert alert-info" role="alert">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${storeOwner}">
                <div class="alert alert-danger">
                    <ul>
                        <g:eachError bean="${storeOwner}" var="error">
                            <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
                        </g:eachError>
                    </ul>
                </div>
            </g:hasErrors>
            <g:form controller="storeOwner" action="register" method="POST">
                <div class="mb-3">
                    <label for="username" class="form-label">Username *</label>
                    <g:textField name="username" value="${storeOwner?.username}" class="form-control" placeholder="Username"  required="required" />
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password *</label>
                    <g:passwordField name="password" class="form-control" placeholder="Password"  required="required" />
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Email *</label>
                    <g:field type="email" name="email" value="${storeOwner?.email}" class="form-control" placeholder="Email"  required="required" />
                </div>
                <div class="mb-3">
                    <label for="storeName" class="form-label">Store Name *</label>
                    <g:textField name="storeName" value="${storeOwner?.storeName}" class="form-control" placeholder="Store Name" required="required" />
                </div>
                <div class="mb-3">
                    <label for="subscriptionPlanId" class="form-label">Select Subscription Plan *</label>
                    <select name="subscriptionPlanId" class="form-control" required>
                        <g:each in="${subscriptionPlans}" var="plan">
                            <option value="${plan.id}">${plan.name}</option>
                        </g:each>
                    </select>
                </div>
                <div class="mb-3 form-check">
                    <input type="checkbox" class="form-check-input" id="terms" name="terms" required>
                    <label class="form-check-label" for="terms">By signing up, you agree to Terms & Conditions and Privacy Policy of Enerpize</label>
                </div>
                <div class="d-grid gap-2">
                    <g:submitButton name="register" class="btn btn-primary btn-lg" value="GET STARTED FOR FREE" />
                </div>
            </g:form>
            <p class="mt-3 text-muted text-center"><a href="${createLink(controller: 'auth', action: 'login')}">Already have an account? Login</a></p>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS and Popper.js -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
</body>
</html>