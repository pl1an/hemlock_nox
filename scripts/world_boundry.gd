extends Node2D

# Define the world boundaries
@export var min_x: float = -1000
@export var max_x: float = 1000
@export var min_y: float = -1000
@export var max_y: float = 1000

# Reference to the object you want to constrain (e.g., a player)
@export var target: Node2D

func _process(delta):
	if target:
		# Clamp the target's position to the world boundaries
		target.position.x = clamp(target.position.x, min_x, max_x)
		target.position.y = clamp(target.position.y, min_y, max_y)
