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
    <script>
        //全局变量
        var excel ="";
        //当前页数
        var pageNo = 1;
        //总共页数
        var pages = 0;
        //总数据量
        var num = 0;

        //页面加载完之后执行
        $(function () {
            fy1();

            //搜索功能
            $("#search").click(function () {
                //获取订单号
                var serialno = $("#serialno").val().trim();
                //商品名称
                var name = $("#name").val().trim();
                //购买人信息
                var userPhone = $("#userPhone").val().trim();
                //创建时间
                var beginTime = $("#beginTime").val().trim();
                //结束时间
                var endTime = $("#endTime").val().trim();
                //订单状态
                var status = $("#status").val().trim();
                //将发货状态中文改为对应的数字
                if (status === "未发货") {
                    status = 4;
                } else if (status === "未收货") {
                    status = 1;
                } else if (status === "交易成功") {
                    status = 2;
                } else if (status === "交易失败") {
                    status = 3;
                } else {
                    status = "";
                }
                //判断是否全部为空
                if (serialno == "" && name == "" && userPhone == "" && beginTime == "" && endTime == "" && status == "") {
                    //全部为空,则刷新页面
                    location.reload();
                    //判断开始或结束时间只有一个
                } else if ((beginTime == "" && endTime != "") || (beginTime != "" && endTime == "")) {
                    alert("时间输入有错!");
                } else {
                    $.ajax({
                        url: "searchOrders",
                        type: "post",
                        dataType: 'JSON',
                        data: {
                            "serialno": serialno,
                            "name": name,
                            "userPhone": userPhone,
                            "beginTime": beginTime,
                            "endTime": endTime,
                            "status": status
                        },
                        success: function (result) {
                            //返回状态码
                            var code = result.code;
                            //返回数据
                            var data = result.data;
                            //判断是否成功
                            if ("000" == code && data != null) {
                                excel = "";
                                toExcel(data);
                                console.log(excel)
                                $("#d1 tbody").remove();
                                if ($('#d1').hasClass('dataTable')) {
                                    $('#d1').dataTable().fnDestroy();
                                }
                                var list = [];
                                var str = "";
                                for (var i = 0; i < data.length; i++) {
                                    var serialno = data[i].serialno;
                                    if (data[i].status == 0) {
                                        str = "<a   data-toggle='modal' data-target='#ordersUndelivered' onclick=toConfigOrdersUndelivered('" + serialno + "');>" + "未发货";
                                    } else if (data[i].status == 1) {
                                        str = "<a   data-toggle='modal' data-target='#ordersDelivered' onclick=toConfigOrdersDelivered('" + serialno + "');>" + "未收货";
                                    } else if (data[i].status == 2) {
                                        str = "<a   data-toggle='modal' data-target='#ordersFinished' onclick=toConfigOrdersFinished('" + serialno + "');>" + "交易成功";
                                    } else {
                                        str = "<a   data-toggle='modal' data-target='#ordersFailed' onclick=toConfigOrdersFailed('" + serialno + "');>" + "交易失败";
                                    }
                                    list[i] = {
                                        "status": str,
                                        "serialno": serialno,
                                        "createDate": data[i].createDate,
                                        "userPhone": data[i].userPhone,
                                        "fullName": data[i].fullName,
                                        "mobile": data[i].mobile,
                                        "address": data[i].address,
                                        "name": data[i].name,
                                        "goodsNum": data[i].goodsNum,
                                        "price": data[i].price
                                    };

                                }
                                var cloums = ["status", "serialno", "createDate", "userPhone", "fullName", "mobile", "address", "name", "goodsNum", "price"];
                                getTableData_("d1", list, cloums, 20, 10);//容器ID，数据集合，数据属性集合（需要展示的属性名），行高,每页显示的条数


                            } else {
                                alert(result.msg);
                            }
                        },
                        error: function () {
                            alert("搜索订单失败!");
                        }
                    });
                }
            });

            $("#fenye").click(fy2);

        });

        //赋值全局变量excel
        function toExcel(data){
            excel ="";
            for(var i=0;i<data.length;i++){
                excel+="<tr><td>"+data[i].status+"</td>";
                excel+="<td>"+data[i].serialno+"</td>";
                excel+="<td>"+data[i].createDate+"</td>";
                excel+="<td>"+data[i].userPhone+"</td>";
                excel+="<td>"+data[i].fullName+"</td>";
                excel+="<td>"+data[i].mobile+"</td>";
                excel+="<td>"+data[i].address+"</td>";
                excel+="<td>"+data[i].name+"</td>";
                excel+="<td>"+data[i].goodsNum+"</td>";
                excel+="<td>"+data[i].price+"</td></tr>";
            }
        }

        function fy1() {
            //发送ajax请求,获取所有的订单
            $.ajax({
                url: "findOrders/pageNo_"+pageNo,
                type: "get",
                dataType: 'JSON',
                success: function (result) {
                    //返回状态码
                    var code = result.code;
                    //返回数据
                    var data = result.data.data;
                    pages = result.data.totalPages;
                    num = result.data.totalNum;
                    if ("000" === code && data != null && data.length >0) {
                        excel = "";
                        toExcel(data);
                        $("#d1 tbody").empty();
                        $("#records").empty();
                        $("#pages").empty();
                        $("#now").empty();
                        var str = "";
                        for (var i = 0; i < data.length; i++) {
                            var  str1 = "<tr><td>" +
                                data[i].status +"</td><td>" +
                                data[i].serialno +"</td><td>"+
                                data[i].createDate +"</td><td>"+
                                data[i].userPhone +"</td><td>"+
                                data[i].fullName +"</td><td>"+
                                data[i].mobile +"</td><td>"+
                                data[i].address +"</td><td>"+
                                data[i].name +"</td><td>"+
                                data[i].goodsNum +"</td><td>"+
                                data[i].price +"</td></tr>";
                            str += str1;
                        }
                        $("#d1 tbody").append(str);
                        $("#records").html(num);
                        $("#pages").html(pages);
                        $("#now").html(pageNo);

                    } else {
                        alert(result.msg);
                    }
                },
                error: function () {
                    alert("订单加载失败!");
                }

            });
        }
        
        function fy2(e) {

            var flag = false;
            //获取事件源
            var target = e.target;
            if(target.value  == "首页"){
                pageNo = 1;
                flag = true;
            }else if(target.value  == "上一页"){
                if(pageNo -1 <= 0){
                    pageNo = 1;
                    flag = true;
                }else{
                    pageNo --;
                    flag = true;
                }
            }else if(target.value  == "下一页"){
                if(parseInt(pageNo)+1 < parseInt(pages)){
                    pageNo ++;
                    flag = true;
                }else{
                    pageNo = pages;
                    flag = true;
                }
            }else if(target.value  == "末页"){
                pageNo = pages;
                flag = true;
            }else if(target.value  == "跳转"){
                if($("#ppp").val() != null && $("#ppp").val() != ""){
                    pageNo = $("#ppp").val();
                    flag = true;
                    $("#ppp").val("");
                }
            }

            if(flag){
                //发送ajax请求,获取所有的订单
                $.ajax({
                    url: "findOrders/pageNo_"+pageNo,
                    type: "get",
                    dataType: 'JSON',
                    success: function (result) {
                        //返回状态码
                        var code = result.code;
                        //返回数据
                        var data = result.data.data;
                        pages = result.data.totalPages;
                        num = result.data.totalNum;
                        if ("000" === code && data != null && data.length >0) {
                            excel = "";
                            toExcel(data);
                            $("#d1 tbody").empty();
                            $("#records").empty();
                            $("#pages").empty();
                            $("#now").empty();
                            var str = "";
                            for (var i = 0; i < data.length; i++) {
                                var  str1 = "<tr><td>" +
                                    data[i].status +"</td><td>" +
                                    data[i].serialno +"</td><td>"+
                                    data[i].createDate +"</td><td>"+
                                    data[i].userPhone +"</td><td>"+
                                    data[i].fullName +"</td><td>"+
                                    data[i].mobile +"</td><td>"+
                                    data[i].address +"</td><td>"+
                                    data[i].name +"</td><td>"+
                                    data[i].goodsNum +"</td><td>"+
                                    data[i].price +"</td></tr>";
                                str += str1;
                            }
                            $("#d1 tbody").append(str);
                            $("#records").html(num);
                            $("#pages").html(pages);
                            $("#now").html(pageNo);

                        } else {
                            alert(result.msg);
                        }
                    },
                    error: function () {
                        alert("订单加载失败!");
                    }

                });

            }
        }

        //未发货详情
        function toConfigOrdersUndelivered(serialno) {
            $.ajax({
                type: "post",
                url: "findOrderInfo",
                data: {"serialno": serialno},
                dataType: "json",
                success: function (data) {
                    $('#spanSerialnoUn').html("" + serialno + "");
                    $('#inputSerialnoUn').val("" + serialno + "");
                    $('#spanCreateDateUn').html("" + data[0].order.createDate + "");
                    $('#inputCreateDateUn').val("" + data[0].order.createDate + "");
                    $('#spanUserPhoneUn').html("" + data[0].order.userPhone + "");
                    $('#inputUserPhoneUn').val("" + data[0].order.userPhone + "");
                    $('#spanFullNameUn').html("" + data[0].order.fullName + "");
                    $('#inputFullNameUn').val("" + data[0].order.fullName + "");
                    $('#spanMobileUn').html("" + data[0].order.mobile + "");
                    $('#inputMobileUn').val("" + data[0].order.mobile + "");
                    $('#spanAddressUn').html("" + data[0].order.address + "");
                    $('#inputAddressUn').val("" + data[0].order.address + "");
                    $('#spanNameUn').html("" + data[0].order.name + "");
                    $('#inputNameUn').val("" + data[0].order.name + "");
                    $('#spanGoodsNumUn').html("" + data[0].order.goodsNum + "");
                    $('#inputGoodsNumUn').val("" + data[0].order.goodsNum + "");
                    $('#spanPriceUn').html("" + data[0].order.price + "");
                    $('#inputPriceUn').val("" + data[0].order.price + "");
                    $('#logisticsMsgUn').val("" + data[0].order.logisticsMsg + "");
                    $('#expressNumUn').val("" + data[0].order.expressNum + "");
                },
                error: function () {
                    alert("打开失败");
                }
            });
        }

        //已发货详情
        function toConfigOrdersDelivered(serialno) {
            $.ajax({
                type: "post",
                url: "findOrderInfo",
                data: {"serialno": serialno},
                dataType: "json",
                success: function (data) {
                    $('#spanSerialnoDel').html("" + serialno + "");
                    $('#inputSerialnoDel').val("" + serialno + "");
                    $('#spanCreateDateDel').html("" + data[0].order.createDate + "");
                    $('#inputCreateDateDel').val("" + data[0].order.createDate + "");
                    $('#spanUserPhoneDel').html("" + data[0].order.userPhone + "");
                    $('#inputUserPhoneDel').val("" + data[0].order.userPhone + "");
                    $('#spanFullNameDel').html("" + data[0].order.fullName + "");
                    $('#inputFullNameDel').val("" + data[0].order.fullName + "");
                    $('#spanMobileDel').html("" + data[0].order.mobile + "");
                    $('#inputMobileDel').val("" + data[0].order.mobile + "");
                    $('#spanAddressDel').html("" + data[0].order.address + "");
                    $('#inputAddressDel').val("" + data[0].order.address + "");
                    $('#spanNameDel').html("" + data[0].order.name + "");
                    $('#inputNameDel').val("" + data[0].order.name + "");
                    $('#spanGoodsNumDel').html("" + data[0].order.goodsNum + "");
                    $('#inputGoodsNumDel').val("" + data[0].order.goodsNum + "");
                    $('#spanPriceDel').html("" + data[0].order.price + "");
                    $('#inputPriceDel').val("" + data[0].order.price + "");
                    $('#logisticsMsgDel').val("" + data[0].order.logisticsMsg + "");
                    $('#expressNumDel').val("" + data[0].order.expressNum + "");
                },
                error: function () {
                    alert("打开失败");
                }
            });
        }

        //已完成详情
        function toConfigOrdersFinished(serialno) {
            $.ajax({
                type: "post",
                url: "findOrderInfo",
                data: {"serialno": serialno},
                dataType: "json",
                success: function (data) {
                    $('#spanSerialnoFin').html("" + serialno + "");
                    $('#spanCreateDateFin').html("" + data[0].order.createDate + "");
                    $('#spanUserPhoneFin').html("" + data[0].order.userPhone + "");
                    $('#spanFullNameFin').html("" + data[0].order.fullName + "");
                    $('#spanMobileFin').html("" + data[0].order.mobile + "");
                    $('#spanAddressFin').html("" + data[0].order.address + "");
                    $('#spanNameFin').html("" + data[0].order.name + "");
                    $('#spanGoodsNumFin').html("" + data[0].order.goodsNum + "");
                    $('#spanPriceFin').html("" + data[0].order.price + "");
                    $('#logisticsMsgFin').html("" + data[0].order.logisticsMsg + "");
                    $('#expressNumFin').html("" + data[0].order.expressNum + "");
                },
                error: function () {
                    alert("打开失败");
                }
            });
        }

        //交易失败详情
        function toConfigOrdersFailed(serialno){
            $.ajax({
                type: "post",
                url: "findOrderInfo",
                data: {"serialno": serialno},
                dataType: "json",
                success: function (data) {
                    $('#spanSerialnoFail').html("" + serialno + "");
                    $('#spanCreateDateFail').html("" + data[0].order.createDate + "");
                    $('#spanUserPhoneFail').html("" + data[0].order.userPhone + "");
                    $('#spanFullNameFail').html("" + data[0].order.fullName + "");
                    $('#spanMobileFail').html("" + data[0].order.mobile + "");
                    $('#spanAddressFail').html("" + data[0].order.address + "");
                    $('#spanNameFail').html("" + data[0].order.name + "");
                    $('#spanGoodsNumFail').html("" + data[0].order.goodsNum + "");
                    $('#spanPriceFail').html("" + data[0].order.price + "");
                    $('#logisticsMsgFail').html("" + data[0].order.logisticsMsg + "");
                    $('#expressNumFail').html("" + data[0].order.expressNum + "");
                },
                error: function () {
                    alert("打开失败");
                }
            });


        }

        //保存未发货的订单
        function saveOrdersUndelivered() {
            var formData = new FormData($("#ordersUndeliveredForm")[0]);
            //发送Ajax请求
            $.ajax({
                url: "updateOrderInfo",
                type: "post",
                data: formData,
                dataType: 'JSON',
                async: false,
                cache: false,
                contentType: false,
                processData: false,
                success: function (data) {
                    alert(data[0].resultMsg);
                    if (data[0].resultMsg == "成功") {
                        $('#ordersUndelivered').modal('hide');
                        window.location.reload();
                    }
                },
                error: function () {
                    alert("提交失败");
                }
            });
        }

        //保存已已发货的订单
        function saveOrdersDelivered() {
            var formData = new FormData($("#ordersDeliveredForm")[0]);
            //发送Ajax请求
            $.ajax({
                url: "updateOrderInfo",
                type: "post",
                data: formData,
                dataType: 'JSON',
                async: false,
                cache: false,
                contentType: false,
                processData: false,
                success: function (data) {
                    alert(data[0].resultMsg);
                    if (data[0].resultMsg == "成功") {
                        $('#ordersDelivered').modal('hide');
                        window.location.reload();
                    }
                },
                error: function () {
                    alert("保存失败");
                }
            });
        }

        //将交易成功订单状态改为未发货状态
        function changeStatusToUndelivered() {
            var serialno = document.getElementById("spanSerialnoFin").innerHTML;
            $.ajax({
                type: "post",
                url: "updateOrderStatus",
                data: {"serialno": serialno},
                dataType: "json",
                success: function (data) {
                    alert(data[0].resultMsg);
                    if(data[0].resultMsg == "成功"){
                        $('#ordersFinished').modal('hide');
                        $('#spanSerialnoUn').html("" + serialno + "");
                        $('#inputSerialnoUn').val("" + serialno + "");
                        $('#spanCreateDateUn').html("" + data[0].order.createDate + "");
                        $('#inputCreateDateUn').val("" + data[0].order.createDate + "");
                        $('#spanUserPhoneUn').html("" + data[0].order.userPhone + "");
                        $('#inputUserPhoneUn').val("" + data[0].order.userPhone + "");
                        $('#spanFullNameUn').html("" + data[0].order.fullName + "");
                        $('#inputFullNameUn').val("" + data[0].order.fullName + "");
                        $('#spanMobileUn').html("" + data[0].order.mobile + "");
                        $('#inputMobileUn').val("" + data[0].order.mobile + "");
                        $('#spanAddressUn').html("" + data[0].order.address + "");
                        $('#inputAddressUn').val("" + data[0].order.address + "");
                        $('#spanNameUn').html("" + data[0].order.name + "");
                        $('#inputNameUn').val("" + data[0].order.name + "");
                        $('#spanGoodsNumUn').html("" + data[0].order.goodsNum + "");
                        $('#inputGoodsNumUn').val("" + data[0].order.goodsNum + "");
                        $('#spanPriceUn').html("" + data[0].order.price + "");
                        $('#inputPriceUn').val("" + data[0].order.price + "");
                        $('#logisticsMsgUn').val("" + data[0].order.logisticsMsg + "");
                        $('#expressNumUn').val("" + data[0].order.expressNum + "");
                        $('#ordersUndelivered').modal('show');
                    }
                },
                error: function () {
                    alert("修改失败");
                }
            });
        }

        //将未发货状态改为交易失败
        function changeStatusToFailed() {
            var serialno = document.getElementById("spanSerialnoUn").innerHTML;
            $.ajax({
                type: "post",
                url: "modifyOrderFailure",
                data: {"serialno": serialno},
                dataType: "json",
                success: function (data) {
                    alert(data[0].resultMsg);
                    if(data[0].resultMsg == "成功") {
                        $('#ordersUndelivered').modal('hide');
                        $('#spanSerialnoFail').html("" + serialno + "");
                        $('#spanCreateDateFail').html("" + data[0].order.createDate + "");
                        $('#spanUserPhoneFail').html("" + data[0].order.userPhone + "");
                        $('#spanFullNameFail').html("" + data[0].order.fullName + "");
                        $('#spanMobileFail').html("" + data[0].order.mobile + "");
                        $('#spanAddressFail').html("" + data[0].order.address + "");
                        $('#spanNameFail').html("" + data[0].order.name + "");
                        $('#spanGoodsNumFail').html("" + data[0].order.goodsNum + "");
                        $('#spanPriceFail').html("" + data[0].order.price + "");
                        $('#logisticsMsgFail').html("" + data[0].order.logisticsMsg + "");
                        $('#expressNumFail').html("" + data[0].order.expressNum + "");
                        $('#ordersFailed').modal('show');
                    }
                },
                error: function () {
                    alert("修改失败");
                }
            });
        }
    </script>

    <script>
        //第五种方法
        var idTmr;
        function  getExplorer() {
            var explorer = window.navigator.userAgent ;
            //ie
            if (explorer.indexOf("MSIE") >= 0) {
                return 'ie';
            }
            //firefox
            else if (explorer.indexOf("Firefox") >= 0) {
                return 'Firefox';
            }
            //Chrome
            else if(explorer.indexOf("Chrome") >= 0){
                return 'Chrome';
            }
            //Opera
            else if(explorer.indexOf("Opera") >= 0){
                return 'Opera';
            }
            //Safari
            else if(explorer.indexOf("Safari") >= 0){
                return 'Safari';
            }
        }
        function method5(tableid) {
            $("#toExcel").append(excel);
            if(getExplorer()=='ie')
            {
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
            else
            {
                tableToExcel(tableid)
            }
            $("#toExcel").empty();
        }
        function Cleanup() {
            window.clearInterval(idTmr);
            CollectGarbage();
        }
        var tableToExcel = (function() {
            var uri = 'data:application/vnd.ms-excel;base64,',
                template = '<html><head><meta charset="UTF-8"></head><body><table>{table}</table></body></html>',
                base64 = function(s) { return window.btoa(unescape(encodeURIComponent(s))) },
                format = function(s, c) {
                    return s.replace(/{(\w+)}/g,
                        function(m, p) { return c[p]; }) }
            return function(table, name) {
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
        left:378px;
    }

    label.order{
        color:red;
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
                <li id="goodManager"><a href="skipGoods"><img src="resources-1.0.0/static/images/activeLog.png" width="25"
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
                        <th>订单状态</th>
                        <th>订单编号</th>
                        <th>订单时间</th>
                        <th>购买人信息</th>
                        <th>收货人姓名</th>
                        <th>收货人手机号</th>
                        <%--<th CLASS="forceUpdateValue">强制升级值</th>--%>
                        <th>收货人地址</th>
                        <th>商品名称</th>
                        <th>购买数量</th>
                        <th>总价(元)</th>
                    </tr>
                    </thead>
                    <tbody id="orderList">
                    </tbody>
                </table>
                <table id="d2" style="display:none;">
                    <thead>
                        <tr>
                         <th>订单状态</th>
                            <th>订单编号</th>
                            <th>订单时间</th>
                            <th>购买人信息</th>
                            <th>收货人姓名</th>
                            <th>收货人手机号</th>
                            <th>收货人地址</th>
                            <th>商品名称</th>
                            <th>购买数量</th>
                            <th>总价(元)</th>
                        </tr>
                    </thead>
                    <tbody id="toExcel">

                    </tbody>

                </table>
            </div>
            <div id="fenye">
                    <input type="button" value="首页" >
                    <input type="button" value="上一页">
                    <input type="button" value="下一页">
                    <input type="button" value="末页">
                    <input type="button" value="跳转">
                    <input id="ppp" type="text" style="width:100px">页
                    当前<span id="now"></span>页
                    共<span id="records"></span>条记录
                    共<span id="pages"></span>页
            </div>
        </div>
    </div>
    <!--模态框-->
    <div class="modal fade" id="ordersUndelivered" tabindex="-1" role="dialog"
         aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog classedit">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close"
                            data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h3 class="modal-title">
                        订单详情
                    </h3>
                </div>
                <div class="modal-body">
                    <div>
                        <form id="ordersUndeliveredForm" enctype="multipart/form-data">
                            <p>
                                <label class='order'> 订单状态:待发货</label>
                            </p>
                            <p>
                                <label> 订单编号：</label>
                                <span id="spanSerialnoUn"></span>
                                <input id="inputSerialnoUn" style="visibility:hidden;display: none" name="serialno"
                                       type="text" value="">
                            </p>
                            <p>
                                <label>
                                    订单时间：
                                </label>
                                <span id="spanCreateDateUn"></span>
                                <input id="inputCreateDateUn" style="visibility:hidden;display: none" name="createDate"
                                       type="text" value="">
                            </p>
                            <p>
                                <label>
                                    购买人手机号：
                                </label>
                                <span id="spanUserPhoneUn"></span>
                                <input id="inputUserPhoneUn" style="visibility:hidden;display: none" name="userPhone" type="text"
                                       value="">
                            </p>
                            <p>
                                <label class="order">
                                    收货人信息：
                                </label>
                            </p>
                            <p>
                                <label>
                                    收货人姓名：
                                </label>
                                <span id="spanFullNameUn"></span>
                                <input id="inputFullNameUn" style="visibility:hidden;display: none" name="fullName" type="text"
                                       value="">
                            </p>
                            <p>
                                <label>
                                    收货人手机号：
                                </label>
                                <span id="spanMobileUn"></span>
                                <input id="inputMobileUn" style="visibility:hidden;display: none" name="mobile" type="text"
                                       value="">
                            </p>
                            <p>
                                <label>
                                    收货人地址：
                                </label>
                                <span id="spanAddressUn"></span>
                                <input id="inputAddressUn" style="visibility:hidden;display: none" name="address" type="text"
                                       value="">
                            </p>
                            <p>
                                <label class="order">
                                    商品信息：
                                </label>
                            </p>
                            <p>
                                <label>
                                    商品名称:
                                </label>
                                <span id="spanNameUn"></span>
                                <input id="inputNameUn" style="visibility:hidden;display: none" name="name" type="text"
                                       value="">
                            </p>
                            <p>
                                <label>
                                    购买数量：
                                </label>
                                <span id="spanGoodsNumUn"></span>
                                <input id="inputGoodsNumUn" style="visibility:hidden;display: none" name="goodsNum" type="text"
                                       value="">
                            </p>
                            <p>
                                <label>
                                    总价：
                                </label>
                                <span id="spanPriceUn"></span>
                                <input id="inputPriceUn" style="visibility:hidden;display: none" name="price" type="text"
                                       value="">
                            </p>
                            <p>
                                <label class="order">
                                    物流信息：
                                </label>
                            </p>
                            <p>
                                <label>
                                    快递：
                                </label>
                                <input id="logisticsMsgUn"  name="logisticsMsg" type="text" value="">
                            </p>
                            <p>
                                <label>
                                    运单编号：
                                </label>
                                <input id="expressNumUn"  name="expressNum" type="text" value="">
                            </p>
                            <input type="button" class="button"  value="提交" onclick="saveOrdersUndelivered()"/>
                            <input type="button" class="button" data-dismiss="modal" aria-hidden="true" value="取消"/>
                            <input type="button" id="changeButtonUn"  class="button"  value="修改状态为交易失败" onclick="changeStatusToFailed()"/>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="ordersDelivered" tabindex="-1" role="dialog"
         aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog classedit">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close"
                            data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h3 class="modal-title">
                        订单详情
                    </h3>
                </div>
                <div class="modal-body">
                    <div>
                        <form id="ordersDeliveredForm" enctype="multipart/form-data">
                            <p>
                                <label class='order'> 订单状态:待收货</label>
                            </p>
                            <p>
                                <label> 订单编号：</label>
                                <span id="spanSerialnoDel"></span>
                                <input id="inputSerialnoDel" style="visibility:hidden;display: none" name="serialno"
                                       type="text" value="">
                            </p>
                            <p>
                                <label>
                                    订单时间：
                                </label>
                                <span id="spanCreateDateDel"></span>
                                <input id="inputCreateDateDel" style="visibility:hidden;display: none" name="createDate"
                                       type="text" value="">
                            </p>
                            <p>
                                <label>
                                    购买人手机号：
                                </label>
                                <span id="spanUserPhoneDel"></span>
                                <input id="inputUserPhoneDel" style="visibility:hidden;display: none" name="userPhone" type="text"
                                       value="">
                            </p>
                            <p>
                                <label class="order">
                                    收货人信息：
                                </label>
                            </p>
                            <p>
                                <label>
                                    收货人姓名：
                                </label>
                                <span id="spanFullNameDel"></span>
                                <input id="inputFullNameDel" style="visibility:hidden;display: none" name="fullName" type="text"
                                       value="">
                            </p>
                            <p>
                                <label>
                                    收货人手机号：
                                </label>
                                <span id="spanMobileDel"></span>
                                <input id="inputMobileDel" style="visibility:hidden;display: none" name="mobile" type="text"
                                       value="">
                            </p>
                            <p>
                                <label>
                                    收货人地址：
                                </label>
                                <span id="spanAddressDel"></span>
                                <input id="inputAddressDel" style="visibility:hidden;display: none" name="address" type="text"
                                       value="">
                            </p>
                            <p>
                                <label class="order">
                                    商品信息：
                                </label>
                            </p>
                            <p>
                                <label>
                                    商品名称:
                                </label>
                                <span id="spanNameDel"></span>
                                <input id="inputNameDel" style="visibility:hidden;display: none" name="name" type="text"
                                       value="">
                            </p>
                            <p>
                                <label>
                                    购买数量：
                                </label>
                                <span id="spanGoodsNumDel"></span>
                                <input id="inputGoodsNumDel" style="visibility:hidden;display: none" name="goodsNum" type="text"
                                       value="">
                            </p>
                            <p>
                                <label>
                                    总价：
                                </label>
                                <span id="spanPriceDel"></span>
                                <input id="inputPriceDel" style="visibility:hidden;display: none" name="price" type="text"
                                       value="">
                            </p>
                            <p>
                                <label class="order">
                                    物流信息：
                                </label>
                            </p>
                            <p>
                                <label>
                                    快递：
                                </label>
                                <input id="logisticsMsgDel"  name="logisticsMsg" type="text" value="">
                            </p>
                            <p>
                                <label>
                                    运单编号：
                                </label>
                                <input id="expressNumDel"  name="expressNum" type="text" value="">
                            </p>
                            <input type="button" class="button"  value="保存" onclick="saveOrdersDelivered()"/>
                            <input type="button" class="button" data-dismiss="modal" aria-hidden="true" value="取消" />
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="ordersFinished" tabindex="-1" role="dialog"
         aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog classedit">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close"
                            data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h3 class="modal-title">
                        订单详情
                    </h3>
                </div>
                <div class="modal-body">
                    <div>
                        <form id="ordersFinishedForm" enctype="multipart/form-data">
                            <p>
                                <label class='order'> 订单状态:交易成功</label>
                            </p>
                            <p>
                                <label> 订单编号：</label>
                                <span id="spanSerialnoFin"></span>
                            </p>
                            <p>
                                <label>
                                    订单时间：
                                </label>
                                <span id="spanCreateDateFin"></span>
                            </p>
                            <p>
                                <label>
                                    购买人手机号：
                                </label>
                                <span id="spanUserPhoneFin"></span>
                            </p>
                            <p>
                                <label class="order">
                                    收货人信息：
                                </label>
                            </p>
                            <p>
                                <label>
                                    收货人姓名：
                                </label>
                                <span id="spanFullNameFin"></span>
                            </p>
                            <p>
                                <label>
                                    收货人手机号：
                                </label>
                                <span id="spanMobileFin"></span>
                            </p>
                            <p>
                                <label>
                                    收货人地址：
                                </label>
                                <span id="spanAddressFin"></span>
                            </p>
                            <p>
                                <label class="order">
                                    商品信息：
                                </label>
                            </p>
                            <p>
                                <label>
                                    商品名称:
                                </label>
                                <span id="spanNameFin"></span>
                            </p>
                            <p>
                                <label>
                                    购买数量：
                                </label>
                                <span id="spanGoodsNumFin"></span>
                            </p>
                            <p>
                                <label>
                                    总价：
                                </label>
                                <span id="spanPriceFin"></span>
                            </p>
                            <p>
                                <label class="order">
                                    物流信息：
                                </label>
                            </p>
                            <p>
                                <label>
                                    快递：
                                </label>
                                <span id="logisticsMsgFin"></span>
                            </p>
                            <p>
                                <label>
                                    运单编号：
                                </label>
                                <span id="expressNumFin"></span>
                            </p>
                            <input type="button" class="button"  value="修改状态为待发货" onclick="changeStatusToUndelivered()"/>
                            <input type="button" class="button" data-dismiss="modal" aria-hidden="true" value="取消"/>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="ordersFailed" tabindex="-1" role="dialog"
         aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog classedit">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close"
                            data-dismiss="modal" aria-hidden="true">
                        &times;
                    </button>
                    <h3 class="modal-title">
                        订单详情
                    </h3>
                </div>
                <div class="modal-body">
                    <div>
                        <p>
                            <label class='order'> 订单状态:交易失败</label>
                        </p>
                        <p>
                            <label> 订单编号：</label>
                            <span id="spanSerialnoFail"></span>
                        </p>
                        <p>
                            <label>
                                订单时间：
                            </label>
                            <span id="spanCreateDateFail"></span>
                        </p>
                        <p>
                            <label>
                                购买人手机号：
                            </label>
                            <span id="spanUserPhoneFail"></span>
                        </p>
                        <p>
                            <label class="order">
                                收货人信息：
                            </label>
                        </p>
                        <p>
                            <label>
                                收货人姓名：
                            </label>
                            <span id="spanFullNameFail"></span>
                        </p>
                        <p>
                            <label>
                                收货人手机号：
                            </label>
                            <span id="spanMobileFail"></span>
                        </p>
                        <p>
                            <label>
                                收货人地址：
                            </label>
                            <span id="spanAddressFail"></span>
                        </p>
                        <p>
                            <label class="order">
                                商品信息：
                            </label>
                        </p>
                        <p>
                            <label>
                                商品名称:
                            </label>
                            <span id="spanNameFail"></span>
                        </p>
                        <p>
                            <label>
                                购买数量：
                            </label>
                            <span id="spanGoodsNumFail"></span>
                        </p>
                        <p>
                            <label>
                                总价：
                            </label>
                            <span id="spanPriceFail"></span>
                        </p>
                        <p>
                            <label class="order">
                                物流信息：
                            </label>
                        </p>
                        <p>
                            <label>
                                快递：
                            </label>
                            <span id="logisticsMsgFail"></span>
                        </p>
                        <p>
                            <label>
                                运单编号：
                            </label>
                            <span id="expressNumFail"></span>
                        </p>
                    </div>
                </div>
                <div class="modal-footer">
                </div>
            </div>
        </div>
    </div>

</div>
</body>
</html>
