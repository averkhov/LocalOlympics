
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
<%@ page import="localolympics.db.Participant" %>
<%@ page import="localolympics.db.Activity" %>
<%@ page import="localolympics.db.Record" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.TimeZone" %>
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
    	
    	
    	
    	Entity participant = Participant.getParticipantWithLoginID(user.getUserId());
      	pageContext.setAttribute("user", user);
      	        
        if(participant == null){
        	
        	%>
        	
        	<jsp:forward page="editProfile.jsp" />
        	
        	<%
        	
        }else{
        	
			//Temporary redirect to have users make an alias
        	
        	if(Participant.getAlias(participant)=="" | Participant.getAlias(participant)==null){
        		%>
            	
            	<jsp:forward page="editProfile.jsp" />
            	
            	<%
        	}
        	
	%>
		<div class="top" style="float:left">
			<a class="topbarmenumain" href="/index.jsp">LOCAL OLYMPICS</a>
		</div>
		<div class="top" id="menudrop" style="float:right"><a href="#" class="topbarmenu" onmouseover="popup();" onmouseout="popoff();"><%=Participant.getFirstName(participant)%> <%=Participant.getLastName(participant)%></a></div>
		<div id="popup" class="popup" onmouseover="popup();" onmouseout="popoff();" style="display:none">
		<ul>
			<li><a class="topbarmenu" href="profile.jsp" >PROFILE</a><hr/></li>
			<li><a class="topbarmenu" href="/logout" onmouseover="popup();">LOGOUT</a></li>
		</ul>
		</div>

    	<br />
    	<br />
    	
		<h2>Welcome <%=Participant.getFirstName(participant) %></h2>
		<div style="margin-left:auto;margin-right:auto;width:75%;">
		<div style="background-color:white; border-radius:20px;padding: 15px;">
			<table id="profftable">
				<tr>
					<td style="width:125px">First Name: </td>
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
			</div>
			</div>
			
			<p><a href="editProfile.jsp">Edit your profile</a></p>
			<input type="hidden" id="address" value="<%=Participant.getAddress(participant) %>" />
			<div style="margin-left:auto;margin-right:auto;width:75%;"><div id="map-canvas" class="map-canvas"></div></div>

	<%
  
    }
    
	%>
	
	<% 
	
	List<Entity> allRecord = Record.getParticipantRecords(Participant.getStringID(participant), 100);
	int num = Record.getParticipantRecordsNumber(Participant.getStringID(participant), 100);

	if(allRecord!=null && num !=0)
	{
		%>
		<h2>Awards WON!</h2>
		<table>
		<tr>
		<% 
			int count = 0;
			for(Entity record: allRecord) 
			{
				String award = Record.getAward(record);
				if(award!=null){
					if(!award.equals("")){
					String activityID = Record.getActivityID(record);
					Entity activity = Activity.getActivity(activityID);
					String activityName = Activity.getName(activity);
					String activityType = Activity.getType(activity);
					String recordTime = Record.getValue(record);
					String date = Record.getDate(record);
					Date date1 = new SimpleDateFormat("EEE MMMM dd kk:mm:ss zzz yyyy").parse(date);
					SimpleDateFormat df2 = new SimpleDateFormat("MM/dd/yy hh:mm aa");
					df2.setTimeZone(TimeZone.getTimeZone("America/New_York"));
			        String dateText = df2.format(date1);
					String awardwon = Record.getAward(record);
					if(count==5){
						count = 0;
						%></tr><tr><%
					}
					
					if(awardwon.equals("Gold")){
						count++;
						%>
						<td class="timetext" ><img src="/stylesheets/gold.jpg" alt="gold" height="50" width="50" class="icon" /><br/>
						<a href="/auth/user/activity.jsp?activityID=<%=activityID%>"><%=activityName %></a><br/><%=recordTime %><br /><%=dateText %>
						
						</td>
						<%
					}

					if(awardwon.equals("Silver")){
						count++;
						%>
						<td class="timetext" ><img src="/stylesheets/silver.jpg" alt="silver" height="50" width="50" class="icon" /><br/>
						<a href="/auth/user/activity.jsp?activityID=<%=activityID%>"><%=activityName%></a><br/><%=recordTime %><br /><%=dateText %>
						</td>
						<%
					}

					if(awardwon.equals("Bronze")){
						count++;
						%>
						<td class="timetext"><img src="/stylesheets/bronze.jpg" alt="bronze" height="50" width="50" class="icon" /><br/>
						<a href="/auth/user/activity.jsp?activityID=<%=activityID%>"><%=activityName%></a><br/><%=recordTime %><br /><%=dateText %>
						</td>
						<%
					}

				}
				}
			}
		
		%>
		</table>
		
		<hr />
		
		
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
				if(activity!=null){
					
				
				String activityName = Activity.getName(activity);
				String activityType = Activity.getType(activity);
				String recordTime = Record.getValue(record);
				String date = Record.getDate(record);
				Date date1 = new SimpleDateFormat("EEE MMMM dd kk:mm:ss zzz yyyy").parse(date);
				SimpleDateFormat df2 = new SimpleDateFormat("MM/dd/yy hh:mm aa");
				df2.setTimeZone(TimeZone.getTimeZone("America/New_York"));
		        String dateText = df2.format(date1);
				String award = Record.getAward(record);

				
			%>
			<tr> 
			
				<td><%=activityName %> </td>
				<td><%=activityType %> </td>
				<td><%=recordTime %> </td>
				<td><%=dateText %> </td>
			</tr>
			<%
				
			
			}
			}
			
		%>
		<tr>
		
		</tr>
		
		
		</table>	

		
		<% 
		
	
	}else{
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