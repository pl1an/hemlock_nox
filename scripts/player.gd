extends CharacterBody2D
class_name Player


@export var MAXHEALTH:float
@export var ARMOR:float
@export var SPEED:float
@export var MAXROLLS:int
@export var ROLLSPEED:float
@export var THROWSPEED:float
@export var MAXINVENTORYSIZE:int
@export var NEXTLEVELUPEXP:int
@export var UNLOCKEDPOISONS:Array[int] = [1, -1, -2, -3, -4, -5, -6, -7, -8]
# status effects potency (name:[added_value, status_duration, zone_duration, zone_size])
@export var EFFECTS_POTENCY = {
	"slow":[0.5, 3, 10, 1],
	"poison":[10, 10, 3, 1],
	"burn":[30, 5, 6, 1],
	"confusion":[2, 5, 1, 1],
	"heal":[300, 0, 0.00001, 1],
	"regeneration":[50, 10, 3, 1],
	"weak":[50, 10, 2, 1],
	"cripple":[1, 5, 0, 1],
	"decay":[40, 5, 3, 1]
}
@export var effects_potency_keys:Array[String]

# movement internal variables
var player_input:Vector2

# rolling internal variables
var rolling_count:int
var roll_direction:Vector2
@onready var roll_timer:Timer = self.get_child(3)
@onready var collider:CollisionShape2D = self.get_child(1)

const poison_bottle = preload("res://scenes/poison_bottle.tscn")

# health management internal variables
@onready var health:float = MAXHEALTH
@onready var healthbar:Healthbar = self.get_child(5).get_child(0).get_child(0).get_child(0).get_child(0)

# exp management internal varibales
var player_exp:int = 0
var player_level = 1
@export var levelupmanager:LevelUpManager
@onready var expbar:Healthbar = self.get_child(5).get_child(0).get_child(0).get_child(1).get_child(0)

#inventory management variables
@onready var inventory:Inventory = self.get_child(5).get_child(0).get_child(1).get_child(0)

# status effects management variables
@onready var poison_effects:Poison_effects = self.get_child(4)
# status effects on player (name:[value, timer, ticking, modulate_added])
var status_effects = {
	"slowed":[0, 0, false, Color.BLACK],
	"poisoned":[0, 0, false, Color.BLACK],
	"burning":[0, 0, false, Color.BLACK],
	"confused":[0, 0, false, Color.BLACK],
	"healed":[0, 0, false, Color.BLACK],
	"regenerating":[0, 0, false, Color.BLACK],
	"weakened":[0, 0, false, Color.BLACK],
	"crippled":[0, 0, false, Color.BLACK],
	"decaying":[0, 0, false, Color.BLACK]
}
var status_keys = status_effects.keys()

@export var deathScreen:death_screen
var dead = false
var on_menu = true


func take_damage(damage:float):
	if(dead): return
	health = health - damage*(1-ARMOR)
	healthbar.update_bar_value(health, MAXHEALTH)
	if(health<=0):
		deathScreen.anim.play("death_screen")
		var animation_sprite:AnimatedSprite2D = self.get_child(0)
		animation_sprite.play("roll_transition_in")
		rolling_count = 1000
		levelupmanager.hide()
		dead = true
func heal(healing:float):
	if(health+healing>MAXHEALTH): health = MAXHEALTH
	else: health = health + healing
	healthbar.update_bar_value(health, MAXHEALTH)

func gain_exp(exp:int):
	player_exp += exp
	if(player_exp==NEXTLEVELUPEXP):
		levelupmanager.level_up()
	expbar.update_bar_value(player_exp, NEXTLEVELUPEXP)

func _ready() -> void:
	expbar.update_bar_value(player_exp, NEXTLEVELUPEXP)
	randomize()

