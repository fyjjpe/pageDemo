package com.tpadsz.update.mvc.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Created by zhiyuan.zhao on 2017/5/17.
 */
@Controller
public class StoreGoodsController extends BaseDecodedController {
    /**
     *跳转到订单管理jsp
     */
    @RequestMapping(value ="skipGoods",method = RequestMethod.GET)
    public String skipGoods(){
        return "main";
    }
}
