<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Smart POS - The Ultimate Business Solution</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
  <!-- FontAwesome Icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <!-- Animate.css for animations -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">

  <style>
  body { font-family: 'Arial', sans-serif; }
  .hero-section { background: linear-gradient(135deg, #007bff, #6610f2); color: white; padding: 80px 0; text-align: center; }
  .icon-box { text-align: center; padding: 20px; }
  .icon-box i { font-size: 40px; color: #007bff; }
  .pricing-card { border-radius: 15px; box-shadow: 0px 4px 10px rgba(0,0,0,0.1); transition: transform 0.3s; }
  .pricing-card:hover { transform: scale(1.05); }
  .role-card {
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    border-radius: 15px;
    background: #fff;
    overflow: hidden;
  }

  .role-card:hover {
    transform: scale(1.05);
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15) !important;
  }

  .role-features {
    margin-bottom: 20px;
  }

  .role-features li {
    margin-bottom: 12px;
    font-size: 1rem;
  }

  .role-card i {
    transition: transform 0.3s ease;
  }

  .role-card:hover i {
    transform: scale(1.2);
  }

  .text-primary { color: #0d6efd !important; }
  .text-success { color: #198754 !important; }
  .text-info { color: #0dcaf0 !important; }
  .text-warning { color: #ffc107 !important; }

  @media (max-width: 768px) {
    .role-card {
      margin-bottom: 20px;
    }
  }
  .features-slider-wrapper {
    overflow: hidden;
    position: relative;
    width: 100%;
    max-height: 450px; /* Adjust height as needed */
  }

  .features-slider {
    display: flex;
    align-items: center;
    animation: slide 60s linear infinite; /* Slow scrolling: 60s duration */
    white-space: nowrap;
  }

  .feature-card {
    display: inline-block;
    width: 300px; /* Fixed width for consistency */
    margin-right: 20px; /* Space between cards */
    flex-shrink: 0;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    border-radius: 15px;
    background: #fff;
    overflow: hidden;
  }

  .feature-card:hover {
    transform: scale(1.05);
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15) !important;
  }

  .feature-benefits {
    margin-bottom: 0; /* Remove extra margin since no button */
  }

  .feature-benefits li {
    margin-bottom: 10px;
    font-size: 0.95rem;
  }

  .feature-card i {
    transition: transform 0.3s ease;
  }

  .feature-card:hover i {
    transform: scale(1.2);
  }

  /* Custom Colors */
  .text-primary { color: #0d6efd !important; }
  .text-success { color: #198754 !important; }
  .text-warning { color: #ffc107 !important; }
  .text-info { color: #0dcaf0 !important; }
  .text-purple { color: #6f42c1 !important; }
  .text-teal { color: #20c997 !important; }
  .text-danger { color: #dc3545 !important; }
  .text-secondary { color: #6c757d !important; }
  .text-indigo { color: #6610f2 !important; }
  .text-orange { color: #fd7e14 !important; }
  .text-pink { color: #d63384 !important; }
  .text-green { color: #28a745 !important; }

  /* Slider Animation */
  @keyframes slide {
    0% { transform: translateX(0); }
    100% { transform: translateX(-50%); } /* Halfway since we duplicated content */
  }

  @media (max-width: 768px) {
    .feature-card {
      width: 250px; /* Smaller cards on mobile */
    }
    .features-slider-wrapper {
      max-height: 400px;
    }
  }

  #header { background: #f8f9fa; position: fixed; top: 0; width: 100%; z-index: 1000; }
  .navbar-brand img { width: 40px; height: 40px; margin-right: 10px; filter: brightness(0) saturate(100%) invert(34%) sepia(94%) saturate(2000%) hue-rotate(180deg) brightness(103%) contrast(101%); }
  .navbar-brand { font-weight: bold; color: #2c3e50; font-size: 1.5rem; }
  .nav-link { font-weight: 500; color: #2c3e50; transition: color 0.3s ease; }
  .nav-link:hover { color: #0d6efd; }
  .btn-outline-primary, .btn-success { border-radius: 20px; padding: 8px 20px; font-weight: bold; transition: transform 0.3s ease, box-shadow 0.3s ease; }
  .btn-outline-primary:hover { transform: scale(1.05); box-shadow: 0 5px 15px rgba(13, 110, 253, 0.4); }
  .btn-success:hover { transform: scale(1.05); box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4); }
  /* Retail Inventory Section CSS */
  /* Retail Inventory Section CSS */
  #retail-inventory {
    background: linear-gradient(135deg, #f5f7fa, #ffffff);
    border-radius: 20px;
    padding: 100px 20px;
    box-shadow: 0 15px 40px rgba(0, 0, 0, 0.05);
    margin-top: 80px;
    min-height: 600px;
    display: flex;
    align-items: center;
  }

  #retail-inventory .text-primary {
    color: #1a2b49 !important; /* Dark blue for heading, matching the image */
  }

  #retail-inventory .lead {
    font-size: 1.5rem;
    line-height: 1.6;
    color: #4a5a78; /* Muted blue-gray for text */
  }

  #retail-inventory .btn-success {
    background: #28a745; /* Green button, matching the image */
    border: none;
    border-radius: 30px;
    padding: 15px 40px;
    font-size: 1.25rem;
    transition: all 0.3s ease;
  }

  #retail-inventory .btn-success:hover {
    background: #218838; /* Darker green on hover */
    transform: translateY(-3px);
    box-shadow: 0 8px 20px rgba(40, 167, 69, 0.3);
  }

  .retail-image {
    max-width: 100%;
    height: auto;
    object-fit: contain;
  }

  .min-vh-75 {
    min-height: 75vh;
  }

  /* Responsive Adjustments */
  @media (max-width: 992px) {
    #retail-inventory {
      padding: 60px 15px;
      min-height: 500px;
    }

    #retail-inventory h2 {
      font-size: 2.5rem;
    }

    #retail-inventory .lead {
      font-size: 1.2rem;
    }

    #retail-inventory .btn-success {
      padding: 12px 30px;
      font-size: 1rem;
    }

    #retail-inventory .retail-image {
      margin-top: 20px;
    }
  }

  @media (max-width: 768px) {
    #retail-inventory .col-lg-6 {
      flex: 0 0 100%;
      max-width: 100%;
    }

    #retail-inventory .text-lg-start {
      text-align: center !important;
    }
  }
  .module-card {
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    border-radius: 15px;
    background: #fff;
    overflow: hidden;
  }

  .module-card:hover {
    transform: translateY(-10px);
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15) !important;
  }

  .module-benefits {
    margin-bottom: 20px;
  }

  .module-benefits li {
    margin-bottom: 12px;
    font-size: 0.95rem;
  }

  .module-card i {
    transition: transform 0.3s ease;
  }

  .module-card:hover i {
    transform: scale(1.2);
  }

  /* Custom Colors */
  .text-primary { color: #0d6efd !important; }
  .text-success { color: #198754 !important; }
  .text-warning { color: #ffc107 !important; }
  .text-info { color: #0dcaf0 !important; }
  .text-purple { color: #6f42c1 !important; }

  @media (max-width: 768px) {
    .module-card {
      margin-bottom: 20px;
    }
    .col-lg-2 {
      flex: 0 0 50%; /* Stack in 2 columns on medium screens */
      max-width: 50%;
    }
  }
  #header {
    background: #f8f9fa;
    position: fixed;
    top: 0;
    width: 100%;
    z-index: 1000;
    /* Ensure header height is consistent */
    padding: 15px 0;
  }
  /* Footer Styling */
  footer {
    background: #1a2b49; /* Matches your professional color scheme */
    color: #ffffff;
    font-size: 0.9rem;
  }

  footer h5 {
    color: #ffffff;
    font-size: 1.25rem;
  }

  footer .text-muted {
    color: #a1b0c8 !important; /* Light muted color for better contrast */
  }

  footer a {
    transition: color 0.3s ease;
  }

  footer a:hover {
    color: #0d6efd; /* Primary color on hover for links */
  }

  footer .social-icons i {
    font-size: 1.5rem;
    transition: transform 0.3s ease, color 0.3s ease;
  }

  footer .social-icons i:hover {
    transform: scale(1.2);
    color: #0d6efd;
  }

  footer .border-top {
    border-width: 1px !important;
  }

  @media (max-width: 768px) {
    footer .col-md-4 {
      flex: 0 0 100%;
      max-width: 100%;
      text-align: center;
    }

    footer .social-icons {
      margin-top: 1rem;
    }
  }
  /* Logo Text Styling */
  .logo-text {
    font-family: 'Arial Black', sans-serif; /* Bold, modern font; adjust as needed */
    font-size: 1.8rem; /* Adjust size for visibility */
    font-weight: bold;
    color: #333; /* Default text color (dark gray) */
    display: flex;
    align-items: center;
    position: relative;
    transition: transform 0.3s ease; /* Smooth hover effect */
  }

  .logo-text::before {
    content: '';
    position: absolute;
    top: -5px;
    left: -5px;
    width: 10px;
    height: 10px;
    background: #ff0000; /* Red corner (top-left) */
    border-radius: 2px;
  }

  .logo-text::after {
    content: '';
    position: absolute;
    bottom: -5px;
    right: -5px;
    width: 10px;
    height: 10px;
    background: #00ff00; /* Green corner (bottom-right) */
    border-radius: 2px;
  }

  .logo-text span {
    display: inline-block;
  }

  .logo-text span:nth-child(1) { /* "Smart" */
    color: #007bff; /* Blue for "Smart" */
  }

  .logo-text span:nth-child(2) { /* "POS" */
    color: #333; /* Dark gray for "POS" (matches your logo) */
    margin-left: 5px;
  }

  .logo-text span:nth-child(3) { /* "System" */
    color: #28a745; /* Green for "System" */
    margin-left: 5px;
  }

  /* Frame-like lines around the text */
  .logo-text::before,
  .logo-text::after {
    z-index: -1;
  }

  .logo-text::before {
    top: -8px;
    left: -8px;
    border-top: 2px solid #ff4500; /* Orange top line */
    border-left: 2px solid #ff0000; /* Red left line */
  }

  .logo-text::after {
    bottom: -8px;
    right: -8px;
    border-bottom: 2px solid #28a745; /* Green bottom line */
    border-right: 2px solid #007bff; /* Blue right line */
  }

  /* Hover effect for the entire logo text */
  .logo-text:hover {
    transform: scale(1.1);
  }

  /* Responsive Adjustments */
  @media (max-width: 768px) {
    .logo-text {
      font-size: 1.4rem; /* Smaller on mobile */
    }

    .logo-text::before,
    .logo-text::after {
      width: 8px;
      height: 8px;
    }
  }

  /* Ensure navbar-brand styling remains consistent */
  .navbar-brand {
    font-weight: bold;
    color: #2c3e50;
    font-size: 1.5rem;
    display: flex;
    align-items: center;
  }

  .navbar-brand:hover {
    color: #0d6efd;
    text-decoration: none;
  }

  /* Demo Section Styles */
  #demo {
    background: linear-gradient(135deg, #f5f7fa, #ffffff);
    border-radius: 20px;
    padding: 60px 20px;
    box-shadow: 0 15px 40px rgba(0, 0, 0, 0.05);
    margin-top: 80px;
    min-height: 100vh; /* Full viewport height */
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }
  /* Updated Demo Section Styles */
  #Demo {
    background: linear-gradient(135deg, #f5f7fa, #ffffff);
    border-radius: 20px;
    padding: 60px 20px;
    box-shadow: 0 15px 40px rgba(0, 0, 0, 0.05);
    margin-top: 80px;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }

  #Demo h2 {
    margin-bottom: 20px;
    font-size: 2.5rem;
    font-weight: bold;
    color: #0d6efd;
  }

  #Demo p {
    margin-bottom: 40px;
    font-size: 1.25rem;
    color: #6c757d;
    text-align: center;
    max-width: 800px;
  }

  #Demo .demo-container {
    border: 2px solid #0d6efd;
    border-radius: 15px;
    overflow: hidden;
    background: #fff;
    width: 90%;
    max-width: 1200px;
    height: 80vh;
    position: relative;
    transition: all 0.3s ease;
  }

  #Demo .demo-container iframe {
    width: 100%;
    height: 100%;
    border: none;
    display: none; /* Initially hidden */
  }

  #Demo .demo-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.7);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 10;
    transition: opacity 0.3s ease;
  }

  #Demo .demo-overlay button {
    background: #0d6efd;
    border: none;
    border-radius: 30px;
    padding: 15px 40px;
    font-size: 1.25rem;
    color: white;
    transition: all 0.3s ease;
  }

  #Demo .demo-overlay button:hover {
    background: #0056b3;
    transform: translateY(-3px);
    box-shadow: 0 8px 20px rgba(13, 110, 253, 0.3);
  }

  #Demo .demo-overlay button:disabled {
    background: #6c757d;
    cursor: not-allowed;
  }

  @media (max-width: 768px) {
    #Demo .demo-container {
      height: 60vh;
      width: 95%;
    }
    #Demo h2 {
      font-size: 2rem;
    }
    #Demo p {
      font-size: 1rem;
    }
    #Demo .demo-overlay button {
      padding: 12px 30px;
      font-size: 1rem;
    }
  }
  </style>
