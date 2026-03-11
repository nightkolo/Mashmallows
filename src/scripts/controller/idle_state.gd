## Under construction
extends State
class_name IdleState

#// Actions availabe
	#Jump
	#Mash
	#Unmash

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_mash"):
		entity.mash_child_blocks()
	
	if event.is_action_pressed("move_unmash"):
		entity.unmash()


func enter(msg := {}) -> void:
	pass
	#entity.velocity.x = 0
	#entity.play_animation("idle")


func physics_update(delta: float) -> void:
	## Jumpped off platform
	if Input.is_action_just_pressed("move_jump"):
		entity.jump()
	
	## Fell off platform
	if !entity.is_on_floor():
		state_machine.change_state("AirState")
	
	## Horizontal movement action
	var dir : float = entity.input_direction

	if dir != 0.0:
		entity.velocity.x = move_toward(entity.velocity.x,dir * entity.speed,entity.acceleration * delta)

		state_machine.change_state("RunState")
	else:
		entity.velocity.x = move_toward(entity.velocity.x,0,entity.deceleration * delta)
		
		
	#if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		#state_machine.change_state("RunState")
#
	#if Input.is_action_just_pressed("jump"):
		#state_machine.change_state("AirState")
