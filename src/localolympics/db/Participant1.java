/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Anugh
 */

package localolympics.db;

import java.util.List;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Transaction;

public class Participant1 {

	//
	// SECURITY
	//

	/**
	 * Private constructor to avoid instantiation.
	 */
	private Participant1() {
		// TODO Auto-generated constructor stub
	}
	//
	// KIND
	//

	/**
	 * The name of the Permit ENTITY KIND used in GAE.
	 */
	private static final String ENTITY_KIND = "Participant";

	//
	// KEY
	//

	/**
	 * Return the Key for a given Permit id given as String.
	 * 
	 * @param recordID A string with the record ID (a long).
	 * @return the Key for this recordID.
	 */
	public static Key getKey(String participantID) {
		long id = Long.parseLong(participantID);
		Key participantKey = KeyFactory.createKey(ENTITY_KIND, id);
		return participantKey;
	}
	/**
	 * Return the string ID corresponding to the key for the permit.
	 * 
	 * @param record The GAE Entity storing the record.
	 * @return A string with the record ID (a long).
	 */
	public static String getStringID(Entity participant) {
		return Long.toString(participant.getKey().getId());
	}

	//
	// Time
	//
	/**
	 * The property time for the <b>time</b> value of the record.
	 */
	private static final String NAME_PROPERTY = "name";

	/**
	 * Return the time for the record.
	 * 
	 * @param record The GAE Entity storing the time
	 * @return the time in the record.
	 */
	public static String getName(Entity participant) {
		Object name = participant.getProperty(NAME_PROPERTY);
		if (name == null)
			name = "unknown";
		return (String) name;
	}
	//
	// CREATE PARTICIPANT
	//

	/**
	 * Create a new record if the recordID is correct and none exists with this id.
	 * 
	 * @param recordTime The time for this record.
	 * @return the Entity created with this id or null if error
	 */
	public static Entity createParticipant(String participantName) {
		Entity participant = null;
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Transaction txn = datastore.beginTransaction();
		try {

			participant = new Entity(ENTITY_KIND);
			participant.setProperty(NAME_PROPERTY, participantName);
			datastore.put(participant);

			txn.commit();
		} catch (Exception e) {
			return null;
		} finally {
			if (txn.isActive()) {
				txn.rollback();
			}
		}

		return participant;
	}
	//
	// GET RECORD
	//

	/**
	 * Get the record based on a string containing its long ID.
	 * 
	 * @param recordID a {@link String} containing the ID key (a <code>long</code> number)
	 * @return A GAE {@link Entity} for the Record or <code>null</code> if none or error.
	 */
	public static Entity getParticipant(String participantID) {
		Entity participant = null;
		try {
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			long id = Long.parseLong(participantID);
			Key participantKey = KeyFactory.createKey(ENTITY_KIND, id);
			participant = datastore.get(participantKey);
		} catch (Exception e) {
			// TODO log the error
		}
		return participant;
	}
	//
	// UPDATE RECORD
	//

	/**
	 * Update the current description of the record
	 * 
	 * @param recordID A string with the record ID (a long).
	 * @param time The time of the record as a String.
	 * @return true if succeed and false otherwise
	 */
	public static boolean updateParticipant(String participantID, String name) {
		Entity participant = null;
		try {
			participant = getParticipant(participantID);
			participant.setProperty(NAME_PROPERTY, name);
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			datastore.put(participant);
		} catch (Exception e) {
			return false;
		}
		return true;
	}
	//
	// DELETE RECORD
	//

	/**
	 * Delete the record if not linked to anything else.
	 * 
	 * @param recordID A string with the record ID (a long).
	 * @return True if succeed, false otherwise.
	 */
	public static boolean deleteParticipant(String participantID) {
		try {
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			datastore.delete(getKey(participantID));
		} catch (Exception e) {
			return false;
		}
		return true;
	}
	//
	// QUERY RECORD
	//

	/**
	 * Return the requested number of records (e.g. 100).
	 * 
	 * @param limit The number of records to be returned.
	 * @return A list of GAE {@link Entity entities}.
	 */
	public static List<Entity> getFirstParticipants(int limit) {
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Query query = new Query(ENTITY_KIND);
		List<Entity> result = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(limit));
		return result;
	}

}
