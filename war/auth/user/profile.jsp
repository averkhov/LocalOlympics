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
<%@ page import="localolympics.db.Activity" %>
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
    <link type="text/css" rel="stylesheet" href="/stylesheets/user.css" />
    
    <title>Local Olympics</title>
    
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

	    window.onload = function () {
	        var address = document.getElementById("address").value;
	        initializeMap(address);
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
    	
    	Entity participant = Participant.getParticipantWithLoginID(user.getNickname());
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
					<td>Favorite Activity: </td>
					<td><%=Participant.getActivity(participant)%></td>
				</tr>
				<tr> 
					<td>About Me: </td>
					<td><%=Participant.getAboutMe(participant)%></td>
				</tr>
				<tr> 
					<td>Zip Code: </td>
					<td><%=Participant.getAddress(participant)%></td>
				</tr>

			</table>
			
			<p><a href="editProfile.jsp">Edit your profile</a></p>
			<input type="hidden" id="address" value="<%=Participant.getAddress(participant) %>" />
			<div id="map-canvas" class="map-canvas"></div>

	<%
  
    }
    
	%>
	
	<% 
	
	List<Entity> allRecord = Record.getParticipantRecords(Participant.getStringID(participant), 100);
	int num = Record.getParticipantRecordsNumber(Participant.getStringID(participant), 100);
	boolean won = false;
	if(allRecord!=null && num !=0)
	{
		%>
		<h3> Records for the activities that you have participated so far</h3>
		<table>
		<tr>
			<th>Activity Name </th>
			<th>Activity Type </th>
			<th>Record </th>
			<th>Date</th>
			
		</tr>
		
		<%
			for(Entity record: allRecord) 
			{
				String activityID = Record.getActivityID(record);
				Entity activity = Activity.getActivity(activityID);
				String activityName = Activity.getName(activity);
				String activityType = Activity.getType(activity);
				String recordTime = Record.getValue(record);
				String recordDate = Record.getDate(record);
				String award = Record.getAward(record);
				if(award!=null)
				{
					won = true;
				}
			%>
			<tr> 
			
				<td><%=activityName %> </td>
				<td><%=activityType %> </td>
				<td><%=recordTime %> </td>
				<td><%=recordDate %> </td>
			</tr>
			<%
				
				//String activityName = Activity.getA
			
			}
		%>
		<tr>
		
		</tr>
		
		
		</table>	
		<%
		//this is where a table is displayed when a user win an award 
		
		if(won == true)
		{
		%>
		<table>
		<tr> 
			<th>Activity Name </th>
			<th>Activity Type </th>
			<th>Record </th>
			<th>Date</th>
		</tr>
		<% 
			for(Entity record: allRecord) 
			{
				String award = Record.getAward(record);
				if(award!=null)
				{
					String activityID = Record.getActivityID(record);
					Entity activity = Activity.getActivity(activityID);
					String activityName = Activity.getName(activity);
					String activityType = Activity.getType(activity);
					String recordTime = Record.getValue(record);
					String recordDate = Record.getDate(record);
					
					%>
					<tr> 
			
				<td><%=activityName %> </td>
				<td><%=activityType %> </td>
				<td><%=recordTime %> </td>
				<td><%=recordDate %> </td>
			</tr>
					
					<% 
				}
			}
		
		%>
		</table>
		<% 
		}
	}
	else
	{
		%>
		<h3> You have not yet participated in any activities</h3>
		<%
	}
	}
	%>


</div>
</div>
  </body>
    
</html>