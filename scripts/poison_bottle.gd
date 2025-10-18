extends CharacterBody2D

@export var poison_type:int
@onready var potion_color:Sprite2D = self.get_child(0).get_child(1).get_child(0)
var poison_effects:Poison_effects

var throw_direction:Vector2
var throw_velocity:int

const poison_zone = preload("res://scenes/poison_zone.tscn")


func _process(delta: float) -> void:
	rotate(PI*delta)
	velocity = throw_direction.normalized()*throw_velocity
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	var instantiated_poison_zone = poison_zone.instantiate()
	self.get_parent().add_child(instantiated_poison_zone)
	instantiated_poison_zone.self_modulate = self.get_child(0).get_child(1).get_child(0).modulate
	instantiated_poison_zone.poison_type = poison_type
	instantiated_poison_zone.global_position = self.global_position
	instantiated_poison_zone.poison_effect_list = self.poison_effects
	var player:Player = poison_effects.get_parent()
	instantiated_poison_zone.scale = instantiated_poison_zone.scale*player.EFFECTS_POTENCY[player.effects_potency_keys[poison_type]][3]
	instantiated_poison_zone.duration_timer.wait_time = player.EFFECTS_POTENCY[player.effects_potency_keys[poison_type]][2]
	instantiated_poison_zone.duration_timer.start()
	self.queue_free()
