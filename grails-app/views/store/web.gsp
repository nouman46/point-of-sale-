<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>POS System - Your All-in-One Business Solution</title>
  <!-- Bootstrap CSS -->
  <asset:stylesheet src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <!-- Animate.css -->
  <asset:stylesheet src="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
  <!-- Font Awesome -->
  <asset:stylesheet src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"/>
  <!-- Custom CSS -->
  <style>
  :root {
    --primary-color: #2c3e50;
    --secondary-color: #3498db;
    --accent-color: #e74c3c;
    --light-bg: #f8f9fa;
  }
  /* Same CSS as before, copied here */
  body { font-family: 'Arial', sans-serif; line-height: 1.6; color: #333; background: var(--light-bg); }
  .hero { background: linear-gradient(135deg, var(--primary-color), var(--secondary-color)); color: white; padding: 100px 0; text-align: center; }
  .hero h1 { font-size: 3.5rem; font-weight: bold; }
  .hero p { font-size: 1.25rem; margin-bottom: 30px; }
  .btn-cta { background: var(--accent-color); border: none; padding: 12px 30px; font-size: 1.1rem; transition: transform 0.3s ease; }
  .btn-cta:hover { transform: scale(1.05); background: #c0392b; }
  section { padding: 80px 0; }
  section h2 { font-size: 2.5rem; font-weight: bold; margin-bottom: 40px; text-align: center; }
  .feature-card { background: white; padding: 20px; border-radius: 10px; text-align: center; transition: transform 0.3s ease; }
  .feature-card i { font-size: 2.5rem; color: var(--secondary-color); margin-bottom: 15px; }
  .feature-card:hover { transform: translateY(-10px); box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1); }
  .role-card { background: var(--primary-color); color: white; padding: 20px; border-radius: 10px; text-align: center; transition: transform 0.3s ease; }
  .role-card:hover { transform: scale(1.1); }
  .demo-section { background: var(--light-bg); text-align: center; }
  .demo-section .btn-demo { background: var(--secondary-color); border: none; padding: 12px 30px; font-size: 1.1rem; transition: transform 0.3s ease; }
  .demo-section .btn-demo:hover { transform: scale(1.05); background: #2980b9; }
  .plan-card { background: white; padding: 30px; border-radius: 10px; text-align: left; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05); }
  .plan-card.ultimate { border: 3px solid var(--secondary-color); }
  .plan-card ul { list-style: none; padding-left: 0; }
  .plan-card ul li { margin-bottom: 10px; position: relative; padding-left: 25px; }
  .plan-card ul li:before { content: "✔"; position: absolute; left: 0; color: var(--secondary-color); font-weight: bold; }
  footer { background: var(--primary-color); color: white; padding: 20px 0; text-align: center; }
  @media (max-width: 768px) {
    .hero h1 { font-size: 2.5rem; }
    .hero p { font-size: 1rem; }
    section h2 { font-size: 2rem; }
  }
  </style>
</head>
<body>
<!-- Hero Section -->
<header class="hero animate__animated animate__fadeIn">
  <div class="container">
    <h1>Next-Gen POS System</h1>
    <p>Manage your business seamlessly with our all-in-one solution.</p>
    <a href="#signup" class="btn btn-cta text-white">Start 14-Day Free Trial</a>
  </div>
</header>

<!-- Features Section -->
<section id="features" class="bg-white">
  <div class="container">
    <h2 class="animate__animated animate__fadeInUp">Powerful Features</h2>
    <div class="row g-4">
      <div class="col-md-3 animate__animated animate__fadeInUp" data-animate-delay="0.1s">
        <div class="feature-card">
          <i class="fas fa-box"></i>
          <h3>Inventory</h3>
          <p>Real-time stock management made simple.</p>
        </div>
      </div>
      <div class="col-md-3 animate__animated animate__fadeInUp" data-animate-delay="0.2s">
        <div class="feature-card">
          <i class="fas fa-chart-line"></i>
          <h3>Sales</h3>
          <p>Track and optimize your sales effortlessly.</p>
        </div>
      </div>
      <div class="col-md-3 animate__animated animate__fadeInUp" data-animate-delay="0.3s">
        <div class="feature-card">
          <i class="fas fa-shopping-cart"></i>
          <h3>Checkout</h3>
          <p>Fast and secure transactions for your customers.</p>
        </div>
      </div>
      <div class="col-md-3 animate__animated animate__fadeInUp" data-animate-delay="0.4s">
        <div class="feature-card">
          <i class="fas fa-tachometer-alt"></i>
          <h3>Dashboard</h3>
          <p>Insightful graphs and real-time analytics.</p>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- Roles Section -->
<section id="roles" class="bg-light">
  <div class="container">
    <h2 class="animate__animated animate__fadeInUp">Role-Based Management</h2>
    <p class="text-center mb-4 animate__animated animate__fadeInUp" data-animate-delay="0.1s">
      Tailored access for every team member.
    </p>
    <div class="row g-4">
      <div class="col-md-3 animate__animated animate__zoomIn" data-animate-delay="0.1s">
        <div class="role-card">Salesperson</div>
      </div>
      <div class="col-md-3 animate__animated animate__zoomIn" data-animate-delay="0.2s">
        <div class="role-card">Cashier</div>
      </div>
      <div class="col-md-3 animate__animated animate__zoomIn" data-animate-delay="0.3s">
        <div class="role-card">Manager</div>
      </div>
      <div class="col-md-3 animate__animated animate__zoomIn" data-animate-delay="0.4s">
        <div class="role-card">Admin</div>
      </div>
    </div>
  </div>
</section>

<!-- Demo Section -->
<section id="demo" class="demo-section">
  <div class="container">
    <h2 class="animate__animated animate__fadeInUp">Try Our Demo</h2>
    <p class="text-center mb-4 animate__animated animate__fadeInUp" data-animate-delay="0.1s">
      Experience our POS system in action—test it now!
    </p>
    <a href="https://your-pos-demo.com" target="_blank" class="btn btn-demo text-white">Launch Demo</a>
  </div>
</section>

<!-- Subscription Section -->
<section id="signup" class="bg-white">
  <div class="container">
    <h2 class="animate__animated animate__fadeInUp">Subscription Plans</h2>
    <div class="row g-4">
      <div class="col-md-6 animate__animated animate__fadeInLeft" data-animate-delay="0.1s">
        <div class="plan-card">
          <h3>14-Day Free Trial</h3>
          <p>Test all core features—no credit card required.</p>
          <a href="#" class="btn btn-cta text-white">Start Free Trial</a>
        </div>
      </div>
      <div class="col-md-6 animate__animated animate__fadeInRight" data-animate-delay="0.2s">
        <div class="plan-card ultimate">
          <h3>Ultimate Package</h3>
          <p>Unlock premium features:</p>
          <ul>
            <li>Theme Color Customization</li>
            <li>AI-Powered Data Analysis</li>
          </ul>
          <a href="#" class="btn btn-cta text-white">Subscribe Now</a>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- Footer -->
<footer>
  <div class="container">
    <p>© 2025 POS System. All rights reserved.</p>
  </div>
</footer>

<!-- Bootstrap JS -->
<asset:javascript src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"/>
<!-- Custom JS for Animation Triggers -->
<script>
  const animateOnScroll = (entries, observer) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('animate__animated');
        const animation = entry.target.getAttribute('data-animate') || 'fadeInUp';
        entry.target.classList.add(`animate__${animation}`);
        observer.unobserve(entry.target);
      }
    });
  };

  const observer = new IntersectionObserver(animateOnScroll, { threshold: 0.1 });
  document.querySelectorAll('[data-animate]').forEach(element => observer.observe(element));
</script>
</body>
</html>