extends Control
class_name LevelUpManager

@export var player:Player
@export var upgrade_manager:UpgradeManager
var upgrade_choices

@export var option_buttons:Array[TextureButton]
var selected_option:int


func replace_char(target_string:String, target_char:String, replace_string:String):
	var result := ""
	for i in range(target_string.length()):
		var current_char = target_string[i]
		if(current_char==target_char):
			result += replace_string
		else:
			result += current_char
	return result

func update_options():
	for i in range(0, upgrade_choices.size()):
		var rarity_label:Label = option_buttons[i].get_child(0)
		rarity_label.text = upgrade_manager.rarity_order[upgrade_choices[i][1]]
		rarity_label.label_settings.font_color = upgrade_manager.rarity_color_array[upgrade_choices[i][1]]
		var title_label:Label = option_buttons[i].get_child(1)
		title_label.text = upgrade_manager.possible_choices[0][upgrade_choices[i][0]][0]
		var description_label:Label = option_buttons[i].get_child(2)
		description_label.text = replace_char(upgrade_manager.possible_choices[0][upgrade_choices[i][0]][1], "X", str(upgrade_manager.possible_choices[0][upgrade_choices[i][0]][2+upgrade_choices[i][1]]))


func show_options():
	Engine.time_scale = 0
	var option_canvas:TextureRect = self.get_child(0)
	option_canvas.show()
func hide_options():
	Engine.time_scale = 1
	var option_canvas:TextureRect = self.get_child(0)
	option_canvas.hide()

func level_up():
	player.on_menu = true
	player.player_exp = 0
	player.player_level += 1
	player.NEXTLEVELUPEXP = int(2*pow(1.08, player.player_level))
	upgrade_choices = upgrade_manager.choose_upgrades()
	update_options()
	show_options()


func handle_upgrade_choice():
	var final_upgrade_choice = upgrade_choices[selected_option]
	upgrade_manager.possible_choices[1][final_upgrade_choice[0]].call(final_upgrade_choice[1])
	hide_options()
	player.on_menu = false

func _on_opt_1_button_pressed() -> void:
	selected_option = 0
	handle_upgrade_choice()
func _on_opt_2_button_pressed() -> void:
	selected_option = 1
	handle_upgrade_choice()
func _on_opt_3_button_pressed() -> void:
	selected_option = 2
	handle_upgrade_choice()
