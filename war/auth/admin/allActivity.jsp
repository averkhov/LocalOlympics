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
<%@page import="localolympics.db.Participant"%>
<%@page import="localolympics.db.Activity"%>

<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!--  
   Copyright 2014 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Anugh
   
   Version 0.1 - Spring 2014
-->

<!-- test -->
<html>

<head> 
<title>Add Activity</title>

   <link type="text/css" rel="stylesheet" href="/stylesheets/admin.css" />
   
   <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    
    <script>
	    function popup(){
	    	var pos = $("#menudrop").position();
	    	var wid = $("#menudrop").width();
	    	$("#popup").css({
	            position: "absolute",
	            top: (pos.top + 15) + "px",
	            left: pos.left + "px",
	            width: wid + "px"
	        }).show();
	    	document.getElementById("popup").style.display = "";
	    }
	    function popoff(){
	    	document.getElementById("popup").style.display = "none";
	    }
    </script>
   
   </head>
<body>
	  <div class="topbar"></div>
	  <div class="backgroundwrapper">
	  <div class="background">

  
  <%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    
    if (user == null) {
    	
    	%>
			<jsp:forward page="/index.jsp" />
		<%
		
    } else {
    	
    	Entity participant = Participant.getParticipantWithLoginID(user.getUserId());
      	pageContext.setAttribute("user", user);
      	        
        if(participant == null){
        	
        	%>
        	
        	<jsp:forward page="/auth/user/editProfile.jsp" />
        	
        	<%
        	
        }else{
        	
	%>
		<div class="top" style="float:left">
			<a href="/index.jsp">INDEX</a> | 
			<a href="/auth/user/home.jsp">HOME</a> | 
			<a href="/auth/admin/admin.jsp">ADMIN</a>
		</div>
		<div class="top" id="menudrop" style="float:right"><a href="#" onmouseover="popup();" onmouseout="popoff();"><%=Participant.getFirstName(participant)%> <%=Participant.getLastName(participant)%></a></div>
		<div id="popup" class="popup" onmouseover="popup();" onmouseout="popoff();" style="display:none">
		<ul>
			<li><a href="profile.jsp" >PROFILE</a></li>
			<li><a href="/logout" >LOGOUT</a></li>
		</ul>
		</div>

    	<br />
    	<br />
    	
<% List<Entity>allActivity = Activity.getFirstActivity(100); 

if(allActivity != null)
{
	
	%>
	<table>
		<tr>
			<th>Activity Name</th><th>Activity Type</th><th>Activity Description</th><th>Activity Location</th>
		</tr>
	<%
	for (Entity activity : allActivity) {
		String activityName = Activity.getName(activity);
		String activityID = Activity.getStringID(activity);
		String activityType = Activity.getType(activity);
		String activityLocation = Activity.getLocation(activity);
		String activityDescription = Activity.getDescription(activity);
		
	%>
	<tr>

			<td><%=activityName%></td><td><%=activityType%></td><td><%=activityDescription%></td><td><%=activityLocation%></td>

		</tr>
	<%
	}
	%>
	</table>
	<%
}
else
{
	%>
	<h3>No Activities Listed</h3>
	<% 
}
%>
	<hr />
	<h1>Create Activity</h1>
	<form action = "addActivity" method = "post">
	<table border="1">
	 <tr>
	 	<td>Activity Name: </td><td><input type = "text" name = "ActivityName" /></td>
	</tr>
	<tr>
		<td>Description: </td><td><input type = "text" name = "description" /></td>
	</tr>
	<tr>
		<td>Type: </td>
		<td>
		<select name = "type">
		<option value = ""> </option>
		<option value = "Running">Running </option>
		<option value = "Walking" >Walking</option>
		<option value = "Swimming">Swimming</option>
		<option value = "Hiking">Hiking</option>

		</select>
		</td>
	</tr>
	<tr>
		<td>Zipcode: </td><td><input type = "text" name = "address"/></td>
	</tr>
	</table>
	<input type="submit" value="Add Activity" />
	</form>
	</div>
	</div>
	<%
        }
    }
	
	%>
</body>
</html>