@tool
extends Node2D
class_name World

@onready var bg_sprite: TiledSprite2D = $TiledSprite2D

@export var bg_color: Color = Color(1.0, 1.0, 0.56):
	set(value):
		await ready
		bg_color = value
		#$TiledSprite2D.self_modulate = value
@onready var bg_node: Node2D = $BG


# World structure
# > Cam
# World
#> TileMaps
	#> Ground
	#> Foreground
	#> Deco
	#> Sprite2D
		#> Outline
#> OrderChecker
# > Level entites


func _ready() -> void:
	bg_node.modulate = Color(Color.WHITE, 1.0)
	
	#bg_sprite.self_modulate = bg_color
