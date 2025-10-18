extends Node2D
class_name Poisoncollectable


@export var poison_type:int
@onready var color_node:Sprite2D = self.get_child(0).get_child(0).get_child(0)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body is Player):
		if(body.inventory.collect_item(poison_type)):
			self.queue_free()
		else:
			pass
