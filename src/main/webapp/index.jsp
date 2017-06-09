<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>登陆页面</title>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script type="text/javascript" src="js/jquery-1.11.3.js"></script>
    <link
            href="resources-1.0.0/static/bootstrap/2.1.1/css/bootstraped.min.css"
            type="text/css" rel="stylesheet" />
    <link
            href="resources-1.0.0/static/bootstrap/2.1.1/css/bootstraped-responsive.min.css"
            type="text/css" rel="stylesheet" />
    <link href="resources-1.0.0/static/css/mini-web.css" type="text/css"
          rel="stylesheet" />
    <link
            href="resources-1.0.0/static/jquery-validation/1.10.0/validate.css"
            rel="stylesheet">
    <script
            src="resources-1.0.0/static/jquery-validation/1.10.0/jquery.validate.min.js"></script>
    <script
            src="resources-1.0.0/static/jquery-validation/1.10.0/messages_bs_zh.js"></script>
	<style>
		html{
			height: 100%;
		}
		body {
			background-color: #f5f5f5;
			background: url('resources-1.0.0/static/images/taihu.jpg') no-repeat
			fixed;
			-webkit-background-size: cover;
			-moz-background-size: cover;
			-o-background-size: cover;
			background-size: cover;
			overflow: hidden;
		}

		.form-signin {
			max-width: 300px;
			padding: 19px 20px 29px;
			margin: 15% 20% 20px auto;
			background: #fff;
			position: relative;
			background: -webkit-gradient(linear, left top, left bottom, color-stop(0%, #fff),
			color-stop(100%, #ddd));
			background: -webkit-linear-gradient(top, #fff 0, #ddd 100%);
			background: -moz-linear-gradient(top, #fff 0, #ddd 100%);
			background: -ms-linear-gradient(top, #fff 0, #ddd 100%);
			background: -o-linear-gradient(top, #fff 0, #ddd 100%);
			background: linear-gradient(top, #fff 0, #ddd 100%);
			border: 1px solid #e5e5e5;
			-webkit-border-radius: 5px;
			-moz-border-radius: 5px;
			border-radius: 5px;
			-webkit-box-shadow: 0 1px 2px rgba(0, 0, 0, .05);
			-moz-box-shadow: 0 1px 2px rgba(0, 0, 0, .05);
			box-shadow: 0 1px 2px rgba(0, 0, 0, .05);
		}

		.form-signin .form-signin-heading, .form-signin .checkbox {
			margin-bottom: 10px;
		}

		.form-signin input[type="text"], .form-signin input[type="password"] {
			font-size: 16px;
			height: auto;
			margin-bottom: 15px;
			padding: 7px 9px;
		}

		.nav_head {
			height: 40px;
		}
		header{
			background: #113665;
			line-height: 50px;
			color: #e4e6e8;
			padding:0  50px;
			letter-spacing: 3px;
			box-shadow: 1px 1px 5px #395b86;
			font-family: STXinwei;
			font-size: 26px;
			text-shadow: 1px 1px 5px #395b86;
		}
		header span:hover{
			color: #f5f5f5;
		}

		body{
			background:url("resources-1.0.0/static/images/login.jpg")no-repeat;
			background-size: 100% 100%;
		}
		form{

			margin: 0 auto;
			position: absolute;
			top: 50%;
			left: 70%;
			z-index: 3;
			transform: translate(-50%,-50%);
			-webkit-transform: translate(-50%,-50%);
			border: 1px solid #ccc;
			box-shadow: 1px 1px 5px #6094CD;
			padding:0 0 50px 0;
			background: #fff;
			border-radius: 10px;
		}
		form h3{
			color:#113665;
			letter-spacing: 1px;
			font-family: STXinwei;
			font-family:  Microsoft YaHei;
			font-size: 26px;
			text-align: center;
			margin: 0 0 20px 0;
			padding: 20px 30px;
			border-bottom: 2px solid #6094CD;
		}
		form div{
			padding: 0 30px;
            position: relative;
		}
		input{
			margin: 10px 0;
			height: 30px;
			/*text-indent: 20px;*/
			text-align: center;
			border: 1px solid #ccc;
			border-radius: 3px;
			color: #999;
			outline: none;
            padding: 4px 0px;
		}
		input:hover{
			border: 1px solid #6094CD;
		}
		#login{
			cursor: pointer;
			background:#6094CD ;
			color: #e4e6e8;
			font-weight: bold;
		}
        span.error {
            display: block;
            line-height: 16px;
            position: absolute;
            top: 42px;
            font-size: 14px;
            right: 30px;
            font-family: SimHei;
        }
        .alert {
            margin: 5px 0 0 0;
            padding: 5px;
            position: absolute;
            top: 222px;
            right: 0;
        }
	</style>
	<script>
		$(document).ready(function() {
			$("#username").focus();
			$("#loginForm").validate();
		});
	</script>
</head>

<body style="margin:0;height: 100%;">
<header>
	<span>老板锁屏升级后台</span>
</header>
<form id="loginForm" action="login" method="post">
    <%
        String msg = (String) request.getAttribute("msg");
        if (StringUtils.isNotBlank(msg)) {
    %>
    <div class="control-group">
        <div class="controls ">
            <div class="alert alert-error">
                <button class="close" data-dismiss="alert">×</button>
                <%=msg%>
            </div>
        </div>
    </div>
    <%
        }
    %>
	<h3>老板锁屏升级后台登录</h3>
	<div>
		<input type="text" placeholder="帐号" id="username" name="userName" size="50" class="required input" style="width: 300px;padding: 4px 0px;margin-bottom: 12px;" />
	</div>
	<div>
		<input type="password" id="password" placeholder="密码" name="pwd" size="50" class="required input" style="width: 300px;padding: 4px 0px;margin-bottom: 12px;"/>
	</div>
    <div>
        <label class="checkbox" for="rememberMe">
            <input style="height: 16px;" type="checkbox" id="rememberMe" name="rememberMe" checked="checked" />
            下次自动登录
        </label>
    </div>

	<div>
		<input id="login"  style="width:302px;margin: 28px 0 0 0;" type="submit" value="登录" />
	</div>
</form>
<script
        src="resources-1.0.0/static/bootstrap/2.1.1/js/bootstraped.min.js"
        type="text/javascript"></script>
</body>

</html>