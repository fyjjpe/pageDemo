package com.tpadsz.update.mvc.web.vo;

import java.io.Serializable;
import java.util.Date;

/**
 * Created by zhiyuan.zhao on 2017/5/15.
 */
public class SearchOrderParamsVo implements Serializable{

    private static final long serialVersionUID = -7691405007660961756L;
    //开始时间
    private Date beginTime;
    //结束时间
    private Date endTime;
    //商品名称
    private String name;
    //订单号
    private String serialno;
    //购买人手机号
    private String userPhone;
    //订单状态
    private Integer status;

    public SearchOrderParamsVo() {
    }

    public Date getBeginTime() {
        return beginTime;
    }

    public void setBeginTime(Date beginTime) {
        this.beginTime = beginTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
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

    public String getUserPhone() {
        return userPhone;
    }

    public void setUserPhone(String userPhone) {
        this.userPhone = userPhone;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "SearchOrderParamsVo{" +
                "beginTime=" + beginTime +
                ", endTime=" + endTime +
                ", name='" + name + '\'' +
                ", serialno='" + serialno + '\'' +
                ", userPhone='" + userPhone + '\'' +
                ", status=" + status +
                '}';
    }
}
