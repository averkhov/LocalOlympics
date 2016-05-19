/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Karen Bacon
 */

package localolympics.servlet;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;

import localolympics.db.Award;



public class AddAwardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String value = req.getParameter("awardName");
        String awardID = req.getParameter("awardID");
        String recordID = req.getParameter("recordID");
        String participantID = req.getParameter("participantID");
        Award.createAward(participantID, recordID, value);
        
        System.out.println(req.getRequestURI());
        
        //if(req.getRequestURI().equals("/auth/admin/addAward"))
        	resp.sendRedirect("allAwards.jsp");
        
        //if(req.getRequestURI().equals("/auth/user/addAward"))
        	//resp.sendRedirect("activity.jsp?activityID=" + activityID);
}
	
	

	

}

	