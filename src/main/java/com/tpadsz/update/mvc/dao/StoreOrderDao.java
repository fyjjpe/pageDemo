package com.tpadsz.update.mvc.dao;

import com.tpadsz.update.mvc.model.DStoreOrder;
import com.tpadsz.update.mvc.web.vo.SearchOrderParamsVo;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by yuanjie.fang on 2017/5/15.
 */
@Repository("storeOrderDao")
public interface StoreOrderDao {
    //查询所有的订单
    List<DStoreOrder> findOrders();

    //按条件检索订单
    List<DStoreOrder> findOrdersByConditions(SearchOrderParamsVo searchOrderParamsVo);

    //通过订单serialno获取唯一订单
    DStoreOrder getOrderBySerialno(@Param("serialno") String serialno);

    //更新订单物流信息
    void updateOrderLogisticsInfo(DStoreOrder order);

    //将订单状态“2”完成改为状态“0”待发货（用于订单完成详情处理）
    void updateOrderStatus(@Param("serialno") String serialno);

    //将订单状态“0”：待发货  修改为“3”：失败  （用于订单待发货详情处理，将订单设定为失败）
    void modifyOrderFailure(@Param("serialno") String serialno);

    //-------------------以下代码测试分页功能
    //获取一页中所有的订单
    List<DStoreOrder>  queryList(@Param("pageno") int pageno,@Param("pagesize") int pagesize);

    //获取总的记录数
    int getTotalCount();

}
