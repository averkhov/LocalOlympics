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

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

@SuppressWarnings("serial")
public class LoginRequiredServlet extends HttpServlet {

    private static final Map<String, String> openIdProviders;
    static {
        openIdProviders = new HashMap<String, String>();
        openIdProviders.put("Google", "https://www.google.com/accounts/o8/id");
        openIdProviders.put("Yahoo", "yahoo.com");
        openIdProviders.put("MySpace", "myspace.com");
        openIdProviders.put("AOL", "aol.com");
        openIdProviders.put("MyOpenId.com", "myopenid.com");
    }

    @Override
    public void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser(); // or req.getUserPrincipal()
        Set<String> attributes = new HashSet<String>();

        resp.setContentType("text/html");
        PrintWriter out = resp.getWriter();

        if (user == null) {
        	out.println("Sign in at: ");
            for (String providerName : openIdProviders.keySet()) {
                String providerUrl = openIdProviders.get(providerName);
                String loginUrl = userService.createLoginURL(req
                        .getRequestURI(), null, providerUrl, attributes);
                out.println("[<a href=\"" + loginUrl + "\">" + providerName + "</a>] ");
            }
            resp.sendRedirect("/index.jsp");
        } else {
        	out.println("Login successful return to <a href=\"/index.jsp\">home</a>");
        	resp.sendRedirect("/index.jsp");
        }
    }
    
}