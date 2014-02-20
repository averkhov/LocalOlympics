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

<title>All Participants</title>
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>

<script>s


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
	if (editNameError||editLoginIDError) {
		$("#saveEditParticipantButton"+selectedParticipantForEdit).attr("disabled","disabled");
	} else {
		$("#saveEditParticipantButton"+selectedParticipantForEdit).attr("disabled",null);
	}
	if (editNameError) {
		$("#editParticipantNameError"+selectedParticipantForEdit).show();
	} else {
		$("#editParticipantNameError"+selectedParticipantForEdit).show();
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
	$("#edit"+ParticipantID).show();
	$("#view"+ParticipantID).show();
	disableAllButtons(false);
}

</script>

</head>

<body>


	<a href="/index.html">home</a>
	
	
	<%
		List<Entity> allParticipants = Participant.getFirstParticipants(100);
		if (allParticipants.isEmpty()) {
	%>
	<h1>No Participant  Defined</h1>
	<div class="menu">
		<div class="menu_item">
			<a href="/admin/allActivity.jsp">Activities</a>
		</div>
		<div class="menu_item">
			<a href="/admin/allRecords.jsp">Records</a>
		</div>
		
	</div>
	<%
		} else {
	%>
	<h1>ALL Participants</h1>
	<div class="menu">
		<div class="menu_item">
			<a href="/admin/allActivity.jsp">Activities</a>
		</div>
		<div class="menu_item">
			<a href="/admin/allRecords.jsp">Records</a>
		</div>
		
	</div>
	<table id="main">
		<tr>
			<th class="ParticipantOperationsList">Operations</th>
			<th>Participant  Login ID</th>

		</tr>
		<%
			for (Entity Participant1 : allParticipants) {
				String ParticipantName = Participant.getName(Participant1);
				String ParticipantID = Participant.getStringID(Participant1);
				String ParticipantLoginID = Participant.getLoginID(Participant1);
				
					
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

					<form action="/admin/updateparticipant" method="get">
						<input type="hidden" value="<%=ParticipantID%>"
							name="ParticipantID" />
						<table class="editTable">
							<tr>
								<td class="editTable">Login ID:</td>
								<td class="editTable"><input type="text" class="editText"
									value="<%=ParticipantLoginID%>" name="ParticipantLoginID" /></td>
							</tr>
							<tr>
								<td class="editTable" width=90>Name:</td>
								<td class="editTable"><input type="text"
									id="editParticipantNameInput<%=ParticipantID%>"
									class="editParticipantNameInput" value="<%=ParticipantName%>"
									name="ParticipantName" />
									<div id="editParticipantNameError<%=ParticipantID%>"
										class="error" style="display: none">Invalid Participant
										name (minimum 3 characters: letters, digits, spaces, -, ')</div></td>
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

</body>
</html>

