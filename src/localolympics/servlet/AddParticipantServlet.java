/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Karen
 */



package localolympics.servlet;

import java.io.IOException;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
        String participantID = req.getParameter("ParticipantLoginID");
        String participantFirstName = req.getParameter("participantFirstName");
        String participantLastName = req.getParameter("participantLastName");
        String gender = req.getParameter("gender");
        String birthday = req.getParameter("birthday");
        String activity = req.getParameter("activity");
        String aboutme = req.getParameter("aboutme");
        String address = req.getParameter("address");
        Participant.createParticipant(participantID, participantFirstName, participantLastName, gender, birthday, activity, aboutme, address);
        resp.sendRedirect("profile.jsp"); 
    }
}