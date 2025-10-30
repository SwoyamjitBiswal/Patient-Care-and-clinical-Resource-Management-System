<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PatientCare - Footer Update</title>
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
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            overflow-x: hidden;
            background: #f8fafc;
        }
        
        .demo-content {
            min-height: 60vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 4rem 0;
        }
        
        .demo-content h1 {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 1rem;
            color: var(--dark);
        }
        
        .demo-content p {
            font-size: 1.25rem;
            color: var(--secondary);
            max-width: 600px;
            margin: 0 auto;
        }
        
        /* Updated Footer Styles */
        .pc-footer {
            background: linear-gradient(135deg, #1a202c 0%, #2d3748 50%, #4a5568 100%);
            color: #e2e8f0;
            padding: 4rem 0 2rem;
            position: relative;
            overflow: hidden;
        }
        
        .pc-footer::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.05) 0%, transparent 50%, rgba(0, 0, 0, 0.1) 100%);
            z-index: 1;
        }
        
        .pc-footer-content {
            position: relative;
            z-index: 2;
        }
        
        .pc-footer h4, .pc-footer h5 {
            color: #ffffff;
            font-weight: 600;
            margin-bottom: 1.5rem;
        }
        
        .pc-footer h4 i {
            color: var(--primary);
        }
        
        .pc-footer p {
            color: #cbd5e0;
            line-height: 1.7;
        }
        
        .pc-footer ul li {
            margin-bottom: 0.75rem;
        }
        
        .pc-footer ul li a {
            color: #cbd5e0;
            text-decoration: none;
            transition: var(--transition);
            display: flex;
            align-items: center;
        }
        
        .pc-footer ul li a:hover {
            color: var(--primary-light);
            transform: translateX(5px);
        }
        
        .pc-footer ul li a i {
            margin-right: 0.5rem;
            width: 20px;
            text-align: center;
            color: var(--primary);
        }
        
        .pc-footer-contact li {
            display: flex;
            align-items: flex-start;
            color: #cbd5e0;
            margin-bottom: 1rem;
        }
        
        .pc-footer-contact li i {
            margin-right: 0.75rem;
            color: var(--primary);
            margin-top: 0.25rem;
        }
        
        .pc-footer-divider {
            border-color: rgba(255, 255, 255, 0.1);
            margin: 2.5rem 0 2rem;
        }
        
        .pc-footer-bottom {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        .pc-footer-copyright {
            color: #a0aec0;
            font-size: 0.9rem;
        }
        
        .pc-footer-social {
            display: flex;
            gap: 1rem;
        }
        
        .pc-footer-social a {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.1);
            color: #cbd5e0;
            text-decoration: none;
            transition: var(--transition);
        }
        
        .pc-footer-social a:hover {
            background: var(--primary);
            color: white;
            transform: translateY(-3px);
        }
        
        .pc-footer-newsletter {
            margin-top: 1.5rem;
        }
        
        .pc-footer-newsletter p {
            margin-bottom: 1rem;
            font-size: 0.95rem;
        }
        
        .pc-newsletter-form {
            display: flex;
            max-width: 350px;
        }
        
        .pc-newsletter-input {
            flex: 1;
            padding: 0.75rem 1rem;
            border: 1px solid #4a5568;
            border-radius: 8px 0 0 8px;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            outline: none;
            transition: var(--transition);
        }
        
        .pc-newsletter-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.2);
            background: rgba(255, 255, 255, 0.15);
        }
        
        .pc-newsletter-input::placeholder {
            color: #a0aec0;
        }
        
        .pc-newsletter-btn {
            padding: 0.75rem 1.25rem;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 0 8px 8px 0;
            cursor: pointer;
            transition: var(--transition);
        }
        
        .pc-newsletter-btn:hover {
            background: var(--primary-dark);
        }
        
        .pc-footer-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            background: rgba(79, 70, 229, 0.2);
            border-radius: 50px;
            font-size: 0.85rem;
            margin-top: 1.5rem;
            color: var(--primary-light);
            border: 1px solid rgba(79, 70, 229, 0.3);
        }
        
        .pc-footer-badge i {
            color: var(--success);
        }
        
        .pc-app-download-btn {
            border: 1px solid #4a5568;
            color: #cbd5e0;
            transition: var(--transition);
            background: rgba(255, 255, 255, 0.05);
        }
        
        .pc-app-download-btn:hover {
            border-color: var(--primary);
            color: var(--primary-light);
            background: rgba(79, 70, 229, 0.1);
        }
        
        .pc-footer-copyright a {
            color: #a0aec0;
            text-decoration: underline;
            transition: var(--transition);
        }
        
        .pc-footer-copyright a:hover {
            color: var(--primary-light);
        }
        
        @media (max-width: 768px) {
            .pc-footer-bottom {
                flex-direction: column;
                text-align: center;
            }
            
            .pc-footer-social {
                justify-content: center;
            }
            
            .pc-newsletter-form {
                flex-direction: column;
                gap: 0.5rem;
            }
            
            .pc-newsletter-input, .pc-newsletter-btn {
                border-radius: 8px;
                width: 100%;
            }
        }
    </style>