</head>
<body>

<!-- Header -->
<header class="navbar navbar-expand-lg navbar-light bg-light shadow-sm py-3" id="header">
  <div class="container">
    <a class="navbar-brand" href="#">
      <span class="logo-text">Smart POS System</span>
    </a>

    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav mx-auto">
        <li class="nav-item"><a class="nav-link text-dark" href="#modules">Modules</a></li>
        <li class="nav-item"><a class="nav-link text-dark" href="#features">Features</a></li>
        <li class="nav-item"><a class="nav-link text-dark" href="#pricing">Pricing</a></li>
        <li class="nav-item"><a class="nav-link text-dark" href="#Blog">Blog</a></li>

      </ul>
      <div class="d-flex">
        <a href="http://localhost:8080/auth/login" class="btn btn-outline-primary me-3 animate__animated animate__pulse animate__infinite">Sign In</a>
        <a href="http://localhost:8080/storeOwner/register" class="btn btn-success animate__animated animate__pulse animate__infinite">Get Started for Free</a>
      </div>
    </div>
  </div>
</header>

<!-- Retail Inventory Management Software Section -->
<div class="container mt-5 py-5" id="retail-inventory">
  <div class="row justify-content-center align-items-center min-vh-75">
    <div class="col-12 d-flex flex-column flex-lg-row align-items-center">
      <!-- Text Content (Left on Desktop, Full Width on Mobile) -->
      <div class="col-lg-6 text-lg-start text-center mb-4 mb-lg-0">
        <h2 class="fw-bold mb-4 display-4 text-primary">Smart POS System</h2>
        <p class="lead text-muted mb-5 fs-4">
          Our Smart POS software is tailored for your business to manage your merchandise,
          assign retailers, follow up with shoppers, and track revenue to stay on top of
          your retail business.
        </p>
        <a href="http://localhost:8080/storeOwner/register" class="btn btn-success btn-lg px-5 py-3 fw-bold animate__animated animate__pulse animate__infinite">Get Started for Free</a>
      </div>
      <!-- Image (Right on Desktop, Full Width on Mobile) -->
      <div class="col-lg-6 d-flex justify-content-center">
        <img src="https://www.enerpize.com/wp-content/uploads/2020/11/Retail-Hero.svg" alt="Retail Inventory Management Illustration" class="img-fluid retail-image">
      </div>
    </div>
  </div>
