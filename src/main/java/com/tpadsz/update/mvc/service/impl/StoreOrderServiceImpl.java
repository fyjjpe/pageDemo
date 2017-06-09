package com.tpadsz.update.mvc.service.impl;

import com.tpadsz.exception.NotExecutedDbException;
import com.tpadsz.update.mvc.dao.StoreOrderDao;
import com.tpadsz.update.mvc.model.DStoreOrder;
import com.tpadsz.update.mvc.service.StoreOrderService;
import com.tpadsz.update.mvc.utils.DateUtil;
import com.tpadsz.update.mvc.web.vo.SearchOrderParamsVo;
import com.tpadsz.update.mvc.web.vo.StoreOrderVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * Created by yuanjie.fang on 2017/5/15.
 */
@Service("storeOrderService")
public class StoreOrderServiceImpl implements StoreOrderService {

    @Resource(name = "storeOrderDao")
    private StoreOrderDao storeOrderDao;

    @Override
    public List<StoreOrderVo> findOrders() {
        try {
            List<DStoreOrder> orders = storeOrderDao.findOrders();
            if (orders == null || orders.size() == 0) {
                return null;
            }
            List<StoreOrderVo> orderVos = new ArrayList<StoreOrderVo>();
            for (DStoreOrder order : orders) {
                StoreOrderVo vo = convert(order);
                orderVos.add(vo);
            }
            return orderVos;
        } catch (Exception e) {
            throw e;
        }
    }

    @Override
    public List<StoreOrderVo> findOrdersByConditions(SearchOrderParamsVo params) {
        try {
            List<DStoreOrder> orders = storeOrderDao.findOrdersByConditions(params);
            if (orders == null || orders.size() == 0) {
                return null;
            }
            List<StoreOrderVo> orderVos = new ArrayList<StoreOrderVo>();
            for (DStoreOrder order : orders) {
                StoreOrderVo vo = convert(order);
                orderVos.add(vo);
            }
            return orderVos;
        } catch (Exception e) {
            throw e;
        }
    }

    private StoreOrderVo convert(DStoreOrder order) {
        StoreOrderVo vo = new StoreOrderVo();
        vo.setStatus(order.getStatus());
        vo.setSerialno(order.getSerialno());
        vo.setCreateDate(DateUtil.format(order.getCreateDate(), "yyyy-MM-dd HH:mm:ss"));
        vo.setUserPhone(order.getUserPhone());
        vo.setFullName(order.getFullName());
        vo.setMobile(order.getMobile());
        //收货人地址需要将省和具体地址拼接起来
        String address = order.getProvince().trim() + order.getAddress().trim();
        vo.setAddress(address);
        vo.setName(order.getName());
        vo.setGoodsNum(order.getGoodsNum());
        vo.setPrice(order.getPrice());
        return vo;
    }

    @Override
    //通过订单serialno获取唯一订单（点击订单详情页使用)
    public DStoreOrder getOrderBySerialno(String serialno) {
        if (serialno == null || serialno == "") {
            return null;
        }
        DStoreOrder dStoreOrder = null;
        try {
            dStoreOrder = storeOrderDao.getOrderBySerialno(serialno);
        } catch (Exception e) {
            return null;
        }
        return dStoreOrder;
    }

    @Override
    //1.更新订单物流信息（用于待发货详情处理，点击更新提交按钮）
    //2.修改物流信息（用户已发货详情处理，点击修改提交按钮）
    public DStoreOrder updateOrderLogisticsInfo(DStoreOrder order) {
        String serialno = order.getSerialno();
        if (serialno == null || serialno == "") {
            return null;
        }
        DStoreOrder dStoreOrder = null;
        try {
            dStoreOrder = storeOrderDao.getOrderBySerialno(serialno);
            dStoreOrder.setExpressNum(order.getExpressNum());
            dStoreOrder.setLogisticsMsg(order.getLogisticsMsg());
            dStoreOrder.setSendDate(new Date());
            dStoreOrder.setFinishDate(plusSixDays());
            storeOrderDao.updateOrderLogisticsInfo(dStoreOrder);
        } catch (Exception e) {
            return null;
        }
        return dStoreOrder;
    }

    /**
     * 当前时间加6天
     *
     * @return
     */
    public static Date plusSixDays() {
        Date finishDate = new Date();
        Calendar ca = Calendar.getInstance();
        ca.add(Calendar.DATE, 6);
        finishDate = ca.getTime();
        return finishDate;
    }

    @Override
    //将订单状态“2”完成改为状态“0”待发货（用于订单完成详情处理，用户点击修改为待处理状态按钮）
    public DStoreOrder updateOrderStatus(String serialno) {
        if (serialno == null || serialno == "") {
            return null;
        }
        DStoreOrder dStoreOrder = null;
        try {
            storeOrderDao.updateOrderStatus(serialno);
            dStoreOrder = storeOrderDao.getOrderBySerialno(serialno);
        } catch (Exception e) {
            return null;
        }
        return dStoreOrder;

    }

    @Override
    //将订单状态“0”：待发货  修改为“3”：失败  （用于订单待发货详情处理，将订单设定为失败）
    public DStoreOrder modifyOrderFailure(String serialno) {
        if (serialno == null || serialno == "") {
            return null;
        }
        DStoreOrder dStoreOrder = null;
        try {
            storeOrderDao.modifyOrderFailure(serialno);
            dStoreOrder = storeOrderDao.getOrderBySerialno(serialno);
        } catch (Exception e) {
            return null;
        }
        return dStoreOrder;
    }

    //获取一页的订单数
    @Override
    public List<DStoreOrder> getOrders(int pageno, int pagesize) throws NotExecutedDbException {
        try {
            return storeOrderDao.queryList((pageno - 1) * 2, pagesize);
        } catch (Exception e) {
            throw new NotExecutedDbException("bean:storeOrderDao, method:getOrders", e);
        }

    }

    //获取总的订单数量
    @Override
    public long getTotalCount() throws NotExecutedDbException {
        try {
            return storeOrderDao.getTotalCount();
        }catch (Exception e){
            throw new NotExecutedDbException("bean:storeOrderDao, method:getTotalCount", e);
        }
    }
}
