package localolympics.servlet;

import java.io.IOException;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import localolympics.db.Participant1;

public class DeleteParticipantServlet1 extends HttpServlet{
	private static final long serialVersionUID = 1L;

	 protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		 String id = req.getParameter("participantID");
         Participant1.deleteParticipant(id);
         resp.sendRedirect("/admin/allParticipant1.jsp");
 }
	

}
