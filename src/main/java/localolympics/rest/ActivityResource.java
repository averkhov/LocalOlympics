/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package localolympics.rest;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.DELETE;
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
@Path("/activity")
public class ActivityResource{
    
        /**
        *
        * get all activity
        */
	@GET
	@Path("/all")
        @Produces("application/json")
	public Response getAllActivity() {
            List<Entity> allActivity = Activity.getFirstActivity(100);
            return Response.status(200).entity(allActivity).build();
	}
        
        /**
        *
        * get activity by ID
        */
	@GET
	@Path("/{id}")
        @Produces("application/json")
	public Response getActivity(@PathParam("id") String id ) {
            Entity activity = Activity.getActivity(id);
            return Response.status(200).entity(activity).build();
	}
        
        
        /**
        *
        * create Activity
        */
	@POST
	@Path("/create")
	@Consumes("application/json")
	public Response createActivity(Activity act) {
            Activity.createActivity(act.getName(),
                                    act.getDescription(),
                                    act.getType(),
                                    act.getLimithour(),
                                    act.getLimitmin(),
                                    act.getLimitsec(),
                                    act.getLocation());
            return Response.status(200).entity(act.getName()).build();
	}
        
        /**
        *
        * update Activity
        */
        @PUT
	@Path("/update")
	@Consumes("application/json")
	public Response udpateActivity(Activity act) {
            Activity.UpdateActivity(act.getId(),
                                    act.getName(),
                                    act.getDescription(),
                                    act.getType(),
                                    act.getLocation(),
                                    act.getLimithour(),
                                    act.getLimitmin(),
                                    act.getLimitsec());
            return Response.status(200).entity(act.getName()).build();
		
	}
        
        
        /**
        *
        * delete Activity
        */
        @DELETE
	@Path("/delete/{id}")
	public Response deleteActivity(@PathParam("id") String id ) {
            Activity.deleteActivity(id);
            return Response.status(200).build();
	}
	
}
