/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Alex Verkhovtsev
 */

package localolympics.servlet;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import localolympics.db.Participant;



public class ValidateEmailServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("id");
        
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        
        if(id.equals(user.getUserId())){
        	Participant.setValidatedEmail(Participant.getParticipantWithLoginID(user.getNickname()), "true");
        	resp.sendRedirect("/validated.html");
        }else{
        	resp.sendRedirect("/validationerror.html");
        }
        
}
	
	

	

}

	