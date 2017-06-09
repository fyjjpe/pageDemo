<%@ page language="java" pageEncoding="UTF-8"%>
<style>
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
    header span{
        cursor: pointer;
    }
    header span:hover{
        color: #f5f5f5;
    }
    .brand{
        color: #e4e6e8;;
        text-decoration: none;
    }
    .brand:hover{
        text-decoration: none;
        color: #f5f5f5;
    }
</style>
<%
    String a =  String.valueOf(session.getAttribute("userRealName"));
%>
<header>
    <img src="resources-1.0.0/static/images/upload.png"  width="30" height="30" style="margin: 0;"><a class="brand" href="leftToMain" > 老板锁屏实物商城后台</a>
    <div style="float: right;font-family: Microsoft YaHei;">
        <span id="user" style="line-height: 50px;color:#FFF;font-size: 16px;float: left">
                            <%=a %>
        </span>
        <span>
            <a href="logout"><img src="resources-1.0.0/static/images/logout.png" width="20" height="20" align="center" style="cursor: pointer;margin: 12px 15px"></a>
        </span>
    </div>

</header>