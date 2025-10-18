extends Control
class_name DificultyManager

@export var spawner:Spawner
@export var dificulty_change_animation:AnimationPlayer
@export var dificulty_change_text:Label
@export var dificulty_change_timer:Timer
@export var start_timer:Timer

@export var dificulty_number:int = 0
# array containing the dificulty settings, in order. each dificulty takes 1 minute
# [[dificulty_name, wave_interval, wave_size, {ENEMY_SPAWN_STATUS}]...]
@export var dificulty_list = [
	["easy1", 20, 2, {"MAXHEALTH":100, "SPEED": 200, "DAMAGE":100}],
	["easy2", 20, 4, {"MAXHEALTH":100, "SPEED": 200, "DAMAGE":100}],
	["easy3", 20, 8, {"MAXHEALTH":100, "SPEED": 200, "DAMAGE":100}],
	["???", 20, 16, {"MAXHEALTH":50, "SPEED": 300, "DAMAGE":100}],
	["medium1", 30, 4, {"MAXHEALTH":200, "SPEED": 300, "DAMAGE":200}],
	["medium2", 30, 6, {"MAXHEALTH":200, "SPEED": 300, "DAMAGE":200}],
	["medium2", 30, 8, {"MAXHEALTH":300, "SPEED": 300, "DAMAGE":250}],
	["???", 30, 32, {"MAXHEALTH":100, "SPEED": 350, "DAMAGE":250}],
	["hard1", 20, 8, {"MAXHEALTH":500, "SPEED": 400, "DAMAGE":400}],
	["har2", 20, 10, {"MAXHEALTH":500, "SPEED": 400, "DAMAGE":400}],
	["easy2", 20, 12, {"MAXHEALTH":500, "SPEED": 500, "DAMAGE":400}],
	["???", 30, 64, {"MAXHEALTH":150, "SPEED": 500, "DAMAGE":400}],
	["impossible", 20, 8, {"MAXHEALTH":1000, "SPEED": 600, "DAMAGE":1000}],
	["???", 30, 64, {"MAXHEALTH":500, "SPEED": 700, "DAMAGE":1000}],
]

func change_dificulty():
	if(dificulty_number==dificulty_list.size()): return
	dificulty_change_text.text = dificulty_list[dificulty_number][0]
	dificulty_change_animation.play("difficulty_transition")
	spawner.enemy_wave_timer.wait_time = dificulty_list[dificulty_number][1]
	spawner.enemy_wave_number = dificulty_list[dificulty_number][2]
	spawner.ENEMY_SPAWN_STATUS = dificulty_list[dificulty_number][3]
	spawner.spawn_wave(spawner.enemy_preload, spawner.enemy_wave_number)
	spawner.enemy_wave_timer.start()
	spawner.poison_spawn_timer.start()


func _ready() -> void:
	dificulty_change_timer.start()

func _on_dificulty_change_timer_timeout() -> void:
	dificulty_number += 1
	change_dificulty()
	dificulty_change_timer.start()

func _on_start_timer_timeout() -> void:
	change_dificulty()
	start_timer.stop()
