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
    <link type="text/css" rel="stylesheet" href="/stylesheets/admin.css" />
    
    <title>Local Olympics - All Records</title>
    
    
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    
    <script>
	

    function editButton(recordID) {
    	document.getElementById("view"+recordID).style.display = "none";
    	document.getElementById("edit"+recordID).style.display = "";
    }
    
    function cancelButton(recordID) {
    	document.getElementById("view"+recordID).style.display = "";
    	document.getElementById("edit"+recordID).style.display = "none";
    }
    
    function deleteButton(ID) {
    	if(confirm('Are you sure you want to delete this Record?')){
    		window.location = 'deleteRecord?id=' + ID;
    	}else{
    	}
    }
    
    function saveButton(recordID) {
    	$("#recordIDUpdate").val(recordID);
    	$("#participantIDUpdate").val($("#participantID"+recordID).val());
    	$("#activityIDUpdate").val($("#activityID"+recordID).val());
    	$("#recordTimeUpdate").val($("#recordTime"+recordID).val());
    	$("#awardLevelUpdate").val($("#awardLevel"+recordID).val());
    	$("#isValidUpdate").val($("#isValid"+recordID).val());
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
    	
    	Entity participant = Participant.getParticipantWithLoginID(user.getUserId());
      	pageContext.setAttribute("user", user);
      	        
        if(participant == null){
        	
        	%>
        	
        	<jsp:forward page="/auth/user/editProfile.jsp" />
        	
        	<%
        	
        }else{
        	
	%>
		<div class="top" style="float:left">
			<a class="topbarmenu" href="/index.jsp">LOCAL OLYMPICS</a> | 
			<a class="topbarmenu" href="/auth/user/home.jsp">HOME</a> | 
			<a class="topbarmenu" href="/auth/admin/admin.jsp">ADMIN</a>
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
  
  
	<%
		List<Entity> allRecords = Record.getFirstRecords(100);
		if (allRecords.isEmpty()) {
	%>
	<h1>No Records Entered</h1>
	<%
		}else{	
	%>
	
	<h1>All Records</h1>
	<table class="myTable" border="1">
		<tr>
			<td>ParticipantID</td>
			<td>Participant alias</td>
			<td>ActivityID</td>
			<td>Value</td>
			<td>AwardLevel</td>
			<td>ActivityName</td>
			<td>isValid</td>
			<td>Edit</td>
			<td>Delete</td>
		</tr>
		<%
			for (Entity record : allRecords) {
					String recordTime = Record.getValue(record);
					String participantID = Record.getParticipantID(record);
					String activityID = Record.getActivityID(record);
					String recordID = Record.getStringID(record);
					String awardLevel = Record.getAward(record);
					String activityName = "";
					String participantAlias = "";
					if(Activity.getActivity(activityID)==null){
						activityName="";
					}else{
						activityName = Activity.getName(Activity.getActivity(activityID));
					}
					if(Participant.getParticipant(participantID)==null){
						participantAlias="";
					}else{
						participantAlias = Participant.getAlias((Participant.getParticipant(participantID)));
					}
					String isValid = "";
					if(Record.getIsValid(record)!=null){
						isValid = Record.getIsValid(record);
					}
					
					
					
		%>

		<tr id="view<%=recordID%>">
				<td><%=participantID%></td>
				<td><%=participantAlias %></td>
				<td><%=activityID %></td>
				<td><%=recordTime %></td>
				<td><%=awardLevel %></td>
				<td><%=activityName %></td>
				<td><%=isValid %></td>
			
				<td><button type="button" onclick="editButton(<%=recordID%>)">Edit</button></td>
				<td><button type="button" onclick="deleteButton(<%=recordID%>)">Delete</button></td>
		</tr>
		
		<tr id="edit<%=recordID%>" style="display: none">
				<td><input id="participantID<%=recordID%>" type="text" name="participantID" value="<%=participantID%>" size="20" /></td>
				<td><input type="text" name="participantAlias" value="<%=participantAlias%>" size="20" /></td>
				<td><input id="activityID<%=recordID%>" type="text" name="activityID" value="<%=activityID%>" size="20" /></td>
				<td><input id="recordTime<%=recordID%>" type="text" name="recordTime" value="<%=recordTime%>" size="20" /></td>
				<td><input id="awardLevel<%=recordID%>" type="text" name="awardLevel" value="<%=awardLevel%>" size="20" /></td>
				
				<td><input type="text" name="activityName" value="<%=activityName%>" size="20" disabled="disabled" /></td>
				<td><input id="isValid<%=recordID%>" type="text" name="isValid" value="<%=isValid%>" size="20" /></td>
				
				
				<td><button type="button" onclick="cancelButton(<%=recordID%>)">cancel</button><button type="button" onclick="saveButton(<%=recordID%>)">save</button></td>
				<td><button type="button" onclick="deleteButton(<%=recordID%>)">Delete</button></td>
		</tr>
		
		<%
			}

		}
		%>

	</table>
	


	<hr />
	<form action="addRecord" method="post">
	<table>
		<tr>
			<td>ParticipantID</td>
			<td>ActivityID</td>
			<td>Value</td>
			
		</tr>
		<tr>
	    	<td><input type="text" name="participantID" size="20" /></td>
			<td><input type="text" name="activityID" size="20" /></td>
			<td><input type="text" name="recordTime" size="20" /></td>
			
		</tr>
	</table>
		<input type="submit" value="Add Record" />
    </form>
    
    <div>
    	<form id="finalSubmit" action="updateRecord" method="post">
	    	<input id="recordIDUpdate" type="hidden" name="id" value="" />
	    	<input id="participantIDUpdate" type="hidden" name="participantID" />
			<input id="activityIDUpdate" type="hidden" name="activityID"  />
			<input id="recordTimeUpdate" type="hidden" name="recordTime"  />
			<input id ="awardLevelUpdate" type="hidden" name="awardLevel" />
			<input id ="isValidUpdate" type="hidden" name="isValid" />
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