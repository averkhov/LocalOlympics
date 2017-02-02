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
import localolympics.db.Award;
import com.google.appengine.api.datastore.Entity;
import java.util.List;

/**
 *
 * @author averkhovtsev
 */
@Path("/award")
public class AwardResource{
    
        /**
        *
        * get all award
        */
	@GET
	@Path("/all")
        @Produces("application/json")
	public Response getAllAward() {
            List<Entity> allAward = Award.getFirstAwards(100);
            return Response.status(200).entity(allAward).build();
	}
        
        /**
        *
        * get award by ID
        */
	@GET
	@Path("/{id:[0-9]+}")
        @Produces("application/json")
	public Response getAward(@PathParam("id") Long id ) {
            Entity award = Award.getAward(id);
            return Response.status(200).entity(award).build();
	}
        
        
        /**
        *
        * create award
        */
	@POST
	@Path("/create")
	@Consumes("application/json")
	public Response createAward(Award o) {
            Award.createAward(o.getParticipantId(),
                              o.getRecordId(),
                              o.getValue());
            return Response.status(200).entity(o.getId()).build();
	}
        
        /**
        *
        * update Award
        */
        @PUT
	@Path("/update")
	@Consumes("application/json")
	public Response udpateAward(Award o) {
            Award.updateAward(o.getId(),
                              o.getParticipantId(),
                              o.getRecordId(),
                              o.getValue());
            return Response.status(200).entity(o.getId()).build();
		
	}
        
        
        /**
        *
        * delete Award
        */
        @DELETE
	@Path("/delete/{id}")
	public Response deleteAward(@PathParam("id") String id ) {
            Award.deleteAward(id);
            return Response.status(200).build();
	}
	
}
