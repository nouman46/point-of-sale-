<!DOCTYPE html>
<html>
<head>
  <title>Login</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
  <h2>Login</h2>
  <g:if test="${flash.message}">
    <div class="alert alert-danger">${flash.message}</div>
  </g:if>
  <form action="${createLink(controller: 'auth', action: 'login')}" method="post">
    <div class="mb-3">
      <label class="form-label">Username:</label>
      <input type="text" name="username" class="form-control" required>
    </div>
    <div class="mb-3">
      <label class="form-label">Password:</label>
      <input type="password" name="password" class="form-control" required>
    </div>
    <button type="submit" class="btn btn-primary">Login</button>
  </form>
</div>
</body>
</html>
