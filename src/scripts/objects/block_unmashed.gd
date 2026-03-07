#@tool Removed tool for now because I haven't read docs enough
class_name Unmashed
extends CharacterBody2D

@export var mash_type: Util.MashType:
	set(value):
		$SpriteNode/Sprite2D.texture = Util.get_mash_type_texture(value, build_type)
		mash_type = value
@export var build_type: Util.BuildType
	#set(value):
		#$SpriteNode/Sprite2D.texture = Util.get_mash_type_texture(mash_type, value)
		#build_type = value

@onready var up: RayCast2D = $Up
@onready var player_detect: Area2D = $PlayerDetect
@onready var colli: CollisionShape2D = $CollisionShape2D

## For Anim
@onready var sprite: Sprite2D = $SpriteNode/Sprite2D
@onready var sprite_highlight: Sprite2D = $SpriteNode/Highlight

var colli_shape: RectangleShape2D


func _ready() -> void:
	set_physics_process(true)
	process_mode = Node.PROCESS_MODE_INHERIT
	
	GameLogic.setup_mash(sprite, mash_type, build_type)
	
	player_detect.body_entered.connect(func(body: Node2D):
		if body is Player:
			anim_highlight(true)
		)
		
	player_detect.body_exited.connect(func(body: Node2D):
		if body is Player:
			anim_highlight(false)
		)
	
	colli_shape = colli.shape
	


func is_mashable() -> bool:
	return !(up.is_colliding() && up.get_collider() is Unmashed)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	move_and_slide()


var _tween_light: Tween

func anim_highlight(p_mash: bool) -> void:
	if _tween_light:
		_tween_light.kill()
		
	_tween_light = get_tree().create_tween()
	if p_mash:
		_tween_light.tween_property(sprite_highlight, "scale", Vector2.ONE*0.52, 0.1)
	else:
		_tween_light.tween_property(sprite_highlight, "scale", Vector2.ONE*0.4, 0.1)
