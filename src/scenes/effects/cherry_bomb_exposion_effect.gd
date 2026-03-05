extends Node2D
class_name ExplosionFX

@onready var sprite_cloud: Sprite2D = $Cloud

func _ready() -> void:
	sprite_cloud.visible = false
	
	sprite_cloud.texture = sprite_cloud.texture.duplicate(true)
	
	#await get_tree().create_timer(0.5).timeout
	
	anim_explode_then_free()


func anim_explode_then_free() -> void:
	sprite_cloud.visible = true
	
	var dur := 2.0
	
	var tween := create_tween().set_parallel()
	
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(sprite_cloud.texture as GradientTexture2D, "fill_to:x", 1.45, dur)
	tween.tween_property(sprite_cloud, "self_modulate", Color(Color.WHITE, 0.0), dur)
	
	#(sprite_cloud.texture as GradientTexture2D).fill_to.x = 1.4
	
	await tween.finished
	
	queue_free()
	
	
