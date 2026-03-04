# Game Logic
extends Node

signal player_mashed()
signal player_unmashed()
signal order_checked()
signal order_complete()

signal completion_percentage_updated(perc: float)

var is_checking_order_match: bool = false
var has_won: bool = false

var number_of_order_blocks: int
var completion_percentage: float:
	set(value):
		if value != completion_percentage:
			completion_percentage_updated.emit(value)
		completion_percentage = value

var order_check_ori_pos: Vector2

## TODO: Analyze execution structure, minimize race conditions


func reset_game_logic() -> void:
	number_of_order_blocks = 0
	completion_percentage = 0.0
	
	has_won = false
	order_check_ori_pos = Vector2.ZERO


func _ready() -> void:
	player_mashed.connect(check_order_completion)

	player_unmashed.connect(check_order_completion)
	
	order_checked.connect(func():
		is_checking_order_match = false
		
		GameMgr.current_order_checker.global_position = order_check_ori_pos
		)
	
	order_complete.connect(func():
		GameMgr.game_just_ended.emit()
		)
		

func order_met() -> void:
	order_complete.emit()
	print("Game over.")
		

## 0.05s waittime
func check_order_completion() -> void: # Ok -> O(n), Worst case -> O(n^2)
	if GameMgr.current_order_checker == null || GameMgr.current_level.ignore_order:
		return
	
	# TODO Count satisfied order blocks
	
	is_checking_order_match = true
	GameMgr.current_order_checker.global_position = GameMgr.current_player.position
	
	await get_tree().create_timer(0.05).timeout
	
	print("Checking satisfaction")
	
	var amount_satisfied: int = GameMgr.current_order_checker.check_satisfaction_full()
	
	completion_percentage = (float(amount_satisfied - 1.0) / number_of_order_blocks)
	
	print(completion_percentage)
	
	if amount_satisfied - 1 == number_of_order_blocks:
		order_met()
		has_won = true
		
	order_checked.emit()
	
	
func setup_mash_block(sprite: Sprite2D, type: Util.MashType, build: Util.BuildType = Util.BuildType.SQUARE) -> void:
	sprite.texture = Util.get_order_block_texture(type, build)
	

func setup_mash(
	sprite: Sprite2D,
	type: Util.MashType,
	build: Util.BuildType = Util.BuildType.SQUARE) -> void:
	sprite.texture = Util.get_mash_type_texture(type, build)
	
	
