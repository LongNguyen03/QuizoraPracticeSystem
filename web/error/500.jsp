<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Lỗi máy chủ</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 60px 40px;
            text-align: center;
            max-width: 600px;
            width: 90%;
        }

        .error-icon {
            font-size: 80px;
            color: #e74c3c;
            margin-bottom: 20px;
        }

        .error-code {
            font-size: 72px;
            font-weight: 700;
            color: #e74c3c;
            margin-bottom: 10px;
        }

        .error-title {
            font-size: 28px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 15px;
        }

        .error-message {
            font-size: 16px;
            color: #7f8c8d;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .info-section {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 25px;
            text-align: left;
        }

        .info-item {
            margin-bottom: 10px;
        }

        .info-label {
            font-size: 14px;
            color: #6c757d;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .info-value {
            font-size: 16px;
            color: #495057;
            word-break: break-all;
        }

        .btn-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: #3498db;
            color: white;
        }

        .btn-primary:hover {
            background: #2980b9;
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: #ecf0f1;
            color: #2c3e50;
        }

        .btn-secondary:hover {
            background: #bdc3c7;
            transform: translateY(-2px);
        }

        @media (max-width: 480px) {
            .container {
                padding: 40px 20px;
            }
            
            .error-code {
                font-size: 48px;
            }
            
            .error-title {
                font-size: 24px;
            }
            
            .btn-group {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="error-icon">⚡</div>
        <div class="error-code">500</div>
        <h1 class="error-title">Lỗi máy chủ</h1>
        <p class="error-message">
            Đã xảy ra lỗi bên trong máy chủ. Vui lòng thử lại sau hoặc liên hệ quản trị viên nếu vấn đề vẫn tiếp tục.
        </p>
        
        <div class="info-section">
            <div class="info-item">
                <div class="info-label">URL yêu cầu:</div>
                <div class="info-value">${pageContext.request.requestURI}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">Thời gian:</div>
                <div class="info-value"><%= new java.util.Date() %></div>
            </div>
        </div>
        
        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/views/home.jsp" class="btn btn-primary">
                Về trang chủ
            </a>
            <a href="javascript:history.back()" class="btn btn-secondary">
                Quay lại
            </a>
        </div>
    </div>
</body>
</html> 