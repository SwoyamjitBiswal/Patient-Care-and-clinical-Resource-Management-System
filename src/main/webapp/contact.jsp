<%@ include file="includes/header.jsp" %>
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
            --light: #f9fafb;
            --dark: #1f2937;
            --darker: #111827;
            --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --transition: all 0.3s ease;
            --border-radius: 12px;
        }
        
        /* Scoped styles for contact page only */
        .main-content * {
            margin: 0 !important;
            padding: 0 !important;
            box-sizing: border-box !important;
        }
        
        .main-content {
            font-family: 'Inter', sans-serif !important;
            background-color: #f9fafb !important;
            color: var(--dark) !important;
            line-height: 1.6 !important;
            min-height: 100vh !important;
            display: flex !important;
            flex-direction: column !important;
            flex: 1 !important;
            padding: 2rem !important;
            max-width: 1200px !important;
            margin: 0 auto !important;
            width: 100% !important;
        }
        
        .main-content .page-header {
            text-align: center !important;
            margin-bottom: 3rem !important;
            padding: 2rem 0 !important;
        }
        
        .main-content .page-title {
            font-size: 2.5rem !important;
            font-weight: 700 !important;
            color: var(--dark) !important;
            margin-bottom: 1rem !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            gap: 1rem !important;
        }
        
        .main-content .page-subtitle {
            font-size: 1.2rem !important;
            color: var(--secondary) !important;
            max-width: 600px !important;
            margin: 0 auto !important;
        }
        
        .main-content .contact-card {
            background: white !important;
            border-radius: var(--border-radius) !important;
            box-shadow: var(--shadow-lg) !important;
            overflow: hidden !important;
            transition: var(--transition) !important;
            border: 1px solid #f3f4f6 !important;
        }
        
        .main-content .contact-card:hover {
            transform: translateY(-5px) !important;
            box-shadow: var(--shadow-lg) !important;
        }
        
        .main-content .card-header {
            background: linear-gradient(135deg, var(--primary), #6366f1) !important;
            color: white !important;
            padding: 2rem !important;
            text-align: center !important;
        }
        
        .main-content .card-header h3 {
            font-weight: 600 !important;
            margin: 0 !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            gap: 1rem !important;
            font-size: 1.75rem !important;
        }
        
        .main-content .card-body {
            padding: 2.5rem !important;
        }
        
        .main-content .contact-grid {
            display: grid !important;
            grid-template-columns: 1fr 1fr !important;
            gap: 3rem !important;
        }
        
        .main-content .section-title {
            font-size: 1.5rem !important;
            font-weight: 600 !important;
            margin-bottom: 2rem !important;
            color: var(--primary) !important;
            position: relative !important;
            padding-bottom: 0.75rem !important;
        }
        
        .main-content .section-title::after {
            content: '' !important;
            position: absolute !important;
            bottom: 0 !important;
            left: 0 !important;
            width: 50px !important;
            height: 4px !important;
            background: var(--primary) !important;
            border-radius: 2px !important;
        }
        
        .main-content .contact-info {
            display: flex !important;
            flex-direction: column !important;
            gap: 1.5rem !important;
        }
        
        .main-content .contact-item {
            display: flex !important;
            align-items: flex-start !important;
            gap: 1.5rem !important;
            padding: 1.5rem !important;
            border-radius: var(--border-radius) !important;
            transition: var(--transition) !important;
            border: 1px solid #f3f4f6 !important;
        }
        
        .main-content .contact-item:hover {
            background-color: var(--primary-light) !important;
            border-color: var(--primary) !important;
            transform: translateX(5px) !important;
        }
        
        .main-content .contact-icon {
            width: 60px !important;
            height: 60px !important;
            border-radius: var(--border-radius) !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            color: white !important;
            font-size: 1.5rem !important;
            flex-shrink: 0 !important;
        }
        
        .main-content .icon-primary {
            background: linear-gradient(135deg, var(--primary), #6366f1) !important;
        }
        
        .main-content .icon-success {
            background: linear-gradient(135deg, var(--success), #34d399) !important;
        }
        
        .main-content .icon-warning {
            background: linear-gradient(135deg, var(--warning), #f59e0b) !important;
        }
        
        .main-content .icon-info {
            background: linear-gradient(135deg, var(--info), #0ea5e9) !important;
        }
        
        .main-content .contact-details h6 {
            font-weight: 600 !important;
            margin-bottom: 0.5rem !important;
            color: var(--dark) !important;
            font-size: 1.1rem !important;
        }
        
        .main-content .contact-details p {
            color: var(--secondary) !important;
            margin: 0 !important;
            font-size: 1rem !important;
            line-height: 1.5 !important;
        }
        
        /* Form Styles */
        .main-content .form-group {
            margin-bottom: 1.5rem !important;
        }
        
        .main-content .form-label {
            display: block !important;
            margin-bottom: 0.5rem !important;
            font-weight: 500 !important;
            color: var(--dark) !important;
            font-size: 1rem !important;
        }
        
        /* Updated Input Group Styles */
        .main-content .input-group {
            position: relative !important;
            display: flex !important;
            flex-wrap: wrap !important;
            align-items: stretch !important;
            width: 100% !important;
            border-radius: 10px !important;
            overflow: hidden !important;
            border: 1px solid #d1d5db !important;
            transition: var(--transition) !important;
        }
        
        .main-content .input-group:focus-within {
            border-color: var(--primary) !important;
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.15) !important;
        }
        
        .main-content .input-group-text {
            background: #f9fafb !important;
            border: none !important;
            color: #6b7280 !important;
            padding: 0.75rem 1rem !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            min-width: 50px !important;
            flex-shrink: 0 !important;
        }
        
        .main-content .form-control {
            border-radius: 0 !important;
            padding: 0.75rem 1rem !important;
            border: none !important;
            transition: var(--transition) !important;
            font-size: 1rem !important;
            width: 100% !important;
            flex: 1 !important;
        }
        
        .main-content .form-control:focus {
            box-shadow: none !important;
            border: none !important;
            outline: none !important;
        }
        
        .main-content textarea.form-control {
            min-height: 120px !important;
            resize: vertical !important;
        }
        
        /* Contact Page Specific Buttons - Won't conflict with footer */
        .main-content .btn-contact {
            display: inline-flex !important;
            align-items: center !important;
            justify-content: center !important;
            padding: 0.875rem 2rem !important;
            border-radius: var(--border-radius) !important;
            font-weight: 500 !important;
            text-decoration: none !important;
            transition: var(--transition) !important;
            font-size: 1rem !important;
            border: none !important;
            cursor: pointer !important;
            gap: 0.75rem !important;
        }
        
        .main-content .btn-contact-primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark)) !important;
            color: white !important;
            width: 100% !important;
        }
        
        .main-content .btn-contact-primary:hover {
            transform: translateY(-2px) !important;
            box-shadow: 0 7px 14px rgba(79, 70, 229, 0.25) !important;
        }
        
        /* Additional Info Section */
        .main-content .additional-info {
            margin-top: 3rem !important;
            padding: 2rem !important;
            background: var(--primary-light) !important;
            border-radius: var(--border-radius) !important;
            border-left: 4px solid var(--primary) !important;
        }
        
        .main-content .info-title {
            font-size: 1.25rem !important;
            font-weight: 600 !important;
            margin-bottom: 1rem !important;
            color: var(--primary) !important;
        }
        
        .main-content .info-list {
            list-style: none !important;
            padding: 0 !important;
        }
        
        .main-content .info-list li {
            display: flex !important;
            align-items: center !important;
            gap: 0.75rem !important;
            padding: 0.5rem 0 !important;
            color: var(--dark) !important;
        }
        
        .main-content .info-list li i {
            color: var(--success) !important;
            font-size: 0.875rem !important;
        }
        
        /* Emergency contact styling */
        .main-content .emergency-contact {
            background: rgba(239, 68, 68, 0.1) !important;
            padding: 1rem !important;
            border-radius: 8px !important;
            margin-top: 0.5rem !important;
            border-left: 4px solid var(--danger) !important;
        }
        
        .main-content .emergency-contact strong {
            color: var(--danger) !important;
            font-size: 1.2rem !important;
        }
        
        @media (max-width: 992px) {
            .main-content .contact-grid {
                grid-template-columns: 1fr !important;
                gap: 2rem !important;
            }
            
            .main-content .card-body {
                padding: 2rem !important;
            }
            
            .main-content .page-title {
                font-size: 2rem !important;
            }
        }
        
        @media (max-width: 768px) {
            .main-content {
                padding: 1rem !important;
            }
            
            .main-content .card-header {
                padding: 1.5rem !important;
            }
            
            .main-content .card-body {
                padding: 1.5rem !important;
            }
            
            .main-content .contact-item {
                flex-direction: column !important;
                text-align: center !important;
                gap: 1rem !important;
                padding: 1.25rem !important;
            }
            
            .main-content .contact-icon {
                align-self: center !important;
            }
            
            .main-content .page-title {
                font-size: 1.75rem !important;
                flex-direction: column !important;
                gap: 0.5rem !important;
            }
            
            .main-content .page-header {
                margin-bottom: 2rem !important;
                padding: 1rem 0 !important;
            }
        }
        
        @media (max-width: 576px) {
            .main-content .contact-icon {
                width: 50px !important;
                height: 50px !important;
                font-size: 1.25rem !important;
            }
            
            .main-content .section-title {
                font-size: 1.25rem !important;
            }
            
            .main-content .card-header h3 {
                font-size: 1.5rem !important;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <%@ include file="includes/navbar.jsp" %>
    
    <main class="main-content">
        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-envelope"></i>
                Contact Us
            </h1>
            <p class="page-subtitle">
                Get in touch with our team. We're here to help you with any questions or concerns about your healthcare journey.
            </p>
        </div>

        <div class="contact-card">
            <div class="card-header">
                <h3><i class="fas fa-comments"></i>We're Here to Help</h3>
            </div>
            <div class="card-body">
                <div class="contact-grid">
                    <div class="contact-info">
                        <h5 class="section-title">Get in Touch</h5>
                        
                        <div class="contact-item">
                            <div class="contact-icon icon-primary">
                                <i class="fas fa-map-marker-alt"></i>
                            </div>
                            <div class="contact-details">
                                <h6>Our Location</h6>
                                <p>123 Healthcare Street<br>Medical City, MC 12345<br>United States</p>
                            </div>
                        </div>
                        
                        <div class="contact-item">
                            <div class="contact-icon icon-success">
                                <i class="fas fa-phone"></i>
                            </div>
                            <div class="contact-details">
                                <h6>Phone Number</h6>
                                <p>+1 (555) 123-4567<br>+1 (555) 987-6543</p>
                            </div>
                        </div>
                        
                        <div class="contact-item">
                            <div class="contact-icon icon-warning">
                                <i class="fas fa-envelope"></i>
                            </div>
                            <div class="contact-details">
                                <h6>Email Address</h6>
                                <p>info@patientcare.com<br>support@patientcare.com</p>
                            </div>
                        </div>
                        
                        <div class="contact-item">
                            <div class="contact-icon icon-info">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div class="contact-details">
                                <h6>Working Hours</h6>
                                <p>Monday - Friday: 8:00 AM - 8:00 PM<br>Saturday: 9:00 AM - 6:00 PM<br>Sunday: 10:00 AM - 4:00 PM</p>
                            </div>
                        </div>

                        <div class="additional-info">
                            <h6 class="info-title">Emergency Contact</h6>
                            <p>For medical emergencies, please call:</p>
                            <div class="emergency-contact">
                                <strong>
                                    <i class="fas fa-phone-alt me-2"></i>911
                                </strong>
                                <p>
                                    Or visit your nearest emergency room immediately.
                                </p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="contact-form">
                        <h5 class="section-title">Send us a Message</h5>
                        <form>
                            <div class="form-group">
                                <label for="name" class="form-label">Full Name</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-user text-primary"></i>
                                    </span>
                                    <input type="text" class="form-control" id="name" placeholder="Enter your full name" required>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="email" class="form-label">Email Address</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-envelope text-primary"></i>
                                    </span>
                                    <input type="email" class="form-control" id="email" placeholder="Enter your email address" required>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="phone" class="form-label">Phone Number</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-phone text-primary"></i>
                                    </span>
                                    <input type="tel" class="form-control" id="phone" placeholder="Enter your phone number">
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="subject" class="form-label">Subject</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-tag text-primary"></i>
                                    </span>
                                    <select class="form-control" id="subject" required>
                                        <option value="">Select a subject</option>
                                        <option value="appointment">Appointment Inquiry</option>
                                        <option value="billing">Billing Question</option>
                                        <option value="medical">Medical Question</option>
                                        <option value="feedback">Feedback</option>
                                        <option value="other">Other</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="message" class="form-label">Message</label>
                                <div class="input-group">
                                    <span class="input-group-text align-items-start pt-3">
                                        <i class="fas fa-comment text-primary"></i>
                                    </span>
                                    <textarea class="form-control" id="message" rows="5" placeholder="Please describe your inquiry in detail..." required></textarea>
                                </div>
                            </div>
                            
                            <button type="submit" class="btn-contact btn-contact-primary">
                                <i class="fas fa-paper-plane me-2"></i>Send Message
                            </button>
                        </form>

                        <div class="additional-info mt-4">
                            <h6 class="info-title">Response Time</h6>
                            <ul class="info-list">
                                <li>
                                    <i class="fas fa-check-circle"></i>
                                    <span>We typically respond within 24 hours</span>
                                </li>
                                <li>
                                    <i class="fas fa-check-circle"></i>
                                    <span>Urgent matters are prioritized</span>
                                </li>
                                <li>
                                    <i class="fas fa-check-circle"></i>
                                    <span>You'll receive a confirmation email</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <!-- Footer -->
    <%@ include file="includes/footer.jsp" %>
</body>
</html>