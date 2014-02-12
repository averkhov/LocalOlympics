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
		String recordTime = req.getParameter("recordTime");
        Record.updateRecord(id, recordTime);
        resp.sendRedirect("/admin/allRecords.jsp");
    }
	

}

	