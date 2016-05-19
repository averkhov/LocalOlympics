/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Karen Bacon
 */

package averkhov.localolympics.db;

import java.util.Date;
import java.util.List;





import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Transaction;
import com.google.appengine.api.datastore.Query.Filter;
import com.google.appengine.api.datastore.Query.FilterPredicate;
import com.google.appengine.api.datastore.Query.FilterOperator;


/**
 * GAE ENTITY UTIL CLASS: "Award" <br>
 * PARENT: NONE <br>
 * KEY: A long Id generated by GAE <br>
 * FEATURES: <br>
 * - "participantID" a {@link String} with the participantid award for the Participant that entered award<br>
 * - "recordID" a {@link String} with the recordid award for the record that the award is for<br>
 * - "value" a {@link String} with the value award for the award<br>
 * - "date" a {@link String} with the date award for the award<br>
 */

public class Award {

	//
	// SECURITY
	//

	/**
	 * Private constructor to avoid instantiation.
	 */
	private Award() {
	}

	//
	// KIND
	//

	/**
	 * The name of the Permit ENTITY KIND used in GAE.
	 */
	private static final String ENTITY_KIND = "Award";

	//
	// KEY
	//

	/**
	 * Return the Key for a given Permit id given as String.
	 * 
	 * @param awardID A string with the award ID (a long).
	 * @return the Key for this awardID.
	 */
	public static Key getKey(String awardID) {
		long id = Long.parseLong(awardID);
		Key awardKey = KeyFactory.createKey(ENTITY_KIND, id);
		return awardKey;
	}

	/**
	 * Return the string ID corresponding to the key for the permit.
	 * 
	 * @param award The GAE Entity storing the award.
	 * @return A string with the award ID (a long).
	 */
	public static String getStringID(Entity award) {
		return Long.toString(award.getKey().getId());
	}

	
	
	
	//
	// ATTRIBUTES
	//

	/**
	 * The property value for the <b>value</b> value of the award.
	 */
	private static final String VALUE_PROPERTY = "Value";

	/**
	 * The property participantID for the <b>participantid</b> value of the award.
	 */
	private static final String PARTICIPANTID_PROPERTY = "ParticipantID";
	
	/**
	 * The property recordID for the <b>recordID</b> value of the award.
	 */
	private static final String RECORDID_PROPERTY = "RecordID";
	
	/**
	 * The property Name for name value of the award.
	 */
	private static final String NAME_PROPERTY = "Name";
	
	/**
	 * The property awardID for the awardID value of award.
	 */
	private static final String AWARDID_PROPERTY = "AwardID";
			
	/**
	 * The property Description for Description value of award.
	 */
	
	private static final String DESCRIPTION_PROPERTY = "Description";
	
	
	//
	// GETTERS
	//
	
	/**
	 * Return the value for the award.
	 * 
	 * @param award The GAE Entity storing the attribute
	 * @return the value in the award.
	 */
	public static String getValue(Entity award) {
		Object value = award.getProperty(VALUE_PROPERTY);
		if (value == null)
			value = "";
		return (String) value;
	}
	
	/**
	 * Return the participantID for the award.
	 * 
	 * @param award The GAE Entity storing the attribute
	 * @return the participantID in the award.
	 */
	public static String getParticipantID(Entity award) {
		Object participantID = award.getProperty(PARTICIPANTID_PROPERTY);
		if (participantID == null)
			participantID = "";
		return (String) participantID;
	}
	
	/**
	 * Return the recordID for the award.
	 * 
	 * @param award The GAE Entity storing the attribute
	 * @return the recordID in the award.
	 */
	public static String getRecordID(Entity award) {
		Object recordID = award.getProperty(AWARDID_PROPERTY);
		if (recordID == null)
			recordID = "";
		return (String) recordID;
	}
	
