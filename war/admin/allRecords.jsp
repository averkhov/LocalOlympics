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
    <link type="text/css" rel="stylesheet" href="/stylesheets/record.css" />
  </head>
  
  	<a href="/index.html">home</a>

  <body>
  
  <%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user);
	%>
	<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
	<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
	<%
	    } else {
	%>
	<p>Hello!
	<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
	to include your name with greetings you post.</p>
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
			<td>Record</td>
			<td>Delete</td>
			<td>Update</td>
			<td>Delete (Get) test</td>
		</tr>
		<%
			for (Entity record : allRecords) {
					String recordTime = Record.getTime(record);
					String id = Record.getStringID(record);
		%>

		<tr>
			<td><%=recordTime%></td>
			<td>
				<form action="/admin/deleteRecord" method="post">
					<input type="hidden" name="id" value="<%=id%>" />
					<input type="submit" value="Delete" />
				</form>
			</td>
			<td>
				<form action="/admin/updateRecord" method="post">
					<input type="hidden" name="id" value="<%=id%>" />
					<input type="text" name="recordTime" size="20" />
					<input type="submit" value="Update" />
				</form>
			</td>
			<td>
				<a href="/admin/deleteRecord?id=<%=id%>">delete</a>
			</td>

		</tr>

		<%
			}

		}
		%>

	</table>
	


	<hr />
    <form action="/admin/addRecord" method="post">
      <div><input type="text" name="recordTime" size="50" /></div>
      <div><input type="submit" value="Add Record" /></div>
    </form>

  </body>
</html>