</div>


<!-- Modules Section -->
<div class="container mt-5 py-5" id="modules">
  <h2 class="text-center fw-bold mb-5 animate__animated animate__fadeIn">Powerful Modules for Your Business</h2>
  <p class="text-center text-muted mb-5 animate__animated animate__fadeIn" data-animate-delay="0.1s">
    Streamline every aspect of your operations with our comprehensive modules.
  </p>
  <div class="row g-4 justify-content-center text-center">
    <!-- Inventory Module -->
    <div class="col-md-4 col-lg-2 animate__animated animate__fadeInUp" data-animate-delay="0.1s">
      <div class="card module-card h-100 shadow-sm border-0">
        <div class="card-body p-4">
          <i class="fas fa-boxes fa-3x text-primary mb-3"></i>
          <h5 class="fw-bold text-primary">Inventory</h5>
          <p class="text-muted mb-3">Effortlessly manage your stock.</p>
          <ul class="list-unstyled module-benefits">
            <li><i class="fas fa-check-circle text-primary me-2"></i> Add Unlimited Products</li>

          </ul>
        </div>
      </div>
    </div>

    <!-- Sales Module -->
    <div class="col-md-4 col-lg-2 animate__animated animate__fadeInUp" data-animate-delay="0.2s">
      <div class="card module-card h-100 shadow-sm border-0">
        <div class="card-body p-4">
          <i class="fas fa-shopping-cart fa-3x text-success mb-3"></i>
          <h5 class="fw-bold text-success">Sales</h5>
          <p class="text-muted mb-3">Drive revenue with powerful sales tools.</p>
          <ul class="list-unstyled module-benefits">

            <li><i class="fas fa-check-circle text-success me-2"></i> Track Sales Performance</li>

          </ul>
        </div>
      </div>
    </div>

    <!-- Accounting Module -->
    <div class="col-md-4 col-lg-2 animate__animated animate__fadeInUp" data-animate-delay="0.3s">
      <div class="card module-card h-100 shadow-sm border-0">
        <div class="card-body p-4">
          <i class="fas fa-calculator fa-3x text-warning mb-3"></i>
          <h5 class="fw-bold text-warning">Accounting</h5>
          <p class="text-muted mb-3">Simplify your financial management.</p>
          <ul class="list-unstyled module-benefits">
            <li><i class="fas fa-check-circle text-warning me-2"></i> Manage Cash Flow</li>

          </ul>
        </div>
      </div>
    </div>

    <!-- Operations Module -->
    <div class="col-md-4 col-lg-2 animate__animated animate__fadeInUp" data-animate-delay="0.4s">
      <div class="card module-card h-100 shadow-sm border-0">
        <div class="card-body p-4">
          <i class="fas fa-cogs fa-3x text-info mb-3"></i>
          <h5 class="fw-bold text-info">Operations</h5>
          <p class="text-muted mb-3">Optimize daily business processes.</p>
          <ul class="list-unstyled module-benefits">
            <li><i class="fas fa-check-circle text-info me-2"></i> Workflow Automation</li>

          </ul>
        </div>
      </div>
    </div>

    <!-- Data Analysis Module -->
    <div class="col-md-4 col-lg-2 animate__animated animate__fadeInUp" data-animate-delay="0.5s">
      <div class="card module-card h-100 shadow-sm border-0">
        <div class="card-body p-4">
          <i class="fas fa-chart-pie fa-3x text-purple mb-3"></i>
          <h5 class="fw-bold text-purple">Data Analysis</h5>
          <p class="text-muted mb-3">Unlock actionable insights.</p>
          <ul class="list-unstyled module-benefits">

            <li><i class="fas fa-check-circle text-purple me-2"></i> Custom Reports</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Features Section -->
