/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Alex Verkhovtsev
 */

package localolympics.servlet;

import javax.servlet.http.*;

import java.io.IOException;

import localolympics.db.Record;



public class UpdateRecordServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	
	@Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		String id = req.getParameter("id");
		String value = req.getParameter("recordTime");
        String activityID = req.getParameter("activityID");
        //String awardLevel = req.getParameter("awardLevel");
        String participantID = req.getParameter("participantID");
        String isValid = req.getParameter("isValid");
        Record.updateRecord(id, participantID, activityID, value, isValid);
        resp.sendRedirect("allRecords.jsp");
    }
	

}

	