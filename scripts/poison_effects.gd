extends Node2D
class_name Poison_effects

# to add a new poison:
	# add a new entry in STATUS_POTENCY player dictionary
	# add a new entry to effect_potency_keys player dictionary
	# add a new entry in status_effects dictionary (both player and enemy)
	# implement corresponding status effects in player and in enemy
	# add corresponding enter area and exit area functions to effects list
	# add poison color to effect_colors

@export var effect_colors:Array[Color]
@onready var player:Player = self.get_parent()

var effects = [
	[
		func ice_poison_entered(target):
			target.status_effects["slowed"][2] = false
			target.status_effects["slowed"][0] += (target.SPEED-target.status_effects["slowed"][0])*(player.EFFECTS_POTENCY["slow"][0]/(player.EFFECTS_POTENCY["slow"][0]+3))
			target.get_child(0).modulate += effect_colors[0]
			target.status_effects["slowed"][3] += effect_colors[0]
			,
		func ice_poison_exited(target):
			target.status_effects["slowed"][1] = player.EFFECTS_POTENCY["slow"][1]
			target.status_effects["slowed"][2] = true
			,
	],
	[
		func gas_poison_entered(target):
			target.status_effects["poisoned"][2] = false
			target.status_effects["poisoned"][0] += player.EFFECTS_POTENCY["poison"][0]
			target.get_child(0).modulate += effect_colors[1]
			target.status_effects["poisoned"][3] += effect_colors[1]
			,
		func gas_poison_exited(target):
			target.status_effects["poisoned"][1] = player.EFFECTS_POTENCY["poison"][1]
			target.status_effects["poisoned"][2] = true
			,
	],
	[
		func burn_poison_entered(target):
			target.status_effects["burning"][2] = false
			target.status_effects["burning"][0] += player.EFFECTS_POTENCY["burn"][0]
			target.get_child(0).modulate += effect_colors[2]
			target.status_effects["burning"][3] += effect_colors[2]
			,
		func burn_poison_exited(target):
			target.status_effects["burning"][1] = player.EFFECTS_POTENCY["burn"][1]
			target.status_effects["burning"][2] = true
			,
	],
	[
		func confusion_poison_entered(target):
			target.status_effects["confused"][2] = false
			target.status_effects["confused"][0] += player.EFFECTS_POTENCY["confusion"][0]*player.EFFECTS_POTENCY["confusion"][0]/(player.EFFECTS_POTENCY["confusion"][0]+target.status_effects["confused"][0])
			target.get_child(0).modulate += effect_colors[3]
			target.status_effects["confused"][3] += effect_colors[3]
			,
		func confusion_poison_exited(target):
			target.status_effects["confused"][1] = player.EFFECTS_POTENCY["confusion"][1]
			target.status_effects["confused"][2] = true
			,
	],
	[
		func heal_poison_entered(target):
			target.heal(player.EFFECTS_POTENCY["heal"][0])
			,
		func confusion_poison_exited(target):
			pass
			,
	],
	[
		func regeneration_poison_entered(target):
			target.status_effects["regenerating"][2] = false
			target.status_effects["regenerating"][0] += player.EFFECTS_POTENCY["regeneration"][0]
			target.get_child(0).modulate += effect_colors[5]
			target.status_effects["regenerating"][3] += effect_colors[5]
			,
		func regeneration_poison_exited(target):
			target.status_effects["regenerating"][1] = player.EFFECTS_POTENCY["regeneration"][1]
			target.status_effects["regenerating"][2] = true
			,
	],
	[
		func weak_poison_entered(target):
			target.status_effects["weakened"][2] = false
			target.status_effects["weakened"][0] += player.EFFECTS_POTENCY["weak"][0]
			target.get_child(0).modulate += effect_colors[6]
			target.status_effects["weakened"][3] += effect_colors[6]
			,
		func weak_poison_exited(target):
			target.status_effects["weakened"][1] = player.EFFECTS_POTENCY["weak"][1]
			target.status_effects["weakened"][2] = true
			,
	],
	[
		func cripple_poison_entered(target):
			target.status_effects["crippled"][2] = false
			target.status_effects["crippled"][0] += player.EFFECTS_POTENCY["cripple"][0]
			target.get_child(0).modulate += effect_colors[7]
			target.status_effects["crippled"][3] += effect_colors[7]
			,
		func confusion_poison_exited(target):
			target.status_effects["crippled"][1] = player.EFFECTS_POTENCY["cripple"][1]
			target.status_effects["crippled"][2] = true
			,
	],
	[
		func decay_poison_entered(target):
			target.status_effects["decaying"][2] = false
			target.status_effects["decaying"][0] += player.EFFECTS_POTENCY["decay"][0]
			target.get_child(0).modulate += effect_colors[8]
			target.status_effects["decaying"][3] += effect_colors[8]
			,
		func decay_poison_exited(target):
			target.status_effects["decaying"][1] = player.EFFECTS_POTENCY["decay"][1]
			target.status_effects["decaying"][2] = true
			,
	],
]
