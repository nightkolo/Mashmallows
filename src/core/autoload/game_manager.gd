extends CanvasLayer

signal level_entered()
signal game_just_ended()
signal game_end()
signal game_reset()

## Self-assigned by the Entites
var current_level_number: int:
	set(value):
		current_level_goal.level_number_label.text = "1-" + str(value)
		current_level_number = value
var current_level: Level:
	set(value):
		current_level = value
		current_level.show_dev_ui = true
var current_player: Player
var current_order_checker: OrderChecker
var current_level_goal: LevelGoal
var current_camera: Cam

## Level Begin
# Variables self-assigned


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("game_reset"):
		game_reset.emit()


func _ready() -> void:
	#Engine.time_scale = 1.0/8.0
	game_just_ended.connect(func():
		await get_tree().create_timer(Util.ORDER_COMPLETE_WAIT_TIME).timeout
		
		game_end.emit()
		)
	
	game_end.connect(goto_next_level)
		
	game_reset.connect(func():
		GameLogic.reset_game_logic()
		get_tree().reload_current_scene()
		)


func goto_next_level() -> void:
	if !current_level:
		return
	
	if current_level.no_progression:
		return
	
	var next_lvl_id := current_level.scene_file_path.to_int() + 1
	var next_lvl_path := Util.LEVEL_FILE_BEGIN + str(next_lvl_id) + Util.LEVEL_FILE_END
	
	if ResourceLoader.exists(next_lvl_path):
		Trans.slide_to_next_stage(next_lvl_path)
		
		#get_tree().change_scene_to_file(next_lvl_path)
	
	#if next_lvl_id <= GameUtil.NUMBER_OF_BOARDS: 
		#Trans.slide_to_next_stage(next_lvl_path)
	#else:
		#Trans.slide_to_credits(0.4)
		#game_has_ended = true
