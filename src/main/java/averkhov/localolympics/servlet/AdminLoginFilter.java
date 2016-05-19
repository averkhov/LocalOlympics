/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Alex Verkhovtsev
 */

package averkhov.localolympics.servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

/**
 * The Filter to check and redirect parking spot administrative login.
 *
 */
public class AdminLoginFilter implements Filter {
  
	/**
	 * The filter configuration.
	 */
    private FilterConfig filterConfig;
    

    /**
     * Process the filter request. If an admin is not logged redirect the request to the login page.
     * If the user has no rights for the operation report invalid access. 
     */
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain filterChain) throws IOException, ServletException {
    	//check if it is in a current session with the client
    	 UserService userService = UserServiceFactory.getUserService();
         User user = userService.getCurrentUser(); // or req.getUserPrincipal()

         
         HttpSession session = ((HttpServletRequest) req).getSession(false);
         //String url = ((HttpServletRequest) req).getRequestURL().toString();

         if (!userService.isUserLoggedIn()) {
             ((HttpServletResponse) resp).sendRedirect("/index.jsp");
         }else{
         	if(session.getAttribute("user")==null | !session.getAttribute("isAdmin").equals("true")){
         		((HttpServletResponse) resp).sendRedirect("/accessdenied.html");
         	}else{
         		filterChain.doFilter(req, resp);
         	}
             
         }
         	
         
     }
     
    	


    /**
     * Return the current filter configuration.
     * @return a FilterConfig with the configuration.
     */
    public FilterConfig getFilterConfig() {
        return filterConfig;
    }

    /**
     * Initialize the current filter configuration.
     */
    public void init(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
    }
  
    /**
     * Destroy the filter.
     */
    public void destroy() {}
  
}