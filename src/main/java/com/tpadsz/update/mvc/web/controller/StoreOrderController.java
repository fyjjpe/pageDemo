package com.tpadsz.update.mvc.web.controller;

import com.tpadsz.exception.NotExecutedDbException;
import com.tpadsz.update.mvc.model.DStoreOrder;
import com.tpadsz.update.mvc.model.OrderResult;
import com.tpadsz.update.mvc.model.Page;
import com.tpadsz.update.mvc.model.ResultDict;
import com.tpadsz.update.mvc.service.StoreOrderService;
import com.tpadsz.update.mvc.web.vo.SearchOrderParamsVo;
import com.tpadsz.update.mvc.web.vo.StoreOrderVo;
import com.tpadsz.utils.BeanMapper;
import net.sf.json.JSONArray;
import org.apache.commons.collections.map.HashedMap;
import org.apache.commons.fileupload.FileItemIterator;
import org.apache.commons.fileupload.FileItemStream;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.util.Streams;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;

/**
 * Created by zhiyuan.zhao on 2017/5/15.
 */
@Controller
public class StoreOrderController extends BaseDecodedController{
    @Resource(name="storeOrderService")
    private StoreOrderService storeOrderService;

    //定义每页显示的条数
    public static final int PAGE_SIZE = 2;

    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    /**
     * 将DB实体 -> VO实体转化
     *
     * @param order
     * @return VO order
     */
    private StoreOrderVo convert(DStoreOrder order) {
        if (order == null) {
            return null;
        }
        StoreOrderVo orderVo = BeanMapper.map(order, StoreOrderVo.class);
        if (order.getCreateDate() != null) {
            orderVo.setCreateDate(sdf.format(order.getCreateDate()));
        }
        if (order.getProvince() != null && order.getAddress() != null) {
            String totalAddress = order.getProvince() + " " + order.getAddress();
            orderVo.setAddress(totalAddress);
        }
        return orderVo;
    }

    /**
     *跳转到订单管理jsp
     */
    @RequestMapping(value ="skipOrders",method = RequestMethod.GET)
    public String skipOrder(){
      return "orderManager";
    }

    /**
     * 查询所有的订单,使用分页功能进行分页
     */
    @RequestMapping(value ="findOrders/p_{pageNo}",method = RequestMethod.GET)
    @ResponseBody
    public OrderResult<Page<StoreOrderVo>> findOrders(@PathVariable("pageNo") Integer pageNo){
        try {
            //创建返回结果类
            OrderResult<Page<StoreOrderVo>> result = new OrderResult<Page<StoreOrderVo>>();

            Page page = new Page(pageNo);
            //获取一页的数据
            page.setData(storeOrderService.getOrders(pageNo, PAGE_SIZE));
            //获取总条数
            page.setTotalNumber(storeOrderService.getTotalCount());

            if(page.getData() == null ||page.getData().size() < 0){
                //返回未知错误
                result.setCode(ResultDict.UNEXPECTED_ERROR.getCode());
                result.setMsg("未知错误");
                //返回数据为null
                result.setData(null);
                return result;
            }
            //返回订单
            result.setCode(ResultDict.SUCCESS.getCode());
            result.setMsg("成功");
            result.setData(page);
            return result;

        } catch (NotExecutedDbException e) {
            e.printStackTrace();
        }
        return null;

    }

    /**
     * 根据查询条件查询订单
     */
    @RequestMapping(value ="searchOrders",method = RequestMethod.POST)
    @ResponseBody
    public OrderResult<List<StoreOrderVo>> searchOrders(String serialno,String name,String userPhone,String beginTime,String endTime,String status) {
        //创建返回结果类
        OrderResult<List<StoreOrderVo>> result = new OrderResult<List<StoreOrderVo>>();
        //将传入参数转换为SearchOrderParamsVo对象
        try {
            SearchOrderParamsVo paramsVo = parse(serialno,name,userPhone,beginTime,endTime,status);
            //paramsVo为null,开始时间大于结束时间
            if(paramsVo == null){
                result.setCode(ResultDict.TIME_INPUT_ERROR.getCode());
                result.setMsg("开始时间大于结束时间");
                result.setData(null);
                return result;
            }
            //根据条件查询订单
            List<StoreOrderVo> orderVos = storeOrderService.findOrdersByConditions(paramsVo);
            if(orderVos == null ||orderVos.size() < 0){
                //返回未知错误
                result.setCode(ResultDict.UNEXPECTED_ERROR.getCode());
                result.setMsg("没有查询到任何结果!");
                //返回数据为null
                result.setData(null);
                return result;
            }
            //返回订单
            result.setCode(ResultDict.SUCCESS.getCode());
            result.setMsg("成功");
            result.setData(orderVos);
            return result;
        } catch (ParseException e) {
            result.setCode(ResultDict.PARAMS_NOT_PARSED.getCode());
            result.setMsg("参数解析错误");
            result.setData(null);
            return result;
        }
    }

