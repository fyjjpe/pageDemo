package com.tpadsz.update.mvc.model;

import java.util.Date;

public class DStoreOrder {
    //订单Id
    private String id;
    //商品Id
    private String goodsId;
    //创建日期
    private Date createDate;
    //发货日期
    private Date sendDate;
    //完成日期
    private Date finishDate;
    //单笔订单价格, 没有数量概念
    private Integer price;
    //订单状态
    private Integer status;
    //商品名称
    private String name;
    //订单编号
    private String serialno;
    //用户ID
    private String uid;
    //收货人姓名1
    private String fullName;
    //用户注册手机号
    private String userPhone;
    //收货人手机号2
    private String mobile;
    //省份3
    private String province;
    //城市4
    private String city;
    //地址5
    private String address;
    //描述
    private String descr;
    //是否删除
    private Integer isDelete;
    //支付方式
    private String payType;
    //快递号
    private String expressNum;
    //物流信息
    private String logisticsMsg;
    //商品数量
    private Integer goodsNum;


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

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Integer getPrice() {
        return price;
    }

    public void setPrice(Integer price) {
        this.price = price;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSerialno() {
        return serialno;
    }

    public void setSerialno(String serialno) {
        this.serialno = serialno;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getDescr() {
        return descr;
    }

    public void setDescr(String descr) {
        this.descr = descr;
    }

    public String getPayType() {
        return payType;
    }

    public void setPayType(String payType) {
        this.payType = payType;
    }

    public String getExpressNum() {
        return expressNum;
    }

    public void setExpressNum(String expressNum) {
        this.expressNum = expressNum;
    }

    public String getLogisticsMsg() {
        return logisticsMsg;
    }

    public void setLogisticsMsg(String logisticsMsg) {
        this.logisticsMsg = logisticsMsg;
    }

    public String getGoodsId() {
        return goodsId;
    }

    public void setGoodsId(String goodsId) {
        this.goodsId = goodsId;
    }

    public Date getSendDate() {
        return sendDate;
    }

    public void setSendDate(Date sendDate) {
        this.sendDate = sendDate;
    }

    public Date getFinishDate() {
        return finishDate;
    }

    public void setFinishDate(Date finishDate) {
        this.finishDate = finishDate;
    }

    public Integer getIsDelete() {
        return isDelete;
    }

    public void setIsDelete(Integer isDelete) {
        this.isDelete = isDelete;
    }

    public Integer getGoodsNum() {
        return goodsNum;
    }

    public void setGoodsNum(Integer goodsNum) {
        this.goodsNum = goodsNum;
    }

    @Override
    public String toString() {
        return "DStoreOrder{" +
                "id='" + id + '\'' +
                ", goodsId=" + goodsId +
                ", createDate=" + createDate +
                ", sendDate=" + sendDate +
                ", finishDate=" + finishDate +
                ", price='" + price + '\'' +
                ", status='" + status + '\'' +
                ", name='" + name + '\'' +
                ", serialno='" + serialno + '\'' +
                ", uid='" + uid + '\'' +
                ", descr='" + descr + '\'' +
                ", isDelete='" + isDelete + '\'' +
                ", payType='" + payType + '\'' +
                ", expressNum='" + expressNum + '\'' +
                ", logisticsMsg='" + logisticsMsg + '\'' +
                ", goodsNum='" + goodsNum + '\'' +
                '}';
    }

    public String getUserPhone() {
        return userPhone;
    }

    public void setUserPhone(String userPhone) {
        this.userPhone = userPhone;
    }
}
