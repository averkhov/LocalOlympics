/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Alex Verkhovtsev
 */



package localolympics.servlet;


import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

@SuppressWarnings("serial")
public class LogoutServlet extends HttpServlet {

    @Override
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        //User user = userService.getCurrentUser();

        HttpSession session = req.getSession(false);
        //if(session != null){
        //	session.invalidate();
        //}
        session.removeAttribute("user");
        session.invalidate();
        for(int i=0; i<req.getCookies().length; i++){
        	Cookie cookie = req.getCookies()[i];
        	cookie.setMaxAge(-1);
        	resp.addCookie(cookie);
        }
        
        resp.sendRedirect(userService.createLogoutURL("/index.jsp"));
    }
    
}