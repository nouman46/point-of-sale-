<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Edit Store Owner</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-4" style="max-width: 2000px;">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h3 class="mb-0">Edit Store Owner</h3>
                    </div>
                    <div class="card-body">
                        <g:if test="${flash.message}">
                            <div class="alert alert-info" role="status">${flash.message}</div>
                        </g:if>

                        <g:hasErrors bean="${storeOwner}">
                            <div class="alert alert-danger">
                                <ul class="list-unstyled mb-0">
                                    <g:eachError bean="${storeOwner}" var="error">
                                        <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>>
                                            <g:message error="${error}"/>
                                        </li>
                                    </g:eachError>
                                </ul>
                            </div>
                        </g:hasErrors>

                        <g:form resource="${storeOwner}" method="PUT" enctype="multipart/form-data">
                            <g:hiddenField name="id" value="${storeOwner?.id}"/>

                            <!-- Username Field -->
                            <div class="form-group mb-3">
                                <label for="username" class="form-label">Username <span class="text-danger">*</span></label>
                                <g:textField name="username" value="${storeOwner?.username}" class="form-control" required="true"/>
                            </div>

                            <!-- Password Field -->
                            <div class="form-group mb-3">
                                <label for="password" class="form-label">Password <span class="text-danger">*</span></label>
                                <g:passwordField name="password" value="" class="form-control" required="true"/>
                            </div>

                            <!-- Email Field -->
                            <div class="form-group mb-3">
                                <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                                <g:textField name="email" value="${storeOwner?.email}" class="form-control" required="true"/>
                            </div>

                            <!-- Store Name Field -->
                            <div class="form-group mb-3">
                                <label for="storeName" class="form-label">Store Name <span class="text-danger">*</span></label>
                                <g:textField name="storeName" value="${storeOwner?.storeName}" class="form-control" required="true"/>
                            </div>

                            <!-- Sync with AppUser Field -->
                            <div class="form-group mb-3">
                                <div class="form-check">
                                    <g:checkBox name="syncWithAppUser" value="${false}" class="form-check-input"/>
                                    <label for="syncWithAppUser" class="form-check-label">
                                        Sync Username/Password with AppUser
                                    </label>
                                </div>
                            </div>

                            <!-- Buttons -->
                            <div class="d-flex justify-content-between mt-4">
                                <g:link action="index" id="${storeOwner?.id}" class="btn btn-secondary">Cancel</g:link>
                                <g:actionSubmit class="btn btn-primary" action="updateStoreOwner" value="Update"/>
                            </div>
                        </g:form>

                        <!-- Logo Upload Form -->
                        <hr class="my-4"/>
                        <h4>Update Logo</h4>
                        <g:form controller="setting" action="updateLogo" method="POST" enctype="multipart/form-data">
                            <g:hiddenField name="id" value="${storeOwner?.id}"/>
                            <div class="form-group mb-3">
                                <g:if test="${storeOwner?.logo}">
                                    <g:set var="base64Logo" value="${storeOwner.logo.encodeBase64().toString()}"/>
                                    <img src="data:${storeOwner.logoContentType ?: 'image/png'};base64,${base64Logo}"
                                         alt="Store Logo" class="img-thumbnail mb-3" style="max-width: 200px;"/>
                                </g:if>
                                <input type="file" name="logo" class="form-control"/>
                                <small class="form-text text-muted">Upload a new logo to replace the current one. Max size: 5MB.</small>
                            </div>

                            <div class="d-flex justify-content-end mt-4">
                                <g:actionSubmit class="btn btn-primary" action="updateLogo" value="Update Logo"/>
                            </div>
                        </g:form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>