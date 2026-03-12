## Under construction
extends State
class_name IdleState

# Actions available
	#Jump
	#Mash
	#Unmash

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_mash"):
		player.mash_child_blocks()
	
	if event.is_action_pressed("move_unmash"):
		player.unmash()


func enter(msg := {}) -> void:
	pass
	

func physics_update(delta: float) -> void:
	if player == null:
		return
	
	## Jump logic and platform fall is handled globally in player code

	# Start running
	if player.input_direction != 0.0:
		state_machine.change_state("RunState")
		return

	# Apply ground friction
	player.velocity.x = move_toward(
		player.velocity.x,
		0.0,
		player.deceleration * delta
	)
