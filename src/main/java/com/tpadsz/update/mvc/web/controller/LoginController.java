package com.tpadsz.update.mvc.web.controller;

import com.tpadsz.update.mvc.model.User;
import com.tpadsz.update.mvc.service.LoginValidateService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Created by zhiyuan.zhao on 2017/5/11.
 */
@Controller
public class LoginController {

    /**
     * 登录方法
     * @param req
     * @param res
     * @throws ServletException
     * @throws IOException
     */
    @RequestMapping("login")
    public void login(HttpServletRequest req,
                      HttpServletResponse res) throws ServletException, IOException {
        LoginValidateService loginValidate = new LoginValidateService();
        User user = new User();
        user.setUid(req.getParameter("userName"));
        user.setPassword(req.getParameter("pwd"));
        String loginUser = loginValidate.authenricate(user.getUid(), user.getPassword());
        if (loginUser != null && !loginUser.equals("")) {
            req.getSession().setAttribute("userRealName", loginUser);
            req.getRequestDispatcher("WEB-INF/main.jsp").forward(req, res);
        } else {
            req.setAttribute("msg", loginValidate.msg);
            req.getRequestDispatcher("index.jsp").forward(req, res);
        }
    }

    /**
     * 退出方法
     * @param req
     * @param res
     * @throws ServletException
     * @throws IOException
     */
    @RequestMapping(value = "logout", method = RequestMethod.GET)
    public void logout(HttpServletRequest req, HttpServletResponse res) throws ServletException,
            IOException {
        //销毁session
        if (req.getSession().getAttribute("userRealName") != null) {
            req.getSession().removeAttribute("userRealName");
        }
        req.getRequestDispatcher(
                "index.jsp").forward(req, res);
    }


}
