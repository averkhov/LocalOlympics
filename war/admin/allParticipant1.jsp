<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="localolympics.db.Participant1" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
</head>
<body>
	<%
		List<Entity> allParticipants = Participant1.getFirstParticipants(100);
		if (allParticipants.isEmpty()) {
	%>
	<h1>No Participants Entered</h1>
	<%
		}else{	
	%>
	<table>
		<%
			for (Entity participant : allParticipants) {
					String participantName = Participant1.getName(participant);
					String id = Participant1.getStringID(participant);
		%>
		<tr>

			<td><%=participantName%> <%=id%></td>

		</tr>

		<%
			}

		}
		
		%>
	</table>
	
	 <form action="/admin/addParticipant1" method="post">
      <div><input type="text" name="participantName" size="50" /></div>
      <div><input type="submit" value="Add Participant" /></div>
    </form>
    <br/>
    <hr/>
    <form action = "/admin/deleteParticipant1" method = "post">
    <%
			for (Entity participant : allParticipants) {
					String participantName = Participant1.getName(participant);
					String id = Participant1.getStringID(participant);
		%>
		
			
		<input type= "radio" name="participant" value= <%=id%> /> <%=participantName %> <br/>

		

		<%
			}
    %>
    
	
    <div><input type = "submit" value = "Delete Participant" /></div>
    </form>
   <br/>
    <hr/>
   <form action = "/admin/updateParticipant1" method = "post">
   <%
   for (Entity participant : allParticipants) {
		String participantName = Participant1.getName(participant);
		String id = Participant1.getStringID(participant);
   %>
   <input type= "radio" name="participant" value= <%=id%> /> <%=participantName %> <br/>
   <input type = "text" name = "participant1" value = <%=participantName %> /> <br/>
   	<%
			}
    %>
    <div><input type = "submit" value = "Update Participant" /></div>
   </form>
</body>
</html>