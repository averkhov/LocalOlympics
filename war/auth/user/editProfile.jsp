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
        	
        	<div class="top" style="float:left">
				<a href="/index.jsp">INDEX</a> | 
				<a href="/auth/user/home.jsp">HOME</a>
			</div>
			<div class="top" id="menudrop" style="float:right"><a href="#" onmouseover="popup();" onmouseout="popoff();"><%=user.getNickname()%></a></div>
			<div id="popup" class="popup" onmouseover="popup();" onmouseout="popoff();" style="display:none">
			<ul>
				<li><a href="profile.jsp" >PROFILE</a></li>
				<li><a href="/logout" onmouseover="popup();">LOGOUT</a></li>
			</ul>
		</div>

    	<br />
    	<br />
    	
    	<h2>Welcome <%=user.getNickname() %>! Please create your profile below.</h2>
		<form action="addParticipant" method="post">
			<table>
				<tr>
					<td>First Name: </td><td><input type="text" name="participantFirstName" size="30" required /></td>
				</tr>
				<tr>
					<td>Last Name: </td><td><input type="text" name="participantLastName" size="30" required /></td>
				</tr>
				
				<tr>
					<td>Alias: </td><td><input type="text" name="participantAlias" size="30" required /></td>
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
			</table>
			<input type="hidden" name="ParticipantLoginID" value="<%=user.getNickname()%>" />
			<input type="submit" value="Update" />
		</form>
        	
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
    	
    	<%
    		if(Participant.getAlias(participant).equals("")){
    	%>
    	
		<h2>Welcome <%=Participant.getFirstName(participant) %>! Edit your profile below!</h2>
		<form  action="updateParticipant" method="post">
			<table>
				<tr>
					<td>First Name: </td><td><input type="text" name="participantFirstName" size="30" value="<%=Participant.getFirstName(participant) %>" required /></td>
				</tr>
				<tr>
					<td>Last Name: </td><td><input type="text" name="participantLastName" size="30" value="<%=Participant.getLastName(participant) %>" required /></td>
				</tr>
				
				<tr>
					<td>Alias: </td><td><input type="text" name="participantAlias" size="30"  required /></td>
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
					<td><input type = "text" name = "address" value="<%=Participant.getAddress(participant) %>"/> </td>
				</tr>
			</table>
			<input type="hidden" name="ParticipantLoginID" value="<%=user.getNickname()%>" />
			<input type="hidden" name="ParticipantID" value="<%=Participant.getStringID(participant)%>" />
			<input type="submit" value="update" />
		</form>


<%
    		}else{

    	%>
    	
		<h2>Welcome <%=Participant.getFirstName(participant) %>! Edit your profile below!</h2>
		<form action="updateParticipant" method="post">
			<table>
				<tr>
					<td>First Name: </td><td><input type="text" name="participantFirstName" size="30" value="<%=Participant.getFirstName(participant) %>" required /></td>
				</tr>
				<tr>
					<td>Last Name: </td><td><input type="text" name="participantLastName" size="30" value="<%=Participant.getLastName(participant) %>" required /></td>
				</tr>
				
				<tr>
					<td>Alias: </td><td><input type="text" name="participantAlias" size="30" value="<%=Participant.getAlias(participant) %>" disabled="disabled"  /></td>
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
					<td><input type = "text" name = "address" value="<%=Participant.getAddress(participant) %>"/> </td>
				</tr>
			</table>
			<input type="hidden" name="ParticipantLoginID" value="<%=user.getNickname()%>" />
			<input type="hidden" name="ParticipantID" value="<%=Participant.getStringID(participant)%>" />
			<input type="submit" value="update" />
		</form>
	<%
    	
    	
    		}
    
        }
    }
    
	%>
  
	</div>
	</div>
  </body>
 
</html>