</head>
<body>

    <!-- Updated Footer -->
    <footer class="pc-footer">
        <div class="container pc-footer-content">
            <div class="row">
                <div class="col-lg-4 mb-5 mb-lg-0">
                    <h4 class="mb-3">
                        <i class="fas fa-heartbeat me-2"></i>
                        PatientCare
                    </h4>
                    <p class="mb-4">Your trusted partner in health and wellness. We're committed to providing the best healthcare experience through innovative technology.</p>
                    
                    <div class="pc-footer-newsletter">
                        <p class="mb-3">Subscribe to our newsletter for health tips and updates</p>
                        <div class="pc-newsletter-form">
                            <input type="email" class="pc-newsletter-input" placeholder="Your email address">
                            <button class="pc-newsletter-btn">Subscribe</button>
                        </div>
                    </div>
                    
                    <div class="pc-footer-badge">
                        <i class="fas fa-shield-alt"></i>
                        <span>HIPAA Compliant & Secure</span>
                    </div>
                </div>
                
                <div class="col-lg-2 col-md-4 mb-4 mb-md-0">
                    <h5 class="mb-3">Quick Links</h5>
                    <ul class="list-unstyled">
                        <li><a href="#"><i class="fas fa-chevron-right"></i>Home</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i>Services</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i>Doctors</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i>About Us</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i>Contact</a></li>
                    </ul>
                </div>
                
                <div class="col-lg-3 col-md-4 mb-4 mb-md-0">
                    <h5 class="mb-3">Our Services</h5>
                    <ul class="list-unstyled">
                        <li><a href="#"><i class="fas fa-chevron-right"></i>Appointments</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i>Telemedicine</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i>Health Records</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i>Prescriptions</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i>Health Analytics</a></li>
                    </ul>
                </div>
                
                <div class="col-lg-3 col-md-4">
                    <h5 class="mb-3">Contact Us</h5>
                    <ul class="list-unstyled pc-footer-contact">
                        <li>
                            <i class="fas fa-map-marker-alt"></i>
                            <span>123 Health Street, Medical City, MC 12345</span>
                        </li>
                        <li>
                            <i class="fas fa-phone"></i>
                            <span>(123) 456-7890</span>
                        </li>
                        <li>
                            <i class="fas fa-envelope"></i>
                            <span>info@patientcare.com</span>
                        </li>
                        <li>
                            <i class="fas fa-clock"></i>
                            <span>24/7 Customer Support</span>
                        </li>
                    </ul>
                    
                    <div class="mt-4">
                        <h5 class="mb-3">Download Our App</h5>
                        <div class="d-flex gap-2 flex-wrap">
                            <a href="#" class="btn pc-app-download-btn btn-sm py-2 px-3 d-flex align-items-center">
                                <i class="fab fa-apple me-2"></i>
                                <div>
                                    <small>Download on the</small>
                                    <div>App Store</div>
                                </div>
                            </a>
                            <a href="#" class="btn pc-app-download-btn btn-sm py-2 px-3 d-flex align-items-center">
                                <i class="fab fa-google-play me-2"></i>
                                <div>
                                    <small>Get it on</small>
                                    <div>Google Play</div>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            
            <hr class="pc-footer-divider">
            
            <div class="pc-footer-bottom">
                <div class="pc-footer-copyright">
                    <p class="mb-0">© 2023 PatientCare. All rights reserved. | <a href="#" class="text-decoration-underline">Privacy Policy</a> | <a href="#" class="text-decoration-underline">Terms of Service</a></p>
                </div>
                <div class="pc-footer-social">
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                    <a href="#"><i class="fab fa-youtube"></i></a>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>