<div class="container mt-5 py-5" id="features">
  <h2 class="text-center fw-bold mb-5 animate__animated animate__fadeIn">Unmatched Features for Business Success</h2>
  <p class="text-center text-muted mb-5 animate__animated animate__fadeIn" data-animate-delay="0.1s">
    Elevate your operations with cutting-edge tools designed to scale and succeed.
  </p>
  <div class="features-slider-wrapper">
    <div class="features-slider">
      <!-- Inventory Management -->
      <div class="feature-card animate__animated animate__fadeInUp" data-animate-delay="0.1s">
        <div class="card h-100 shadow-sm border-0 text-center">
          <div class="card-body p-4">
            <i class="fas fa-boxes fa-3x text-primary mb-3"></i>
            <h5 class="fw-bold text-primary">Inventory Management</h5>
            <p class="text-muted mb-3">Master your stock with precision.</p>
            <ul class="list-unstyled feature-benefits">
              <li><i class="fas fa-check-circle text-primary me-2"></i> Real-Time Tracking</li>
              <li><i class="fas fa-check-circle text-primary me-2"></i> Automated Updates</li>
              <li><i class="fas fa-check-circle text-primary me-2"></i> Low Stock Alerts</li>
              <li><i class="fas fa-check-circle text-primary me-2"></i> Multi-Location Sync</li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Sales & Checkout -->
      <div class="feature-card animate__animated animate__fadeInUp" data-animate-delay="0.2s">
        <div class="card h-100 shadow-sm border-0 text-center">
          <div class="card-body p-4">
            <i class="fas fa-shopping-cart fa-3x text-success mb-3"></i>
            <h5 class="fw-bold text-success">Sales & Checkout</h5>
            <p class="text-muted mb-3">Effortless transactions, happy customers.</p>
            <ul class="list-unstyled feature-benefits">
              <li><i class="fas fa-check-circle text-success me-2"></i> Seamless Checkout</li>
              <li><i class="fas fa-check-circle text-success me-2"></i> Multi-Payment Options</li>
              <li><i class="fas fa-check-circle text-success me-2"></i> Discounts & Promos</li>
              <li><i class="fas fa-check-circle text-success me-2"></i> Offline Mode</li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Dashboard & Reports -->
      <div class="feature-card animate__animated animate__fadeInUp" data-animate-delay="0.3s">
        <div class="card h-100 shadow-sm border-0 text-center">
          <div class="card-body p-4">
            <i class="fas fa-chart-line fa-3x text-warning mb-3"></i>
            <h5 class="fw-bold text-warning">Dashboard & Reports</h5>
            <p class="text-muted mb-3">Insights that drive growth.</p>
            <ul class="list-unstyled feature-benefits">
              <li><i class="fas fa-check-circle text-warning me-2"></i> AI-Powered Analytics</li>
              <li><i class="fas fa-check-circle text-warning me-2"></i> Custom Dashboards</li>
              <li><i class="fas fa-check-circle text-warning me-2"></i> Sales Trends</li>
              <li><i class="fas fa-check-circle text-warning me-2"></i> Exportable Reports</li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Dynamic Role Management -->
      <div class="feature-card animate__animated animate__fadeInUp" data-animate-delay="0.4s">
        <div class="card h-100 shadow-sm border-0 text-center">
          <div class="card-body p-4">
            <i class="fas fa-users-cog fa-3x text-info mb-3"></i>
            <h5 class="fw-bold text-info">Dynamic Role Management</h5>
            <p class="text-muted mb-3">Tailor access for every team member.</p>
            <ul class="list-unstyled feature-benefits">
              <li><i class="fas fa-check-circle text-info me-2"></i> Custom Role Creation</li>
              <li><i class="fas fa-check-circle text-info me-2"></i> Granular Permissions</li>
              <li><i class="fas fa-check-circle text-info me-2"></i> Role-Based Dashboards</li>
              <li><i class="fas fa-check-circle text-info me-2"></i> Scalable Team Setup</li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Dynamic Pages Access -->
      <div class="feature-card animate__animated animate__fadeInUp" data-animate-delay="0.5s">
        <div class="card h-100 shadow-sm border-0 text-center">
          <div class="card-body p-4">
            <i class="fas fa-door-open fa-3x text-purple mb-3"></i>
            <h5 class="fw-bold text-purple">Dynamic Pages Access</h5>
            <p class="text-muted mb-3">Control what each user sees.</p>
            <ul class="list-unstyled feature-benefits">
              <li><i class="fas fa-check-circle text-purple me-2"></i> Page-Level Permissions</li>
              <li><i class="fas fa-check-circle text-purple me-2"></i> Custom Navigation</li>
              <li><i class="fas fa-check-circle text-purple me-2"></i> Role-Specific Views</li>
              <li><i class="fas fa-check-circle text-purple me-2"></i> Secure Access Control</li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Future Better Sales Predictions -->
      <div class="feature-card animate__animated animate__fadeInUp" data-animate-delay="0.6s">
        <div class="card h-100 shadow-sm border-0 text-center">
          <div class="card-body p-4">
            <i class="fas fa-eye fa-3x text-teal mb-3"></i>
            <h5 class="fw-bold text-teal">Sales Predictions</h5>
            <p class="text-muted mb-3">See the future of your sales.</p>
            <ul class="list-unstyled feature-benefits">
              <li><i class="fas fa-check-circle text-teal me-2"></i> AI-Driven Forecasts</li>
              <li><i class="fas fa-check-circle text-teal me-2"></i> Seasonal Trends</li>
              <li><i class="fas fa-check-circle text-teal me-2"></i> Demand Planning</li>
              <li><i class="fas fa-check-circle text-teal me-2"></i> Predictive Alerts</li>
            </ul>
          </div>
        </div>
      </div>

      <!-- AI Tools -->
      <div class="feature-card animate__animated animate__fadeInUp" data-animate-delay="0.7s">
        <div class="card h-100 shadow-sm border-0 text-center">
          <div class="card-body p-4">
            <i class="fas fa-robot fa-3x text-danger mb-3"></i>
            <h5 class="fw-bold text-danger">AI Tools</h5>
            <p class="text-muted mb-3">Smart solutions at your fingertips.</p>
            <ul class="list-unstyled feature-benefits">
              <li><i class="fas fa-check-circle text-danger me-2"></i> Customer Behavior Analysis</li>
              <li><i class="fas fa-check-circle text-danger me-2"></i> Auto-Optimized Pricing</li>
              <li><i class="fas fa-check-circle text-danger me-2"></i> Chatbot Support</li>
              <li><i class="fas fa-check-circle text-danger me-2"></i> AI Insights Dashboard</li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Printing Receipts -->
      <div class="feature-card animate__animated animate__fadeInUp" data-animate-delay="0.8s">
        <div class="card h-100 shadow-sm border-0 text-center">
          <div class="card-body p-4">
            <i class="fas fa-print fa-3x text-secondary mb-3"></i>
            <h5 class="fw-bold text-secondary">Printing Receipts</h5>
            <p class="text-muted mb-3">Professional receipts, instantly.</p>
            <ul class="list-unstyled feature-benefits">
              <li><i class="fas fa-check-circle text-secondary me-2"></i> Customizable Templates</li>
              <li><i class="fas fa-check-circle text-secondary me-2"></i> Fast Printing</li>
              <li><i class="fas fa-check-circle text-secondary me-2"></i> Digital Receipts Option</li>
              <li><i class="fas fa-check-circle text-secondary me-2"></i> Multi-Printer Support</li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Recorded Data Management -->
      <div class="feature-card animate__animated animate__fadeInUp" data-animate-delay="0.9s">
        <div class="card h-100 shadow-sm border-0 text-center">
          <div class="card-body p-4">
            <i class="fas fa-database fa-3x text-indigo mb-3"></i>
            <h5 class="fw-bold text-indigo">Data Management</h5>
            <p class="text-muted mb-3">Organized records, always accessible.</p>
            <ul class="list-unstyled feature-benefits">
              <li><i class="fas fa-check-circle text-indigo me-2"></i> Well-Structured Data</li>
              <li><i class="fas fa-check-circle text-indigo me-2"></i> Years of History</li>
              <li><i class="fas fa-check-circle text-indigo me-2"></i> Searchable Archives</li>
              <li><i class="fas fa-check-circle text-indigo me-2"></i> Secure Backups</li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Advanced Sales Monitoring -->
      <div class="feature-card animate__animated animate__fadeInUp" data-animate-delay="1.0s">
        <div class="card h-100 shadow-sm border-0 text-center">
          <div class="card-body p-4">
            <i class="fas fa-binoculars fa-3x text-orange mb-3"></i>
            <h5 class="fw-bold text-orange">Sales Monitoring</h5>
            <p class="text-muted mb-3">Keep a sharp eye on performance.</p>
            <ul class="list-unstyled feature-benefits">
              <li><i class="fas fa-check-circle text-orange me-2"></i> Live Sales Tracking</li>
              <li><i class="fas fa-check-circle text-orange me-2"></i> Employee Performance</li>
              <li><i class="fas fa-check-circle text-orange me-2"></i> Anomaly Detection</li>
              <li><i class="fas fa-check-circle text-orange me-2"></i> Custom Alerts</li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Customer Loyalty Program -->
      <div class="feature-card animate__animated animate__fadeInUp" data-animate-delay="1.1s">
        <div class="card h-100 shadow-sm border-0 text-center">
          <div class="card-body p-4">
            <i class="fas fa-gift fa-3x text-pink mb-3"></i>
            <h5 class="fw-bold text-pink">Loyalty Program</h5>
            <p class="text-muted mb-3">Reward and retain your customers.</p>
            <ul class="list-unstyled feature-benefits">
              <li><i class="fas fa-check-circle text-pink me-2"></i> Points System</li>
              <li><i class="fas fa-check-circle text-pink me-2"></i> Custom Rewards</li>
              <li><i class="fas fa-check-circle text-pink me-2"></i> Customer Profiles</li>
              <li><i class="fas fa-check-circle text-pink me-2"></i> Engagement Analytics</li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Multi-Platform Sync -->
      <div class="feature-card animate__animated animate__fadeInUp" data-animate-delay="1.2s">
        <div class="card h-100 shadow-sm border-0 text-center">
          <div class="card-body p-4">
            <i class="fas fa-sync fa-3x text-green mb-3"></i>
            <h5 class="fw-bold text-green">Multi-Platform Sync</h5>
            <p class="text-muted mb-3">Seamless across devices.</p>
            <ul class="list-unstyled feature-benefits">
              <li><i class="fas fa-check-circle text-green me-2"></i> Desktop & Mobile</li>
              <li><i class="fas fa-check-circle text-green me-2"></i> Cloud Sync</li>
              <li><i class="fas fa-check-circle text-green me-2"></i> Real-Time Updates</li>
              <li><i class="fas fa-check-circle text-green me-2"></i> Cross-Store Access</li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Duplicate the cards for seamless looping -->
      <div class="feature-card animate__animated animate__fadeInUp" data-animate-delay="0.1s">
        <div class="card h-100 shadow-sm border-0 text-center">
          <div class="card-body p-4">
            <i class="fas fa-boxes fa-3x text-primary mb-3"></i>
            <h5 class="fw-bold text-primary">Inventory Management</h5>
            <p class="text-muted mb-3">Master your stock with precision.</p>
            <ul class="list-unstyled feature-benefits">
              <li><i class="fas fa-check-circle text-primary me-2"></i> Real-Time Tracking</li>
              <li><i class="fas fa-check-circle text-primary me-2"></i> Automated Updates</li>
              <li><i class="fas fa-check-circle text-primary me-2"></i> Low Stock Alerts</li>
              <li><i class="fas fa-check-circle text-primary me-2"></i> Multi-Location Sync</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Role Management Section -->
