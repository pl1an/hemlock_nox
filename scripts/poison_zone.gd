extends Sprite2D


@onready var duration_timer:Timer = self.get_child(2)
@onready var animation_player:AnimationPlayer = self.get_child(1)

var poison_type:int
var poison_effect_list:Poison_effects


func _on_duration_timer_timeout() -> void:
	animation_player.play("duration_ended")

func on_duration_end():
	self.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body is Player or body is Enemy):
		if(body is Player): if(body.rolling_count!=0): return
		poison_effect_list.effects[poison_type][0].call(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if(body is Player or body is Enemy):
		if(body is Player): if(body.rolling_count!=0): return
		poison_effect_list.effects[poison_type][1].call(body)
