@tool
extends Control
class_name LevelGoal
## Let be Control

@export var level: Level

@onready var level_number_label: Label = %LevelNumber

@onready var star_node_2: Node2D = $Star/Star2
@onready var star_node: Node2D = $Star
@onready var star_no_win: Sprite2D = %NoWin
#@onready var star_win: Sprite2D = $Star/Win
@onready var perc_label: Label = %PercLabel

@onready var percent_gradient: Sprite2D = %PercentGradient

var prec_grad: GradientTexture2D = preload("res://resources/level_goal/order_star_gradient_texture_2d.tres")

var _current_order_precent: float


func _ready() -> void:
	# TODO: Anim function
	
	GameMgr.current_level_goal = self
	percent_gradient.texture = prec_grad
	
	level_number_label.position = Vector2(-level_number_label.size.x / 2, 16.0)
	
	GameLogic.completion_percentage_updated.connect(update_completion_prec)
	
	GameLogic.order_complete.connect(func():
		star_no_win.self_modulate = Color(Color.WHITE * 4.0)
		)
	
	GameMgr.level_entered.connect(func():
		if tween_prec:
			tween_prec.kill()
			
		prec_grad.gradient.set_offset(1, 0.126)
		)
	
	anim_idle(star_node, star_node_2)


var tween_prec: Tween

func anim_idle(node: Node2D, sprite: Node2D) -> void:
	var dur_hover := 1.7
	var dur_rot := 1.0
	var mag_hover := 5.0 # magnitude
	var mag_rot := 10.0
	
	var tween = create_tween().set_loops()
	var tween_b = create_tween().set_loops()
	
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween_b.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
	tween.tween_property(node,"position:y", -mag_hover ,dur_hover).as_relative()
	tween.tween_property(node,"position:y", mag_hover ,dur_hover).as_relative()
	
	tween_b.tween_property(sprite,"rotation", deg_to_rad(-mag_rot / 2.0), dur_rot)
	tween_b.tween_property(sprite,"rotation", deg_to_rad(mag_rot / 2.0), dur_rot)



func update_completion_prec(perc: float) -> void:
	perc_label.text = str(Util.round_to_dec(perc * 100.0, 2)) + "%"
	
	if perc < _current_order_precent:
		star_node_2.scale = Vector2(0.6, 1.8)
	else:
		prec_grad.gradient.set_offset(1, 0.15)
		star_node_2.scale = Vector2(1.8, 0.6)
	
	_current_order_precent = perc
	
	if tween_prec:
		tween_prec.kill()
	
	tween_prec = create_tween().set_parallel(true)
	tween_prec.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	tween_prec.tween_property(prec_grad.gradient,
	"offsets",
	PackedFloat32Array([0.125, lerpf(0.15, 0.9, perc)]),
	0.5)
	
	tween_prec.tween_property(star_node_2, "scale", Vector2.ONE, 0.4)
	
	
	
	
