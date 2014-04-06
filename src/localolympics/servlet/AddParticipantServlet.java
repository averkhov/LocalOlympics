/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Karen
 */



package localolympics.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.List;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import localolympics.db.Participant;


/**
 * Answer to the HTTP Servlet to add a user. Redirect to the list of users. If error (e.g.
 * duplicated login ID) show error page.
 */
@SuppressWarnings("serial")
public class AddParticipantServlet extends HttpServlet {
        
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String participantID = req.getParameter("ParticipantLoginID");
            Participant.createParticipant(participantID);
            resp.sendRedirect("allparticipant.jsp");
    }
        
        
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    	
    	UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        
        
        String alias = req.getParameter("participantAlias");
        List<String> aliasList = Participant.getAliasList();
        for(int i=0; i<aliasList.size(); i++){
        	if(aliasList!=null && aliasList.size()>0){
        		System.out.println("AliasList value: " + aliasList.get(i));
        		System.out.println("Alias: " + alias);
        	if(alias.equals((String) aliasList.get(i))){

                resp.sendRedirect("editProfile.jsp");
        	}
        	}
        }
    	
    	if(sendValidationEmail(user.getEmail(), user.getUserId()) == true){
    		
	        String participantID = req.getParameter("ParticipantLoginID");
	        String participantFirstName = req.getParameter("participantFirstName");
	        String participantLastName = req.getParameter("participantLastName");
	        String gender = req.getParameter("gender");
	        String birthday = req.getParameter("birthday");
	        String activity = req.getParameter("activity");
	        String aboutme = req.getParameter("aboutme");
	        String address = req.getParameter("address");
	        Participant.createParticipant(participantID, participantFirstName, participantLastName, alias, gender, birthday, activity, aboutme, address, "false");
	        
	        resp.sendRedirect("profile.jsp"); 
    	}else{
    		resp.sendRedirect("/error.html");
    	}
    }
    
    protected boolean sendValidationEmail(String email, String id){
    	
    	Properties props = new Properties();
    	Session session = Session.getDefaultInstance(props, null);
    	
    	System.out.println(email);

    	String msgBody = "<html><body><p>Please validate your email. Click <a href=\"localolympics.appspot.com/validateEmail?id=" + id + "\">here.</a></p></body></html>";

    	try {
    	    Message msg = new MimeMessage(session);
    	    msg.setFrom(new InternetAddress("admin@localolympics.appspotmail.com"));
    	    msg.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
    	    msg.setSubject("Validate your email account for LocalOlympics");
    	    msg.setText(msgBody);
    	    Transport.send(msg);

    	} catch (AddressException e) {
    	    return false;
    	} catch (MessagingException e){
    		return false;
    	}
    	
    	
    	return true;
    }
}