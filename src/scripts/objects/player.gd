## Under construction
class_name Player
extends CharacterBody2D

signal has_mashed()
signal has_jumpped()
signal has_landed(strength: float)
signal cherry_bomb_activated()
signal cherry_bomb_has_exploded()
signal mashable_state_changed(can_mash: bool)

@export var animate: bool = true ## @experimental
@export var auto_assign_child_blocks: bool = true
@export_group("Movement Variables")
@export_range(-600.0, 600.0, 1.0, "or_greater", "or_less") var speed: float = 480.0
@export_range(-1500.0, 1500.0, 1.0, "or_greater", "or_less") var acceleration: float = 1000.0
@export_range(-2000.0, 2500.0, 1.0, "or_greater", "or_less") var deceleration: float = 2000.0
@export_range(-400.0, 400.0, 1.0, "or_greater", "or_less") var jump_height: float = 1050.0
@export_category("Objects to Assign")
@export var animator: PlayerAnimationComponent
@export var state_machine: StateMachine
@export var unmashed_object: PackedScene = preload("res://scenes/objects/block_unmashed_1x1.tscn")
@export var unmashed_object_1x2: PackedScene = preload("res://scenes/objects/block_unmashed_1x2.tscn")

@onready var jump_window_timer: Timer = $JumpBufferTimer
@onready var coyote_jump_timer: Timer = $CoyoteJumpTimer
@onready var cherry_bomb_air_timer: Timer = $CherryBombAirTimer
@onready var mashed: Mashed = $Mashed

var stop_deceleration: float = deceleration * 4.0
var air_deceleration: float = deceleration / 3.2
var input_direction: float

var child_blocks: Array[Mashed] # Stack data structure
var new_child_blocks: Array[Mashed] # Stack data structure

var is_landed: bool
var is_exploding: bool

# Anim
var tween_jump: Tween

const CHERRY_BOMB_STRENGTH = 1600.0

var _pos_before_mash: Vector2
var _has_mashed: bool
var _last_velocity_y: float = 0.0


func _ready() -> void:
	GameMgr.current_player = self
	
	has_mashed.connect(func():
		if !_has_mashed:
			GameLogic.player_mashed.emit()
			_has_mashed = true
		
		await get_tree().create_timer(0.025).timeout
		
		_check_child_blocks()
		)
	cherry_bomb_activated.connect(func():
		cherry_bomb_air_timer.start()
		)
	
	new_child_blocks.clear()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_mash"):
		mash_child_blocks()
	
	if event.is_action_pressed("move_unmash"):
		unmash()


func get_unmashed_object(type: Util.BuildType) -> Unmashed:
	match type:
		Util.BuildType.SQUARE:
			return unmashed_object.instantiate()
		Util.BuildType.RECTANGLE:
			return unmashed_object_1x2.instantiate()
		_:
			return null
			

func mash_child_blocks() -> void: ## Ok -> O(n)
	if !can_perform_mash():
		return
	
	var blocks: Array[Mashed] = child_blocks.duplicate(true) # To avoid infinite recursion
	_pos_before_mash = position
	
	for block: Mashed in blocks:
		block.mash()


func unmash() -> void: # -> O(1)
	if !can_unmash():
		return
	
	GameLogic.player_unmashed.emit()
	
	var old_mashed: Mashed = child_blocks[-1]
	_pos_before_mash = position
	
	match old_mashed.mash_type:
		Util.MashType.CHERRY_BOMB:
			if state_machine.current_state == AirState:
				return
				
			_handle_cherry_bomb(old_mashed)
			
		Util.MashType.AIR_CHERRY_BOMB:
			_handle_cherry_bomb(old_mashed)
			
		_:
			if state_machine.current_state == AirState:
				return
				
			child_blocks.pop_back()
	
			var unmashed: Unmashed = get_unmashed_object(old_mashed.build_type)
			unmashed.global_position = old_mashed.global_position
			unmashed.mash_type = old_mashed.mash_type

			old_mashed.queue_free()
			GameMgr.current_level.add_child(unmashed)

			await return_position()


