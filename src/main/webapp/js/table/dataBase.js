/**
 * Created by Administrator on 2016/1/7.
 */
var flag = true;
var id = "";
var lists = [];
var colums = [];
var cloumheights = 25;
var codes="";
function getTableData_(id_,list,cloum,cloumheight,size_){
    var code = $("#"+id_).html();
    codes=code;
    getData_(id_,list,cloum,cloumheight,size_);
}
function getData_(id_,list,cloum,cloumheight,size_){
    id=id_;
    lists=list;
    colums=cloum;
    cloumheights=cloumheight;
    var h = new Number(cloumheight);
    var code = codes;
    code=code+"<tbody>";
    for(var i=0;i<list.length;i++){
        code=code+"<tr style='line-height: "+h+"px'>";
        for(var j=0;j<cloum.length;j++){
            var cloumname=cloum[j];
            code = code+"<td align='center'>"+list[i][cloumname]+"</td>";
        }
        code=code+"</tr>";
    }
    code=code+"</tbody>";
    if($("#hid_").val()=="top"){
        code=code+"<tfoot><tr><td align='center' colspan='"+cloum.length+"'><div><a href='javascript:void(0);' title='展开' id='c_' onclick='c_()'><img src='../images/sort_asc.png'></a></div></td></tr></tfoot>";
    }else if($("#hid_").val()=="buttom"){
        code=code+"<tfoot><tr><td align='center' colspan='"+cloum.length+"'><div><a href='javascript:void(0);' title='收起' id='c_' onclick='c_()'><img src='../images/sort_desc.png'></a></div></td></tr></tfoot>";
    }
    $("#"+id_).html(code);
    var oTable = $('#'+id_).dataTable({
        "iDisplayLength":size_,
        "bProcessing": true,
        "bPaginate": flag, //翻页功能
        "bLengthChange": false, //改变每页显示数据数量
        "bFilter": true, //过滤功能
        "bSort": false, //排序功能
        "bInfo": true,//页脚信息
        "bAutoWidth": true,//自动宽度
        "oLanguage": {
            "sLengthMenu": "每页显示 _MENU_条",
            "sZeroRecords": "没有找到符合条件的数据",
            "sProcessing": "&lt;img src=’./loading.gif’ /&gt;",
            "sInfo": "当前第 _START_ - _END_ 条　共计 _TOTAL_ 条",
            "sInfoEmpty": "木有记录",
            "sInfoFiltered": "(从 _MAX_ 条记录中过滤)",
            "sSearch": "搜索：",
            "oPaginate": {
                "sFirst": "首页",
                "sPrevious": "前一页",
                "sNext": "后一页",
                "sLast": "尾页"
            }
        },//语言设置
        });
    var oSettings = oTable.fnSettings();
    oTable.fnPageChange( "next" );
    oTable.fnPageChange( "previous" );
}
function c_(){
    if(flag){
        flag=false;
    }else{
        flag=true;
    }
    if($("#hid_").val()=="top"){
        $("#hid_").val("buttom");
    }else{
        $("#hid_").val("top");
    }
    $("#"+id).html("");
    getData_(id,lists,colums,cloumheights);
}
