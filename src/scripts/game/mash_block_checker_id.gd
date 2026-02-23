@tool
extends Node2D
class_name MashBlockCheckerID

@onready var sprite: Sprite2D = $Sprite2D


@export var is_mash_type: Util.MashType:
	set(value):
		$Sprite2D.texture = Util.get_block_mash_type_texture(value, is_build_type)
		is_mash_type = value
@export var is_build_type: Util.BuildType:
	set(value):
		$Sprite2D.texture = Util.get_block_mash_type_texture(is_mash_type, value)
		is_build_type = value



func _ready() -> void:
	GameLogic.setup_mash_block(sprite, is_mash_type, is_build_type)

	if get_parent() is Order:
		(get_parent() as Order).mash_block_checker_ids.append(self)
