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
<%@ page import="localolympics.db.Award" %>
<%@ page import="localolympics.db.Participant" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>



<!--  
   Copyright 2014 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Karen Bacon
   
   Version 0.1 - Spring 2014
-->



<html>

  <head>
    <link type="text/css" rel="stylesheet" href="/stylesheets/admin.css" />
    
    <title>Local Olympics - All Awards</title>
    
    
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    
    <script>
	

    function editButton(awardID) {
    	document.getElementById("view"+awardID).style.display = "none";
    	document.getElementById("edit"+awardID).style.display = "";
    }
    
    function cancelButton(awardID) {
    	document.getElementById("view"+awardID).style.display = "";
    	document.getElementById("edit"+awardID).style.display = "none";
    }
    
    function saveButton(awardID) {
    	$("#awardIDUpdate").val(awardID);
    	$("#participantIDUpdate").val($("#participantID"+awardID).val());
    	$("#recordIDUpdate").val($("#recordID"+awardID).val());
    	$("#awardNameUpdate").val($("#awardName"+awardID).val());
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
  
  
	<%
		List<Entity> allAwards = Award.getFirstAwards(100);
		if (allAwards.isEmpty()) {
	%>
	<h1>No Awards Entered</h1>
	<%
		}else{	
	%>
	
	<h1>All Awards</h1>
	<table class="myTable" border="1">
		<tr>
			<td>ParticipantID</td>
			<td>RecordID</td>
			<td>Value</td>
			<td>Edit</td>
		</tr>
		<%
			for (Entity award : allAwards) {
					String awardName = Award.getValue(award);
					String participantID = Award.getParticipantID(award);
					String recordID = Award.getRecordID(award);
					String awardID = Award.getStringID(award);
		%>

		<tr id="view<%=awardID%>">
				<td><%=participantID%></td>
				<td><%=recordID %></td>
				<td><%=awardName %></td>
				<td><button type="button" onclick="editButton(<%=awardID%>)">Edit</button></td>
		</tr>
		
		<tr id="edit<%=awardID%>" style="display: none">
				<td><input id="participantID<%=awardID%>" type="text" name="participantID" value="<%=participantID%>" size="20" /></td>
				<td><input id="recordID<%=awardID%>" type="text" name="recordID" value="<%=recordID%>" size="20" /></td>
				<td><input id="awardName<%=awardID%>" type="text" name="awardName" value="<%=awardName%>" size="20" /></td>
				<td><button type="button" onclick="cancelButton(<%=awardID%>)">cancel</button><button type="button" onclick="saveButton(<%=awardID%>)">save</button></td>
		</tr>
		
		<%
			}

		}
		%>

	</table>
	


	<hr />
	<form action="addAward" method="post">
	<table>
		<tr>
			<td>ParticipantID</td>
			<td>RecordID</td>
			<td>Value</td>
		</tr>
		<tr>
	    	<td><input type="text" name="participantID" size="20" /></td>
			<td><input type="text" name="recordID" size="20" /></td>
			<td><input type="text" name="awardName" size="20" /></td>
		</tr>
	</table>
		<input type="submit" value="Add Award" />
    </form>
    
    <div>
    	<form id="finalSubmit" action="updateAward" method="post">
	    	<input id="awardIDUpdate" type="hidden" name="id" value="" />
	    	<input id="participantIDUpdate" type="hidden" name="participantID" />
			<input id="recordIDUpdate" type="hidden" name="recordID"  />
			<input id="awardNameUpdate" type="hidden" name="awardName"  />
    	</form>
    </div>



<%
        }
    }

%>
</div>
</div>
  </body>

</html>