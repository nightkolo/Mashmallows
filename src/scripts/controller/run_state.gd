extends State
class_name RunState

# Actions available
	#Jump
	#Mash
	#Unmash

func _unhandled_input(event: InputEvent) -> void:
	if player == null:
		return
	
	if event.is_action_pressed("move_mash"):
		player.mash_child_blocks()
	
	if event.is_action_pressed("move_unmash"):
		player.unmash()


func physics_update(delta: float) -> void:
	if player == null:
		return
	
	## Jump logic and platform fall is handled globally in player code
	
	var dir := player.input_direction

	if dir == 0.0:
		state_machine.change_state("IdleState")
		return

	# Stop friction
	if dir < 0.0 and player.velocity.x > 0.0:
		player.velocity.x = move_toward(
			player.velocity.x,
			0.0,
			player.stop_deceleration * delta
			)

	elif dir > 0.0 and player.velocity.x < 0.0:
		player.velocity.x = move_toward(
			player.velocity.x,
			0.0,
			player.stop_deceleration * delta
			)

	# Normal acceleration
	else:
		player.velocity.x = move_toward(
			player.velocity.x,
			dir * player.speed,
			player.acceleration * delta
		)
