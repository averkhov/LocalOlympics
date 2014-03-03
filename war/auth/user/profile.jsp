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

   Authors: Alex Verkhovtsev 
   
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
    		<h2>Welcome Please create your profile below!</h2>
    		<form action="addParticipant" method="post">
    			<table>
    				<tr>
    					<td>First Name: </td><td><input type="text" name="participantFirstName" length="30" /></td>
    				</tr>
    				<tr>
    					<td>Last Name: </td><td><input type="text" name="participantLastName" length="30" /></td>
    				</tr>
    			<tr> 
    				<td>Gender: </td>
					<td><input type = "radio" name = "gender" value = "male" checked/> Male</td>
					<td><input type = "radio" name = "gender" value = "female" /> female</td>
				</tr>
				<td> Birthday: </td>
					<td><input type = "text" name = "birthday" length="30" /> </td>
				</tr>
				<tr>
					<td>Activity: </td>
					<td><select name = "activity">
							<option value = "Running" >Running </option>
							<option value = "Walking">Walking</option>
							<option value = "Swimming">Swimming</option>
							<option value = "Hiking">Hiking</option>
							</select>
							</td>
				</tr>
				<tr>
					<td> About Me: </td>
					<td>
						<textarea name = "aboutMe"> 
						</textarea>
					</td>
				</tr>
    			</table>
    			<input type="hidden" name="ParticipantLoginID" value="<%=user.getNickname()%>" />
    			<input type="submit" value="submit" />
    		</form>
    	
    	<%
    	
    	
    }else{
    	
    	
    	%>
		<h2>Welcome Please edit your profile below!</h2>
		<form action="updateParticipant" method="post">
			<table>
				<tr>
					<td>First Name: </td><td><input type="text" name="participantFirstName" length="30" value="<%=Participant.getFirstName(participant) %>" /></td>
				</tr>
				<tr>
					<td>Last Name: </td><td><input type="text" name="participantLastName" length="30" value="<%=Participant.getLastName(participant) %>" /></td>
				</tr>
				
				<%
				    if(Participant.getGender(participant) == "male")
				    {
				    	%>
				    	<tr>
					<td>Gender: </td> 
					<td><input type = "radio" name = "gender" value = "male" checked/> Male</td>
					<td><input type = "radio" name = "gender" value = "female" /> female</td>
					</tr>
					<% 
				    }
				    else if(Participant.getGender(participant) == "female")
				    {
				    	%>
				    	<tr>
					<td>Gender: </td> 
					<td><input type = "radio" name = "gender" value = "male" /> Male</td>
					<td><input type = "radio" name = "gender" value = "female" checked/> female</td>
					</tr>
					<%
				    }
				    else
				    {
				    	%>
				    	<tr>
					<td>Gender: </td> 
					<td><input type = "radio" name = "gender" value = "male" /> Male</td>
					<td><input type = "radio" name = "gender" value = "female" /> female</td>
					</tr>
					<% 
				    }
				%>
				<tr> 
					<td> Birthday: </td>
					<td><input type = "text" name = "birthday" value = "<% Participant.getBirthday(participant);%>" /> </td>
				</tr>
				
				<tr>
					<td> Activity: </td>
					<td>
					<%
					  if(Participant.getActivity(participant)=="Running")
					  {
						  %>
						  <select name = "activity">
							<option value = "Running" selected>Running </option>
							<option value = "Walking">Walking</option>
							<option value = "Swimming">Swimming</option>
							<option value = "Hiking">Hiking</option>
							</select>
							<% 
					  }
					  else if(Participant.getActivity(participant)=="Walking")
					  {
						  %>
						  <select name = "activity">
					<option value = ""> </option>
					<option value = "Running">Running </option>
					<option value = "Walking" selected>Walking</option>
					<option value = "Swimming">Swimming</option>
					<option value = "Hiking">Hiking</option>
					</select>
						  
						  <% 
					  }
					  else if(Participant.getActivity(participant)=="Swimming")
					  {
						  %>
						  <select name = "activity">
					<option value = ""> </option>
					<option value = "Running">Running </option>
					<option value = "Walking">Walking</option>
					<option value = "Swimming" selected>Swimming</option>
					<option value = "Hiking">Hiking</option>
					</select>
						  <%
					  }
					  else if (Participant.getActivity(participant)=="Hiking")
					  { %>
						  <select name = "activity">
					<option value = ""> </option>
					<option value = "Running">Running </option>
					<option value = "Walking">Walking</option>
					<option value = "Swimming">Swimming</option>
					<option value = "Hiking" selected>Hiking</option>
					</select>
						  <%
					  }
					  else
					  {
						 %>
						  <select name = "activity">
					<option value = ""> </option>
					<option value = "Running">Running </option>
					<option value = "Walking">Walking</option>
					<option value = "Swimming">Swimming</option>
					<option value = "Hiking" >Hiking</option>
					</select>
						 <%  
						  
					  }
					%>
					</td>
				</tr>
				<tr>
					<td><textarea name = "aboutMe" >
					<%Participant.getAboutMe(participant); %>
					</textarea></td>
				</tr>
			</table>
			<input type="hidden" name="ParticipantLoginID" value="<%=user.getNickname()%>" />
			<input type="hidden" name="ParticipantID" value="<%=Participant.getStringID(participant)%>" />
			<input type="submit" value="update" />
		</form>

	<%
    	
    	
    	
    
    
    }
    
	%>
  

  </body>
</html>