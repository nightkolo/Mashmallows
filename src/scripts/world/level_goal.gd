extends Control
class_name LevelGoal
## Let be Control

@export var level: Level

@onready var level_number_label: Label = %LevelNumber

@onready var star_node: Node2D = $Star
@onready var star_no_win: Sprite2D = $Star/NoWin
@onready var star_win: Sprite2D = $Star/Win
@onready var perc_label: Label = %PercLabel


func _ready() -> void:
	# TODO: Anim function
	
	GameMgr.current_level_goal = self
	
	level_number_label.position = Vector2(-level_number_label.size.x / 2, 16.0)
	
	GameLogic.completion_percentage_updated.connect(func(perc: float):
		perc_label.text = str(Util.round_to_dec(perc * 100.0, 2)) + "%"
		)
	
	GameLogic.order_complete.connect(func():
		star_no_win.visible = false
		star_win.visible = true
		)
