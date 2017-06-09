package com.tpadsz.update.mvc.service;

import com.tpadsz.exception.NotExecutedDbException;
import com.tpadsz.update.mvc.model.DStoreOrder;
import com.tpadsz.update.mvc.web.vo.SearchOrderParamsVo;
import com.tpadsz.update.mvc.web.vo.StoreOrderVo;

import java.util.List;

/**
 * Created by zhiyuan.zhao on 2017/5/15.
 */
public interface StoreOrderService {
    //查询所有的订单
    List<StoreOrderVo> findOrders();

    //按条件检索订单
    List<StoreOrderVo> findOrdersByConditions(SearchOrderParamsVo params);

    //通过订单serialno获取唯一订单（点击订单详情页使用）
    DStoreOrder getOrderBySerialno(String serialno);

    //1.更新订单物流信息（用于待发货详情处理，点击更新提交按钮）
    //2.修改物流信息（用户已发货详情处理，点击修改提交按钮）
    DStoreOrder updateOrderLogisticsInfo(DStoreOrder order);

    //将订单状态“2”：完成  改为状态“0”：待发货 （用于订单完成详情处理，用户点击修改为待处理状态按钮）
    DStoreOrder updateOrderStatus(String serialno);

    //将订单状态“0”：待发货  修改为“3”：失败  （用于订单待发货详情处理，将订单设定为失败）
    DStoreOrder modifyOrderFailure(String serialno);


    //分页展示测试---------------
    //获取一页的订单数
    List<DStoreOrder> getOrders(int pageno, int pagesize) throws NotExecutedDbException;

    //获取总的订单数
    long getTotalCount() throws NotExecutedDbException;
}
