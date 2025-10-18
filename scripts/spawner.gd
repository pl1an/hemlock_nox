extends Node2D
class_name Spawner

@export var enemy_wave_number:int
@export var poison_spawn_number:int
@export var enemy_wave_timer:Timer
@export var poison_spawn_timer:Timer

@export var poison_effects:Poison_effects

@export var SPAWN_MINIMUM_RANGE:float
@export var player:Player

@onready var enemy_preload = preload("res://scenes/enemy.tscn")
@onready var poison_collectable_preload = preload("res://scenes/poison_collectable.tscn")

@export var ENEMY_SPAWN_STATUS = {
	"MAXHEALTH":100,
	"SPEED": 200,
	"DAMAGE":100
}


func spawn(target_spawn):
	var new_instance = target_spawn.instantiate()
	self.get_parent().get_parent().add_child(new_instance)
	if(new_instance is Enemy):
		new_instance.global_position = player.position + Vector2(SPAWN_MINIMUM_RANGE, 0).rotated(randf_range(0, 2*PI))
		new_instance.MAXHEALTH = ENEMY_SPAWN_STATUS["MAXHEALTH"]
		new_instance.SPEED = ENEMY_SPAWN_STATUS["SPEED"]
		new_instance.DAMAGE = ENEMY_SPAWN_STATUS["DAMAGE"]
	if(new_instance is Poisoncollectable):
		new_instance.global_position = player.position + Vector2(SPAWN_MINIMUM_RANGE, 0).rotated(randf_range(0, 2*PI))
		new_instance.scale = new_instance.scale*3
		new_instance.poison_type = player.UNLOCKEDPOISONS.filter(func(element): return element>=0)[randi()%player.UNLOCKEDPOISONS.filter(func(element): return element>=0).size()]
		new_instance.color_node.modulate = poison_effects.effect_colors[new_instance.poison_type]

func spawn_wave(target_spawn, wave_size:int):
	for i in range(wave_size):
		spawn(target_spawn)

func _on_spawn_enemy_timer_timeout() -> void:
	spawn_wave(enemy_preload, enemy_wave_number)
	enemy_wave_timer.start()

func _on_spawn_collectable_poison_timer_timeout() -> void:
	spawn_wave(poison_collectable_preload, poison_spawn_number)
	poison_spawn_timer.start()
