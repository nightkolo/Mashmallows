extends Control
class_name LevelGoal
## Let be Control

@export var level: Level

@onready var level_number_label: Label = %LevelNumber

@onready var star_node: Node2D = $Star
@onready var star_no_win: Sprite2D = $Star/NoWin
#@onready var star_win: Sprite2D = $Star/Win
@onready var perc_label: Label = %PercLabel

@onready var percent_gradient: Sprite2D = %PercentGradient

var prec_grad: GradientTexture2D = preload("res://resources/level_goal/order_star_gradient_texture_2d.tres")



func _ready() -> void:
	# TODO: Anim function
	
	GameMgr.current_level_goal = self
	percent_gradient.texture = prec_grad
	
	level_number_label.position = Vector2(-level_number_label.size.x / 2, 16.0)
	
	GameLogic.completion_percentage_updated.connect(update_completion_prec)
	
	GameLogic.order_complete.connect(func():
		star_no_win.visible = false
		#star_win.visible = true
		)
	
	GameMgr.level_entered.connect(func():
		if tween_prec:
			tween_prec.kill()
			
		prec_grad.gradient.set_offset(1, 0.126)
		)

var tween_prec: Tween


func update_completion_prec(perc: float) -> void:
	perc_label.text = str(Util.round_to_dec(perc * 100.0, 2)) + "%"
	
	#await get_tree().create_timer(0.1).timeout
	
	print(lerpf(0.125, 0.9, perc))
	#prec_grad.gradient.set_offset(1, lerpf(0.125, 0.9, perc))
	
	if tween_prec:
		tween_prec.kill()
	
	tween_prec = create_tween()
	tween_prec.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	tween_prec.tween_property(prec_grad.gradient,
	"offsets",
	PackedFloat32Array([0.125, lerpf(0.126, 0.9, perc)]),
	0.5)
	
	
	
	
