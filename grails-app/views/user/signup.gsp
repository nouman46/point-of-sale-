<%--
  Created by IntelliJ IDEA.
  User: zeeshan
  Date: 2/6/25
  Time: 11:23 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Signup</title>
</head>

<body>
<g:form controller="user" action="register">
    <input type="text" name="username" />
    <input type="password" name="password" />
    <input type="email" name="email" />
    <g:submitButton name="Sign Up" value="Sign Up"/>
</g:form>
</body>
</html>