package com.tpadsz.update.mvc.listener;

import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.Iterator;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;

@Service("testSessionListener")
public class TestSessionListener implements HttpSessionBindingListener {

    public void valueBound(HttpSessionBindingEvent arg0) {
        HttpSession session = arg0.getSession();
        ServletContext context = session.getServletContext();
        // 在application范围由一个HashSet集保存所有的session
        HashSet<HttpSession> sessionsSet = (HashSet<HttpSession>) context
                .getAttribute("sessions");
        if (sessionsSet == null) {
            sessionsSet = new HashSet<HttpSession>();
        }
        sessionsSet.add(session);
        context.setAttribute("sessions", sessionsSet);

    }

    public void valueUnbound(HttpSessionBindingEvent arg0) {
        HttpSession session = arg0.getSession();
        ServletContext application = session.getServletContext();
        HashSet<HttpSession> sessionsSet = (HashSet<HttpSession>) application
                .getAttribute("sessions");
        sessionsSet.remove(session);
    }

}