    /**
     * 根据订单号查询订单详情
     *
     * @param req
     * @param res
     * @return
     * @throws ServletException
     * @throws IOException
     */
    @RequestMapping(value = "findOrderInfo", method = RequestMethod.POST)
    public void findOrderInfo(HttpServletRequest req, HttpServletResponse res) throws ServletException,
            IOException {
        res.setContentType("text/html;charset=utf-8");
        res.setHeader("Access-Control-Allow-Origin", "*");
        PrintWriter out = res.getWriter();
        String serialno = req.getParameter("serialno");
        DStoreOrder order = storeOrderService.getOrderBySerialno(serialno);
        Map<String, Object> result = new HashedMap();
        if (order == null) {
            //“404”表示查询订单异常
            result.put("resultMsg", ResultDict.LOGISTICS_INFO_ERROR.getValue());
        } else {
            result.put("order", convert(order));
            //"000"表示成功
            result.put("resultMsg", ResultDict.SUCCESS.getValue());
        }
        JSONArray obj = JSONArray.fromObject(result);
        String msg = obj.toString();
        out.print(msg);
    }

    /**
     * 1.更新订单物流信息（用于待发货详情处理，点击更新提交按钮）
     * 2.修改物流信息（用户已发货详情处理，点击修改提交按钮）
     *
     * @param req
     * @param res
     * @throws ServletException
     * @throws IOException
     */
    @RequestMapping(value = "updateOrderInfo", method = RequestMethod.POST)
    public void updateOrderInfo(HttpServletRequest req, HttpServletResponse res) throws ServletException,
            IOException {
        res.setContentType("text/html;charset=utf-8");
        res.setHeader("Access-Control-Allow-Origin", "*");
        PrintWriter out = res.getWriter();
        Map<String, Object> result = new HashedMap();
        String serialno = "";
        String logisticsMsg = "";
        String expressNum = "";
        ServletFileUpload upload = new ServletFileUpload();
        FileItemIterator iter = null; //得到所有的上传数据
        try {
            iter = upload.getItemIterator(req);
            while (iter.hasNext()) { //循环上传表单的元素
                FileItemStream item = iter.next();
                String name = item.getFieldName(); //得到元素名
                InputStream stream = item.openStream();
                if (item.isFormField()) {
                    if (name.equals("serialno")) {
                        serialno = Streams.asString(stream);
                    }
                    if (name.equals("logisticsMsg")) {
                        logisticsMsg = Streams.asString(stream, "UTF-8");
                    }
                    if (name.equals("expressNum")) {
                        expressNum = Streams.asString(stream);
                    }
                }
            }
        } catch (Exception e) {
            //“200”表示修改物流信息异常
            result.put("resultMsg", "物流信息异常");
            return;
        }
        DStoreOrder sOrder = new DStoreOrder();
        sOrder.setSerialno(serialno);
        sOrder.setLogisticsMsg(logisticsMsg);
        sOrder.setExpressNum(expressNum);
        DStoreOrder order = storeOrderService.updateOrderLogisticsInfo(sOrder);
        if (order == null) {
            //“404”表示修改物流信息异常
            result.put("resultMsg", ResultDict.LOGISTICS_INFO_ERROR.getValue());
        } else {
            result.put("order", convert(order));
            //"000"表示成功
            result.put("resultMsg", ResultDict.SUCCESS.getValue());
        }
        JSONArray obj = JSONArray.fromObject(result);
        String msg = obj.toString();
        out.print(msg);
    }

