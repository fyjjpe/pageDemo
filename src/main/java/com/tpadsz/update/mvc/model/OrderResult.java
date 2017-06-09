package com.tpadsz.update.mvc.model;

import java.io.Serializable;

/**
 * 返回结果封装成一个类
 * Created by zhiyuan.zhao on 2017/5/15.
 */
public class OrderResult<T> implements Serializable{
    //返回结果码
    private String code;
    //返回信息
    private String msg;
    //返回数据
    private T data;

    public OrderResult() {
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    @Override
    public String toString() {
        return "OrderResult{" +
                "code='" + code + '\'' +
                ", msg='" + msg + '\'' +
                ", data=" + data +
                '}';
    }
}
