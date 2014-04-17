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

import localolympics.db.Activity;

public class AddActivityServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String ActivityName = req.getParameter("ActivityName");
		String description = req.getParameter("description");
		String type = req.getParameter("type");
		String limitHour = req.getParameter("limithour");
		String limitMinute = req.getParameter("limitminute");
		String limitSecond = req.getParameter("limitsecond");
		String address = req.getParameter("address");
		Activity.createActivity(ActivityName, description, type, limitHour, 
				limitMinute, limitSecond, address);
		resp.sendRedirect("allActivity.jsp");
	}
	
	
	@Override
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		String ActivityName = req.getParameter("ActivityName");
		String description = req.getParameter("description");
		String type = req.getParameter("type");
		String limitHour = req.getParameter("limithour");
		String limitMinute = req.getParameter("limitminute");
		String limitSecond = req.getParameter("limitsecond");
		String address = req.getParameter("address");
		Activity.createActivity(ActivityName, description, type, limitHour, 
				limitMinute, limitSecond, address);
		resp.sendRedirect("allActivity.jsp");
		
    }

}