    /**
     * 将订单状态“2”完成改为状态“0”待发货（用于订单完成详情处理，用户点击修改为待处理状态按钮）
     *
     * @param req
     * @param res
     * @throws ServletException
     * @throws IOException
     */
    @RequestMapping(value = "updateOrderStatus", method = RequestMethod.POST)
    public void updateOrderStatus(HttpServletRequest req, HttpServletResponse res) throws ServletException,
            IOException {
        res.setContentType("text/html;charset=utf-8");
        res.setHeader("Access-Control-Allow-Origin", "*");
        PrintWriter out = res.getWriter();
        String serialno = req.getParameter("serialno");
        DStoreOrder order = storeOrderService.updateOrderStatus(serialno);

        Map<String, Object> result = new HashedMap();
        if (order == null) {
            //“404”表示修改订单状态异常
            result.put("resultMsg", ResultDict.LOGISTICS_INFO_ERROR.getValue());
        } else {
            result.put("order", convert(order));
            //"000"表示成功
            result.put("resultMsg", ResultDict.SUCCESS.getValue());
        }
        JSONArray obj = JSONArray.fromObject(result);
        String msg = obj.toString();
        out.print(msg);
    }

    /**
     * //将订单状态“0”：待发货  修改为“3”：失败  （用于订单待发货详情处理，将订单设定为失败）
     *
     * @param req
     * @param res
     * @throws ServletException
     * @throws IOException
     */
    @RequestMapping(value = "modifyOrderFailure", method = RequestMethod.POST)
    public void modifyOrderFailure(HttpServletRequest req, HttpServletResponse res) throws ServletException,
            IOException {
        res.setContentType("text/html;charset=utf-8");
        res.setHeader("Access-Control-Allow-Origin", "*");
        PrintWriter out = res.getWriter();
        String serialno = req.getParameter("serialno");
        DStoreOrder order = storeOrderService.modifyOrderFailure(serialno);

        Map<String, Object> result = new HashedMap();
        if (order == null) {
            //“404”表示修改订单状态异常
            result.put("resultMsg", ResultDict.LOGISTICS_INFO_ERROR.getValue());
        } else {
            result.put("order", convert(order));
            //"000"表示成功
            result.put("resultMsg", ResultDict.SUCCESS.getValue());
        }
        JSONArray obj = JSONArray.fromObject(result);
        String msg = obj.toString();
        out.print(msg);
    }

    /**
     * 将搜索订单参数转换为SearchOrderParamsVo对象
     */
    public SearchOrderParamsVo parse(String serialno,String name,String userPhone,String beginTime,String endTime,String status) throws ParseException {
        //创建参数对象
        SearchOrderParamsVo paramsVo = new SearchOrderParamsVo();
        if( "".equals(name) || name == null){
            paramsVo.setName(null);
        }else{
            //设置商品名
            paramsVo.setName(name);
        }
        if( "".equals(serialno) || serialno == null){
            paramsVo.setSerialno(null);
        }else{
            //设置订单号
            paramsVo.setSerialno(serialno);
        }
        if(userPhone == null ||  "".equals(userPhone)){
            paramsVo.setUserPhone(null);
        }else{
            //设置购买人信息
            paramsVo.setUserPhone(userPhone);
        }

        //判断开始时间是否输入
        if(beginTime == null || "".equals(beginTime)){
            //没输设置为null
            paramsVo.setBeginTime(null);
        }else{
            //输入则转换为Date类型
            paramsVo.setBeginTime(sdf.parse(beginTime));
        }
        //判断结束时间是否输入
        if(endTime == null || "".equals(endTime)){
            //没输设置为null
            paramsVo.setEndTime(null);
        }else{
            //输入则转换为Date类型
            paramsVo.setEndTime(sdf.parse(endTime));
        }
        //判断状态是否为空
        if("".equals(status) || status == null){
            //为空设置为null
            paramsVo.setStatus(null);
        }else{
            //输入则转换为相应的数字
            paramsVo.setStatus(Integer.parseInt(status));
            if(paramsVo.getStatus() == 4){
                paramsVo.setStatus(0);
            }
        }
        //如果开始时间都输入,但开始时间大于结束时间
        if(paramsVo.getBeginTime() != null && paramsVo.getEndTime() != null && paramsVo.getBeginTime().getTime()>paramsVo.getEndTime().getTime()){
            //返回null
            return null;
        }
        return paramsVo;
    }


}
