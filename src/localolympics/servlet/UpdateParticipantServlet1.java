/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Anugh Shrestha
 */


package localolympics.servlet;

import java.io.IOException;


import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import localolympics.db.Participant1;
import javax.servlet.http.HttpServlet;

public class UpdateParticipantServlet1 extends HttpServlet {

	private static final long serialVersionUID = 1L;
	
	 protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String id = req.getParameter("participantID");
		String participantName = req.getParameter(id);
        Participant1.updateParticipant(id, participantName);
        resp.sendRedirect("allParticipant1.jsp");
    }
	public UpdateParticipantServlet1() {
		// TODO Auto-generated constructor stub
	}

}
