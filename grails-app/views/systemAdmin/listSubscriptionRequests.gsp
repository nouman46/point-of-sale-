<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Manage Subscription Requests</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-4">
        <h2>Pending Subscription Requests</h2>
        <g:if test="${flash.message}">
            <div class="alert alert-info">${flash.message}</div>
        </g:if>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>User</th>
                    <th>Plan</th>
                    <th>Request Date</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <g:each in="${pendingRequests}" var="request">
                    <tr>
                        <td>${request.user.username}</td>
                        <td>${request.plan.name}</td>
                        <g:formatDate date="${request.requestDate}" format="yyyy-MM-dd" />
                        <td>
                            <g:form action="approveSubscriptionRequest" method="POST">
                                <g:hiddenField name="id" value="${request.id}"/>
                                <g:submitButton name="approve" value="Approve" class="btn btn-success btn-sm"/>
                            </g:form>
                            <g:form action="rejectSubscriptionRequest" method="POST">
                                <g:hiddenField name="id" value="${request.id}"/>
                                <g:submitButton name="reject" value="Reject" class="btn btn-danger btn-sm"/>
                            </g:form>
                        </td>
                    </tr>
                </g:each>
            </tbody>
        </table>
    </div>
</body>
</html>