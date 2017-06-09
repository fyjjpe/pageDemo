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
    <script type="text/javascript" language="javascript"
            src="js/My97DatePickerBeta/My97DatePicker/WdatePicker.js"></script>

    <link href="js/pagination.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="js/jquery.pagination.js"></script>
    <script>
        //全局变量
        var total = 0;           //总共多少记录
        var pageNo = 0;         //当前页码
        $(function () {
            Init(0); //注意参数，初始页面默认传到后台的参数，第一页是0;
            $("#News-Pagination").pagination(total, {
                callback: PageCallback,
                prev_text: '上一页',
                next_text: '下一页',
                items_per_page: 2,             //每页显示几条记录
                num_display_entries: 3,        //连续分页主体部分显示的分页条目数
                num_edge_entries: 2,           //两侧显示的首尾分页的条目数
            });
            function PageCallback(index, jq) {//前一个表示您当前点击的那个分页的页数索引值，后一个参数表示装载容器。
                Init(index);
            }

        });

        // 点击分页按钮以后触发的动作
        function Init(pageIndex) {//这个参数就是点击的那个分页的页数索引值，第一页为0，上面提到了，下面这部分就是AJAX传值了
            //发送ajax请求,获取所有的订单
            $.ajax({
                url: "findOrders/p_" + (pageIndex + 1),
                type: "get",
                dataType: 'JSON',
                async : false,//设置为同步操作就可以给全局变量赋值成功
                success: function (result) {
                    //返回状态码
                    var code = result.code;
                    //总记录数
                    total = result.data.totalNumber;
                    //当前页码
                    pageNo = result.data.pageno;

                    //返回数据
                    var data = result.data.data;
                    //定义显示表单数据字符串
                    var str = "";
//                    console.log(data)
                    if ("000" === code && data != null) {
                        $("#d1 tbody").empty();
                        for (var i = 0; i < data.length; i++) {
                            str += "<tr>"
                                + "<td>" + data[i].id + "</td>"
                                + "<td>" + data[i].name + "</td>"
                                + "<td>" + data[i].price + "</td>"
                                + "</tr>";

                        }
                        $("#orderList").html(str)

                    } else {
                        alert(result.msg);
                    }
                },
                error: function () {
                    alert("订单加载失败!");
                }
            });
        }

    </script>

    <script>
        //导出excel方法
        var idTmr;
        function getExplorer() {
            var explorer = window.navigator.userAgent;
            //ie
            if (explorer.indexOf("MSIE") >= 0) {
                return 'ie';
            }
            //firefox
            else if (explorer.indexOf("Firefox") >= 0) {
                return 'Firefox';
            }
            //Chrome
            else if (explorer.indexOf("Chrome") >= 0) {
                return 'Chrome';
            }
            //Opera
            else if (explorer.indexOf("Opera") >= 0) {
                return 'Opera';
            }
            //Safari
            else if (explorer.indexOf("Safari") >= 0) {
                return 'Safari';
            }
        }
        function method5(tableid) {
            $("#toExcel").append(excel);
            if (getExplorer() == 'ie') {
                var curTbl = document.getElementById(tableid);
                var oXL = new ActiveXObject("Excel.Application");
                var oWB = oXL.Workbooks.Add();
                var xlsheet = oWB.Worksheets(1);
                var sel = document.body.createTextRange();
                sel.moveToElementText(curTbl);
                sel.select();
                sel.execCommand("Copy");
                xlsheet.Paste();
                oXL.Visible = true;

                try {
                    var fname = oXL.Application.GetSaveAsFilename("Excel.xls", "Excel Spreadsheets (*.xls), *.xls");
                } catch (e) {
                    print("Nested catch caught " + e);
                } finally {
                    oWB.SaveAs(fname);
                    oWB.Close(savechanges = false);
                    oXL.Quit();
                    oXL = null;
                    idTmr = window.setInterval("Cleanup();", 1);
                }
            }
            else {
                tableToExcel(tableid)
            }
            $("#toExcel").empty();
        }
        function Cleanup() {
            window.clearInterval(idTmr);
            CollectGarbage();
        }
        var tableToExcel = (function () {
            var uri = 'data:application/vnd.ms-excel;base64,',
                template = '<html><head><meta charset="UTF-8"></head><body><table>{table}</table></body></html>',
                base64 = function (s) {
                    return window.btoa(unescape(encodeURIComponent(s)))
                },
                format = function (s, c) {
                    return s.replace(/{(\w+)}/g,
                        function (m, p) {
                            return c[p];
                        })
                }
            return function (table, name) {
                if (!table.nodeType) table = document.getElementById(table)
                var ctx = {worksheet: name || 'Worksheet', table: table.innerHTML}
                window.location.href = uri + base64(format(template, ctx))
            }
        })()
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
        width: 80px;
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
        padding: 10px 0px;
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
        color: #333;
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

    #d1 th.forceUpdateValue {
        width: 150px;
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
    }

    .xline {
        border-bottom: solid 2px #000;
        height: 5px;
    }

    #orderList th {
        color: #333;
        font-size: 11px;
    }

    #changeButtonUn {
        position: absolute;
        left: 378px;
    }

    label.order {
        color: red;
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
                    商城兑换
                </li>
                <li id="goodManager"><a href="skipGoods"><img src="resources-1.0.0/static/images/activeLog.png"
                                                              width="25"
                                                              height="25" alt=""> 商品模块</a>
                </li>
                <li id="orderManager"><a style="color: #428bca;" href="skipOrders"><img
                        src="resources-1.0.0/static/images/activeLog.png" width="25"
                        height="25" alt=""> 订单模块</a>
                </li>
            </ul>
        </div>

    </div>
    <div id="middlebar">
        <div class="well span3" style="margin:50px 0;padding:0 20px 20px 20px;height: 80%;">
            <h3 style="color:green;">订单管理</h3>
            <HR class="xline">
            <p>订单号:<input id="serialno" name="serialno" type="text" style="width:320px"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                商品名称:<input id="name" name="name" type="text" style="width:200px"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                购买人:<input id="userPhone" name="userPhone" type="text" style="width:200px"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            </p>
            <p>订单时间:<input id="beginTime" type="text" name="beginTime" style="width:150px" class="Wdate"
                           onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"/>
                -<input id="endTime" type="text" name="endTime" style="width:150px" class="Wdate"
                        onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                订单状态:<select id="status" name="status" style="width:200px">
                    <option>全部</option>
                    <option>未发货</option>
                    <option>未收货</option>
                    <option>交易成功</option>
                    <option>交易失败</option>
                </select>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input id="search" type="button" value="搜索" name="search"/>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <input id="excel" type="button" value="导出excel" name="excel" onclick="method5('d2')"/>
            </p>
            <div id="1" style="margin-top: 10px; text-align: center;">
                <table id="d1">
                    <thead>
                    <tr>
                        <th>订单编号</th>
                        <th>商品名称</th>
                        <th>总价(元)</th>
                    </tr>
                    </thead>
                    <tbody id="orderList">
                    </tbody>
                </table>
            </div>
            <div id="News-Pagination" class="pagination"><!-- 这里显示分页 --></div>
        </div>
    </div>


</div>
</body>
</html>