func _process(delta: float) -> void:
	# handling characther movement speed
	player_input.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	player_input.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	velocity = player_input.normalized()*(SPEED - status_effects["slowed"][0])*(1-status_effects["confused"][0])
	# handling characther roll speed
	if(rolling_count>0):
		velocity = roll_direction.normalized()*(ROLLSPEED - status_effects["slowed"][0])*(1-status_effects["confused"][0])*(roll_timer.time_left+0.5)
	# handling moving animation
	if(rolling_count==0):
		var animation_sprite:AnimatedSprite2D = self.get_child(0)
		if((velocity.x==0 and velocity.y==0) or on_menu):
			animation_sprite.play("idle")
		elif(velocity.x>0):
			if(animation_sprite.scale.x<0): animation_sprite.scale.x = -animation_sprite.scale.x
			animation_sprite.play("run")
		elif(velocity.x<0):
			animation_sprite.play("run")
			if(animation_sprite.scale.x>0): animation_sprite.scale.x = -animation_sprite.scale.x
		else:
			animation_sprite.play("run")
	# moving
	if(!on_menu): move_and_slide()
	# handling status effects
	if(status_effects["poisoned"][0]!=0): take_damage(status_effects["poisoned"][0]*delta)
	if(status_effects["burning"][0]!=0): take_damage(status_effects["burning"][0]*delta)
	if(status_effects["regenerating"][0]!=0): heal(status_effects["regenerating"][0]*delta)
	if(status_effects["crippled"][0]!=0): take_damage((status_effects["crippled"][0]*velocity.length()/100)*delta)
	if(status_effects["decaying"][0]!=0): take_damage(status_effects["decaying"][0]*delta)
	# handling status effects timer
	for i in range(status_keys.size()):
		if(status_effects[status_keys[i]][2]):
			status_effects[status_keys[i]][1] -= delta
			if(status_effects[status_keys[i]][1]<=0):
				self.get_child(0).modulate = (self.get_child(0).modulate - status_effects[status_keys[i]][3]).clamp()
				self.get_child(0).modulate.a = 1.0
				status_effects[status_keys[i]][0] = 0
				status_effects[status_keys[i]][1] = 0
				status_effects[status_keys[i]][2] = false
				# hard reset of status effects, just in case
				var reset = true
				for ii in status_keys:
					if(status_effects[ii][2]):
						reset = false
				if(reset):
					for ii in status_keys:
						status_effects[ii][0] = 0
						status_effects[ii][1] = 0
						status_effects[ii][2] = false
					self.get_child(0).modulate = Color.WHITE


func _input(event: InputEvent) -> void:
	var animation_sprite:AnimatedSprite2D = self.get_child(0)
	# handling characther roll input
	if(event.is_action_pressed("roll") and !on_menu):
		if(rolling_count>=MAXROLLS):
			pass
		else:
			self.set_collision_mask_value(3, false)
			rolling_count = rolling_count + 1
			roll_direction = player_input
			roll_timer.stop()
			roll_timer.start()
			if(animation_sprite.animation!="rolling"):
				animation_sprite.play("roll_transition_in")
				if(roll_direction!=Vector2.ZERO):
					animation_sprite.scale = Vector2(5, 5)
					self.rotation = roll_direction.angle()
	# handling throw poison bottle input
	if(event.is_action_pressed("throw_poison_bottle") and inventory.items.size()>0 and !on_menu):
		var instanciated_poison_bottle = poison_bottle.instantiate()
		self.get_parent().add_child(instanciated_poison_bottle)
		instanciated_poison_bottle.throw_direction = self.global_position.direction_to(get_global_mouse_position())
		instanciated_poison_bottle.throw_velocity = THROWSPEED - THROWSPEED*(status_effects["weakened"][0]/(status_effects["weakened"][0]+85))
		instanciated_poison_bottle.global_position = self.global_position + instanciated_poison_bottle.throw_direction*THROWSPEED*0.3
		instanciated_poison_bottle.poison_effects = poison_effects
		var poison_type_choice = inventory.items[inventory.selected_item]
		inventory.remove_item(inventory.selected_item)
		instanciated_poison_bottle.poison_type = poison_type_choice
		instanciated_poison_bottle.potion_color.modulate = poison_effects.effect_colors[poison_type_choice]
	# handling selected poison change input
	if(event.is_action_pressed("select_next_poison")):
		inventory.select_next()
	if(event.is_action_pressed("select_previous_poison")):
		inventory.select_previous()


func _on_roll_timer_timeout() -> void:
	set_collision_mask_value(3, true)
	var animation_sprite:AnimatedSprite2D = self.get_child(0)
	if(rolling_count!=0):
		animation_sprite.play("roll_transition_out")
		self.rotation = 0

func _on_sprite_2d_animation_finished() -> void:
	var animation_sprite:AnimatedSprite2D = self.get_child(0)
	print(animation_sprite.animation)
	if(animation_sprite.animation=="roll_transition_out"):
		rolling_count = 0
		self.rotation = 0
	if(animation_sprite.animation=="roll_transition_in" and rolling_count!=0): 
		animation_sprite.play("rolling")
	if(health<=0):
		animation_sprite.stop()
