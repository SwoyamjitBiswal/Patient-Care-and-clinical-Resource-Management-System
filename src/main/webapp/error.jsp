<%@ page isErrorPage="true" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error Page</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%);
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            color: #333;
        }
        .error-container {
            max-width: 800px;
            width: 100%;
            background: white;
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            position: relative;
            z-index: 1;
        }
        .error-header {
            background: linear-gradient(135deg, #6a82fb 0%, #6a82fb 50%, #fc5c7d 100%);
            color: white;
            padding: 30px 40px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        .error-header::before {
            content: '';
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: url("data:image/svg+xml,%3Csvg width='100' height='100' ... %3E");
            opacity: 0.3;
        }
        .error-icon { font-size: 80px; margin-bottom: 20px; color: rgba(255,255,255,0.9); filter: drop-shadow(0 4px 8px rgba(0,0,0,0.2)); }
        .error-title { font-size: 42px; font-weight: 700; margin-bottom: 10px; letter-spacing: -0.5px; }
        .error-subtitle { font-size: 18px; font-weight: 400; opacity: 0.9; max-width: 500px; margin: 0 auto; }
        .error-content { padding: 40px; text-align: center; }
        .error-code {
            display: inline-flex;
            align-items: center;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 12px 24px;
            border-radius: 50px;
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 30px;
            box-shadow: 0 6px 15px rgba(245,87,108,0.3);
        }
        .error-code i { margin-right: 10px; font-size: 20px; }
        .error-message { font-size: 18px; line-height: 1.6; margin-bottom: 40px; color: #555; max-width: 600px; margin-left: auto; margin-right: auto; }
        .action-buttons { display: flex; justify-content: center; gap: 20px; flex-wrap: wrap; }
        .btn {
            padding: 14px 32px;
            border-radius: 50px;
            font-size: 16px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            cursor: pointer;
            border: none;
            outline: none;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .btn-primary {
            background: linear-gradient(135deg, #6a82fb 0%, #6a82fb 100%);
            color: white;
        }
        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(106,130,251,0.4);
        }
        .btn-secondary {
            background: white;
            color: #6a82fb;
            border: 2px solid #6a82fb;
        }
        .btn-secondary:hover { background: #f8f9ff; transform: translateY(-3px); }
        .btn i { margin-right: 8px; font-size: 18px; }
        .floating-elements { position: absolute; top: 0; left: 0; width: 100%; height: 100%; overflow: hidden; z-index: -1; }
        .floating-element { position: absolute; background: rgba(106,130,251,0.05); border-radius: 50%; animation: float 15s infinite linear; }
        .floating-element:nth-child(1) { width: 80px; height: 80px; top: 10%; left: 10%; animation-delay: 0s; }
        .floating-element:nth-child(2) { width: 120px; height: 120px; top: 60%; left: 80%; animation-delay: -5s; }
        .floating-element:nth-child(3) { width: 60px; height: 60px; top: 80%; left: 20%; animation-delay: -10s; }
        @keyframes float { 0%{transform:translateY(0)rotate(0deg);}50%{transform:translateY(-20px)rotate(180deg);}100%{transform:translateY(0)rotate(360deg);} }
        .pulse { animation: pulse 2s infinite; }
        @keyframes pulse { 0%{transform:scale(1);}50%{transform:scale(1.05);}100%{transform:scale(1);} }
        @media (max-width: 600px) {
            .error-header { padding: 20px; }
            .error-title { font-size: 32px; }
            .error-content { padding: 30px 20px; }
            .action-buttons { flex-direction: column; align-items: center; }
            .btn { width: 100%; max-width: 280px; }
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-header">
            <div class="error-icon">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <h1 class="error-title">Oops! Something went wrong</h1>
            <p class="error-subtitle">We encountered an unexpected error while processing your request</p>
        </div>
        
        <div class="error-content">
            <div class="error-code">
                <i class="fas fa-bug"></i>
                Error Code: <%= request.getAttribute("javax.servlet.error.status_code") != null ? request.getAttribute("javax.servlet.error.status_code") : "Unknown" %>
            </div>
            
            <p class="error-message">
                <%
                    Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
                    String message = (String) request.getAttribute("javax.servlet.error.message");
                    String uri = (String) request.getAttribute("javax.servlet.error.request_uri");
                    if (uri == null) uri = "Unknown";

                    if (statusCode != null) {
                        out.print("Error " + statusCode + ": " + (message != null ? message : "Unexpected Error"));
                    } else {
                        out.print("An unknown error occurred while accessing " + uri);
                    }
                %>
            </p>
            
            <div class="action-buttons">
                <a href="index.jsp" class="btn btn-primary pulse">
                    <i class="fas fa-home"></i> Return Home
                </a>
                <button class="btn btn-secondary" onclick="location.reload()">
                    <i class="fas fa-redo"></i> Refresh Page
                </button>
            </div>
        </div>
        
        <div class="floating-elements">
            <div class="floating-element"></div>
            <div class="floating-element"></div>
            <div class="floating-element"></div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const errorCode = document.querySelector('.error-code');
            errorCode.addEventListener('click', function() {
                this.style.transform = 'scale(0.95)';
                setTimeout(() => { this.style.transform = 'scale(1)'; }, 150);
            });
        });
    </script>
</body>
</html>
