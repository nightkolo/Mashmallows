extends State
class_name RunState


func update(delta):
	var direction = Input.get_axis("move_left", "move_right")
	owner.velocity.x = direction * owner.speed

	if direction == 0:
		state_machine.change_state("IdleState")

	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("JumpState")
