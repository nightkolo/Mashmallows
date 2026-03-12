## Under construction
extends State
class_name AirState


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_mash"):
		entity.mash_child_blocks()


func enter(msg := {}):
	pass
	#if msg.get("jumped", false):
		#entity.play_animation("jump")
	#else:
		#entity.play_animation("fall")


func physics_update(delta: float) -> void:
	if entity == null:
		return
	
	entity.velocity += entity.get_gravity() * delta
	
	if Input.is_action_just_released("move_jump") and entity.velocity.y < 0.0:
		entity.velocity.y = entity.velocity.y / 2.0
	
	var dir := entity.input_direction
	
	if entity.is_on_floor():
		if entity.is_being_flown():
			entity.cherry_bomb_air_timer.stop()

		if dir != 0.0:
			state_machine.change_state("RunState")
		else:
			state_machine.change_state("IdleState")

		return
	
	if dir != 0.0:
		entity.velocity.x = move_toward(
			entity.velocity.x,
			dir * entity.speed,
			entity.acceleration * delta
		)
	else:
		if entity.is_being_flown():
			entity.velocity.x = move_toward(
				entity.velocity.x,
				0.0,
				entity.air_deceleration * delta
			)
