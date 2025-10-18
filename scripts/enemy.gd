extends CharacterBody2D
class_name Enemy


@export var MAXHEALTH:float
@onready var health:float = MAXHEALTH
@export var SPEED:float
@onready var player:Player = self.get_parent().get_child(0)

@export var DAMAGE:float
var attacking_player = false

# status effects on enemy (name:[value, timer, ticking, modulate_added])
var status_effects = {
	"poisoned":[0, 0, false, Color.BLACK],
	"slowed":[0, 0, false, Color.BLACK],
	"burning":[0, 0, false, Color.BLACK],
	"confused":[0, 0, false, Color.BLACK],
	"healed":[0, 0, false, Color.BLACK],
	"regenerating":[0, 0, false, Color.BLACK],
	"weakened":[0, 0, false, Color.BLACK],
	"crippled":[0, 0, false, Color.BLACK],
	"decaying":[0, 0, false, Color.BLACK]
}
var status_keys = status_effects.keys()


func take_damage(damage:float):
	health = health - damage
func heal(healing:float):
	if(health+healing>MAXHEALTH): health = MAXHEALTH
	else: health = health + healing

func _process(delta: float) -> void:
	# handling death
	if(health<=0):
		player.gain_exp(1)
		self.queue_free()
	# handling movement
	velocity = global_position.direction_to(player.global_position)*(SPEED - status_effects["slowed"][0])*(1-status_effects["confused"][0])
	move_and_slide()
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
				self.get_child(0).modulate -= status_effects[status_keys[i]][3]
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
					self.get_child(0).modulate = Color.WHITE
	# handling player collisions
	if(attacking_player):
		player.take_damage((DAMAGE-status_effects["weakened"][0])*delta)


func _on_hitbox_body_entered(body: Node2D) -> void:
	if(status_effects["decaying"][0]!=0 and (body is Enemy or body is Player)):
		player.poison_effects.effects[8][0].call(body)
	if(body is Player):
		if(body.status_effects["decaying"][0]!=0):
			player.poison_effects.effects[8][0].call(self)
		if(body.rolling_count!=0): return
		attacking_player = true

func _on_hitbox_body_exited(body: Node2D) -> void:
	player.poison_effects.effects[8][1].call(body)
	if(body is Player):
		attacking_player = false
