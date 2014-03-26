/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Alex Verkhovtsev
 */

package localolympics.db;

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
 * GAE ENTITY UTIL CLASS: "Record" <br>
 * PARENT: NONE <br>
 * KEY: A long Id generated by GAE <br>
 * FEATURES: <br>
 * - "participantID" a {@link String} with the participantid record for the Participant that entered record<br>
 * - "activityID" a {@link String} with the activityid record for the activity that the record is for<br>
 * - "value" a {@link String} with the value record for the record<br>
 * - "date" a {@link String} with the date record for the record<br>
 */

public class Record {

	//
	// SECURITY
	//

	/**
	 * Private constructor to avoid instantiation.
	 */
	private Record() {
	}

	//
	// KIND
	//

	/**
	 * The name of the Permit ENTITY KIND used in GAE.
	 */
	private static final String ENTITY_KIND = "Record";

	//
	// KEY
	//

	/**
	 * Return the Key for a given Permit id given as String.
	 * 
	 * @param recordID A string with the record ID (a long).
	 * @return the Key for this recordID.
	 */
	public static Key getKey(String recordID) {
		long id = Long.parseLong(recordID);
		Key recordKey = KeyFactory.createKey(ENTITY_KIND, id);
		return recordKey;
	}

	/**
	 * Return the string ID corresponding to the key for the permit.
	 * 
	 * @param record The GAE Entity storing the record.
	 * @return A string with the record ID (a long).
	 */
	public static String getStringID(Entity record) {
		return Long.toString(record.getKey().getId());
	}

	
	
	
	//
	// ATTRIBUTES
	//

	/**
	 * The property value for the <b>value</b> value of the record.
	 */
	private static final String VALUE_PROPERTY = "Value";

	/**
	 * The property participantID for the <b>participantid</b> value of the record.
	 */
	private static final String PARTICIPANTID_PROPERTY = "ParticipantID";
	
	/**
	 * The property activityID for the <b>activityID</b> value of the record.
	 */
	private static final String ACTIVITYID_PROPERTY = "ActivityID";
	
	/**
	 * The property activdateityID for the <b>date</b> value of the record.
	 */
	private static final String DATE_PROPERTY = "Date";
	
	private static final String SECOND_VALUE = "Second";
	
	
	
	//
	// GETTERS
	//
	
	/**
	 * Return the value for the record.
	 * 
	 * @param record The GAE Entity storing the attribute
	 * @return the value in the record.
	 */
	public static String getValue(Entity record) {
		Object value = record.getProperty(VALUE_PROPERTY);
		if (value == null)
			value = "";
		return (String) value;
	}
	
	/**
	 * Return the participantID for the record.
	 * 
	 * @param record The GAE Entity storing the attribute
	 * @return the participantID in the record.
	 */
	public static String getParticipantID(Entity record) {
		Object participantID = record.getProperty(PARTICIPANTID_PROPERTY);
		if (participantID == null)
			participantID = "";
		return (String) participantID;
	}
	
	/**
	 * Return the activityID for the record.
	 * 
	 * @param record The GAE Entity storing the attribute
	 * @return the activityID in the record.
	 */
	public static String getActivityID(Entity record) {
		Object activityID = record.getProperty(ACTIVITYID_PROPERTY);
		if (activityID == null)
			activityID = "";
		return (String) activityID;
	}
	
	/**
	 * Return the date for the record.
	 * 
	 * @param record The GAE Entity storing the attribute
	 * @return the date in the record.
	 */
	public static String getDate(Entity record) {
		Object date = record.getProperty(DATE_PROPERTY);
		if (date == null)
			date = "";
		return (String) date;
	}
	

	

	//
	// CREATE RECORD
	//