func _handle_cherry_bomb(old_mashed: Mashed) -> void:
	is_exploding = true
	cherry_bomb_activated.emit()
	
	var push_to: Vector2 = Vector2.ZERO
	
	for ray: RayCast2D in old_mashed.block_detect.cherry_bomb_rays:
		ray.force_raycast_update()
		if ray.get_collider() is Player:
			push_to = -ray.target_position.sign()
	
	old_mashed.cherry_bomb_activated.emit(push_to)
	
	var time := Util.CHERRY_BOMB_WAITTIME if old_mashed.mash_type == Util.MashType.CHERRY_BOMB else 0.0
	
	await get_tree().create_timer(time).timeout
	
	child_blocks.pop_back()
	
	explode(push_to)
	
	old_mashed.queue_free()
	
	is_exploding = false


func explode(push: Vector2) -> void:
	cherry_bomb_has_exploded.emit()
	GameLogic.cherry_bomb_exploded.emit()
	
	if absf(push.y) > absf(push.x) && velocity.y > 0:
		velocity.y = 0.0
	
	velocity += -push * CHERRY_BOMB_STRENGTH
	
	state_machine.change_state("AirState", {"jumped": false})


func is_being_flown() -> bool:
	return cherry_bomb_air_timer.time_left > 0.0


func can_perform_mash() -> bool:
	return !(child_blocks[-1].mash_type == Util.MashType.CHERRY_BOMB || child_blocks[-1].mash_type == Util.MashType.AIR_CHERRY_BOMB)


func can_mash() -> bool:
	if is_exploding:
		return false
	
	for block: Mashed in child_blocks:
		if block.block_detect.is_colliding():
			return true
	return false
	
		
func can_unmash() -> bool:
	return child_blocks.size() > 1 && !is_exploding


func return_position() -> void:
	await get_tree().create_timer(0.01).timeout
	
	position = _pos_before_mash


func jump() -> void:
	if is_exploding:
		return
	
	has_jumpped.emit()
	
	velocity.y = -jump_height
	move_and_slide()
	
	state_machine.change_state("AirState", {"jumped": true})


func _move(delta: float) -> void:
	var was_on_floor = is_on_floor()
	
	_last_velocity_y = velocity.y
	
	move_and_slide()

	## Jump logic, w/ coyote jump and buffer jump
	
	## Fell of platform
	if was_on_floor && !is_on_floor() && velocity.y >= 0.0:
		coyote_jump_timer.start()
		
		state_machine.change_state("AirState", {"jumped": false})
		
	if Input.is_action_just_pressed("move_jump"):
		if coyote_jump_timer.time_left > 0.0:
			jump()
		else:
			jump_window_timer.start()
			
	## If the player in on the floor and within the jump window/jump buffer timer, then jump
	if is_on_floor() && !jump_window_timer.is_stopped():
		jump()
		
	input_direction = Input.get_axis("move_left", "move_right")


func _state() -> void:
	if !is_landed && is_on_floor():
		has_landed.emit(abs(_last_velocity_y / 100.0))
		is_landed = true
		
	if !is_on_floor():
		is_landed = false
		
	if is_on_ceiling() && tween_jump:
		tween_jump.kill()
		
		for block: Mashed in child_blocks:
			block.sprite.scale = Vector2.ONE * 0.5


func _animate(delta: float) -> void:
	for block: Mashed in child_blocks:
		if block:
			block.sprite_eyes.position = Vector2(
				move_toward(block.sprite_eyes.position.x, minf(12.0, velocity.x / 50.0), delta * 100.0),
				move_toward(block.sprite_eyes.position.y, minf(12.0, velocity.y / 50.0), delta * 100.0)
			) 


func _physics_process(delta: float) -> void:
	if !GameLogic.is_checking_order_match:
		_move(delta)
	_state()
	_animate(delta)
	

func _check_child_blocks() -> void:
	if new_child_blocks.is_empty():
		return
	
	# TODO: Fix for 1x2 blocks
	# There's issues probably
	
	for i in range(1, new_child_blocks.size()):
		if new_child_blocks[i].position == new_child_blocks[0].position:
			new_child_blocks[i].queue_free()
			child_blocks.pop_back()
			
	new_child_blocks.clear()
	_has_mashed = false
