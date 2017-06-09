package com.tpadsz.update.mvc.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import java.util.List;


public class LogInterceptor extends HandlerInterceptorAdapter {
	
	public static final Logger SYSTEM = Logger.getLogger("systemLog");

	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {
		String name = (String) request.getSession().getAttribute("userRealName");
		String requestUrl = request.getRequestURI().replace(request.getContextPath(), "");
		if(null != allowUrls && allowUrls.length>=1) {
			for (String allowUrl : allowUrls) {
				if (requestUrl.contains(allowUrl)) {
					return true;
				}
			}
		}
			if (name != null) {
		} else {
			response.sendRedirect("/bossLocker-store-hq");
			return false;
		}
		return true;
	}

	@Override
	public void postHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		super.postHandle(request, response, handler, modelAndView);
	}


	public String[] allowUrls;//还没发现可以直接配置不拦截的资源，所以在代码里面来排除

	public void setAllowUrls(String[] allowUrls) {
		this.allowUrls = allowUrls;
	}
}
