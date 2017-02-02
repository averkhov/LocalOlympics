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
import localolympics.db.Record;
import com.google.appengine.api.datastore.Entity;
import java.util.List;

/**
 *
 * @author averkhovtsev
 */
@Path("/record")
public class RecordResource{
    
        /**
        *
        * get all record
        */
	@GET
	@Path("/all")
        @Produces("application/json")
	public Response getAllRecord() {
            List<Entity> allRecord = Record.getFirstRecords(100);
            return Response.status(200).entity(allRecord).build();
	}
        
        /**
        *
        * get record by ID
        */
	@GET
	@Path("/{id:[0-9]+}")
        @Produces("application/json")
	public Response getRecord(@PathParam("id") Long id ) {
            Entity record = Record.getRecord(id);
            return Response.status(200).entity(record).build();
	}
        
        
        /**
        *
        * create Record
        */
	@POST
	@Path("/create")
	@Consumes("application/json")
	public Response createRecord(Record o) {
            Record.createRecord(o.getParticipantId(),
                                o.getActivityId(),
                                o.getHour(),
                                o.getMinute(),
                                o.getSecond());
            return Response.status(200).entity(o.getId()).build();
	}
        
        /**
        *
        * update Record
        */
        @PUT
	@Path("/update")
	@Consumes("application/json")
	public Response udpateRecord(Record o) {
            Record.updateRecord(o.getId(),
                                o.getParticipantId(),
                                o.getActivityId(),
                                o.getValue(),
                                o.getIsValid());
            return Response.status(200).entity(o.getId()).build();
		
	}
        
        
        /**
        *
        * delete Participant
        */
        @DELETE
	@Path("/delete/{id}")
	public Response deleteRecord(@PathParam("id") String id ) {
            Record.deleteRecord(id);
            return Response.status(200).build();
	}
	
}
