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
    
    function editButton(activityID) {
    	$("#activityIDUpdate").val(activityID);
    	$("#activityNameUpdate").val($("#activityName"+activityID).val());
    	$("#descriptionUpdate").val($("#description"+activityID).val());
    	$("#typeUpdate").val($("#type"+activityID).val());
    	$("#addressUpdate").val($("#address"+activityID).val());
    	var pos = $("#back").position();
	    	var wid = $("#back").width();
	    	$("#edit").css({
	            position: "absolute",
	            top: (pos.top + 30) + "px",
	            left: (pos.left + 30) + "px",
	            width: (wid/2) + "px"
	        }).show();
	    	document.getElementById("edit").style.display = "";
    	
    	
    }
    
    function cancelButton() {
    	document.getElementById("edit").style.display = "none";
    }
    
    function deleteButton(ID) {
    	if(confirm('Are you sure you want to delete this Activity?')){
    		window.location = 'deleteActivity?id=' + ID;
    	}else{
    	
    	}
    }
    
    
    function saveButton() {
    	document.forms["finalSubmit"].submit();
    }
    
    
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
	  <div class="backgroundwrapper" id="back">
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
			<li><a href="/auth/user/profile.jsp" >PROFILE</a></li>
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
			<th>Activity Name</th><th>Activity Type</th><th>Activity Description</th><th>Activity Location</th><th>Limit</th><th>edit</th><th>delete</th>
		</tr>
	<%
	for (Entity activity : allActivity) {
		String activityName = Activity.getName(activity);
		String activityID = Activity.getStringID(activity);
		String activityType = Activity.getType(activity);
		String activityLocation = Activity.getLocation(activity);
		String activityDescription = Activity.getDescription(activity);
		String timeLimit = Activity.getLimit(activity);
		
	%>
	<tr>

			<td><%=activityName%><input id="activityName<%=activityID%>" type="hidden" value="<%=activityName%>" /></td>
			<td><%=activityType%><input id="type<%=activityID%>" type="hidden" value="<%=activityType%>" /></td>
			<td><%=activityDescription%><input id="description<%=activityID%>" type="hidden" value="<%=activityDescription%>" /></td>
			<td><%=activityLocation%><input id="address<%=activityID%>" type="hidden" value="<%=activityLocation%>" /></td>
			<td><%=timeLimit %><input id="limit<%=activityID%>" type="hidden" value="<%=timeLimit%>" /></td>
			<td><button type="button" onclick="editButton(<%=activityID%>)">Edit</button></td>
			<td><button type="button" onclick="deleteButton(<%=activityID%>)">Delete</button></td>

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
		<td>Time limit: </td>
	</tr>
	<tr>
		<td>Hour: </td>
		<td>
		<select name = "limithour">
			<% for(int i =0; i< 25; i++)
				{
			%>
			<option value = "<%=i%>"> <%=i %> </option>
			
			<% 	
				}
			%>
			</select>
		</td>
		<td>Minute: </td>
		<td>
		<select name = "limitminute">
			<% for(int i = 0; i < 61; i++)
				{
				%>
				<option value = "<%=i %>"><%=i %> </option>
				
				<% 
				}
				%>
				</select>
		</td>
		<td>Second:</td>
		<td>
			<select name = "limitsecond">
			<% for(int i = 0; i < 61; i++)
				{
				%>
				<option value = "<%=i %>"><%=i %> </option>
				
				
				<% 
				}
				%>
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
	
	<div id="edit" class="edit" style="display:none">
    	<form id="finalSubmit" action="UpdateActivity" method="post">
    		
	    	<input id="activityIDUpdate" type="text" hidden="true" name="id" />
	    	<table>
    		<tr>
	    	<td>Activity Name: </td>
	    	<td><input id="activityNameUpdate" type="text"  name="activityName" /></td>
	    	</tr>
	    	<tr>
	    	<td>Description: </td>
	    	<td><input id="descriptionUpdate" type="text" name="description"  /></td>
	    	</tr>
			<tr>
			<td>Type: </td>
			<td><select id="typeUpdate" name = "type">
				<option value = ""> </option>
				<option value = "Running">Running </option>
				<option value = "Walking" >Walking</option>
				<option value = "Swimming">Swimming</option>
				<option value = "Hiking">Hiking</option>
			</select>
			</td>
			</tr>
			<tr>
			<td colspan="2">
			<table border="">
				<tr>
					<td>Time limit: </td>
				</tr>
				<tr>
					<td>Hour: </td>
					<td>
					<select name = "limithour" id="hourUpdate">
						<% for(int i =0; i< 25; i++)
							{
						%>
						<option value = "<%=i%>"> <%=i %> </option>
						
						<% 	
							}
						%>
						</select>
					</td>
					<td>Minute: </td>
					<td>
					<select name = "limitminute" id="minuteUpdate">
						<% for(int i = 0; i < 61; i++)
							{
							%>
							<option value = "<%=i %>"><%=i %> </option>
							
							<% 
							}
							%>
							</select>
					</td>
					<td>Second:</td>
					<td>
						<select name = "limitsecond" id="secondUpdate">
						<% for(int i = 0; i < 61; i++)
							{
							%>
							<option value = "<%=i %>"><%=i %> </option>
							
							
							<% 
							}
							%>
							</select>
					</td>
				</tr>
			</table>
			</td>
			</tr>
			<tr>
			<td>Address: </td>
			<td><input id ="addressUpdate" type="text" name="address" /></td>
			</tr>
			<tr>
			<td colspan="2">
			<button type="button" onclick="cancelButton()">cancel</button>
			<button type="button" onclick="saveButton()">Save</button>
			</td>
			</tr>
			</table>
    	</form>
    </div>
    
</body>
</html>