	/**
	 * Create a new record if the recordID is correct and none exists with this id.
	 * 
	 * @param participantID The participantID for this record.
	 * @param activityID The activityID for this record.
	 * @param value The value for this record.
	 * @return the Entity created with this id or null if error
	 */
	public static Entity createRecord(String participantID, String activityID, String hour, String minute, String second) {
		Entity record = null;
		String value = " ";
		int hour1;
		int minute1;
		int second1;
		String secondAsign = "";
		int totalSecond;
		String storingHour = " ";
		String storingMinute = " ";
		String storingSecond = " ";
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Transaction txn = datastore.beginTransaction();
		try {
			hour1 = Integer.parseInt(hour);
			minute1 = Integer.parseInt(minute);
			second1 = Integer.parseInt(second);
			totalSecond = secondCal(hour1, minute1, second1);
			secondAsign = String.valueOf(totalSecond);
			if(hour1>=0 && hour1 <=9)
			{
				storingHour = "0"+hour1;
			}
			else
			{
				storingHour = storingHour + hour1;
			}
			if(minute1>=0 && minute1 <=9)
			{
				storingMinute = "0"+minute1;
			}
			else
			{
				storingMinute = storingMinute + minute1;
			}
			if(second1>=0 && second1 <=9)
			{
				storingSecond = "0"+second1;
			}
			else
			{
				storingSecond = storingSecond + second1;
			}
			value = value + storingHour + ":" + storingMinute + ":" + storingSecond;
			record = new Entity(ENTITY_KIND);
			record.setProperty(VALUE_PROPERTY, value);
			record.setProperty(SECOND_VALUE, secondAsign);
			record.setProperty(PARTICIPANTID_PROPERTY, participantID);
			record.setProperty(ACTIVITYID_PROPERTY, activityID);
			
			Date date = new Date();
			record.setProperty(DATE_PROPERTY, date.toString());
			
			datastore.put(record);

			txn.commit();
		} catch (Exception e) {
			return null;
		} finally {
			if (txn.isActive()) {
				txn.rollback();
			}
		}

		return record;
	}

	private static int secondCal(int hour, int minute, int second)
	{
		int totalSecond;
		int hourConvert;
		int minuteConvert;
		
		hourConvert = hour * 3600;
		minuteConvert = minute * 60;
		
		totalSecond = hourConvert + minuteConvert + second;
		
		return totalSecond;
		
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
	public static Entity getRecord(String recordID) {
		Entity record = null;
		try {
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			long id = Long.parseLong(recordID);
			Key recordKey = KeyFactory.createKey(ENTITY_KIND, id);
			record = datastore.get(recordKey);
		} catch (Exception e) {
			// TODO log the error
		}
		return record;
	}

	
	

	//
	// UPDATE RECORD
	//

	/**
	 * Update the current description of the record
	 * 
	 * @param recordID A string with the record ID (a long).
	 * @param participantID The participantID of the record as a String.
	 * @param activityID The activityID of the record as a String.
	 * @param value The value of the record as a String.
	 * @return true if succeed and false otherwise
	 */
	public static boolean updateRecord(String recordID, String participantID, String activityID, String value) {
		Entity record = null;
		try {
			record = getRecord(recordID);
			record.setProperty(VALUE_PROPERTY, value);
			record.setProperty(ACTIVITYID_PROPERTY, activityID);
			record.setProperty(PARTICIPANTID_PROPERTY, participantID);
			
			Date date = new Date();
			record.setProperty(DATE_PROPERTY, date.toString());
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			datastore.put(record);
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
	public static boolean deleteRecord(String recordID) {
		try {
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			datastore.delete(getKey(recordID));
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
	public static List<Entity> getFirstRecords(int limit) {
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Query query = new Query(ENTITY_KIND);
		List<Entity> result = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(limit));
		return result;
	}
	
	/**
	 * Return the requested number of records (e.g. 100) for an Activity.
	 * 
	 * @param limit The number of records to be returned.
	 * @return A list of GAE {@link Entity entities}.
	 */
	public static List<Entity> getActivityRecords(String activityID, int limit) {
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Filter activityFilter = new FilterPredicate("ActivityID", FilterOperator.EQUAL, activityID);
		Query query = new Query(ENTITY_KIND).setFilter(activityFilter);
		List<Entity> result = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(limit));
		return result;
	}
	public static List<Entity> getParticipantRecords(String participantID, int limit) {
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Filter participantFilter = new FilterPredicate("ParticipantID", FilterOperator.EQUAL, participantID);
		Query query = new Query(ENTITY_KIND).setFilter(participantFilter);
		List<Entity> result = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(limit));
		return result;
	}
	
	public static int getParticipantRecordsNumber(String participantID, int limit) {
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Filter participantFilter = new FilterPredicate("ParticipantID", FilterOperator.EQUAL, participantID);
		Query query = new Query(ENTITY_KIND).setFilter(participantFilter);
		List<Entity> result = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(limit));
		int amount = result.size();
		return amount;
	}

}
