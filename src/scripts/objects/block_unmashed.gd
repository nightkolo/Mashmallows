@tool
class_name Unmashed
extends RigidBody2D

@export var mash_type: Util.MashType:
	set(value):
		$SpriteNode/Sprite2D.texture = Util.get_mash_type_texture(value, build_type)
		mash_type = value
@export var build_type: Util.BuildType
	#set(value):
		#$SpriteNode/Sprite2D.texture = Util.get_mash_type_texture(mash_type, value)
		#build_type = value

@onready var up: RayCast2D = $Up
@onready var sprite: Sprite2D = $SpriteNode/Sprite2D
@onready var colli: CollisionShape2D = $CollisionShape2D

@onready var sprite_highlight: Sprite2D = $SpriteNode/Highlight

#var up_2: RayCast2D
var colli_shape: RectangleShape2D

var _tween_light: Tween

func anim_highlight(p_mash: bool) -> void:
	if _tween_light:
		_tween_light.kill()
		
	_tween_light = get_tree().create_tween()
	if p_mash:
		_tween_light.tween_property(sprite_highlight, "scale", Vector2.ONE*0.52, 0.1)
	else:
		_tween_light.tween_property(sprite_highlight, "scale", Vector2.ONE*0.4, 0.1)


func _ready() -> void:
	GameLogic.setup_mash(sprite, mash_type, build_type)
	
	colli_shape = colli.shape
	


func is_mashable() -> bool:
	return !(up.is_colliding() && up.get_collider() is Unmashed)
