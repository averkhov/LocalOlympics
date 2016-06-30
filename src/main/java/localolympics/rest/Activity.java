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
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;

/**
 *
 * @author averkhovtsev
 */
@Path("/json/activity")
public class Activity {
    


	@GET
	@Path("/get")
	@Produces("application/json")
	public Activity getProductInJSON() {

            return null;

	}

	@POST
	@Path("/post")
	@Consumes("application/json")
	public Response createProductInJSON() {
            return null;
		
	}
	
}
