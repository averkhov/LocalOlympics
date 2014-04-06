/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Alex Verkhovtsev
 */



package localolympics.servlet;


import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import localolympics.db.Participant;

@SuppressWarnings("serial")
public class LoginSessionServlet extends HttpServlet {


    @Override
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser(); // or req.getUserPrincipal()
        
        HttpSession session = req.getSession();
        
        synchronized (session) {
			if (user == null) {
				resp.sendRedirect("/error.html");
			}else{
				session.setAttribute("user", user.getUserId());
				session.setAttribute("isAdmin", "false");
				if(Participant.getParticipantWithLoginID(user.getNickname())!=null ){
					if(Participant.getIsAdmin(Participant.getParticipantWithLoginID(user.getNickname())).equals("true")){
						session.setAttribute("isAdmin", "true");
					}
				}else if(Participant.getParticipantWithLoginID(user.getUserId())!=null){
					if (Participant.getIsAdmin(Participant.getParticipantWithLoginID(user.getUserId())).equals("true")){
						session.setAttribute("isAdmin", "true");
					}
				}

				resp.sendRedirect("/index.jsp");
			}

		}
		
    	resp.sendRedirect("/index.jsp");

    }
    
}
