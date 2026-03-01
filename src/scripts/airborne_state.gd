extends State
class_name AirborneState


func enter(msg := {}):
	owner.velocity.y = owner.jump_force

func physics_update(delta):
	if owner.is_on_floor():
		state_machine.change_state("IdleState")
