/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package localolympics.rest;

import java.util.HashSet;
import java.util.Set;

import javax.ws.rs.core.Application;

/**
 *
 * @author averkhovtsev
 */
public class JavaRSApp extends Application{
    
    @Override
	public Set<Class<?>> getClasses() {
		Set<Class<?>> classes = new HashSet<Class<?>>();
        	classes.add(localolympics.rest.ActivityResource.class);
                classes.add(localolympics.rest.AwardResource.class);
                classes.add(localolympics.rest.ParticipantResource.class);
                classes.add(localolympics.rest.RecordResource.class);
        	return classes;
	}
    
}
