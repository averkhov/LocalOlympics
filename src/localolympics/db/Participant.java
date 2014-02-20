/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Karen
 */



package localolympics.db;


import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Transaction;
import com.google.appengine.api.datastore.Query.Filter;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.datastore.Query.FilterPredicate;

public class Participant {
	/**
     * Private constructor to avoid instantiation.
     */
    private Participant() {
    }
    //
    // KIND
    //
    
    /**
     * The name of the User ENTITY KIND used in GAE.
     */
    private static final String ENTITY_KIND = "Participant";
    
    /**
     * Return the Key for a given user id given as String. 
     * @param userId A string with the User ID (a long).
     * @return the Key for this userID. 
     */
    public static Key getKey(String participantId) {
            long id = Long.parseLong(participantId);
            Key participantKey = KeyFactory.createKey(ENTITY_KIND, id);
            return participantKey;
    }
    
    /**
     * Return the string ID corresponding to the key for the user.
     * @param user The GAE Entity storing the user.
     * @return A string with the lot ID (a long).
     */
    public static String getStringID(Entity participant) {
            return Long.toString(participant.getKey().getId());
    }
    
    //
    // NAME
    //
    
    /**
     * The property name for the <b>name</b> of the user profile.
     */
    private static final String NAME_PROPERTY = "name";
    
    /**
     * Return the name of the user. 
     * @param user The GAE Entity storing the user.
     * @return the name of the user. 
     */
    public static String getName(Entity participant) {
	        Object name = participant.getProperty(NAME_PROPERTY);
	        if (name == null) name = "";
	        return (String)name;
    }
    
    /**
     * The regular expression pattern for the name of the admin profile.
     */
    private static final Pattern NAME_PATTERN = Pattern.compile("\\A[A-Za-z]+([ -][A-Za-z]+){0,10}\\Z");
	
    /**
     * Check if the name is correct for a user. 
     * @param name The checked string. 
     * @return true is the name is correct. 
     */
    public static boolean checkName(String name) {
            Matcher matcher=NAME_PATTERN.matcher(name);
            return matcher.find();
    }
    
    //
    // LOGIN ID
    //
    
    /**
     *  The property name for the <b>loginID</b> of the admin profile.
     */
    private static final String LOGIN_ID_PROPERTY = "loginID";
    //LOGIN_ID_PROPERTY = email address tied to Google OAuth?
    
    /**
     * Return the login ID of the profile. 
     * @return a String with the permit type. 
     */
    public static String getLoginID(Entity participant) {
            Object val = participant.getProperty(LOGIN_ID_PROPERTY);
            if (val == null) 
            	val = "test1";
            return (String) val;
    }
    
    //
    // Permit
    //
    
    /**
     *  The property name for the <b>permit</b> of the user.
     */
    private static String RECORD_PROPERTY = "record";
    
    /**
     * Return the permit type of the profile. 
     * @param campus The Entity storing the user profile.
     * @return a String with the login ID. 
     */
    public static String getRecord(Entity record) {
            Object val=Record.getRecord(RECORD_PROPERTY);
            if (val==null) return "";
            return (String) val;
    }
    
    //
    // CREATE USER
    //

    /**
     * Create a new user if the login ID is correct and none exists with this id.
     * @param loginID The id for this user.
     * @return the Entity created with this id or null if error
     */
    public static Entity createParticipant(String loginID) {
            Entity participant = null;
            DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
            Transaction txn = datastore.beginTransaction();
            try {
            
                    participant = getParticipantWithLoginID(loginID);
                    if (participant!=null) {
                            return null;
                    }
                    
                    participant = new Entity(ENTITY_KIND);
                    participant.setProperty(LOGIN_ID_PROPERTY, loginID);
                    datastore.put(participant);

                txn.commit();
            } finally {
                if (txn.isActive()) {
                    txn.rollback();
                }
            }
            
            return participant;
    }
    
    //
    // GET USER
    //

    /**
     * Get the user based on a string containing its long ID.
     * 
     * @param id A {@link String} containing the ID key (a <code>long</code> number)
     * @return A GAE {@link Entity} for the User or <code>null</code> if none or error.
     */
    public static Entity getParticipant(String participantId) {
            Entity participant = null;
            try {
                    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
                    long id = Long.parseLong(participantId);
                    Key participantKey = KeyFactory.createKey(ENTITY_KIND, id);
                    participant = datastore.get(participantKey);
            } catch (Exception e) {
                    // TODO log the error
            }
            return participant;
    }
    
    /**
     * Get an user based on a string containing its loginID.
     * @param loginID The login of the user as a String.
     * @return A GAE {@link Entity} for the user or <code>null</code> if none or error.
     */
    public static Entity getParticipantWithLoginID(String loginID) {
            DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
            return getParticipantWithLoginID(datastore, loginID);
    }
    
    /**
     * Get a user based on a string containing its name.
     * @param datastore The current datastore instance. 
     * @param name The name of the user as a String.
     * @return A GAE {@link Entity} for the User or <code>null</code> if none or error.
     */
    public static Entity getParticipantWithLoginID(DatastoreService datastore, String loginID) {
            Entity participant = null;
            try {
                    
                    Filter hasLoginID =
                                      new FilterPredicate(NAME_PROPERTY,
                                                          FilterOperator.EQUAL,
                                                          loginID);
                    Query query = new Query(ENTITY_KIND);
                    query.setFilter(hasLoginID);
                    List<Entity> result = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(10));
                    if (result!=null && result.size()>0) {
                            participant=result.get(0);
                    }
            } catch (Exception e) {
                    // TODO log the error
            }
            return participant;
    }
    
    //
    // UPDATE USER
    //
    
    /**
     * Update the current description of the User.
     * @param userID A string with the user ID (a long).
     * @param name The name of the user as a String.
     * @param loginID The login ID of the user as a String.
     * @return true if succeed and false otherwise
     */
    public static boolean updateParticipantCommand(String participantID, String name, String participantLoginID) {
            Entity participant = null;
            try {
            		participant = getParticipant(participantID);
            		participant.setProperty(NAME_PROPERTY, name);
            		participant.setProperty(LOGIN_ID_PROPERTY, participantLoginID);
                    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
                    datastore.put(participant);
            } catch (Exception e) {
                    return false;
            }
            return true;
    }
    
    //
    // DELETE USER
    //
    
    /**
     * Delete the user if not linked to anything else.
     * @param userID A string with the user ID (a long).
     * @return True if succeed, false otherwise.
     */
    public static boolean deleteParticipantCommand(String participantID) {
            try {
                    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
                    datastore.delete(getKey(participantID));
            } catch (Exception e) {
                    return false;
            }
            return true;
    }
    
    //
    // QUERY USERS
    //
    
    /**
     * Return the requested number of users (e.g. 100).  
     * @param limit The number of users to be returned. 
     * @return A list of GAE {@link Entity entities}. 
     */
    public static List<Entity> getFirstParticipants(int limit) {
            DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
            Query query = new Query(ENTITY_KIND);
            List<Entity> result = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(limit));
            return result;
    } 
   
}


