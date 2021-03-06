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
    
    <title>Local Olympics</title>
    
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    
    <script>
    
    
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
	    
	    function updateProfile() {
	    	var alias = $("#updateAlias").val();
    		$.post("/validateAlias", 
    				{alias: alias}, 
    				function (data,status) {
    					//alert("Data "+data+" status "+status);
    					if (status!="success") {
    						alert("Alias already in use. Please choose a new alias.");
    					} else {
    						document.forms["updateForm"].submit();
    					}
    				}		
    		);
	    }
	    
	    function createProfile() {
	    	var alias = $("#createAlias").val();
    		$.post("/validateAlias", 
    				{alias: alias}, 
    				function (data,status) {
    					//alert("Data "+data+" status "+status);
    					if (status!="success") {
    						alert("Alias already in use. Please choose a new alias.");
    					} else {
    						document.forms["createForm"].submit();
    					}
    				}		
    		);
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
    	
    	//Temporary Fix User Id issue for all users that log in with incorrect user id feilds
    	
    	if(Participant.getParticipantWithLoginID(user.getNickname()) != null){
    		Participant.setEmail(Participant.getParticipantWithLoginID(user.getNickname()), user.getNickname());
    		Participant.setUserId(Participant.getParticipantWithLoginID(user.getNickname()), user.getUserId());
    	}
    	
    	Entity participant = Participant.getParticipantWithLoginID(user.getUserId());
      	pageContext.setAttribute("user", user);
      	        
        if(participant == null){
        	
        	
        	
        	%>
        	
        	<div class="top" style="float:left">
				<a class="topbarmenumain" href="/index.jsp">LOCAL OLYMPICS</a>
			</div>
			<div class="top" id="menudrop" style="float:right"><a href="#" class="topbarmenu" onmouseover="popup();" onmouseout="popoff();"><%=user.getNickname()%></a></div>
			<div id="popup" class="popup" onmouseover="popup();" onmouseout="popoff();" style="display:none">
			<ul>
				<li><a class="topbarmenu" href="profile.jsp" >PROFILE</a><hr/></li>
				<li><a class="topbarmenu" href="/logout" onmouseover="popup();">LOGOUT</a></li>
			</ul>
		</div>

    	<br />
    	<br />
    	
    	<h2>Welcome <%=user.getNickname() %>! Please create your profile below.</h2>
    	<div style="margin-left:auto;margin-right:auto;width:75%;">
		<div style="background-color:white; border-radius:20px;padding: 15px;">
		<form id="createForm" action="/auth/user/addParticipant" method="post">
		
			<table id="profftable">
				<tr>
					<td>First Name: </td><td><input type="text" name="participantFirstName" size="30" required /></td>
				</tr>
				<tr>
					<td>Last Name: </td><td><input type="text" name="participantLastName" size="30" required /></td>
				</tr>
				
				<tr>
					<td>Alias: </td><td><input id="createAlias" type="text" name="participantAlias" size="30" required /></td>
				</tr>
				

				 <tr>
					<td>Gender: </td> 
					<td><input type = "radio" name = "gender" value = "male" /> Male     <input type = "radio" name = "gender" value = "female" /> Female</td>
					</tr>
				<tr> 
					<td> Birthday: </td>
					<td><input type = "text" name = "birthday" /> </td>
				</tr>
				
				<tr>
					<td>Favorite Activity: </td>
					<td>
				    	<select name = "activity">
							<option value = ""> </option>
							<option value = "Running">Running </option>
							<option value = "Walking">Walking</option>
							<option value = "Swimming">Swimming</option>
							<option value = "Hiking" >Hiking</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>About Me</td>
					<td><textarea name = "aboutme" cols="40" rows="6" ></textarea></td>
				</tr>
				<tr> 
					<td>Zip Code: </td>
					<td><input type = "text" name = "address" required /> </td>
				</tr>
				<tr> 
					<td>Email Address: </td>
					<td><input type = "text" name = "email" required /> </td>
				</tr>
			</table>
			<input type="hidden" name="ParticipantLoginID" value="<%=user.getUserId()%>" />
			<button type="button" onclick="createProfile()" >Create</button>
		</form>
        	</div>
        	</div>
        	<%
        	
        }else{
        	
	%>
		<div class="top" style="float:left">
			<a class="topbarmenumain"href="/index.jsp">LOCAL OLYMPICS</a>
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
    	
    	<%
    		if(Participant.getAlias(participant).equals("")){
    	%>
    	
		<h2>Welcome <%=Participant.getFirstName(participant) %>! Edit your profile below!</h2>
		<h3>Your Account is missing an alias please create an alias to proceed.</h3>
		<div style="margin-left:auto;margin-right:auto;width:75%;">
		<div style="background-color:white; border-radius:20px;padding: 15px;">
		<form  id="updateForm" action="/auth/user/updateParticipant" method="post">
			<table id="profftable">
				<tr>
					<td>First Name: </td><td><input type="text" name="participantFirstName" size="30" value="<%=Participant.getFirstName(participant) %>" required /></td>
				</tr>
				<tr>
					<td>Last Name: </td><td><input type="text" name="participantLastName" size="30" value="<%=Participant.getLastName(participant) %>" required /></td>
				</tr>
				
				<tr>
					<td>Alias: </td><td><input id="updateAlias" type="text" name="participantAlias" size="30"  required /></td>
				</tr>
				
				<%
				    if(Participant.getGender(participant).equals("male"))
				    {
				    	%>
				    	<tr>
					<td>Gender: </td> 
					<td><input type = "radio" name = "gender" value = "male" checked/> Male     <input type = "radio" name = "gender" value = "female" /> Female</td>
					</tr>
					<% 
				    }
				    else if(Participant.getGender(participant).equals("female"))
				    {
				    	%>
				    	<tr>
					<td>Gender: </td> 
					<td><input type = "radio" name = "gender" value = "male" /> Male     <input type = "radio" name = "gender" value = "female" checked/> Female</td>
					</tr>
					<%
				    }
				    else
				    {
				    	%>
				    	<tr>
					<td>Gender: </td> 
					<td><input type = "radio" name = "gender" value = "male" /> Male     <input type = "radio" name = "gender" value = "female" /> Female</td>
					</tr>
					<% 
				    }
				%>
				<tr> 
					<td>Birthday: </td>
					<td><input type = "text" name = "birthday" value = "<%=Participant.getBirthday(participant)%>" /> </td>
				</tr>
				
				<tr>
					<td>Favorite Activity: </td>
					<td>
					<%
					  if(Participant.getActivity(participant).equals("Running"))
					  {
						  %>
						  <select name = "activity">
							<option value = "Running" selected>Running </option>
							<option value = "Walking">Walking</option>
							<option value = "Swimming">Swimming</option>
							<option value = "Hiking">Hiking</option>
							</select>
							<% 
					  }
					  else if(Participant.getActivity(participant).equals("Walking"))
					  {
						  %>
						  <select name = "activity">
					<option value = ""> </option>
					<option value = "Running">Running </option>
					<option value = "Walking" selected>Walking</option>
					<option value = "Swimming">Swimming</option>
					<option value = "Hiking">Hiking</option>
					</select>
						  
						  <% 
					  }
					  else if(Participant.getActivity(participant).equals("Swimming"))
					  {
						  %>
						  <select name = "activity">
					<option value = ""> </option>
					<option value = "Running">Running </option>
					<option value = "Walking">Walking</option>
					<option value = "Swimming" selected>Swimming</option>
					<option value = "Hiking">Hiking</option>
					</select>
						  <%
					  }
					  else if (Participant.getActivity(participant).equals("Hiking"))
					  { %>
						  <select name = "activity">
					<option value = ""> </option>
					<option value = "Running">Running </option>
					<option value = "Walking">Walking</option>
					<option value = "Swimming">Swimming</option>
					<option value = "Hiking" selected>Hiking</option>
					</select>
						  <%
					  }
					  else
					  {
						 %>
						  <select name = "activity">
					<option value = ""> </option>
					<option value = "Running">Running </option>
					<option value = "Walking">Walking</option>
					<option value = "Swimming">Swimming</option>
					<option value = "Hiking" >Hiking</option>
					</select>
						 <%  
						  
					  }
					%>
					</td>
				</tr>
				<tr>
					<td>About Me</td>
					<td><textarea name = "aboutme"  cols="40" rows="6" ><%=Participant.getAboutMe(participant)%></textarea></td>
				</tr>
				<tr> 
					<td>Zip Code: </td>
					<td><input type = "text" name = "address" value="<%=Participant.getAddress(participant) %>" required /> </td>
				</tr>
				<tr> 
					<td>Email: </td>
					<td><input type = "text" name = "email" value="<%=Participant.getEmail(participant) %>" required /> </td>
				</tr>
			</table>
			<input type="hidden" name="ParticipantLoginID" value="<%=user.getUserId()%>" />
			<input type="hidden" name="ParticipantID" value="<%=Participant.getStringID(participant)%>" />
			<button type="button" onclick="updateProfile()" >Update</button>
		</form>
		</div>
		</div>


<%
    		}else{

    	%>
    	
		<h2>Welcome <%=Participant.getFirstName(participant) %>! Edit your profile below!</h2>
		<div style="margin-left:auto;margin-right:auto;width:75%;">
		<div style="background-color:white; border-radius:20px;padding: 15px;">
		<form action="/auth/user/updateParticipant" method="post">
			<table id="profftable">
				<tr>
					<td>First Name: </td><td><input type="text" name="participantFirstName" size="30" value="<%=Participant.getFirstName(participant) %>" required /></td>
				</tr>
				<tr>
					<td>Last Name: </td><td><input type="text" name="participantLastName" size="30" value="<%=Participant.getLastName(participant) %>" required /></td>
				</tr>
				
				<tr>
					<td>Alias: </td><td><%=Participant.getAlias(participant) %><input type="text" name="participantAlias" size="30" value="<%=Participant.getAlias(participant) %>" hidden="true"  /></td>
				</tr>
				
				<%
				    if(Participant.getGender(participant).equals("male"))
				    {
				    	%>
				    	<tr>
					<td>Gender: </td> 
					<td><input type = "radio" name = "gender" value = "male" checked/> Male     <input type = "radio" name = "gender" value = "female" /> Female</td>
					</tr>
					<% 
				    }
				    else if(Participant.getGender(participant).equals("female"))
				    {
				    	%>
				    	<tr>
					<td>Gender: </td> 
					<td><input type = "radio" name = "gender" value = "male" /> Male     <input type = "radio" name = "gender" value = "female" checked/> Female</td>
					</tr>
					<%
				    }
				    else
				    {
				    	%>
				    	<tr>
					<td>Gender: </td> 
					<td><input type = "radio" name = "gender" value = "male" /> Male     <input type = "radio" name = "gender" value = "female" /> Female</td>
					</tr>
					<% 
				    }
				%>
				<tr> 
					<td>Birthday: </td>
					<td><input type = "text" name = "birthday" value = "<%=Participant.getBirthday(participant)%>" /> </td>
				</tr>
				
				<tr>
					<td>Favorite Activity: </td>
					<td>
					<%
					  if(Participant.getActivity(participant).equals("Running"))
					  {
						  %>
						  <select name = "activity">
							<option value = "Running" selected>Running </option>
							<option value = "Walking">Walking</option>
							<option value = "Swimming">Swimming</option>
							<option value = "Hiking">Hiking</option>
							</select>
							<% 
					  }
					  else if(Participant.getActivity(participant).equals("Walking"))
					  {
						  %>
						  <select name = "activity">
					<option value = ""> </option>
					<option value = "Running">Running </option>
					<option value = "Walking" selected>Walking</option>
					<option value = "Swimming">Swimming</option>
					<option value = "Hiking">Hiking</option>
					</select>
						  
						  <% 
					  }
					  else if(Participant.getActivity(participant).equals("Swimming"))
					  {
						  %>
						  <select name = "activity">
					<option value = ""> </option>
					<option value = "Running">Running </option>
					<option value = "Walking">Walking</option>
					<option value = "Swimming" selected>Swimming</option>
					<option value = "Hiking">Hiking</option>
					</select>
						  <%
					  }
					  else if (Participant.getActivity(participant).equals("Hiking"))
					  { %>
						  <select name = "activity">
					<option value = ""> </option>
					<option value = "Running">Running </option>
					<option value = "Walking">Walking</option>
					<option value = "Swimming">Swimming</option>
					<option value = "Hiking" selected>Hiking</option>
					</select>
						  <%
					  }
					  else
					  {
						 %>
						  <select name = "activity">
					<option value = ""> </option>
					<option value = "Running">Running </option>
					<option value = "Walking">Walking</option>
					<option value = "Swimming">Swimming</option>
					<option value = "Hiking" >Hiking</option>
					</select>
						 <%  
						  
					  }
					%>
					</td>
				</tr>
				<tr>
					<td>About Me</td>
					<td><textarea name = "aboutme"  cols="40" rows="6" ><%=Participant.getAboutMe(participant)%></textarea></td>
				</tr>
				<tr> 
					<td>Zip Code: </td>
					<td><input type = "text" name = "address" value="<%=Participant.getAddress(participant) %>" required /> </td>
				</tr>
				<tr> 
					<td>Email: </td>
					<td><input type = "text" name = "email" value="<%=Participant.getEmail(participant) %>" required /> </td>
				</tr>
			</table>
			<input type="hidden" name="ParticipantLoginID" value="<%=user.getUserId()%>" />
			<input type="hidden" name="ParticipantID" value="<%=Participant.getStringID(participant)%>" />
			<input type="submit" value="update" />
		</form>
		</div>
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