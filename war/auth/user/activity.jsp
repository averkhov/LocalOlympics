<%@page import="com.google.appengine.repackaged.com.google.api.client.http.HttpRequest"%>
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
<%@ page import="javax.servlet.http.*" %>
<%@ page import="localolympics.db.Activity" %>
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
    <link type="text/css" rel="stylesheet" href="/stylesheets/user.css" />
    
    <title>Local Olympics - Activity</title>
    
    <script src="https://maps.googleapis.com/maps/api/js?sensor=false"></script>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    
    <script>

	  
	    function initializeMap(address){   
	    	var geocoder = new google.maps.Geocoder();
	    	var latlng = new google.maps.LatLng(-34.397, 150.644);
	        var map_options = {
	                center: latlng,
	                zoom: 11,
	                mapTypeId: google.maps.MapTypeId.ROADMAP
	              }
	        var map = new google.maps.Map(document.getElementById("map-canvas"), map_options);

	        geocoder.geocode( { 'address': address}, function(results, status) {
		          if (status == google.maps.GeocoderStatus.OK) {
		            map.setCenter(results[0].geometry.location);
		            var marker = new google.maps.Marker({
		            	map: map,
		                position: results[0].geometry.location
		            });
		          } else {
		        	  map.setCenter(new google.maps.LatLng(38.849468, -77.306355));
		          }
		        });


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
	    
	    function submitform(){
	    	document.getElementById("submitbutton").disabled = true;
	    	document.forms["addrecord"].submit();
	    }
    
    </script>
  </head>
	  <body background="/stylesheets/medals.png">
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
        	
        	<jsp:forward page="editProfile.jsp" />
        	
        	<%
        	
        }else{
        	
	%>
		<div class="top" style="float:left">
			<a href="/index.jsp">INDEX</a> | 
			<a href="/auth/user/home.jsp">HOME</a>
			
		</div>
		<div class="top" id="menudrop" style="float:right"><a href="#" onmouseover="popup();" onmouseout="popoff();"><%=Participant.getFirstName(participant)%> <%=Participant.getLastName(participant)%></a></div>
		<div id="popup" class="popup" onmouseover="popup();" onmouseout="popoff();" style="display:none">
		<ul>
			<li><a href="profile.jsp" >PROFILE</a></li>
			<li><a href="/logout" onmouseover="popup();">LOGOUT</a></li>
		</ul>
		</div>

    	<br />
    	<br />
    	
			<%
			Entity activity = Activity.getActivity(request.getParameter("activityID"));
			
			%>
			
			<table>
				<tr>
					<td>Activity Name: <%=Activity.getName(activity)%></td>
				</tr>
				<tr>
					<td><%=Activity.getDescription(activity) %></td>
				</tr>
				<tr>
					<td>Location: <%=Activity.getLocation(activity) %></td>
				</tr>
				<tr>
				  <td> </td>
				</tr>
				<tr>
					<%
					List<Entity> allRecords = Record.getParticipantActivityRecords(Participant.getStringID(participant), Activity.getStringID(activity), 100);
					if (allRecords.isEmpty()) {
					%>
						<td><h1>No records entered</h1></td>
						</tr>
						</table>
					<%
					}else{	
						
						//Displays the best record of the activity
						
					%>
					<h3> Best Record </h3>
					<table>
						<tr>
							<th> participant </th> <th>record</th> <th> date </th> 
							<th>Award </th>
						</tr>
					<%
						int count = 0;
						String activityID = Activity.getStringID(activity);
						String name = " ";
						for(Entity record: allRecords)
						{
							String value = Record.getValue(record);
							String valueID = Record.getStringID(record);
							String username = Participant.getAlias(Participant.getParticipant(Record.getParticipantID(record)));
							if (username==null | username.equals("")){
								username = Participant.getFirstName(Participant.getParticipant(Record.getParticipantID(record))) + 
										(Record.getParticipantID(record).substring(10));
							}
							String date = Record.getDate(record);
							String award = Record.getAward(record);
							if(!award.equals(""))
							{
								
								%>
								<tr>
								<td><%= username %> </td>
								<td><%= value %> </td>
								<td><%= date %> </td>
								<td><%= award %> </td>
								</tr>
								<% 
							}
							%>
							
							
							<%
							
						}
					%>
					</table>
					<h3> Best of the Rest</h3>
					<table>
						<tr>
							<th>participant</th><th>record</th><th>date</th>
						</tr>
					<%
					List<Entity> allOtherRecords = Record.getActivityRecords(Activity.getStringID(activity), 100);
						
						for (Entity record : allOtherRecords) {
							String value = Record.getValue(record);
							String username = Participant.getAlias(Participant.getParticipant(Record.getParticipantID(record)));
							if (username==null | username.equals("")){
								username = Participant.getFirstName(Participant.getParticipant(Record.getParticipantID(record))) + 
										(Record.getParticipantID(record).substring(10));
							}
							String date = Record.getDate(record);
						%>
						
						<tr>
							<td><%=username%></td>
							<td><%=value%></td>
							<td><%=date %></td>
						</tr>
						
						<%
    	
    	
						}
						%>
					</table>
				</tr>
			</table>

	<%
    
    
    }
					
				%>
				<hr />
				<form id="addrecord" action="addRecord" method="post">
				<table>
				<tr>
				<td>Enter a new record for this activity.</td>
				<tr>
	    			<td><input type="hidden" name="participantID" value="<%=Participant.getStringID(participant) %>" />
					<input type="hidden" name="activityID" value="<%=Activity.getStringID(activity)%>" />
					
					Hour: <select name = "hour">
					
						<%
						
						for(int i = 0; i<25 ; i++)
						{
							%>
							<option value = "<%=i %>"><%=i %></option>
							<% 
						}
							%>
					
					</select>
					Minute: <select name = "minute">
						<% for(int i = 0; i<60 ; i++)
						{
							%>
							<option value = "<%=i %>"><%=i %></option>
							<% 
						}
							%>
					
					</select>
					Second: <select name = "second">
						<% for(int i = 0; i<60 ; i++)
						{
							%>
							<option value = "<%=i %>"><%=i %></option>
							<% 
						}
							%>
					
					</select>
				</tr>
				<td><button id="submitbutton" type="button" onclick="submitform()">Add</button></td>
				</tr>
				</table>
				</form>
				
				
				<% 
    }
    }
    
    
	%>

  </div>
  </div>
  </body>
  
</html>