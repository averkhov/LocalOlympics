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

<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Map" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>


<%@ page import="localolympics.db.Record" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!--  
   Copyright 2014 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Alex Verkhovtsev, Karen B...
   
   Version 0.1 - Spring 2014
-->

<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
        <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
    <title>Hello App Engine</title>
  </head>

  <body>
	  <table>
	  		<tr>
	  			<td><h1>Local Olympics</h1></td>
	  		</tr>
	  		
	  		<tr>
	  			<td>
	  			    <%
				    UserService userService = UserServiceFactory.getUserService();
				    User user = userService.getCurrentUser();
				    if (user != null) {
				      	pageContext.setAttribute("user", user);
					%>
						<p>Welcome, ${fn:escapeXml(user.nickname)}! (You can <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
					
				</td>
				</tr>
				<tr><td>
					<p><a href="/auth/user/profile.jsp">View my profile.</a></p>
					<p><a href="/auth/admin/admin.jsp">Manage Local Olympics Application</a></p>
				
					
					<%
					
					    } else {
					    	
					    	%>
			    	<p>Sign in with any web account below!</p>
					    	<%
					    	final Map<String, String> openIdProviders;
					            openIdProviders = new HashMap<String, String>();
					            openIdProviders.put("Google", "https://www.google.com/accounts/o8/id");
					            openIdProviders.put("Yahoo", "yahoo.com");
					            openIdProviders.put("MySpace", "myspace.com");
					            openIdProviders.put("AOL", "aol.com");
					            openIdProviders.put("MyOpenId.com", "myopenid.com");
					    	
					    	for (String providerName : openIdProviders.keySet()) {
				                String providerUrl = openIdProviders.get(providerName);
				                String loginUrl = userService.createLoginURL("/index.jsp", null, providerUrl, null);
				                out.println("[<a href=\"" + loginUrl + "\">" + providerName + "</a>] ");
				            }

					    }
					%>
				</td>
	  		</tr>
	  </table>

    

  </body>
</html>
