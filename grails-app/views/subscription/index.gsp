<!DOCTYPE html>
<html>
<head>
<meta name="layout" content="main" />
</head>
<body>
    <h1>Available Plans</h1>
    <g:if test="${currentSubscription}">
        <p>Current Plan: ${currentSubscription.plan.name} (Expires: <g:formatDate date="${currentSubscription.endDate}"/>)</p>
    </g:if>
    <div class="plans">
        <g:each in="${plans}" var="plan">
            <div class="plan">
                <h3>${plan.name} - $${plan.price}/month</h3>
                <p>${plan.description}</p>
                <ul>
                    <g:each in="${plan.features}" var="feature">
                        <li>${feature}</li>
                    </g:each>
                </ul>
                <g:link action="subscribe" params="[planId: plan.id]" class="btn btn-primary">
                    Subscribe
                </g:link>
            </div>
        </g:each>
    </div>
</body>
</html>