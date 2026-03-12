extends Node2D
class_name Level

#@export_group("Dev options")
@export var level_id: int = -1
@export var show_dev_ui: bool = false ## @experimental
@export var ignore_order: bool = false
@export var no_progression: bool = false

@onready var dev_ui: PackedScene = preload("res://scenes/menus/dev_ui.tscn")


func _ready() -> void:
	if level_id < 0:
		GameMgr.current_level_number = scene_file_path.to_int()
	else:
		GameMgr.current_level_number = level_id
	
	GameMgr.current_level = self
	GameMgr.level_entered.emit()
	
	if show_dev_ui:
		var ui := dev_ui.instantiate()
		
		GameMgr.current_level.add_child(ui)
		GameMgr.current_level.move_child(ui, 0)
	
