## Under construction
extends State
class_name AirState


func _unhandled_input(event: InputEvent) -> void:
	if player == null:
		return
	
	if event.is_action_pressed("move_mash"):
		player.mash_child_blocks()


func enter(msg := {}):
	pass
	#if msg.get("jumped", false):
		#player.play_animation("jump")
	#else:
		#player.play_animation("fall")


func physics_update(delta: float) -> void:
	if player == null:
		return
	
	player.velocity += player.get_gravity() * delta
	
	# Variable jump height
	if Input.is_action_just_released("move_jump") and player.velocity.y < 0.0:
		player.velocity.y = player.velocity.y / 3.0
	
	var dir := player.input_direction
	
	if player.is_on_floor():
		if player.is_being_flown():
			player.cherry_bomb_air_timer.stop()

		if dir != 0.0:
			state_machine.change_state("RunState")
		else:
			state_machine.change_state("IdleState")

		return
	
	if dir != 0.0:
		player.velocity.x = move_toward(
			player.velocity.x,
			dir * player.speed,
			player.acceleration * delta
		)
	else:
		if player.is_being_flown():
			player.velocity.x = move_toward(
				player.velocity.x,
				0.0,
				player.air_deceleration * delta
			)
