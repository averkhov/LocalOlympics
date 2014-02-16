package localolympics.servlet;

import java.io.IOException;

import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import localolympics.db.Participant;

/**
 * Update the admin profile.
 */
@SuppressWarnings("serial")
public class UpdateParticipantServlet extends HttpServlet {
	
	
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
                Participant.updateParticipantCommand(req.getParameter("ParticipantID"), req.getParameter("ParticipantName"),
                                req.getParameter("ParticipantLoginID"));

                resp.sendRedirect("/admin/allparticipant.jsp");
        }
}