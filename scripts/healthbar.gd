extends Control
class_name Healthbar

@export var style_box:StyleBoxFlat
@onready var fillable_bar:ProgressBar = self.get_child(0).get_child(0)

func _ready() -> void:
	fillable_bar.add_theme_stylebox_override("fill", style_box)

func update_bar_value(new_value, max_health):
	fillable_bar.max_value = max_health
	fillable_bar.value = new_value

func get_bar_value():
	return fillable_bar.value
