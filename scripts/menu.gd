extends Control
class_name Menu

@export var player:Player
@export var dificulty_manager:DificultyManager
@export var bars:VBoxContainer

@export var hwp_panel:Panel
@export var hwp:MarginContainer

var showing_hwp = false

func start_game():
	player.on_menu = false
	dificulty_manager.start_timer.start()
	hide_hwp()
	self.hide()
	bars.show()

func show_hwp():
	hwp_panel.show()
	hwp.show()
	showing_hwp = true
func hide_hwp():
	hwp_panel.hide()
	hwp.hide()
	showing_hwp = false

func _on_button_pressed() -> void:
	start_game()

func _on_button_2_pressed() -> void:
	if(showing_hwp): hide_hwp()
	else: show_hwp()
