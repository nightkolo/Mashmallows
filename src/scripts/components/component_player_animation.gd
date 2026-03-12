## @experimental: Under construction
extends Node
class_name PlayerAnimationComponent

var player: Player
# TODO Move animation code to here

func _ready() -> void:
	if get_parent() is Player:
		player = get_parent() as Player
	
	else:
		push_error(str(self) + " should be a child of Player.")
		return
	
	player.has_landed.connect(anim_land)
	player.has_jumpped.connect(anim_jump)


### Anim
var _tween_land: Tween

func anim_land(strength: float = 1.0) -> void:
	if !player.animate:
		return
	
	var mag: float = minf(strength / 50.0, 0.3)
	
	if _tween_land:
		_tween_land.kill()
	
	_tween_land = get_tree().create_tween().set_parallel()
	_tween_land.set_ease(Tween.EASE_OUT)
	
	for block: Mashed in player.child_blocks:
		var ori: float = block.sprite_original_pos_y
		
		block.sprite_node.position.y = ori
		
		if block.is_on_ground():
			_tween_land.tween_property(block.sprite_node,"scale",Vector2(1.0 + mag,1.0 - mag),0.07)
			_tween_land.tween_property(block.sprite_node,"scale",Vector2(1.0,1.0),1.0).set_trans(Tween.TRANS_ELASTIC).set_delay(0.07)
		else:
			_tween_land.tween_property(block.sprite_node,"position:y",ori + (mag * 50.0),0.07)
			_tween_land.tween_property(block.sprite_node,"position:y",ori,1.0).set_trans(Tween.TRANS_ELASTIC).set_delay(0.07)



func anim_jump() -> void:
	if !player.animate:
		return
	
	if player.tween_jump:
		player.tween_jump.kill()
		
	player.tween_jump = get_tree().create_tween().set_parallel()
	
	player.tween_jump.set_ease(Tween.EASE_OUT)
	
	for block: Mashed in player.child_blocks:
		if block.is_on_ground():
			player.tween_jump.tween_property(block.sprite, "scale", Vector2(0.875, 1.25) * 0.5, 0.1)
			player.tween_jump.tween_property(block.sprite, "scale", Vector2.ONE * 0.5, 0.6).set_trans(Tween.TRANS_SINE).set_delay(0.1)
		else:
			player.tween_jump.tween_property(block.sprite, "scale", Vector2.ONE*0.5, 1.0)
