extends State
class_name IdleState


func enter(msg := {}):
	owner.velocity.x = 0
	owner.play_animation("idle")

func update(delta):
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.change_state("RunState")

	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("JumpState")