<div class="container mt-5 py-5" id="roles">
  <h2 class="text-center fw-bold mb-5 animate__animated animate__fadeIn">Role-Based Access Control</h2>
  <p class="text-center text-muted mb-5 animate__animated animate__fadeIn" data-animate-delay="0.1s">
    Empower your team with tailored permissions for every role.
  </p>
  <div class="row g-4 justify-content-center text-center">
    <!-- Admin Role -->
    <div class="col-md-3 col-lg-3 animate__animated animate__zoomIn" data-animate-delay="0.1s">
      <div class="card role-card h-100 shadow-sm border-0">
        <div class="card-body p-4">
          <i class="fas fa-user-shield fa-3x text-primary mb-3"></i>
          <h5 class="fw-bold text-primary">Admin</h5>
          <p class="text-muted mb-3">The mastermind with unrestricted control.</p>
          <ul class="list-unstyled role-features">
            <li><i class="fas fa-check-circle text-primary me-2"></i> Full System Access</li>
            <li><i class="fas fa-check-circle text-primary me-2"></i> User Management</li>
            <li><i class="fas fa-check-circle text-primary me-2"></i> Settings Customization</li>
            <li><i class="fas fa-check-circle text-primary me-2"></i> Subscription Oversight</li>
          </ul>
        </div>
      </div>
    </div>

    <!-- Cashier Role -->
    <div class="col-md-3 col-lg-3 animate__animated animate__zoomIn" data-animate-delay="0.2s">
      <div class="card role-card h-100 shadow-sm border-0">
        <div class="card-body p-4">
          <i class="fas fa-cash-register fa-3x text-success mb-3"></i>
          <h5 class="fw-bold text-success">Cashier</h5>
          <p class="text-muted mb-3">The frontline expert in transactions.</p>
          <ul class="list-unstyled role-features">
            <li><i class="fas fa-check-circle text-success me-2"></i> Process Sales</li>
            <li><i class="fas fa-check-circle text-success me-2"></i> Handle Payments</li>
            <li><i class="fas fa-check-circle text-success me-2"></i> Issue Refunds</li>
            <li><i class="fas fa-times-circle text-muted me-2"></i> No Admin Access</li>
          </ul>
        </div>
      </div>
    </div>

    <!-- Salesperson Role -->
    <div class="col-md-3 col-lg-3 animate__animated animate__zoomIn" data-animate-delay="0.3s">
      <div class="card role-card h-100 shadow-sm border-0">
        <div class="card-body p-4">
          <i class="fas fa-user-tie fa-3x text-info mb-3"></i>
          <h5 class="fw-bold text-info">Salesperson</h5>
          <p class="text-muted mb-3">The customer-focused order specialist.</p>
          <ul class="list-unstyled role-features">
            <li><i class="fas fa-check-circle text-info me-2"></i> Manage Customer Orders</li>
            <li><i class="fas fa-check-circle text-info me-2"></i> Update Customer Profiles</li>
            <li><i class="fas fa-check-circle text-info me-2"></i> Apply Discounts</li>
            <li><i class="fas fa-times-circle text-muted me-2"></i> No Reporting Access</li>
          </ul>
        </div>
      </div>
    </div>

    <!-- Manager Role -->
    <div class="col-md-3 col-lg-3 animate__animated animate__zoomIn" data-animate-delay="0.4s">
      <div class="card role-card h-100 shadow-sm border-0">
        <div class="card-body p-4">
          <i class="fas fa-chart-pie fa-3x text-warning mb-3"></i>
          <h5 class="fw-bold text-warning">Manager</h5>
          <p class="text-muted mb-3">The overseer of performance and insights.</p>
          <ul class="list-unstyled role-features">
            <li><i class="fas fa-check-circle text-warning me-2"></i> View Sales Reports</li>
            <li><i class="fas fa-check-circle text-warning me-2"></i> Analyze Dashboard Data</li>
            <li><i class="fas fa-check-circle text-warning me-2"></i> Manage Inventory</li>
            <li><i class="fas fa-check-circle text-warning me-2"></i> Limited User Oversight</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</div>
