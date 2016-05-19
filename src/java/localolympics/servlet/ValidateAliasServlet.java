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

import localolympics.db.Participant;



public class ValidateAliasServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String alias = req.getParameter("alias");
        
        boolean result = false;
        
        if(Participant.getParticipantWithAlias(alias) == null){
    		result = true;
    	}
        
		resp.setStatus((result)?HttpServletResponse.SC_OK:HttpServletResponse.SC_NO_CONTENT);
        
}
	
	

	

}

	