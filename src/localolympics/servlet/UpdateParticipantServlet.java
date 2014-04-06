/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Karen Bacon
 */


package localolympics.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import localolympics.db.Participant;

/**
 * Update the admin profile.
 */
@SuppressWarnings("serial")
public class UpdateParticipantServlet extends HttpServlet {


		protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
			String alias = req.getParameter("participantAlias");
            List<String> aliasList = Participant.getAliasList();
            for(int i=0; i<aliasList.size(); i++){
            	if(alias.equals(aliasList.get(i))){
            		resp.setContentType("text/html");
                    PrintWriter out = resp.getWriter();
                    out.println("<html>alert('Alias already in use please choose a different alias');</html>");
                    resp.sendRedirect("editProfile.jsp");
            	}
            }
	        Participant.updateParticipantCommand(req.getParameter("ParticipantID"), req.getParameter("participantFirstName"),
                    req.getParameter("participantLastName"), alias, req.getParameter("gender"),
                    req.getParameter("birthday"), req.getParameter("activity"),
                    req.getParameter("aboutme"), req.getParameter("address"), req.getParameter("ParticipantLoginID"), req.getParameter("isAdmin"));


                resp.sendRedirect("allparticipant.jsp");
        }
        /*private static final String GENDER_PROPERTY = "gender";
        private static final String BIRTHDAY_PROPERTY = "birthday";
        private static final String ACTIVITY_PROPERTY = "activity";
        private static final String ABOUTME_PROPERTY = "aboutme";*/
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        	String alias = req.getParameter("participantAlias");
            List<String> aliasList = Participant.getAliasList();
            for(int i=0; i<aliasList.size(); i++){
            	if(aliasList!=null && aliasList.size()>0){
            	if(alias.equals(aliasList.get(i))){
            		resp.setContentType("text/html");
                    PrintWriter out = resp.getWriter();
                    out.println("<html>alert('Alias already in use please choose a different alias');</html>");
                    resp.sendRedirect("editProfile.jsp");
            	}
            	}
            }
            Participant.updateParticipantCommand(req.getParameter("ParticipantID"), req.getParameter("participantFirstName"),
                            req.getParameter("participantLastName"),alias, req.getParameter("gender"),
                            req.getParameter("birthday"), req.getParameter("activity"),
                            req.getParameter("aboutme"), req.getParameter("address"), req.getParameter("ParticipantLoginID"), req.getParameter("isAdmin"));
            Participant.setValidatedEmail(Participant.getParticipant(req.getParameter("ParticipantID")), req.getParameter("validated"));
            
            resp.sendRedirect("profile.jsp");
    }
}