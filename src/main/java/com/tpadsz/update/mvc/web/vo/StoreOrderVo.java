package com.tpadsz.update.mvc.web.vo;

import java.io.Serializable;
import java.util.Date;

/**
 * Created by zhiyuan.zhao on 2017/5/15.
 */
public class StoreOrderVo implements Serializable {
    private static final long serialVersionUID = 8665735680264495195L;
    //订单状态
    private Integer status;
    //订单号
    private String serialno;
    //订单时间
    private String createDate;
    //购买人信息
    private String userPhone;
    //收货人姓名
    private String fullName;
    //收货人手机号
    private String mobile;
    //收货人地址
    private String address;
    //商品名称
    private String name;
    //购买数量
    private Integer goodsNum;
    //总价格
    private Integer price;
    //快递
    private String logisticsMsg;
    //运单编号
    private String expressNum;


    public String getLogisticsMsg() {
        return logisticsMsg;
    }

    public void setLogisticsMsg(String logisticsMsg) {
        this.logisticsMsg = logisticsMsg;
    }

    public String getExpressNum() {
        return expressNum;
    }

    public void setExpressNum(String expressNum) {
        this.expressNum = expressNum;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getSerialno() {
        return serialno;
    }

    public void setSerialno(String serialno) {
        this.serialno = serialno;
    }

    public String getCreateDate() {
        return createDate;
    }

    public void setCreateDate(String createDate) {
        this.createDate = createDate;
    }

    public String getUserPhone() {
        return userPhone;
    }

    public void setUserPhone(String userPhone) {
        this.userPhone = userPhone;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getGoodsNum() {
        return goodsNum;
    }

    public void setGoodsNum(Integer goodsNum) {
        this.goodsNum = goodsNum;
    }

    public Integer getPrice() {
        return price;
    }

    public void setPrice(Integer price) {
        this.price = price;
    }
}
