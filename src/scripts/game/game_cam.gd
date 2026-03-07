extends Camera2D
class_name Cam



func _ready():
	GameMgr.current_camera = self
	
	GameLogic.cherry_bomb_exploded.connect(func():
		shake(16.0, 5.0)
		)


var shake_strength := 0.0
var shake_fade := 5.0

func shake(strength: float ,fade: float):
	shake_strength = strength
	shake_fade = fade


func _process(delta: float) -> void:
	if shake_strength > 0:
		offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)

		shake_strength = lerp(shake_strength, 0.0, shake_fade * delta)
	else:
		offset = Vector2.ZERO
