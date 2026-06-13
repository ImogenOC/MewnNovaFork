/// List of hud traits in the admin combo hud
// 		"TRAIT_PREF_HUD_ERP" = TRAIT_PREF_HUD_ERP,
//		"TRAIT_PREF_HUD_ANTAG" = TRAIT_PREF_HUD_ANTAG,
#define ADMIN_HUDS list(TRAIT_SECURITY_HUD, TRAIT_MEDICAL_HUD, TRAIT_DIAGNOSTIC_HUD, TRAIT_BOT_PATH_HUD)

/client/proc/enable_combo_hud()
	if (combo_hud_enabled)
		return

	combo_hud_enabled = TRUE

	for (var/hudtrait in ADMIN_HUDS)
		ADD_TRAIT(mob, hudtrait, ADMIN_TRAIT)

	for (var/datum/atom_hud/alternate_appearance/basic/antagonist_hud/antag_hud in GLOB.active_alternate_appearances)
		antag_hud.show_to(mob)

	mob.lighting_cutoff = mob.default_lighting_cutoff()
	mob.update_sight()

/client/proc/disable_combo_hud()
	if (!combo_hud_enabled)
		return

	combo_hud_enabled = FALSE

	for (var/hudtrait in ADMIN_HUDS)
		REMOVE_TRAIT(mob, hudtrait, ADMIN_TRAIT)

	for (var/datum/atom_hud/alternate_appearance/basic/antagonist_hud/antag_hud in GLOB.active_alternate_appearances)
		antag_hud.hide_from(mob)

	mob.lighting_cutoff = mob.default_lighting_cutoff()
	mob.update_sight()

#undef ADMIN_HUDS

/obj/item/clothing/accessory/energy_shield/proc/update_shield_hud()
	if(!wearer?.hud_list)
		return
	var/image/holder = wearer.hud_list[SHIELD_HUD]
	if(!holder)
		return
	if(!shield_active && shield_health <= 0)
		holder.icon_state = ""
		holder.color = null
		return
	var/shield_percent = (shield_health / max_shield_health) * 100
	holder.icon_state = "hud[round_shield_for_hud(shield_percent)]"
	holder.color = shield_color
	wearer.adjust_hud_position(holder)
	holder.pixel_z += SHIELD_HUD_Y_OFFSET

/// Clears the shield HUD bar on the wearer.
/obj/item/clothing/accessory/energy_shield/proc/clear_shield_hud()
	if(!wearer?.hud_list)
		return
	var/image/holder = wearer.hud_list[SHIELD_HUD]
	if(!holder)
		return
	holder.icon_state = ""
	holder.color = null
