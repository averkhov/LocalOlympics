/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Anugh Shrestha
 */
package localolympics.servlet;

import javax.servlet.http.*;
import javax.servlet.ServletException;

import java.io.IOException;

import localolympics.db.Participant1;

public class AddParticipantServlet1 extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String participantName = req.getParameter("participantName");
        Participant1.createParticipant(participantName);
        resp.sendRedirect("allParticipant1.jsp");
}

	
	

}
