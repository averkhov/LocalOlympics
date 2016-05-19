<%@page import="com.google.appengine.repackaged.com.google.api.client.http.HttpRequest"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import =" java.util.ArrayList" %>
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
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.TimeZone" %>
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
    
    String username = "";
    
    if (user == null) {
        
        username = "Guest";
    	
    	%>
			
		<%
		
    } else {
    	
    	Entity participant = Participant.getParticipantWithLoginID(user.getUserId());
      	pageContext.setAttribute("user", user);
      	        
        if(participant == null){
        	
        	%>
        	
        	<jsp:forward page="editProfile.jsp" />
        	
        	<%
        	
        }else{
            
            username = Participant.getFirstName(participant) + " " + Participant.getLastName(participant);
        	
	%>
		<div class="top" style="float:left">
			<a class="topbarmenumain" href="/index.jsp">LOCAL OLYMPICS</a> 
			
		</div>
		<div class="top" id="menudrop" style="float:right"><a class="topbarmenu" href="#" onmouseover="popup();" onmouseout="popoff();"><%=username%></a></div>
		<div id="popup" class="popup" onmouseover="popup();" onmouseout="popoff();" style="display:none">
		<ul>
			<li><a class="topbarmenu" href="profile.jsp" >PROFILE</a><hr/></li>
			<li><a class="topbarmenu" href="/logout" onmouseover="popup();">LOGOUT</a></li>
		</ul>
		</div>

    	<br />
    	<br />
    	
			<%
			Entity activity = Activity.getActivity(request.getParameter("activityID"));
			
			%>
			
			<table>
				<tr>
					<td class="activitytitle"><%=Activity.getName(activity)%><hr /></td>
				</tr>
				<tr>
					<td><%=Activity.getDescription(activity) %></td>
				</tr>
				<tr>
					<td>Location: <%=Activity.getLocation(activity) %><input type="hidden" id="address" value="<%=Activity.getLocation(activity)%>" /></td>
				</tr>
				<tr>
				  <td><div style="margin-left:auto;margin-right:auto;width:75%;"><div id="map-canvas" class="map-canvas"></div></div></td>
				</tr>
				<tr>
					<%
					List<Entity> allRecords = Record.getParticipantActivityRecords(Participant.getStringID(participant), Activity.getStringID(activity), 100);
					if (allRecords.isEmpty()) {
					%>
						<td><h1 class="activitytitle">You have not entered any Records for this Activity</h1></td>
						</tr>
						</table>
					<%
					}else{	
						
						//Displays the your record of the activity
						
					%>
					<table>
						<tr><td colspan="3" class="activitytitle"><br/>Your Records</td></tr>
						<tr>
							<td><img src="/stylesheets/gold.jpg" alt="gold" height="124" width="124" class="icon" /></td>
							<td><img src="/stylesheets/silver.jpg" alt="silver" height="124" width="124" class="icon" /></td>
							<td><img src="/stylesheets/bronze.jpg" alt="bronze" height="124" width="124" class="icon" /></td>
						</tr>
						<tr>
							<td class="medaltext">GOLD!</td>
							<td class="medaltext">Silver</td>
							<td class="medaltext">Bronze</td>
						</tr>
						<tr>
					<%
						int count = 0;
						String activityID = Activity.getStringID(activity);
						String name = " ";
						for(Entity record: allRecords)
						{
							String value = Record.getValue(record);
							String valueID = Record.getStringID(record);
							String uname = Participant.getAlias(Participant.getParticipant(Record.getParticipantID(record)));
							if (uname==null | uname.equals("")){
								uname = Participant.getFirstName(Participant.getParticipant(Record.getParticipantID(record))) + 
										(Record.getParticipantID(record).substring(10));
							}
							String date = Record.getDate(record);
							Date date1 = new SimpleDateFormat("EEE MMMM dd kk:mm:ss zzz yyyy").parse(date);
							SimpleDateFormat df2 = new SimpleDateFormat("MM/dd/yy hh:mm aa");
							df2.setTimeZone(TimeZone.getTimeZone("America/New_York"));
					        String dateText = df2.format(date1);
							String award = Record.getAward(record);
								
								%>
								
								
									
									<%
									if(!award.equals(""))
									{
										if(award.equals("Gold")){
											%>
											<td class="timetext" >
											<%=value %><br /><%=dateText %>
											</td>
											<%
										}

										if(award.equals("Silver")){
											%>
											<td class="timetext" >
											<%=value %><br /><%=dateText %>
											</td>
											<%
										}

										if(award.equals("Bronze")){
											%>
											<td class="timetext">
											<%=value %><br /><%=dateText %>
											</td>
											<%
										}

							}
							%>
							
							
							
							<%
							
						}
					}
					%>
					</tr>
					</table>
					<hr/>
					<br/>
					<br/>
					<div class="bestofrestdiv">
					

					<table id="bestofrest">
					<tr><td colspan="3" class="activitytitle">Best of the Rest</td></tr>
						<tr>
							<th>Participant</th><th>Record</th><th>Date/Time</th>
						</tr>
					<%
					List<String> usersEntered = new ArrayList<String>(); 
					List<Entity> allOtherRecords = Record.getActivityRecords(Activity.getStringID(activity), 100);
					int counter = 0;
					boolean show = true;
						
						for (Entity record : allOtherRecords) {
							String userID = Record.getParticipantID(record);
							String value = Record.getValue(record);
							String uname = Participant.getAlias(Participant.getParticipant(Record.getParticipantID(record)));
							if (uname==null | uname.equals("")){
								uname = Participant.getFirstName(Participant.getParticipant(Record.getParticipantID(record))) + 
										(Record.getParticipantID(record).substring(10));
							}
							String date = Record.getDate(record);
							Date date1 = new SimpleDateFormat("EEE MMMM dd kk:mm:ss zzz yyyy").parse(date);
							SimpleDateFormat df2 = new SimpleDateFormat("MM/dd/yy hh:mm aa");
							df2.setTimeZone(TimeZone.getTimeZone("America/New_York"));
					        String dateText = df2.format(date1);
					        
					        String valid = Record.getIsValid(record);
					        boolean isValid = false;
					        if(valid==null | valid.equals("") | valid.equals("false")){
					        	isValid = false;
					        }else{
					        	isValid = true;
					        }
					        
					        if(isValid | (Record.getParticipantID(record).equals(Participant.getStringID(participant)))){
					        
					        if(counter == 0){
					        	
					        
						%>
						
						<tr>
							<td><%=username%></td>
							<td><%=value%></td>
							<td><%=dateText %></td>
						</tr>
						
						<%
								usersEntered.add(userID);
								counter++;
								show = false;
							}else{
								for(int i=0; i<usersEntered.size(); i++)
								{
									if(userID.equals(usersEntered.get(i)))
									{
										show = false;
									}
								}
							}
					        
					        if(show)
							{
								usersEntered.add(userID);
								%>
							<tr>
								<td><%=username%></td>
								<td><%=value%></td>
								<td><%=dateText %></td>
							</tr>
									<% 
							}
							show = true;
    	
    	
						}
						}
						%>
					</table>
					</div>


	<%
    
    
    
					
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
				<tr>
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