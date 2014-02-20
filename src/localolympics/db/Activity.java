package localolympics.db;
/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Karen Bacon
 */
import java.util.List;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Transaction;

public final class Activity {

	//
	// SECURITY
	//

	/**
	 * Private constructor to avoid instantiation.
	 */
	private Activity() {
	}

	//
	// KIND
	//

	/**
	 * The name of the Activity ENTITY KIND used in GAE.
	 */
	private static final String ENTITY_KIND = "Activity";

	//
	// KEY
	//

	/**
	 * Return the Key for a given Activity id given as String.
	 * 
	 * @param ActivityId
	 *            A string with the Activity ID (a long).
	 * @return the Key for this ActivityID.
	 */
	public static Key getKey(String ActivityId) {
		long id = Long.parseLong(ActivityId);
		Key ActivityKey = KeyFactory.createKey(ENTITY_KIND, id);
		return ActivityKey;
	}

	/**
	 * Return the string ID corresponding to the key for the Activity.
	 * 
	 * @param Activity
	 *            The GAE Entity storing the Activity.
	 * @return A string with the Activity ID (a long).
	 */
	public static String getStringID(Entity Activity) {
		return Long.toString(Activity.getKey().getId());
	}

	//
	// NAME
	//

	/**
	 * The property name for the name of the Activity.
	 */
	private static final String NAME_PROPERTY = "name";

	/**
	 * Return the name of the Activity.
	 * 
	 * @param Activity
	 *            The GAE Entity storing the Activity.
	 * @return the name of the Activity.
	 */
	public static String getName(Entity Activity) {
		Object nameofActivity = Activity.getProperty(NAME_PROPERTY);

		return (String) nameofActivity;
	}

	/**
	 * Create a new Activity if the name is correct and none exists with this
	 * name.
	 * 
	 * @param ActivityName
	 *            The name for the Activity.
	 * @return the Entity created with this name or null if error
	 */
	public static Entity createActivity(String ActivityName) {

		Entity Activity = null;
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		Transaction txn = datastore.beginTransaction();
		try {

			if (!checkName(ActivityName)) {
				return null;
			}

			Activity = getActivity(ActivityName);
			if (Activity != null) {
				return null;
			}

			Activity = new Entity(ENTITY_KIND);
			Activity.setProperty(NAME_PROPERTY, ActivityName);
			datastore.put(Activity);

			txn.commit();
		} finally {
			if (txn.isActive()) {
				txn.rollback();
			}

		}
		return Activity;
	}

	//
	// GET Activity
	//

	/**
	 * Get a Activity based on a string containing its long ID.
	 * 
	 * @param id
	 *            A {@link String} containing the ID key (a <code>long</code>
	 *            number)
	 * @return A GAE {@link Entity} for the Activity or <code>null</code> if
	 *         none or error.
	 */
	public static Entity getActivity(String ActivityId) {
		Entity Activity = null;
		try {
			DatastoreService datastore = DatastoreServiceFactory
					.getDatastoreService();
			long id = Long.parseLong(ActivityId);
			Key ActivityKey = KeyFactory.createKey(ENTITY_KIND, id);
			Activity = datastore.get(ActivityKey);
		} catch (Exception e) {
			// TODO log the error
		}
		return Activity;
	}

	public static boolean UpdateActivity(String ActivityID, String name) {
		Entity activityInput = null;
		try {
			activityInput = getActivity(ActivityID);
			activityInput.setProperty(NAME_PROPERTY, name);
			DatastoreService datastore = DatastoreServiceFactory
					.getDatastoreService();
			datastore.put(activityInput);
		} catch (Exception e) {
			return false;
		}
		return true;
	}

	/**
	 * The property name for the location of the activity
	 */
	private static final String LOCATION_PROPERTY = "location";

	/**
	 * Return the address of the campus.
	 * 
	 * @param campus
	 *            The Entity storing the campus
	 * @return a String with the address.
	 */
	public static String getLocation(Entity Activity) {
		Object val = Activity.getProperty(LOCATION_PROPERTY);
		if (val == null)
			return "";
		return (String) val;
	}
	/**
	 * checks to see if activity was entered previously
	 * @param String name
	 * @return boolean
	 */
	public static boolean checkName(String name) {

		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		Query query = new Query(ENTITY_KIND);
		Iterable<Entity> result = datastore.prepare(query).asIterable(
				FetchOptions.Builder.withLimit(1000));

		for (Entity Activity : result) {
			if (name.equals(Activity.getProperty(NAME_PROPERTY))) {
				return false;
			}

			else {
				continue;

			}

		}
		return true;
	}

	// QUERY Activity
	//

	/**
	 * Return the requested number of Activity (e.g. 100).
	 * 
	 * @param limit
	 *            The number of Activity to be returned.
	 * @return A list of GAE {@link Entity entities}.
	 */
	public static List<Entity> getFirstActivity(int limit) {
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		Query query = new Query(ENTITY_KIND);
		List<Entity> result = datastore.prepare(query).asList(
				FetchOptions.Builder.withLimit(limit));
		return result;
	}

}
