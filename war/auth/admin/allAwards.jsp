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
<%@ page import="localolympics.db.Award" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>



<!--  
   Copyright 2014 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Karen Bacon
   
   Version 0.1 - Spring 2014
-->



<html>

  <head>
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
    
    <title>Local Olympics - All Awards</title>
    
    
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    
    <script>
	

    function editButton(awardID) {
    	document.getElementById("view"+awardID).style.display = "none";
    	document.getElementById("edit"+awardID).style.display = "";
    }
    
    function cancelButton(awardID) {
    	document.getElementById("view"+awardID).style.display = "";
    	document.getElementById("edit"+awardID).style.display = "none";
    }
    
    function saveButton(awardID) {
    	$("#awardIDUpdate").val(awardID);
    	$("#participantIDUpdate").val($("#participantID"+awardID).val());
    	$("#recordIDUpdate").val($("#recordID"+awardID).val());
    	$("#awardNameUpdate").val($("#awardName"+awardID).val());
    	document.forms["finalSubmit"].submit();
    }
    
    </script>
    
  </head>
  
  	

  <body background="/stylesheets/medals.png">
  <div class="background" align="center">

  
  	<a href="admin.jsp">return to admin main</a>
  	<a href="/index.jsp">home</a>
  
  <%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      	pageContext.setAttribute("user", user);
	%>
		<p>Hello, ${fn:escapeXml(user.nickname)}! (You can <a href="/logout">sign out</a>.)</p>
	<%
	    } else {
	%>
		<p>Hello! <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a></p>
	<%
	    }
	%>
  
  
	<%
		List<Entity> allAwards = Award.getFirstAwards(100);
		if (allAwards.isEmpty()) {
	%>
	<h1>No Awards Entered</h1>
	<%
		}else{	
	%>
	
	<h1>All Awards</h1>
	<table class="myTable" border="1">
		<tr>
			<td>ParticipantID</td>
			<td>RecordID</td>
			<td>Value</td>
			<td>Edit</td>
		</tr>
		<%
			for (Entity award : allAwards) {
					String awardName = Award.getValue(award);
					String participantID = Award.getParticipantID(award);
					String recordID = Award.getRecordID(award);
					String awardID = Award.getStringID(award);
		%>

		<tr id="view<%=awardID%>">
				<td><%=participantID%></td>
				<td><%=recordID %></td>
				<td><%=awardName %></td>
				<td><button type="button" onclick="editButton(<%=awardID%>)">Edit</button></td>
		</tr>
		
		<tr id="edit<%=awardID%>" style="display: none">
				<td><input id="participantID<%=awardID%>" type="text" name="participantID" value="<%=participantID%>" size="20" /></td>
				<td><input id="recordID<%=awardID%>" type="text" name="recordID" value="<%=recordID%>" size="20" /></td>
				<td><input id="awardName<%=awardID%>" type="text" name="awardName" value="<%=awardName%>" size="20" /></td>
				<td><button type="button" onclick="cancelButton(<%=awardID%>)">cancel</button><button type="button" onclick="saveButton(<%=awardID%>)">save</button></td>
		</tr>
		
		<%
			}

		}
		%>

	</table>
	


	<hr />
	<form action="addAward" method="post">
	<table>
		<tr>
			<td>ParticipantID</td>
			<td>RecordID</td>
			<td>Value</td>
		</tr>
		<tr>
	    	<td><input type="text" name="participantID" size="20" /></td>
			<td><input type="text" name="recordID" size="20" /></td>
			<td><input type="text" name="awardName" size="20" /></td>
		</tr>
	</table>
		<input type="submit" value="Add Award" />
    </form>
    
    <div>
    	<form id="finalSubmit" action="updateAward" method="post">
	    	<input id="awardIDUpdate" type="hidden" name="id" value="" />
	    	<input id="participantIDUpdate" type="hidden" name="participantID" />
			<input id="recordIDUpdate" type="hidden" name="recordID"  />
			<input id="awardNameUpdate" type="hidden" name="awardName"  />
    	</form>
    </div>

</div>
  </body>

</html>