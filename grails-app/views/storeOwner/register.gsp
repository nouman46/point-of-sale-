<!-- grails-app/views/storeOwner/register.gsp -->
<!DOCTYPE html>
<html>
<head>
    <title>Store Owner Registration</title>
    <asset:stylesheet src="application.css"/>
</head>
<body>
    <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header bg-primary text-white text-center">
                            <h4>Register Your Store</h4>
                        </div>
                        <div class="card-body">
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
                                    <label for="username" class="form-label">Username</label>
                                    <g:textField name="username" value="${storeOwner?.username}" class="form-control" />
                                </div>
                                <div class="mb-3">
                                    <label for="password" class="form-label">Password</label>
                                    <g:passwordField name="password" class="form-control" />
                                    <div class="invalid-feedback">
                                        Please provide a password.
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <g:field type="email" name="email" value="${storeOwner?.email}" class="form-control" />
                                    <div class="invalid-feedback">
                                        Please provide a valid email.
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="storeName" class="form-label">Store Name</label>
                                    <g:textField name="storeName" value="${storeOwner?.storeName}" class="form-control" />
                                    <div class="invalid-feedback">
                                        Please provide a store name.
                                    </div>
                                </div>
                                <div class="d-grid gap-2">
                                    <g:submitButton name="register" class="btn btn-primary btn-lg" value="Register" />
                                </div>
                            </g:form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
</body>
</html>