<!-- Pricing Section -->
<div class="container mt-5 py-5" id="pricing">
  <h2 class="text-center mb-5 fw-bold animate__animated animate__fadeIn">Choose Your Perfect Plan</h2>
  <div class="row g-4 justify-content-center">
    <!-- Basic Plan -->
    <div class="col-md-4 col-lg-4 animate__animated animate__fadeInUp" data-animate-delay="0.1s">
      <div class="card pricing-card h-100 shadow-sm border-0 text-center">
        <div class="card-header bg-primary text-white py-4">
          <h4 class="fw-bold mb-0">Basic</h4>
          <p class="fs-5 mt-2 mb-0">$9.99<span class="fs-6">/month</span></p>
          <span class="badge bg-light text-primary mt-2">Perfect for Startups</span>
        </div>
        <div class="card-body p-4">
          <p class="text-muted">Essential tools to get your store up and running.</p>
          <ul class="list-unstyled pricing-features">
            <li><i class="fas fa-check text-primary me-2"></i> Basic Store Management</li>
            <li><i class="fas fa-check text-primary me-2"></i> Single User Access</li>
            <li><i class="fas fa-check text-primary me-2"></i> Standard Checkout</li>
            <li><i class="fas fa-times text-muted me-2"></i> Limited Support</li>
          </ul>
          <a href="${createLink(controller: 'storeOwner', action: 'register', params: [planId: 1])}" class="btn btn-primary btn-lg w-75 mt-4 pricing-btn">Subscribe Now</a>
        </div>
      </div>
    </div>

    <!-- Pro Plan -->
    <div class="col-md-4 col-lg-4 animate__animated animate__fadeInUp" data-animate-delay="0.2s">
      <div class="card pricing-card h-100 shadow-lg border-success text-center position-relative">
        <span class="position-absolute top-0 start-50 translate-middle badge rounded-pill bg-success text-white px-3 py-2">Most Popular</span>
        <div class="card-header bg-success text-white py-4">
          <h4 class="fw-bold mb-0">Pro</h4>
          <p class="fs-5 mt-2 mb-0">$29.99<span class="fs-6">/month</span></p>
          <span class="badge bg-light text-success mt-2">Best Value</span>
        </div>
        <div class="card-body p-4">
          <p class="text-muted">Advanced features for growing businesses.</p>
          <ul class="list-unstyled pricing-features">
            <li><i class="fas fa-check text-success me-2"></i> Detailed Sales Reports</li>
            <li><i class="fas fa-check text-success me-2"></i> Discount Management</li>
            <li><i class="fas fa-check text-success me-2"></i> Inventory Tracking</li>
            <li><i class="fas fa-check text-success me-2"></i> Multi-User Access</li>
            <li><i class="fas fa-check text-success me-2"></i> Priority Support</li>
          </ul>
          <a href="${createLink(controller: 'storeOwner', action: 'register', params: [planId: 2])}" class="btn btn-success btn-lg w-75 mt-4 pricing-btn">Subscribe Now</a>
        </div>
      </div>
    </div>

    <!-- Enterprise Plan -->
    <div class="col-md-4 col-lg-4 animate__animated animate__fadeInUp" data-animate-delay="0.3s">
      <div class="card pricing-card h-100 shadow-sm border-0 text-center">
        <div class="card-header bg-warning text-dark py-4">
          <h4 class="fw-bold mb-0">Enterprise</h4>
          <p class="fs-5 mt-2 mb-0">$299.99<span class="fs-6">/month</span></p>
          <span class="badge bg-light text-warning mt-2">For Large Businesses</span>
        </div>
        <div class="card-body p-4">
          <p class="text-muted">Comprehensive solutions for large-scale operations.</p>
          <ul class="list-unstyled pricing-features">
            <li><i class="fas fa-check text-warning me-2"></i> Advanced Analytics</li>
            <li><i class="fas fa-check text-warning me-2"></i> Custom Integrations</li>
            <li><i class="fas fa-check text-warning me-2"></i> Unlimited Users</li>
            <li><i class="fas fa-check text-warning me-2"></i> AI Data Insights</li>
            <li><i class="fas fa-check text-warning me-2"></i> 24/7 Dedicated Support</li>
          </ul>
          <a href="${createLink(controller: 'storeOwner', action: 'register', params: [planId: 3])}" class="btn btn-warning btn-lg w-75 mt-4 pricing-btn text-dark">Subscribe Now</a>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Footer Section -->
