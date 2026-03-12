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
	if entity == null:
		return
	
	# Horizontal movement input
	var dir := entity.input_direction

	# Start running
	if dir != 0.0:
		state_machine.change_state("RunState")
		return

	# Apply ground friction
	entity.velocity.x = move_toward(
		entity.velocity.x,
		0.0,
		entity.deceleration * delta
	)
