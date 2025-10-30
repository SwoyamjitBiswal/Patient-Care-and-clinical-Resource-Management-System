<%@ include file="includes/header.jsp" %>
<title>Patient Care System - About Us | Quality Healthcare Platform</title>
<style>
    :root {
        --primary: #4f46e5;
        --primary-light: #eef2ff;
        --primary-dark: #4338ca;
        --secondary: #6b7280;
        --success: #10b981;
        --warning: #f59e0b;
        --info: #0ea5e9;
        --danger: #ef4444;
        --dark: #1f2937;
        --light: #f9fafb;
        --transition: all 0.3s ease;
        --border-radius: 12px;
        --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
    }
    
    .about-hero {
        background: linear-gradient(135deg, var(--primary), #6366f1);
        padding: 5rem 0;
        margin-bottom: 3rem;
        color: white;
        position: relative;
        overflow: hidden;
    }
    
    .about-hero::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: url("data:image/svg+xml,%3Csvg width='100' height='100' viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M11 18c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm48 25c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm-43-7c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm63 31c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM34 90c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm56-76c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM12 86c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm28-65c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm23-11c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-6 60c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm29 22c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zM32 63c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm57-13c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-9-21c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM60 91c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM35 41c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM12 60c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2z' fill='%23ffffff' fill-opacity='0.1' fill-rule='evenodd'/%3E%3C/svg%3E");
        opacity: 0.1;
    }
    
    .mission-icon {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 2rem;
        font-size: 3rem;
        background: rgba(255, 255, 255, 0.2);
        color: white;
        border: 3px solid rgba(255, 255, 255, 0.3);
        backdrop-filter: blur(10px);
    }
    
    .card {
        background: white;
        border-radius: var(--border-radius);
        box-shadow: var(--shadow);
        overflow: hidden;
        transition: var(--transition);
        border: 1px solid #f3f4f6;
    }
    
    .card:hover {
        box-shadow: var(--shadow-lg);
        transform: translateY(-2px);
    }
    
    .card-header {
        padding: 1.25rem 1.5rem;
        border-bottom: 1px solid #f3f4f6;
        display: flex;
        align-items: center;
        background: #fafafa;
    }
    
    .card-title {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        font-weight: 600;
        color: var(--dark);
        margin: 0;
    }
    
    .card-title i {
        color: var(--primary);
    }
    
    .card-body {
        padding: 1.5rem;
    }
    
    .feature-icon {
        width: 80px;
        height: 80px;
        border-radius: 20px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 1.5rem;
        font-size: 2rem;
        background: var(--primary-light);
        color: var(--primary);
        transition: var(--transition);
    }
    
    .feature-item:hover .feature-icon {
        background: var(--primary);
        color: white;
        transform: scale(1.1);
    }
    
    .value-card {
        background: white;
        border-radius: var(--border-radius);
        padding: 2rem;
        text-align: center;
        box-shadow: var(--shadow);
        transition: var(--transition);
        border: 1px solid #f3f4f6;
        height: 100%;
    }
    
    .value-card:hover {
        transform: translateY(-5px);
        box-shadow: var(--shadow-lg);
        border-color: var(--primary);
    }
    
    .value-icon {
        width: 70px;
        height: 70px;
        border-radius: 18px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 1.5rem;
        font-size: 1.75rem;
        background: var(--primary-light);
        color: var(--primary);
    }
    
    .stat-number {
        font-size: 2.5rem;
        font-weight: 700;
        color: var(--dark);
        margin-bottom: 0.5rem;
    }
    
    .stat-label {
        font-size: 1rem;
        color: var(--secondary);
        font-weight: 500;
    }
    
    .section-title {
        font-weight: 700;
        margin-bottom: 1rem;
        color: var(--dark);
    }
    
    .section-subtitle {
        color: var(--secondary);
        font-size: 1.125rem;
        margin-bottom: 2rem;
    }
    
    .lead-modern {
        font-size: 1.25rem;
        font-weight: 400;
        line-height: 1.7;
        color: var(--dark);
    }
    
    .divider {
        height: 2px;
        background: linear-gradient(90deg, transparent, var(--primary), transparent);
        margin: 3rem 0;
        border: none;
    }
    
    .hero-title {
        font-size: 3.5rem;
        font-weight: 800;
        margin-bottom: 1rem;
    }
    
    .hero-subtitle {
        font-size: 1.25rem;
        opacity: 0.9;
        margin-bottom: 2rem;
    }
    
    @media (max-width: 768px) {
        .hero-title {
            font-size: 2.5rem;
        }
        
        .about-hero {
            padding: 3rem 0;
        }
        
        .mission-icon {
            width: 100px;
            height: 100px;
            font-size: 2.5rem;
        }
    }
    
    .text-gradient {
        background: linear-gradient(135deg, var(--primary), var(--primary-dark));
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }
    
    .feature-item {
        text-align: center;
        padding: 1.5rem;
        border-radius: var(--border-radius);
        transition: var(--transition);
    }
    
    .feature-item:hover {
        background: var(--primary-light);
    }
    
    .stats-section {
        background: linear-gradient(135deg, #f8fafc, #f1f5f9);
        border-radius: var(--border-radius);
        padding: 3rem 2rem;
    }
</style>
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>

    <!-- Hero Section -->
    <section class="about-hero">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-8 mx-auto text-center">
                    <div class="mission-icon">
                        <i class="fas fa-hospital-alt"></i>
                    </div>
                    <h1 class="hero-title">About <span class="text-white">PatientCare</span></h1>
                    <p class="hero-subtitle">
                        We're revolutionizing healthcare by making quality medical services accessible, affordable, and convenient for everyone through innovative technology.
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- Main Content -->
    <div class="container">
        <div class="row">
            <div class="col-lg-10 mx-auto">
                <div class="card mb-5">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-info-circle"></i>
                            Our Story & Mission
                        </h2>
                    </div>
                    <div class="card-body p-4 p-md-5">
                        <div class="row align-items-center mb-5">
                            <div class="col-lg-6">
                                <h3 class="section-title">Transforming Healthcare Delivery</h3>
                                <p class="text-muted mb-4">
                                    Founded with a vision to bridge the gap between patients and healthcare providers, PatientCare System leverages cutting-edge technology to create a seamless healthcare experience. We believe that everyone deserves access to quality medical care, regardless of their location or circumstances.
                                </p>
                                <p class="text-muted">
                                    Our platform connects patients with verified healthcare professionals, streamlines appointment scheduling, and provides secure access to medical records - all while maintaining the highest standards of privacy and security.
                                </p>
                            </div>
                            <div class="col-lg-6 text-center">
                                <div class="feature-icon" style="width: 200px; height: 200px; font-size: 4rem;">
                                    <i class="fas fa-heartbeat"></i>
                                </div>
                            </div>
                        </div>

                        <hr class="divider">

                        <!-- Mission & Vision -->
                        <div class="row g-4 mb-5">
                            <div class="col-md-6">
                                <div class="value-card">
                                    <div class="value-icon">
                                        <i class="fas fa-bullseye"></i>
                                    </div>
                                    <h4 class="fw-bold mb-3">Our Vision</h4>
                                    <p class="text-muted mb-0">
                                        To become the most trusted healthcare platform that connects patients with the best medical professionals seamlessly, making quality healthcare accessible to everyone everywhere.
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="value-card">
                                    <div class="value-icon">
                                        <i class="fas fa-hand-holding-heart"></i>
                                    </div>
                                    <h4 class="fw-bold mb-3">Our Values</h4>
                                    <p class="text-muted mb-0">
                                        Compassion, Excellence, Innovation, and Patient-Centric care are at the core of everything we do. We're committed to upholding the highest ethical standards in healthcare delivery.
                                    </p>
                                </div>
                            </div>
                        </div>

                        <!-- What We Offer -->
                        <div class="text-center mb-5">
                            <h3 class="section-title">What We Offer</h3>
                            <p class="section-subtitle">Comprehensive healthcare solutions designed for modern needs</p>
                        </div>

                        <div class="row g-4">
                            <div class="col-md-4 feature-item">
                                <div class="text-center">
                                    <div class="feature-icon">
                                        <i class="fas fa-calendar-plus"></i>
                                    </div>
                                    <h5 class="fw-bold mb-2">Easy Booking</h5>
                                    <p class="text-muted small">
                                        Book appointments with your preferred doctors in minutes with our intuitive, user-friendly interface.
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-4 feature-item">
                                <div class="text-center">
                                    <div class="feature-icon">
                                        <i class="fas fa-stethoscope"></i>
                                    </div>
                                    <h5 class="fw-bold mb-2">Expert Doctors</h5>
                                    <p class="text-muted small">
                                        Access to qualified and experienced healthcare professionals verified through rigorous screening.
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-4 feature-item">
                                <div class="text-center">
                                    <div class="feature-icon">
                                        <i class="fas fa-shield-alt"></i>
                                    </div>
                                    <h5 class="fw-bold mb-2">Secure Platform</h5>
                                    <p class="text-muted small">
                                        Your health data is protected with enterprise-grade security and privacy measures.
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div class="row g-4 mt-2">
                            <div class="col-md-4 feature-item">
                                <div class="text-center">
                                    <div class="feature-icon">
                                        <i class="fas fa-file-medical"></i>
                                    </div>
                                    <h5 class="fw-bold mb-2">Digital Records</h5>
                                    <p class="text-muted small">
                                        Securely store and access your medical history, prescriptions, and test results anytime.
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-4 feature-item">
                                <div class="text-center">
                                    <div class="feature-icon">
                                        <i class="fas fa-comments"></i>
                                    </div>
                                    <h5 class="fw-bold mb-2">Direct Communication</h5>
                                    <p class="text-muted small">
                                        Chat directly with healthcare providers and get your questions answered quickly.
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-4 feature-item">
                                <div class="text-center">
                                    <div class="feature-icon">
                                        <i class="fas fa-mobile-alt"></i>
                                    </div>
                                    <h5 class="fw-bold mb-2">Mobile Access</h5>
                                    <p class="text-muted small">
                                        Full mobile compatibility lets you manage healthcare on the go with responsive design.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Stats Section -->
                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-chart-line"></i>
                            Our Impact
                        </h2>
                    </div>
                    <div class="card-body p-4 p-md-5">
                        <div class="stats-section">
                            <div class="row text-center g-4">
                                <div class="col-md-3">
                                    <div class="stat-number">10,000+</div>
                                    <div class="stat-label">Happy Patients</div>
                                </div>
                                <div class="col-md-3">
                                    <div class="stat-number">500+</div>
                                    <div class="stat-label">Expert Doctors</div>
                                </div>
                                <div class="col-md-3">
                                    <div class="stat-number">50,000+</div>
                                    <div class="stat-label">Appointments</div>
                                </div>
                                <div class="col-md-3">
                                    <div class="stat-number">99%</div>
                                    <div class="stat-label">Satisfaction Rate</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Team Section -->
                <div class="card mt-4 mb-4">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fas fa-users"></i>
                            Why Choose PatientCare?
                        </h2>
                    </div>
                    <div class="card-body p-4 p-md-5">
                        <div class="row g-4">
                            <div class="col-md-4">
                                <div class="text-center">
                                    <div class="feature-icon">
                                        <i class="fas fa-clock"></i>
                                    </div>
                                    <h5 class="fw-bold mb-2">24/7 Availability</h5>
                                    <p class="text-muted small">
                                        Access healthcare services anytime, anywhere with our round-the-clock platform availability.
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="text-center">
                                    <div class="feature-icon">
                                        <i class="fas fa-dollar-sign"></i>
                                    </div>
                                    <h5 class="fw-bold mb-2">Affordable Care</h5>
                                    <p class="text-muted small">
                                        Transparent pricing with no hidden costs. Quality healthcare that doesn't break the bank.
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="text-center">
                                    <div class="feature-icon">
                                        <i class="fas fa-headset"></i>
                                    </div>
                                    <h5 class="fw-bold mb-2">Dedicated Support</h5>
                                    <p class="text-muted small">
                                        Our support team is always ready to help you with any questions or concerns.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="includes/footer.jsp" %>
</body>
</html>