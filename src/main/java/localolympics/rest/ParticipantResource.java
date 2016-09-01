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
import localolympics.db.Participant;
import com.google.appengine.api.datastore.Entity;
import java.util.List;

/**
 *
 * @author averkhovtsev
 */
@Path("/participant")
public class ParticipantResource{
    
        /**
        *
        * get all participant
        */
	@GET
	@Path("/all")
        @Produces("application/json")
	public Response getAllParticipant() {
            List<Entity> allParticipant = Participant.getFirstParticipants(100);
            return Response.status(200).entity(allParticipant).build();
	}
        
        /**
        *
        * get participant by ID
        */
	@GET
	@Path("/{id}")
        @Produces("application/json")
	public Response getParticipant(@PathParam("id") String id ) {
            Entity participant = Participant.getParticipant(id);
            return Response.status(200).entity(participant).build();
	}
        
        
        /**
        *
        * create participant
        */
	@POST
	@Path("/create")
	@Consumes("application/json")
	public Response createParticipant(Participant o) {
            Participant.createParticipant(o.getLoginId(),
                                          o.getFirstName(),
                                          o.getLastName(),
                                          o.getAlias(),
                                          o.getGender(),
                                          o.getBirthday(),
                                          o.getActivity(),
                                          o.getAboutMe(),
                                          o.getAddress(),
                                          o.getIsValidated(),
                                          o.getEmail());
            return Response.status(200).entity(o.getId()).build();
	}
        
        /**
        *
        * update Participant
        */
        @PUT
	@Path("/update")
	@Consumes("application/json")
	public Response udpateParticipant(Participant o) {
            Participant.updateParticipantCommand(o.getId(),
                                                 o.getFirstName(),
                                                 o.getLastName(),
                                                 o.getAlias(),
                                                 o.getGender(),
                                                 o.getBirthday(),
                                                 o.getActivity(),
                                                 o.getAboutMe(),
                                                 o.getAddress(),
                                                 o.getLoginId(),
                                                 o.getIsAdmin(),
                                                 o.getIsValidated(),
                                                 o.getEmail());
            return Response.status(200).entity(o.getId()).build();
		
	}
        
        
        /**
        *
        * delete Participant
        */
        @DELETE
	@Path("/delete/{id}")
	public Response deleteParticipant(@PathParam("id") String id ) {
            Participant.deleteParticipantCommand(id);
            return Response.status(200).build();
	}
	
}
