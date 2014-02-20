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



<html>
<head>



<title>Activity</title>



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
					String id = Activity.getStringID(activity);
		%>

		<tr>

			<td><%=activityName%></td>

		</tr>

		<%
			}

		}
		%>

	</table>
	


    <form action="addActivity" method="post">
      <div><input type="text" name="ActivityName" size="50" /></div>
      <div><input type="submit" value="Add Activity" /></div>
    </form>
	


</body>
</html>

