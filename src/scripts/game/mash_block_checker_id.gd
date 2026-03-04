@tool
extends Node2D
class_name MashBlockCheckerID

@onready var sprite: Sprite2D = $Sprite2D


@export var is_mash_type: Util.MashType:
	set(value):
		$Sprite2D.texture = Util.get_order_block_texture(value, is_build_type)
		is_mash_type = value
@export var is_build_type: Util.BuildType:
	set(value):
		$Sprite2D.texture = Util.get_order_block_texture(is_mash_type, value)
		is_build_type = value


func _ready() -> void:
	GameLogic.setup_mash_block(sprite, is_mash_type, is_build_type)
	
	if is_mash_type != Util.MashType.PLAYER:
		GameLogic.number_of_order_blocks += 1
		is_satisfied = false

	if get_parent() is Order:
		(get_parent() as Order).mash_block_checker_ids.append(self)


var is_satisfied: bool = true
var tween_anim: Tween


# TODO Clean-up
## Called by [MashBlockChecker]
func anim_satisfied(satisfied: bool) -> void:
	if satisfied == is_satisfied:
		return
	
	is_satisfied = satisfied
	
	if tween_anim:
		tween_anim.kill()
		
	tween_anim = create_tween().set_parallel()
	tween_anim.set_ease(Tween.EASE_OUT)
	
	sprite.self_modulate = Color(2.0 * Color.WHITE)
	sprite.scale = Vector2.ONE * 0.25
	
	tween_anim.tween_property(sprite, "scale", Vector2.ONE / 2.0, 1.25).set_trans(Tween.TRANS_ELASTIC)

	tween_anim.tween_property(sprite, "self_modulate", Color(Color.WHITE), 0.25)
	
	sprite.texture = Util.get_order_block_texture(is_mash_type, is_build_type, satisfied)
		
		
		
		
		
		
		
		
		
		
