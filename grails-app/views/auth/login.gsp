<!DOCTYPE html>
<html>
<head>
  <title>Login</title>
  <asset:stylesheet src="application.css"/>
  <style>
  body {
    background: linear-gradient(135deg, #1e1e2d, #323247);
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    margin: 0;
    font-family: "Poppins", sans-serif;
  }

  .login-card {
    background: rgba(255, 255, 255, 0.1);
    border-radius: 15px;
    padding: 30px;
    width: 350px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.2);
    text-align: center;
    animation: fadeIn 1s ease-in-out;
  }

  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(-20px); }
    to { opacity: 1; transform: translateY(0); }
  }

  .login-card h2 {
    color: white;
    margin-bottom: 20px;
  }

  .form-control {
    background: transparent;
    color: white;
    border: 1px solid rgba(255, 255, 255, 0.3);
    transition: 0.3s;
  }

  .form-control::placeholder {
    color: rgba(255, 255, 255, 0.6);
  }

  .form-control:focus {
    border-color: #ffcc00;
    box-shadow: 0 0 10px #ffcc00;
  }

  .btn-login {
    width: 100%;
    background: #ffcc00;
    border: none;
    padding: 10px;
    border-radius: 5px;
    color: #1e1e2d;
    font-weight: bold;
    cursor: pointer;
    transition: 0.3s;
    text-decoration: none;
  }

  .btn-login:hover {
    background: #ffd633;
    transform: scale(1.05);
  }

  .alert {
    animation: fadeIn 0.5s;
  }
  </style>
</head>
<body>
<div class="login-card">
  <h2>Login</h2>

  <g:if test="${flash.message}">
    <div class="alert alert-danger">${flash.message}</div>
  </g:if>

<!-- ✅ FIXED FORM ACTION (Now pointing to 'authenticate') -->
  <form action="${createLink(controller: 'auth', action: 'login')}" method="post">
    <div class="mb-3">
      <input type="text" name="username" class="form-control" placeholder="Username" required>
    </div>
    <div class="mb-3">
      <input type="password" name="password" class="form-control" placeholder="Password" required>
    </div>
    <button type="submit" class="btn-login">Login</button>
  </form>
  <div class="mt-3" >
    <a href="${createLink(controller: 'storeOwner', action: 'register')}"><button class="btn-login">Register</button></a></button>
  </div>
</div>
</body>
</html>
