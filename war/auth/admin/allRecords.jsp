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
<%@ page import="localolympics.db.Record" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>



<!--  
   Copyright 2014 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Alex Verkhovtsev 
   
   Version 0.1 - Spring 2014
-->



<html>

  <head>
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
    
    <title>Local Olympics - All Records</title>
    
    
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    
    <script>
	

    function editButton(recordID) {
    	document.getElementById("view"+recordID).style.display = "none";
    	document.getElementById("edit"+recordID).style.display = "";
    }
    
    function cancelButton(recordID) {
    	document.getElementById("view"+recordID).style.display = "";
    	document.getElementById("edit"+recordID).style.display = "none";
    }
    
    function saveButton(recordID) {
    	$("#recordIDUpdate").val(recordID);
    	$("#participantIDUpdate").val($("#participantID"+recordID).val());
    	$("#activityIDUpdate").val($("#activityID"+recordID).val());
    	$("#recordTimeUpdate").val($("#recordTime"+recordID).val());
    	document.forms["finalSubmit"].submit();
    }
    
    </script>
    
  </head>
  
  	

  <body>
  
  
  	<a href="admin.jsp">return to admin main</a>
  	<a href="/index.jsp">home</a>
  
  <%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      	pageContext.setAttribute("user", user);
	%>
		<p>Hello, ${fn:escapeXml(user.nickname)}! (You can <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
	<%
	    } else {
	%>
		<p>Hello! <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a></p>
	<%
	    }
	%>
  
  
	<%
		List<Entity> allRecords = Record.getFirstRecords(100);
		if (allRecords.isEmpty()) {
	%>
	<h1>No Records Entered</h1>
	<%
		}else{	
	%>
	<h1>All Records</h1>
	<table border="1">
		<tr>
			<td>ParticipantID</td>
			<td>ActivityID</td>
			<td>Value</td>
			<td>Edit</td>
		</tr>
		<%
			for (Entity record : allRecords) {
					String recordTime = Record.getValue(record);
					String participantID = Record.getParticipantID(record);
					String activityID = Record.getActivityID(record);
					String recordID = Record.getStringID(record);
		%>

		<tr id="view<%=recordID%>">
				<td><%=participantID%></td>
				<td><%=activityID %></td>
				<td><%=recordTime %></td>
				<td><button type="button" onclick="editButton(<%=recordID%>)">Edit</button></td>
		</tr>
		
		<tr id="edit<%=recordID%>" style="display: none">
				<td><input id="participantID<%=recordID%>" type="text" name="participantID" value="<%=participantID%>" size="20" /></td>
				<td><input id="activityID<%=recordID%>" type="text" name="activityID" value="<%=activityID%>" size="20" /></td>
				<td><input id="recordTime<%=recordID%>" type="text" name="recordTime" value="<%=recordTime%>" size="20" /></td>
				<td><button type="button" onclick="cancelButton(<%=recordID%>)">cancel</button><button type="button" onclick="saveButton(<%=recordID%>)">save</button></td>
		</tr>
		
		<%
			}

		}
		%>

	</table>
	


	<hr />
	<form action="addRecord" method="post">
	<table>
		<tr>
			<td>ParticipantID</td>
			<td>ActivityID</td>
			<td>Value</td>
		</tr>
		<tr>
	    	<td><input type="text" name="participantID" size="20" /></td>
			<td><input type="text" name="activityID" size="20" /></td>
			<td><input type="text" name="recordTime" size="20" /></td>
		</tr>
	</table>
		<input type="submit" value="Add Record" />
    </form>
    
    <div>
    	<form id="finalSubmit" action="updateRecord" method="post">
	    	<input id="recordIDUpdate" type="hidden" name="id" value="" />
	    	<input id="participantIDUpdate" type="hidden" name="participantID" />
			<input id="activityIDUpdate" type="hidden" name="activityID"  />
			<input id="recordTimeUpdate" type="hidden" name="recordTime"  />
    	</form>
    </div>

  </body>
</html>