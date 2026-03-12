## Under construction
extends State
class_name RunState


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_mash"):
		entity.mash_child_blocks()
	
	if event.is_action_pressed("move_unmash"):
		entity.unmash()


func physics_update(delta: float) -> void:
	if entity == null:
		return
	
	## Jump logic and platform fall is handled in player code
	
	var dir := entity.input_direction

	if dir == 0.0:
		state_machine.change_state("IdleState")
		return

	# turning brake
	if dir < 0.0 and entity.velocity.x > 0.0:
		entity.velocity.x = move_toward(entity.velocity.x, 0.0, entity.stop_deceleration * delta)

	elif dir > 0.0 and entity.velocity.x < 0.0:
		entity.velocity.x = move_toward(entity.velocity.x, 0.0, entity.stop_deceleration * delta)

	# normal acceleration
	else:
		entity.velocity.x = move_toward(
			entity.velocity.x,
			dir * entity.speed,
			entity.acceleration * delta
		)
