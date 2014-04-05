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
<%@ page import="localolympics.db.Activity" %>
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
    
    <title>Local Olympics - Home</title>
    
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
			<li><a href="/logout">LOGOUT</a></li>
		</ul>
		</div>

    	<br />
    	<br />
    	
    	<div class="main">
		<h2>Welcome <%=Participant.getFirstName(participant) %>.</h2>
			
			
			<br/>
			
			<%
			List<Entity> allActivity = Activity.getFirstActivity(100);
			if (allActivity.isEmpty()) {
			%>
				<h1>No Activities available at this time</h1>
			<%
			}else{	
			%>
			
			
			
			
			<table>
				<tr>
					<td><h3>Click on an activity to join in the fun!</h3></td>
					<td></td>
				</tr>
				<tr>
				<td>
					<table class="activitylist">
						<%
						for (Entity activity : allActivity) {
							String activityName = Activity.getName(activity);
							String activityID = Activity.getStringID(activity);
							String activityType = Activity.getType(activity);
							String activityLocation = Activity.getLocation(activity);
							String description = Activity.getDescription(activity);
						%>
						
						<tr class= "activitylistrow">
						<td class="iconcell"><img src="/stylesheets/runner.jpg" alt="running" height="123" width="124" /></td>
						<td>
							<table>
							<tr>
								<td class="activityname"><a href="activity.jsp?activityID=<%=activityID%>"><%=activityName%></a></td>
							</tr>
							<tr>
								<td><hr/><%=description%></td>
							</tr>
							<tr>
								<td>Located: <a href="https://maps.google.com/maps?saddr=<%=activityLocation%>" target="_blank"><%=activityLocation%></a></td>
							</tr>
							</table>
						</td>
						
						<%
    	
    	
						}
						%>
					</table>
					</td>
				</tr>
			</table>
			</div>
			
			
			
	<%
    
    
    }
    }
    }
    
    
	%>
  </div>
  </div>

  </body>
 
</html>