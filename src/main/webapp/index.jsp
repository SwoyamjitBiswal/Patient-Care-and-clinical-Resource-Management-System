<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PatientCare - Your Health, Our Priority</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
            --border-radius: 16px;
            --transition: all 0.3s ease;
            --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            overflow-x: hidden;
            background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
        }
        
        /* Blur Background Effect */
        .blur-bg {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        /* --- THIS IS THE CORRECT, FINAL FIX --- */
        
        /* 1. Base styles for ALL disabled buttons */
        .btn-disabled {
            cursor: not-allowed !important; /* Force the 'not-allowed' cursor */
            opacity: 0.6 !important;
            filter: grayscale(0.5) !important;
            animation: none !important; /* Stops the 'pulse' animation */
        }
        
        /* 2. Stop hover effects for SOLID buttons when disabled */
        .hero-section .btn-hero-primary.btn-disabled:hover,
        .cta-section .btn-cta-primary.btn-disabled:hover {
            transform: none !important; /* Stop lift effect */
            box-shadow: var(--shadow-lg) !important; /* Keep original shadow, stop hover shadow */
            cursor: not-allowed !important;
        }

        /* 3. Stop hover effects for OUTLINE buttons when disabled */
        .hero-section .btn-hero-outline.btn-disabled:hover {
            transform: none !important; /* Stop lift effect */
            box-shadow: var(--shadow) !important; /* Keep original shadow */
            background: transparent !important;   /* STOP background change */
            color: var(--primary) !important;    /* STOP color change */
            cursor: not-allowed !important;
        }
        
        .cta-section .btn-cta-outline.btn-disabled:hover {
            transform: none !important; /* Stop lift effect */
            box-shadow: var(--shadow) !important; /* Keep original shadow */
            background: transparent !important;   /* STOP background change */
            color: white !important;             /* STOP color change */
            cursor: not-allowed !important;
        }

        /* 4. Stop the shiny ::before element on all disabled buttons */
        .btn-disabled::before {
            display: none !important;
        }
        
        /* --- END OF FIX --- */
        
        
        /* Hero Section */
        .hero-section {
            background: linear-gradient(135deg, #ffffff 0%, #f0f9ff 50%, #ffffff 100%);
            position: relative;
            overflow: hidden;
            padding: 8rem 0 0;
            color: var(--dark);
        }
        
        .hero-content {
            position: relative;
            z-index: 2;
        }
        
        .text-gradient {
            background: linear-gradient(135deg, #4f46e5, #0ea5e9);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        /* Enhanced Button Styles - Scoped to prevent conflicts */
        .hero-section .btn-hero-primary {
            border-radius: 12px;
            padding: 1rem 2rem;
            font-weight: 600;
            transition: var(--transition);
            border: none;
            position: relative;
            overflow: hidden;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            text-decoration: none;
            font-size: 1rem;
            width: 100%;
            max-width: 280px;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            box-shadow: var(--shadow-lg);
            cursor: pointer;
        }
        
        .hero-section .btn-hero-primary::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s;
        }
        
        .hero-section .btn-hero-primary:hover::before {
            left: 100%;
        }
        
        .hero-section .btn-hero-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(79, 70, 229, 0.3);
        }
        
        .hero-section .btn-hero-outline {
            border-radius: 12px;
            padding: 1rem 2rem;
            font-weight: 600;
            transition: var(--transition);
            border: 2px solid var(--primary);
            position: relative;
            overflow: hidden;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            text-decoration: none;
            font-size: 1rem;
            width: 100%;
            max-width: 280px;
            background: transparent;
            color: var(--primary);
            box-shadow: var(--shadow);
            cursor: pointer;
        }
        
        .hero-section .btn-hero-outline::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(79, 70, 229, 0.1), transparent);
            transition: left 0.5s;
        }
        
        .hero-section .btn-hero-outline:hover::before {
            left: 100%;
        }
        
        .hero-section .btn-hero-outline:hover {
            background: var(--primary);
            color: white;
            transform: translateY(-3px);
            box-shadow: var(--shadow-lg);
        }
        
        /* CTA Section Button Styles */
        .cta-section .btn-cta-primary {
            border-radius: 12px;
            padding: 1rem 2rem;
            font-weight: 600;
            transition: var(--transition);
            border: none;
            position: relative;
            overflow: hidden;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            text-decoration: none;
            font-size: 1rem;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            box-shadow: var(--shadow-lg);
            cursor: pointer;
        }
        
        .cta-section .btn-cta-primary::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s;
        }
        
        .cta-section .btn-cta-primary:hover::before {
            left: 100%;
        }
        
        .cta-section .btn-cta-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(79, 70, 229, 0.4);
        }
        
        .cta-section .btn-cta-outline {
            border-radius: 12px;
            padding: 1rem 2rem;
            font-weight: 600;
            transition: var(--transition);
            border: 2px solid white;
            position: relative;
            overflow: hidden;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            text-decoration: none;
            font-size: 1rem;
            background: transparent;
            color: white;
            box-shadow: var(--shadow);
            cursor: pointer;
        }
        
        .cta-section .btn-cta-outline::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }
        
        .cta-section .btn-cta-outline:hover::before {
            left: 100%;
        }
        
        .cta-section .btn-cta-outline:hover {
            background: white;
            color: var(--primary);
            transform: translateY(-3px);
            box-shadow: var(--shadow-lg);
        }
        
        .hero-icon-container {
            position: relative;
            height: 350px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .main-icon {
            font-size: 10rem;
            color: var(--primary);
            z-index: 3;
            position: relative;
            filter: drop-shadow(0 10px 20px rgba(79, 70, 229, 0.2));
        }
        
        .floating-icons {
            position: absolute;
            width: 100%;
            height: 100%;
        }
        
        .floating-icon {
            position: absolute;
            width: 60px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: white;
            border-radius: 16px;
            box-shadow: var(--shadow-lg);
            font-size: 1.6rem;
            color: var(--primary);
            animation: float 6s ease-in-out infinite;
        }
        
        .floating-icon:nth-child(1) {
            top: 10%;
            left: 10%;
            animation-delay: 0s;
            background: #e0f2fe;
            color: #0ea5e9;
        }
        
        .floating-icon:nth-child(2) {
            top: 10%;
            right: 10%;
            animation-delay: 1s;
            background: #f0fdf4;
            color: #10b981;
        }
        
        .floating-icon:nth-child(3) {
            bottom: 20%;
            left: 5%;
            animation-delay: 2s;
            background: #fef3c7;
            color: #f59e0b;
        }
        
        .floating-icon:nth-child(4) {
            bottom: 10%;
            right: 15%;
            animation-delay: 3s;
            background: #fae8ff;
            color: #d946ef;
        }
        
        @keyframes float {
            0%, 100% {
                transform: translateY(0) rotate(0deg);
            }
            50% {
                transform: translateY(-20px) rotate(5deg);
            }
        }
        
        .hero-stats-full {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            padding: 3rem 0;
            margin-top: 4rem;
            position: relative;
            box-shadow: 0 -5px 15px rgba(0, 0, 0, 0.03);
        }
        
        .hero-stats-card {
            text-align: center;
            padding: 1.5rem 1rem;
            transition: var(--transition);
            position: relative;
            z-index: 2;
        }
        
        .hero-stats-card:hover {
            transform: translateY(-5px);
        }
        
        .hero-stats-card i {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .hero-stats-card .number {
            font-size: 2.5rem;
            font-weight: 800;
            color: var(--dark);
            margin-bottom: 0.5rem;
            line-height: 1;
        }
        
        .hero-stats-card .label {
            font-size: 1rem;
            color: var(--secondary);
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        
        .section-title {
            font-weight: 700;
            margin-bottom: 1rem;
            color: var(--dark);
            font-size: 2.5rem;
        }
        
        .section-subtitle {
            color: var(--secondary);
            font-size: 1.125rem;
            margin-bottom: 3rem;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }
        
        .hero-title {
            font-size: 3.5rem;
            font-weight: 800;
            line-height: 1.1;
            color: var(--dark);
            margin-bottom: 1.5rem;
        }
        
        .hero-subtitle {
            font-size: 1.25rem;
            color: var(--secondary);
            line-height: 1.6;
            margin-bottom: 2.5rem;
        }
        
        .trust-badges {
            display: flex;
            align-items: center;
            gap: 2rem;
            flex-wrap: wrap;
        }
        
        .trust-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.25rem;
            background: rgba(255, 255, 255, 0.8);
            border-radius: 50px;
            font-size: 0.9rem;
            font-weight: 500;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(0, 0, 0, 0.05);
            color: var(--primary);
            transition: var(--transition);
        }
        
        .trust-item:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }
        
        .trust-item i {
            font-size: 1.1rem;
        }
        
        .hero-buttons-container {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            justify-content: flex-start;
        }
        
        /* Features Section */
        .features-section {
            padding: 5rem 0;
            background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
            position: relative;
        }
        
        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            position: relative;
            z-index: 2;
        }
        
        .feature-card {
            border: none;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            transition: var(--transition);
            background: white;
            overflow: hidden;
            height: 100%;
            border: 1px solid #f3f4f6;
            position: relative;
        }
        
        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }
        
        .feature-card:hover::before {
            transform: scaleX(1);
        }
        
        .feature-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-xl);
            border-color: var(--primary-light);
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
        
        .feature-card:hover .feature-icon {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            transform: scale(1.1);
        }
        
        /* CTA Section */
        .cta-section {
            padding: 5rem 0;
            background: linear-gradient(135deg, var(--dark) 0%, #374151 100%);
            color: white;
            border-radius: var(--border-radius);
            overflow: hidden;
            position: relative;
            box-shadow: var(--shadow-xl);
            margin: 2rem 0;
        }
        
        .cta-content {
            position: relative;
            z-index: 2;
        }
        
        /* Animation for stats */
        @keyframes countUp {
            from { transform: translateY(20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        
        .hero-stats-card .number {
            animation: countUp 0.6s ease-out;
        }
        
        /* Pulse animation for CTA */
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        .pulse:hover {
            animation: pulse 2s infinite;
        }
        
        /* Welcome Alert Styles */
        .welcome-alert {
            background: rgba(59, 130, 246, 0.1);
            border: 1px solid rgba(59, 130, 246, 0.2);
            border-radius: 12px;
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
            backdrop-filter: blur(10px);
        }
        
        /* Responsive Styles */
        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.5rem;
            }
            
            .section-title {
                font-size: 2rem;
            }
            
            .hero-section .btn-hero-primary,
            .hero-section .btn-hero-outline,
            .cta-section .btn-cta-primary,
            .cta-section .btn-cta-outline {
                padding: 0.875rem 1.5rem;
                width: 100%;
                max-width: 100%;
            }
            
            .hero-buttons-container {
                flex-direction: column;
            }
            
            .trust-badges {
                justify-content: center;
            }
            
            .hero-section {
                padding: 6rem 0 0;
                text-align: center;
            }
            
            .main-icon {
                font-size: 6rem;
            }
            
            .hero-icon-container {
                height: 250px;
            }
            
            .hero-stats-full {
                padding: 2rem 0;
                margin-top: 2rem;
            }
            
            .hero-stats-card .number {
                font-size: 2rem;
            }
        }
        
    </style>
</head>
<body>
    <%@ include file="includes/navbar.jsp" %>

    <%
        Object patientObj = session.getAttribute("patientObj");
        Object doctorObj = session.getAttribute("doctorObj");
        Object adminObj = session.getAttribute("adminObj");
        boolean isLoggedIn = (patientObj != null) || (doctorObj != null) || (adminObj != null);
        
        // Determine user role for display
        String userRole = "";
        String userName = "";
        if (patientObj != null) {
            userRole = "Patient";
            // Assuming Patient entity has getFullName() method
            // userName = ((Patient)patientObj).getFullName();
        } else if (doctorObj != null) {
            userRole = "Doctor";
            // Assuming Doctor entity has getFullName() method
            // userName = ((Doctor)doctorObj).getFullName();
        } else if (adminObj != null) {
            userRole = "Admin";
            // Assuming Admin entity has getFullName() method
            // userName = ((Admin)adminObj).getFullName();
        }
    %>

    <section class="hero-section <%= isLoggedIn ? "blur-bg" : "" %>">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6 hero-content">
                    <h1 class="hero-title">
                        Your Health, 
                        <span class="text-gradient">Our Priority</span>
                    </h1>
                    <p class="hero-subtitle">
                        Experience seamless healthcare with our advanced platform. Book appointments instantly, connect with expert doctors, and manage your health journey - all in one place.
                    </p>
                    
                    <% if (isLoggedIn) { %>
                        <div class="welcome-alert">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-user-check text-primary me-3 fs-4"></i>
                                <div>
                                    <h6 class="mb-1 text-primary">Welcome back!</h6>
                                    <p class="mb-0 text-dark">You are already logged in as <strong><%= userRole %></strong>.</p>
                                </div>
                            </div>
                        </div>
                    <% } %>
                    
                    <div class="hero-buttons-container mb-4">
                        <a href="${pageContext.request.contextPath}/patient/register.jsp" 
                           class="btn-hero-primary pulse <%= isLoggedIn ? "btn-disabled" : "" %>"
                           <%= isLoggedIn ? "onclick=\"return false;\"" : "" %>>
                            <i class="fas fa-user-plus me-2"></i>
                            <%= isLoggedIn ? "Already Logged In" : "Get Started Free" %>
                        </a>
                        <a href="${pageContext.request.contextPath}/patient/login.jsp" 
                           class="btn-hero-outline <%= isLoggedIn ? "btn-disabled" : "" %>"
                           <%= isLoggedIn ? "onclick=\"return false;\"" : "" %>>
                            <i class="fas fa-sign-in-alt me-2"></i>
                            <%= isLoggedIn ? "Session Active" : "Sign In" %>
                        </a>
                    </div>
                    
                    <div class="trust-badges">
                        <div class="trust-item">
                            <i class="fas fa-shield-alt text-success"></i>
                            <span>HIPAA Compliant</span>
                        </div>
                        <div class="trust-item">
                            <i class="fas fa-bolt text-warning"></i>
                            <span>Instant Booking</span>
                        </div>
                        <div class="trust-item">
                            <i class="fas fa-star text-info"></i>
                            <span>Rated 4.9/5</span>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 text-center">
                    <div class="hero-icon-container">
                        <i class="fas fa-stethoscope main-icon"></i>
                        
                        <div class="floating-icons">
                            <div class="floating-icon">
                                <i class="fas fa-heart"></i>
                            </div>
                            <div class="floating-icon">
                                <i class="fas fa-pills"></i>
                            </div>
                            <div class="floating-icon">
                                <i class="fas fa-notes-medical"></i>
                            </div>
                            <div class="floating-icon">
                                <i class="fas fa-user-md"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="hero-stats-full <%= isLoggedIn ? "blur-bg" : "" %>">
            <div class="container">
                <div class="row g-4">
                    <div class="col-md-3">
                        <div class="hero-stats-card">
                            <i class="fas fa-users"></i>
                            <div class="number">10,000+</div>
                            <div class="label">Happy Patients</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="hero-stats-card">
                            <i class="fas fa-user-md"></i>
                            <div class="number">500+</div>
                            <div class="label">Expert Doctors</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="hero-stats-card">
                            <i class="fas fa-calendar-alt"></i>
                            <div class="number">50,000+</div>
                            <div class="label">Appointments</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="hero-stats-card">
                            <i class="fas fa-heart"></i>
                            <div class="number">99%</div>
                            <div class="label">Satisfaction Rate</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="features-section <%= isLoggedIn ? "blur-bg" : "" %>">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="section-title">Why Choose <span class="text-gradient">PatientCare</span>?</h2>
                <p class="section-subtitle">Designed with your health and convenience in mind</p>
            </div>
            
            <div class="feature-grid">
                <div class="feature-card">
                    <div class="card-body p-4 text-center">
                        <div class="feature-icon">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <h5 class="card-title fw-bold mb-3">Easy Appointments</h5>
                        <p class="card-text text-muted">Book appointments with your preferred doctors in just a few clicks with our intuitive booking system.</p>
                    </div>
                </div>
                
                <div class="feature-card">
                    <div class="card-body p-4 text-center">
                        <div class="feature-icon">
                            <i class="fas fa-user-md"></i>
                        </div>
                        <h5 class="card-title fw-bold mb-3">Expert Doctors</h5>
                        <p class="card-text text-muted">Access to qualified and experienced healthcare professionals verified through our rigorous screening process.</p>
                    </div>
                </div>
                
                <div class="feature-card">
                    <div class="card-body p-4 text-center">
                        <div class="feature-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <h5 class="card-title fw-bold mb-3">24/7 Access</h5>
                        <p class="card-text text-muted">Manage your healthcare anytime, anywhere with our responsive platform that works across all devices.</p>
                    </div>
                </div>
                
                <div class="feature-card">
                    <div class="card-body p-4 text-center">
                        <div class="feature-icon">
                            <i class="fas fa-file-medical"></i>
                        </div>
                        <h5 class="card-title fw-bold mb-3">Digital Health Records</h5>
                        <p class="card-text text-muted">Securely store and access your medical history, prescriptions, and test results in one centralized location.</p>
                    </div>
                </div>
                
                <div class="feature-card">
                    <div class="card-body p-4 text-center">
                        <div class="feature-icon">
                            <i class="fas fa-comments"></i>
                        </div>
                        <h5 class="card-title fw-bold mb-3">Instant Communication</h5>
                        <p class="card-text text-muted">Chat directly with healthcare providers and get your questions answered quickly and efficiently.</p>
                    </div>
                </div>
                
                <div class="feature-card">
                    <div class="card-body p-4 text-center">
                        <div class="feature-icon">
                            <i class="fas fa-mobile-alt"></i>
                        </div>
                        <h5 class="card-title fw-bold mb-3">Mobile Friendly</h5>
                        <p class="card-text text-muted">Full mobile compatibility lets you manage your healthcare on the go with our responsive design.</p>
                    </div>
                </div>

                <div class="feature-card">
                    <div class="card-body p-4 text-center">
                        <div class="feature-icon">
                            <i class="fas fa-prescription-bottle-alt"></i>
                        </div>
                        <h5 class="card-title fw-bold mb-3">Prescription Management</h5>
                        <p class="card-text text-muted">Digital prescriptions, medication reminders, and automated refill requests for better medication adherence.</p>
                    </div>
                </div>

                <div class="feature-card">
                    <div class="card-body p-4 text-center">
                        <div class="feature-icon">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <h5 class="card-title fw-bold mb-3">Health Analytics</h5>
                        <p class="card-text text-muted">Track your health progress with detailed analytics and personalized insights from your medical data.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="container">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="cta-section <%= isLoggedIn ? "blur-bg" : "" %>">
                    <div class="card-body py-3 px-5 cta-content">
                        <div class="row align-items-center">
                            <div class="col-lg-8 text-center text-lg-start">
                                <h2 class="mb-3">Ready to Transform Your Healthcare Experience?</h2>
                                <p class="mb-4 opacity-90 fs-5">Join thousands who have already discovered the future of healthcare management.</p>
                                <div class="d-flex gap-3 flex-wrap">
                                    <a href="${pageContext.request.contextPath}/patient/register.jsp" 
                                       class="btn-cta-primary pulse <%= isLoggedIn ? "btn-disabled" : "" %>"
                                       <%= isLoggedIn ? "onclick=\"return false;\"" : "" %>>
                                        <i class="fas fa-rocket me-2"></i>
                                        <%= isLoggedIn ? "Welcome Back!" : "Start Your Journey" %>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/patient/login.jsp" 
                                       class="btn-cta-outline <%= isLoggedIn ? "btn-disabled" : "" %>"
                                       <%= isLoggedIn ? "onclick=\"return false;\"" : "" %>>
                                        <i class="fas fa-sign-in-alt me-2"></i>
                                        <%= isLoggedIn ? "Session Active" : "Existing User" %>
                                    </a>
                                </div>
                            </div>
                            <div class="col-lg-4 text-center mt-4 mt-lg-0">
                                <div class="trust-badges justify-content-center">
                                    <div class="trust-item">
                                        <i class="fas fa-lock"></i>
                                        <span>Secure Platform</span>
                                    </div>
                                    <div class="trust-item mt-2">
                                        <i class="fas fa-clock"></i>
                                        <span>24/7 Support</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <%@ include file="includes/footer.jsp" %>

    <script>
        // Simple animation for stats counter
        document.addEventListener('DOMContentLoaded', function() {
            const statNumbers = document.querySelectorAll('.hero-stats-card .number');
            
            statNumbers.forEach(stat => {
                const target = parseInt(stat.textContent);
                let current = 0;
                const increment = target / 50;
                const timer = setInterval(() => {
                    current += increment;
                    if (current >= target) {
                        current = target;
                        clearInterval(timer);
                    }
                    stat.textContent = Math.floor(current) + (stat.textContent.includes('%') ? '%' : '+');
                }, 50);
            });
        });
    </script>
</body>
</html>