<footer class="bg-dark text-white py-5 mt-5">
  <div class="container">
    <div class="row g-4">
      <!-- Company Info -->
      <div class="col-md-4 col-lg-4">
        <h5 class="fw-bold mb-3">Smart POS</h5>
        <p class="text-muted">
          Empowering businesses with cutting-edge POS solutions to streamline operations, boost sales, and drive growth.
        </p>
      </div>

      <!-- Quick Links -->
      <div class="col-md-4 col-lg-4">
        <h5 class="fw-bold mb-3">Quick Links</h5>
        <ul class="list-unstyled">
          <li class="mb-2"><a href="#modules" class="text-white text-decoration-none">Modules</a></li>
          <li class="mb-2"><a href="#features" class="text-white text-decoration-none">Features</a></li>
          <li class="mb-2"><a href="#pricing" class="text-white text-decoration-none">Pricing</a></li>

        </ul>
      </div>

      <!-- Contact Info -->
      <div class="col-md-4 col-lg-4">
        <h5 class="fw-bold mb-3">Contact Us</h5>
        <p class="text-muted">
          Email: support@rasantsolutions.com<br>
          Phone: (555) 123-4567<br>
          Address: Karnal Sher Khan Shaheed Rd, near PSO pump, New Katarian Satellite Town, Islamabad
        </p>
        <div class="social-icons mt-3">
          <a href="#" class="text-white me-3"><i class="fab fa-facebook-f"></i></a>
          <a href="#" class="text-white me-3"><i class="fab fa-twitter"></i></a>
          <a href="#" class="text-white me-3"><i class="fab fa-linkedin-in"></i></a>
          <a href="#" class="text-white"><i class="fab fa-instagram"></i></a>
        </div>
      </div>
    </div>

    <!-- Footer Bottom -->
    <div class="row mt-4 pt-3 border-top border-secondary">
      <div class="col-12 text-center">
        <p class="mb-0 text-muted">&copy; 2025 Smart POS. All rights reserved. <br>Powered by <a href="https://rasantsolutions.com" class="text-white text-decoration-none">Rasant Solutions</a></p>
      </div>
    </div>
  </div>
</footer>
<script>
  // Smooth scroll with offset for fixed header (existing code unchanged)
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      e.preventDefault();
      const targetId = this.getAttribute('href').substring(1);
      const targetElement = document.getElementById(targetId);
      if (targetElement) {
        const headerHeight = document.querySelector('#header').offsetHeight;
        const targetPosition = targetElement.offsetTop - headerHeight;
        window.scrollTo({
          top: targetPosition,
          behavior: 'smooth'
        });
      }
    });
  });

  // Animation on scroll logic (existing code unchanged)
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

  const observer = new IntersectionObserver(animateOnScroll, { threshold: 0.2 });
  document.querySelectorAll('.animate__animated').forEach(element => observer.observe(element));
</script>
<!-- Bootstrap & JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
