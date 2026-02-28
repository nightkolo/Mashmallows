extends Node2D
class_name LevelGoal

@export var level: Level

@onready var level_number_label: Label = $LevelNumber

@onready var star_node: Node2D = $Star
@onready var star_no_win: Sprite2D = $Star/NoWin
@onready var star_win: Sprite2D = $Star/Win


func _ready() -> void:
	GameMgr.current_level_goal = self
	
	#await get_tree().create_timer(0.1).timeout
	#if level:
		#level_number_label.text = "1-" + str(level.level_id)
	#else:
		#level_number_label.text = "1-" + str(GameMgr.current_level_number)
	
	level_number_label.position = Vector2(-level_number_label.size.x / 2, 16.0)
	
	GameLogic.order_complete.connect(func():
		star_no_win.visible = false
		star_win.visible = true
		)