	/**
	 * Return the date for the award.
	 * 
	 * @param award The GAE Entity storing the attribute
	 * @return the date in the award.
	 */
	public static String getName(Entity award) {
		Object name = award.getProperty(NAME_PROPERTY);
		if (name == null)
			name = "";
		return (String) name;
	}
	

	

	//
	// CREATE RECORD
	//

	/**
	 * Create a new award if the awardID is correct and none exists with this id.
	 * 
	 * @param participantID The participantID for this award.
	 * @param recordID The recordID for this award.
	 * @param value The value for this award.
	 * @return the Entity created with this id or null if error
	 */
	public static Entity createAward(String participantID, String recordID, String value) {
		Entity award = null;
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Transaction txn = datastore.beginTransaction();
		try {

			award = new Entity(ENTITY_KIND);
			award.setProperty(VALUE_PROPERTY, value);
			award.setProperty(PARTICIPANTID_PROPERTY, participantID);
			award.setProperty(AWARDID_PROPERTY, recordID);
			award.setProperty(NAME_PROPERTY, getName(award));
			
			
			datastore.put(award);

			txn.commit();
		} catch (Exception e) {
			return null;
		} finally {
			if (txn.isActive()) {
				txn.rollback();
			}
		}

		return award;
	}

	
	
	//
	// GET RECORD
	//

	/**
	 * Get the award based on a string containing its long ID.
	 * 
	 * @param awardID a {@link String} containing the ID key (a <code>long</code> number)
	 * @return A GAE {@link Entity} for the Award or <code>null</code> if none or error.
	 */
	public static Entity getAward(String awardID) {
		Entity award = null;
		try {
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			long id = Long.parseLong(awardID);
			Key awardKey = KeyFactory.createKey(ENTITY_KIND, id);
			award = datastore.get(awardKey);
		} catch (Exception e) {
			// TODO log the error
		}
		return award;
	}

	
	

	//
	// UPDATE RECORD
	//

	/**
	 * Update the current description of the award
	 * 
	 * @param awardID A string with the award ID (a long).
	 * @param participantID The participantID of the award as a String.
	 * @param recordID The recordID of the award as a String.
	 * @param value The value of the award as a String.
	 * @return true if succeed and false otherwise
	 */
	public static boolean updateAward(String awardID, String participantID, String recordID, String value) {
		Entity award = null;
		try {
			award = getAward(awardID);
			award.setProperty(VALUE_PROPERTY, value);
			award.setProperty(AWARDID_PROPERTY, recordID);
			award.setProperty(PARTICIPANTID_PROPERTY, participantID);
			
			Date date = new Date();
			award.setProperty(NAME_PROPERTY, date.toString());
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			datastore.put(award);
		} catch (Exception e) {
			return false;
		}
		return true;
	}
	
	

	//
	// DELETE RECORD
	//

	/**
	 * Delete the award if not linked to anything else.
	 * 
	 * @param awardID A string with the award ID (a long).
	 * @return True if succeed, false otherwise.
	 */
	public static boolean deleteAward(String awardID) {
		try {
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			datastore.delete(getKey(awardID));
		} catch (Exception e) {
			return false;
		}
		return true;
	}
	
	

	//
	// QUERY RECORD
	//

	/**
	 * Return the requested number of awards (e.g. 100).
	 * 
	 * @param limit The number of awards to be returned.
	 * @return A list of GAE {@link Entity entities}.
	 */
	public static List<Entity> getFirstAwards(int limit) {
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Query query = new Query(ENTITY_KIND);
		List<Entity> result = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(limit));
		return result;
	}
	
	/**
	 * Return the requested number of awards (e.g. 100) for an Record.
	 * 
	 * @param limit The number of awards to be returned.
	 * @return A list of GAE {@link Entity entities}.
	 */
	public static List<Entity> getRecordAwards(String recordID, int limit) {
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Filter recordFilter = new FilterPredicate("RecordID", FilterOperator.EQUAL, recordID);
		Query query = new Query(ENTITY_KIND).setFilter(recordFilter);
		List<Entity> result = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(limit));
		return result;
	}


}
