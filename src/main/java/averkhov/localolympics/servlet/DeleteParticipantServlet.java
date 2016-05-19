/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Karen Bacon
 */


package averkhov.localolympics.servlet;


import java.io.IOException;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import averkhov.localolympics.db.Participant;

@SuppressWarnings("serial")
public class DeleteParticipantServlet extends HttpServlet{


	

	        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

	                boolean result=Participant.deleteParticipantCommand(req.getParameter("ParticipantID"));
	                resp.setStatus((result)?HttpServletResponse.SC_OK:HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	        }
	}

