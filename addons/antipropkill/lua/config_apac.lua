
	DelMods = DelMods or {}
	DelMods.apac = {
		physgun_stop_motion_on_drop = true, // Whenever a prop is dropped, it's motion will halt. This will prevent prop "throwing"
		physgun_disallow_pushing = true, // Disable collisions on players while entity is picked up
		physgun_prop_transparancy = false, // Make prop transparent while its picked up (to help indicate the collision above)
		deny_entity_damage = false, // Whether entities can crush people (drop prop on head)
		deny_player_owned_prop_damage_only = false, // Whether only player owned props are blocked from doing damage
		delay_entity_damage = 15, // if deny_entity_damage is disabled, this is the amount of seconds a prop has to be untouched by a player before it starts doing crush damage.
		deny_vehicle_damage = true, // If enabled, vehicles should do no damage to players anymore.
	}