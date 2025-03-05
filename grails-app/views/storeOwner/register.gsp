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
                            <g:if test="${errors}">
                                <div class="alert alert-danger">
                                    ${errors.allErrors.collect { message(error: it) }.join('<br>')}
                                </div>
                            </g:if>
                            <g:uploadForm controller="storeOwner" action="register" method="POST">
                                <div class="mb-3">
                                    <label for="username" class="form-label">Username</label>
                                    <g:textField name="username" value="${cmd?.username}" class="form-control ${hasErrors(bean: cmd, field: 'username', 'is-invalid') ? 'is-invalid' : ''}"/>
                                    <div class="invalid-feedback">
                                        <g:fieldError bean="${cmd}" field="username" />
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="password" class="form-label">Password</label>
                                    <g:passwordField name="password" class="form-control ${hasErrors(bean: cmd, field: 'password', 'is-invalid') ? 'is-invalid' : ''}"/>
                                    <div class="invalid-feedback">
                                        <g:fieldError bean="${cmd}" field="password" />
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <g:field type="email" name="email" value="${cmd?.email}" class="form-control ${hasErrors(bean: cmd, field: 'email', 'is-invalid') ? 'is-invalid' : ''}"/>
                                    <div class="invalid-feedback">
                                        <g:fieldError bean="${cmd}" field="email" />
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="storeName" class="form-label">Store Name</label>
                                    <g:textField name="storeName" value="${cmd?.storeName}" class="form-control ${hasErrors(bean: cmd, field: 'storeName', 'is-invalid') ? 'is-invalid' : ''}" />
                                    <div class="invalid-feedback">
                                        <g:fieldError bean="${cmd}" field="storeName" />
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="logo" class="form-label">Store Logo (max 5MB)</label>
                                    <input type="file" name="logo" class="form-control" />
                                </div>
                                <div class="mb-3" style="display: none;">
                                    <label for="subscriptionPlanId" class="form-label">Select Subscription Plan</label>
                                    <$--
                                    <select name="subscriptionPlanId" class="form-control">
                                      <g:each in="${subscriptionPlans}" var="plan">
                                        <option value="${plan.id}" ${cmd?.subscriptionPlanId?.toString() == plan.id.toString() ? 'selected' : ''}>${plan.name}</option>
                                      </g:each>
                                    </select>
                                    --$>
                                    <g:select name="subscriptionPlanId" from="${subscriptionPlans}" optionKey="id" optionValue="name" value="${cmd?.subscriptionPlanId}" class="form-control"/>
                                </div>
                                <div class="mb-3" style="display: none;">
                                    <label for="subscriptionPlanId" class="form-label">Select Subscription Plan</label>
                                    <g:select name="subscriptionPlanId" from="${subscriptionPlans}" optionKey="id" optionValue="name" value="${cmd?.subscriptionPlanId}" class="form-control"/>
                                </div>
                                <div class="d-grid gap-2">
                                    <g:submitButton name="register" class="btn btn-primary btn-lg" value="Register" />
                                </div>
                            </g:uploadForm>
                        </div>
                    </div>
                </div>
            </div>
        </div>
</body>
</html>