<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>升级后台主页面</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <script type="text/javascript" src="js/jquery-1.11.3.js"></script>
    <link href="resources-1.0.0/static/bootstrap/2.1.1/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script src="resources-1.0.0/static/bootstrap/2.1.1/js/bootstrap.min.js" type="text/javascript"></script>
    <script type="text/javascript" language="javascript" src="js/table/jquery.dataTables.js"></script>
    <script type="text/javascript" language="javascript" src="js/table/dataBase.js"></script>
    <script type="text/javascript">
    </script>
</head>

<style>
    body {
        font-family: SimHei;
        background: #d2ddea;
        background: #d2d9e2;
    }

    .nav > li.nav-header {
        font-size: 22px;
        color: #113665;
        /*font-family: STXinwei;*/
        padding: 10px 20px;
        text-align: center;
        background: #6094CD;
        border-bottom: 1px solid #ccc;
        color: #fff;
    }

    h3 {
        /*font-family: STXinwei;*/

    }

    .nav > li {
        border-bottom: 1px solid #fbfbfb;
    }

    .nav-list > li > a {
        padding: 3px 40px;
        cursor: pointer;
        /*font-family: Microsoft YaHei;*/
        /*font-family: SimHei;*/
        /*text-indent: 20px;*/
        font-size: 16px;
        color: #636262;
        /*font-family: STXinwei;*/
        line-height: 30px;
    }

    .nav-list > li > a:hover {
        color: #428bca;
    }

    select, textarea, input[type="text"] {
        width: 230px;
        height: 28px;
        border: 1px solid #dcdcdc;
        border-radius: 3px;
        margin: 5px 0;
    }

    textarea {
        width: 300px;
        height: 50px;
    }

    form {
        overflow: hidden;
    }

    form p {
        overflow: hidden;
    }

    form label {
        display: block;
        min-width: 120px;
        height: 30px;
        float: left;
        margin: 0;
        font-weight: normal;
        /*text-align: right;*/
    }

    form span {
        display: block;
        float: left;
        max-width: 400px;
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
    }

    .button {
        background: #5891ce;
        color: #fff;
        border-radius: 3px;
        border: 1px solid #006dcc;
        padding: 0px 30px;
        margin: 15px 0;
    }

    .modal .button {
        margin: 45px 0 0 0;
        cursor: pointer;
        text-decoration: none;
    }

    .well {
        margin: 50px 20px;
        display: block;
        float: left;
        padding: 35px 35px;
        border: 1px solid #ccc;
        box-shadow: 1px 1px 5px #b5cce6;
    }

    #left {
        width: 260px;
        overflow: hidden;
        float: left;
    }

    #middlebar {
        width: 70%;
        float: left;
    }

    .info {
        font-size: 14px;
        color: gray;
    }

    /*#d1 {*/
    /*border: 1px solid #ccc;*/
    /*table-layout: fixed;*/
    /*!*top: 93px;*!*/
    /*!*left: 0px;*!*/
    /*!*position: absolute;*!*/
    /*}*/

    #d1 a {
        display: inline-block;
        font-size: 14px;
        cursor: pointer;
        width: 25px;
        height: 25px;
        margin: 0 3px;
    }

    #d1_filter {
        display: none;
    }

    #d1 {
        border: 1px solid #ccc;
        border-radius: 3px;
        background: #fff;
    }

    #d1 td, #d1 th {
        border: 1px solid #ccc;
        width: 132px;
        text-align: center;
        border-radius: 3px;
        padding: 10px 3px;
        max-width: 180px;
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
    }

    #d1_processing {
        display: none;
    }

    #d1 th {
        /*background: #f5f5f5;*/
        border: 1px solid #b3b0b0;
        color: #6094CD;
    }

    #d1_paginate {
        float: right;
    }

    #d1_paginate a {
        text-decoration: none;
        padding: 0 5px;
        cursor: pointer;
    }

    header {
        background: #113665;
        line-height: 50px;
        color: #e4e6e8;
        padding: 0 50px;
        letter-spacing: 3px;
        box-shadow: 1px 1px 5px #395b86;
        font-family: STXinwei;
        font-size: 26px;
        text-shadow: 1px 1px 5px #395b86;
    }

    header span {
        cursor: pointer;
    }

    header span:hover {
        color: #f5f5f5;
    }

    .upload {
        float: right;
        cursor: pointer;
        width: 30px;
        height: 30px;
        background: url("resources-1.0.0/static/images/uploadFile.png") no-repeat;
        background-size: 30px 30px;
    }

    .force {
        background: url("resources-1.0.0/static/images/forceSet.png") no-repeat;
        background-size: 25px 25px;
    }

    .extra {
        background: url("resources-1.0.0/static/images/extraSet.png") no-repeat;
        background-size: 25px 25px;
    }

    .active {
        background: url("resources-1.0.0/static/images/active.png") no-repeat;
        background-size: 25px 25px;
    }

    .modal {
        /*overflow: hidden;*/
    }

    .nav > li > a > img {
        margin: -3px 0 0 0;
    }

    .modal-body {
        font-size: 16px;
        line-height: 30px;
    }
    #d1 th.forceUpdateValue{
        width: 150px;
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
    }
</style>

<body>
<%--<header>--%>
<%--老板锁屏升级后台--%>
<%--</header>--%>
<%@ include file="/WEB-INF/header.jsp" %>
<div class="container-fluid">
    <div id="left">
        <div class="well span3" style="width: 220px;min-height: 100px;padding: 0;">
            <ul class="nav nav-list">
                <li class="nav-header">
                    升级后台页面
                </li>
                <li id="goodManager"><a style="color: #428bca;" href="skipGoods"><img src="resources-1.0.0/static/images/activeLog.png" width="25"
                                                  height="25" alt=""> 商品模块</a>
                </li>
                <li id="orderManager"><a href="skipOrders"><img src="resources-1.0.0/static/images/activeLog.png" width="25"
                                           height="25" alt=""> 订单模块</a>
                </li>
            </ul>
        </div>

    </div>
    <div id="middlebar">
        <div class="well span3" style="margin:50px 0;padding:0 20px 20px 20px;min-height: 80%;" >
            <h3 style="color:green;">商品管理</h3>
            <HR class="xline">
            <div id="1" style="margin-top: 10px; text-align: center;">
                功能还未开发,敬请期待...
                <table id="d1">
                    <thead>
                    <tr>
                        <th>货架号</th>
                        <th>商品名称</th>
                        <th>库存</th>
                        <th>价格(元)</th>
                        <th>已售出</th>
                        <th>详情</th>
                        <%--<th CLASS="forceUpdateValue">强制升级值</th>--%>
                        <th>状态</th>
                        <th>商品新增时间</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>