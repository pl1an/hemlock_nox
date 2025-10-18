extends Control
class_name death_screen

@export var anim:AnimationPlayer
@export var menu:Menu

func _on_button_pressed() -> void:
	get_tree().reload_current_scene()

func anim_end():
	anim.stop()
	self.modulate.a = 1
