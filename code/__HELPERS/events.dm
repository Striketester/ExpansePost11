#define UNLIT_AREA_BRIGHTNESS 0.2

/**
 * Finds us a generic maintenance spawn location.
 *
 * Goes through the list of the generic mainteance landmark locations, checking for atmos safety if required, and returns
 * a valid turf. Returns MAP_ERROR if no valid locations are present.
 * Returns nothing and alerts admins if no valid points are found. Keep this in mind
 * when using this helper.
 */

/proc/find_maintenance_spawn(atmos_sensitive = FALSE, require_darkness = FALSE)
	var/list/possible_spawns = list()
	for(var/spawn_location in GLOB.generic_maintenance_landmarks)
		var/turf/spawn_turf = get_turf(spawn_location)

		if(atmos_sensitive && !is_safe_turf(spawn_turf))
			continue

		if(require_darkness && spawn_turf.get_lumcount() > UNLIT_AREA_BRIGHTNESS)
			continue

		possible_spawns += spawn_turf

	if(!length(possible_spawns))
		message_admins("No valid generic_maintenance_landmark landmarks found, aborting...")
		return null

	return pick(possible_spawns)

/**
 * Finds us a generic spawn location in space.
 *
 * Goes through the list of the space carp spawn locations, picks from the list, and
 * returns that turf. Returns MAP_ERROR if no landmarks are found.
 */

/proc/find_space_spawn()
	var/list/possible_spawns = list()
	for(var/obj/effect/landmark/carpspawn/spawn_location in GLOB.landmarks_list)
		if(!isturf(spawn_location.loc))
			stack_trace("Carp spawn found not on a turf: [spawn_location.type] on [isnull(spawn_location.loc) ? "null" : spawn_location.loc.type]")
			continue
		possible_spawns += get_turf(spawn_location)

	if(!length(possible_spawns))
		message_admins("No valid carpspawn landmarks found, aborting...")
		return null

	return pick(possible_spawns)

#undef UNLIT_AREA_BRIGHTNESS
