/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Karen Bacon
 */

package localolympics.servlet;

import javax.servlet.http.*;

import java.io.IOException;

import localolympics.db.Award;



public class UpdateAwardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	
	@Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		String id = req.getParameter("id");
		String value = req.getParameter("awardName");
        String recordID = req.getParameter("recordID");
        String participantID = req.getParameter("participantID");
        Award.updateAward(id, participantID, recordID, value);
        resp.sendRedirect("allAwards.jsp");
    }
	

}

	