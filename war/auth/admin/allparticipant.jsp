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
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!--  
   Copyright 2014 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Karen
   
   Version 0.1 - Spring 2014
-->


<html>
<head>

<title>Local Olympics - All Participants</title>
<link type="text/css" rel="stylesheet" href="/stylesheets/admin.css" />
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>

<script>


var selectedParticipantForEdit = null  
var editNameError = false;
var editLoginIDError = false;

$(document).ready(function(){ //test
	
	// keypress event for Add button
	$("#addParticipantInput").keyup(function() {
	loginID=$("#addParticipantInput").val();
	if (checkParticipantLoginID(loginID)) {
		$("#addParticipantButton").attr("enabled",null);
		$("#addParticipantError").show();
	} else {
		$("#addParticipantButton").attr("enabled","enabled");
		if (loginID!=null && loginID.length>0) 
			$("#addParticipantError").show();
	}
	});
	
	$(".editParticipantNameInput").keyup(function() {
		if (selectedParticipantForEdit==null)
			return;
		name=$("#editParticipantNameInput"+selectedParticipantForEdit).val();
		editNameError = ! checkParticipantName(name);
		updateSaveEditButton();
		});
	
	
	$(".editParticipantLoginIDInput").keyup(function() {
		if (selectedParticipantForEdit==null)
			return;
		loginID=$("#editParticipantLoginIDInput"+selectedParticipantForEdit).val();
		editNameError = ! checkParticipantLoginID(loginID);
		updateSaveEditButton();
		});
	
});	



function updateSaveEditButton() {
	if (editLoginIDError) {
		$("#saveEditParticipantButton"+selectedParticipantForEdit).attr("disabled","disabled");
	} else {
		$("#saveEditParticipantButton"+selectedParticipantForEdit).attr("disabled",null);
	}
	
}

function checkParticipantLoginID(loginID) {
	return loginID!=null && loginID.length!="";
}


//"\\A[A-Za-z]+([ -][A-Za-z]+){2,10}\\Z"

var ParticipantNamePattern = /^[A-Za-z]+([ -][A-Za-z]+){0,10}$/
ParticipantNamePattern.compile(ParticipantNamePattern)

// check the syntax of the name of a Participant 
function checkParticipantName(name) {
	return ParticipantNamePattern.test(name);
}

function disableAllButtons(value) {
	$(".deletebutton").attr("disabled", (value)?"disabled":null);
	$(".editbutton").attr("disabled", (value)?"disabled":null);
	if (value)
		$("#addParticipantButton").attr("disabled", (value)?"disabled":null);
}

function deleteButton(ParticipantID) {
	disableAllButtons(false);
	$("#delete"+ParticipantID).show();
}




var selectedParticipantForDelete=null;

function confirmDeleteParticipant(ParticipantID) {
	selectedParticipantForDelete=ParticipantID;
	$.post("/admin/deleteparticipant", 
			{ParticipantID: ParticipantID}, 
			function (data,status) {
				//alert("Data "+data+" status "+status);
				if (status="success") {
					location.reload();
				} else {
					canceldeleteParticipant(selectedParticipantForDelete);
					selectedParticipant=null;
				}
			}
			
	);
	
}

function cancelDeleteParticipant(ParticipantID) {
	$("#delete"+ParticipantID).show();
	disableAllButtons(false);
}

var selectedParticipantOldName=null;
var selectedParticipantOldLoginID=null;

function editButton(ParticipantID) {
	selectedParticipantForEdit=ParticipantID;
	disableAllButtons(false);
	editNameError = false;
	editLocationError = false;
	editAddressError = false;
	updateSaveEditButton();
	selectedParticipantOldName=$("#editParticipantNameInput"+selectedParticipantForEdit).val();
	selectedParticipantOldLoginID=null;
	$("#view"+ParticipantID).show();
	$("#edit"+ParticipantID).show();
}


