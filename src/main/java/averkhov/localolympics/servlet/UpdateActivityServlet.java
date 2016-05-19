/**
* Copyright 2014 -
* Licensed under the Academic Free License version 3.0
* http://opensource.org/licenses/AFL-3.0
*
* Authors: Karen Bacon
*/

package averkhov.localolympics.servlet;

import javax.servlet.http.*;

import java.io.IOException;

import averkhov.localolympics.db.Activity;



public class UpdateActivityServlet extends HttpServlet {
private static final long serialVersionUID = 1L;


@Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		String id = req.getParameter("id");
		String activityName = req.getParameter("activityName");
		String description = req.getParameter("description");
		String type = req.getParameter("type");
		String address = req.getParameter("address");
		String limitHour = req.getParameter("limithour");
		String limitMinute = req.getParameter("limitminute");
		String limitSecond = req.getParameter("limitsecond");
        Activity.UpdateActivity(id, activityName, description, type, address, limitHour, limitMinute, limitSecond);
        resp.sendRedirect("allActivity.jsp");
    }


}

