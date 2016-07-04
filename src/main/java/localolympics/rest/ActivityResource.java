/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package localolympics.rest;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;
import localolympics.db.Activity;
import com.google.appengine.api.datastore.Entity;
import java.util.List;

/**
 *
 * @author averkhovtsev
 */
@Path("/json/activity")
public class ActivityResource{
    


	@GET
	@Path("/get")
        @Produces("application/json")
	public Response getActivityInJSON() {
            
            List<Entity> allActivity = Activity.getFirstActivity(100);
            

            //String result = "Restful example : ";
            return Response.status(200).entity(allActivity).build();

	}

	@POST
	@Path("/post")
	@Consumes("application/json")
	public Response createActivityInJSON() {
            return null;
		
	}
	
}
