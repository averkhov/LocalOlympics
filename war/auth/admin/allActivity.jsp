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

<%@page import="localolympics.db.Activity"%>

<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!--  
   Copyright 2014 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Karen Bacon
   
   Version 0.1 - Spring 2014
-->

<!-- test -->

<html>
<head>



<title>Activity</title>

<script>


function deleteButton(activityID) {
	
	$("#delete"+activityID).show();
}

var selectedActivityForDelete=null;

function confirmDeleteActivity(activityID) {
	selectedActivityForDelete=activityID;
	$.post("deleteActivity",
			{
			activityID: activityID, 
			
			}, 
			function (data,status) {
				//alert("Data "+data+" status "+status);
				if (status="success") {
					location.reload(true);
				} else {
					canceldeleteactivity(selectedactivityForDelete);
					selectedActivity=null;
				}
			}
			
	);
	
}

function cancelDeleteActivity(activityID) {
	$("#delete"+activityID).hide();
	disableAllButtons(false);
}

</script>
</head>
<body>


	<a href="/index.html">home</a>

	
	<%
	
	
		List<Entity> allActivity = Activity.getFirstActivity(100);
		if (allActivity.isEmpty()) {
	%>
	<h1>No Activities Entered</h1>
	<%
		}else{	
	%>
		
		
	<table>
		<%
			for (Entity activity : allActivity) {
					String activityName = Activity.getName(activity);
					String activityID = Activity.getStringID(activity);
		%>

		<tr>

			<td><%=activityName%></td>

		</tr>
		
		
		<tr>
			<td class="adminOperationsList">
				<button class="editbutton" type="button"
					onclick="editButton(<%=activityID%>, '<%=activityName%>')">Edit</button>
				<button class="deletebutton" type="button" onclick="deleteButton(<%=activityID%>)">Delete</button>
			</td>

			<td><div id="view<%=activityID%>"><%=activityName%></div>

				<div id="edit<%=activityID%>" style="display: none">

					<form id="form<%=activityID%>" action="updateActivity" method="get">
						
						<input type="hidden" value="<%=activityID%>" name="activityID" />
						

						<table class="editTable">
							<tr>
								<td class="editTable" width=90>Name:</td>
								<td class="editTable"><input type="text" id="editActivityNameInput<%=activityName%>" class="editActivityNameInput"
										value="<%=activityName%>" name="activityName" />
									<div id="editActivityNameError<%=activityID%>" class="error" style="display: none">Invalid activity name (minimum 3
										characters: letters, digits, spaces, -, ')</div></td>
							</tr>
						
							
						</table>
		
					</form>
				</div>

				<div id="delete<%=activityID%>" style="display: none">
					Do you want to delete this activity?
					<button type="button" onclick="confirmDeleteActivity(<%=activityID%>)">Delete</button>
					<button type="button" onclick="cancelDeleteActivity(<%=activityID%>)">Cancel</button>
				</div></td>

			
		</tr>
		
		
		
		
		

		<%
			}

		}
		%>

	</table>
	


    <form action="addActivity" method="get">
      <div><input type="text" name="ActivityName" size="50" /></div>
      <div><input type="submit" value="Add Activity" /></div>
    </form>


</body>
</html>