function cancelEditParticipant(ParticipantID) {
	$("#editParticipantNameInput"+selectedParticipantForEdit).val(selectedParticipantOldName);
	$("#edit"+ParticipantID).hide();
	$("#view"+ParticipantID).show();
	disableAllButtons(false);
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

  <body >
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
			<li><a href="/auth/user/profile.jsp" >PROFILE</a></li>
			<li><a href="/logout" >LOGOUT</a></li>
		</ul>
		</div>

    	<br />
    	<br />
	<%
		List<Entity> allParticipants = Participant.getFirstParticipants(100);
		if (allParticipants.isEmpty()) {
	%>
	<h1>No Participant  Defined</h1>


			<a href="/admin/allActivity.jsp">Activities</a>


			<a href="/admin/allRecords.jsp">Records</a>


	<%
		} else {
	%>
	<h1>ALL Participants</h1>

			<a href="/admin/allActivity.jsp">Activities</a>

			<a href="/admin/allRecords.jsp">Records</a>

	<table id="main">
		<tr>
			<th class="ParticipantOperationsList">Operations</th>
			<th>Participant  Login ID</th>
			<th>Participant email</th>

		</tr>
		<%
			for (Entity Participant1 : allParticipants) {
				String ParticipantFirstName = Participant.getFirstName(Participant1);
				String ParticipantLastName = Participant.getLastName(Participant1);
				String ParticipantID = Participant.getStringID(Participant1);
				String ParticipantLoginID = Participant.getLoginID(Participant1);
				String birthday = Participant.getBirthday(Participant1);
				String address = Participant.getAddress(Participant1);
				String activityChoice = Participant.getActivity(Participant1);
				String aboutme = Participant.getAboutMe(Participant1);
				String gender = Participant.getGender(Participant1);
				String isAdmin = Participant.getIsAdmin(Participant1);
				String validated = Participant.getValidatedEmail(Participant1);
				String email = Participant.getEmail(Participant1);
				
					
		%>

		<tr>
			<td class="ParticipantOperationsList">
				<button class="editbutton" type="button"
					onclick="editButton(<%=ParticipantID%>)">Edit</button>
				<button class="deletebutton" type="button"
					onclick="deleteButton(<%=ParticipantID%>)">Delete</button>
			</td>

			<td><div id="view<%=ParticipantID%>"><%=ParticipantLoginID%></div>

				<div id="edit<%=ParticipantID%>" style="display: none">

					<form action="updateparticipant" method="get">
						<input type="hidden" value="<%=ParticipantID%>"
							name="ParticipantID" />
						<table class="editTable">
							<tr>
								<td class="editTable">Login ID:</td>
								<td class="editTable"><input type="text" class="editText"
									value="<%=ParticipantLoginID%>" name="ParticipantLoginID" /></td>
							</tr>
							<tr>
								<td class="editTable" width=90>First Name:</td>
								<td class="editTable"><input type="text"
									id="editParticipantFirstNameInput<%=ParticipantID%>"
									class="editParticipantNameInput" value="<%=ParticipantFirstName%>"
									name="participantFirstName" />
								</td>
										
							</tr>
							<tr>
								<td class="editTable" width=90>Last Name:</td>
								<td class="editTable"><input type="text"
									id="editParticipantLastNameInput<%=ParticipantID%>"
									class="editParticipantNameInput" value="<%=ParticipantLastName%>"
									name="participantLastName" />
									</td>
										
							</tr>
							<tr>
							      <td class="editTable" width=90>Birthdate:</td>
							      <td class="editTable">
							      <div id="editParticipantBirthDateInput<%=ParticipantID%>"
							      class="editParticipantBirthDateInput" ><input type=text value="<%=birthday%>"
							      name="birthday" /></div></td>
							</tr>
								<tr>
							      <td class="editTable" width=90>Address</td>
							      <td class="editTable">
							      <div id="editParticipantZipcodeInput<%=ParticipantID%>"
							      class="editParticipantZipcodeInput"><input type="text" value="<%=address%>"
							      name="address" /></div></td>
							</tr>
							
							<tr>
							      <td class="editTable" width=90>Activity Choice</td>
							      <td class="editTable">
							      <div id="editParticipantActivityInput<%=ParticipantID%>"
							      class="editParticipantActivityInput"><input type="text" value="<%=activityChoice%>"
							      name="activity" /></div></td>
							</tr>
							
							
							<tr>
							      <td class="editTable" width=90>Info</td>
							      <td class="editTable">
							      <div id="editParticipantInfoInput<%=ParticipantID%>"
							      class="editParticipantInfoInput"><input type="text" value="<%=aboutme%>"
							      name="aboutme" /></div></td>
							</tr>
							
							<tr>
							      <td class="editTable" width=90>Gender</td>
							      <td class="editTable">
							      <div id="editParticipantGenderInput<%=ParticipantID%>"
							      class="editParticipantGenderInput"><input type="text" value="<%=gender%>"
							      name="gender" /></div></td>
							</tr>
							
							<tr>
							      <td class="editTable" width=90>isAdmin</td>
							      <td class="editTable">
							      <div id="editParticipantIsAdminInput<%=ParticipantID%>"
							      class="editParticipantIsAdminInput"><input type="text" value="<%=isAdmin%>"
							      name="isAdmin" /></div></td>
							</tr>
							
							<tr>
							      <td class="editTable" width=90>Validated Email</td>
							      <td class="editTable">
							      <div id="editParticipantValidatedInput<%=ParticipantID%>"
							      class="editParticipantValidatedInput"><input type="text" value="<%=validated%>"
							      name="validated" /></div></td>
							</tr>
							
							<tr>
							      <td class="editTable" width=90>Email</td>
							      <td class="editTable">
							      <div id="editParticipantEmailInput<%=ParticipantID%>"
							      class="editParticipantEmailInput"><input type="text" value="<%=email%>"
							      name="email" /></div></td>
							</tr>
							

							
						</table>
						<input id="saveEditParticipantButton<%=ParticipantID%>"
							type="submit" value="Save" />
						<button type="button"
							onclick="cancelEditParticipant(<%=ParticipantID%>)">Cancel</button>
					</form>
				</div>

				<div id="delete<%=ParticipantID%>" style="display: none">
					Do you want to delete this Participant?
					<button type="button"
						onclick="confirmDeleteParticipant(<%=ParticipantID%>)">Delete</button>
					<button type="button"
						onclick="cancelDeleteParticipant(<%=ParticipantID%>)">Cancel</button>
				</div></td>
				<td>
					<%=email %>
				</td>

		</tr>

		<%
			}

			}
		%>

		<tfoot>
			<tr>
				<td colspan="2" class="footer">
					<form name="addParticipantForm"
						action="/admin/addparticipant" method="get">
						New Participant  Login ID: <input id="addParticipantInput"
							type="text" name="ParticipantLoginID" size="50" /> <input
							id="addParticipantButton" type="submit" value="Add"
							 />
					</form>
					<div id="addParticipantError" class="error" style="display: none">Invalid
						Participant  login ID (minimum 1 character)</div>
				</td>
			</tr>
		</tfoot>

	</table>
	</div>
</div>

<%
        }
    }
%>
</body>
</html>

