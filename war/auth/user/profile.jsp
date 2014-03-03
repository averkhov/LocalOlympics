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
<%@ page import="localolympics.db.Participant" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>



<!--  
   Copyright 2014 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Alex Verkhovtsev, Karen, Anugh
   
   Version 0.1 - Spring 2014
-->



<html>

  <head>
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
  </head>

  	<a href="/index.jsp">home</a>

  <body>
  
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
       
    Entity participant = Participant.getParticipantWithLoginID(user.getNickname());
    
    if(participant == null){
    	
    	%>
    	
    	<jsp:forward page="editProfile.jsp" />
    	
    	<%
    	
    	
    }else{
    	
    	
    	%>
		<h2>Welcome <%=Participant.getFirstName(participant) %>.</h2>
			<table>
				<tr>
					<td>First Name: </td>
					<td><%=Participant.getFirstName(participant) %></td>
				</tr>
				<tr>
					<td>Last Name: </td>
					<td><%=Participant.getLastName(participant) %></td>
				<tr> 
					<td>Gender: </td>
					<td><%=Participant.getGender(participant)%></td>
				</tr>
				<tr> 
					<td>Birthday: </td>
					<td><%=Participant.getBirthday(participant)%></td>
				</tr>
				
				<tr> 
					<td>Activity: </td>
					<td><%=Participant.getActivity(participant)%></td>
				</tr>
				<tr> 
					<td>About Me: </td>
					<td><%=Participant.getAboutMe(participant)%></td>
				</tr>
			</table>
			<a href="editProfile.jsp">Edit your profile</a>

	<%
    	
    	
    	
    
    
    }
    
	%>
  

  </body>
</html>