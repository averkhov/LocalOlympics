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

import localolympics.db.Record;



public class AddRecordServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String value = req.getParameter("recordTime");
        String activityID = req.getParameter("activityID");
        String participantID = req.getParameter("participantID");
        Record.createRecord(participantID, activityID, value);
        
        System.out.println(req.getRequestURI());
        
        if(req.getRequestURI().equals("/auth/admin/addRecord"))
        	resp.sendRedirect("allRecords.jsp");
        
        if(req.getRequestURI().equals("/auth/user/addRecord"))
        	resp.sendRedirect("activity.jsp?activityID=" + activityID);
}
	
	

	

}

	