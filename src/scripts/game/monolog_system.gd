## @experimental
@tool
extends Node2D
class_name MonologSystem

signal monolog_line_entered(is_index: int)
signal character_emotion_set(is_em: Variant)

signal letter_showing_started()
signal letter_showing_finished()
signal letter_showed()

@export var auto_start: bool = true
@export var flow: MonologFlow

 # TODO: Make flow in seperate class
# Let monolog_lines, monolog_emotions only in MonologSystem (generalized)

@export_multiline var preview_line: String:
	set(value):
		preview_line = value
		if label:
			label.text = value

@export_group("Parameters")
@export_multiline var BBCODE_DEFAULT: String = "[center][tornado radius=0.5 freq=1.0][wave amp=9.0 freq=-5.0]"
@export var letter_time: float = 0.04
@export var space_time: float = 0.08
@export var punctuation_time: float = 0.32
@export var speed_up_time: float = 0.005

@export_category("Objects to Assign")
#@export var monolog_box: Control
@export var label: RichTextLabel
@export var character: Node2D # TODO: Make unique (seperate class)

## Included in flow
# preview: bool = false
# monolog_auto_adjust_size: bool = true
# monolog_font_size: float = 25.0
# monolog_speed: float = 1.0
# monolog_emotions: Array[MillieEmotion] = [MillieEmotion.NEUTRAL]
# monolog_line: String


var is_monolog_active: bool = false
var can_advance_line: bool = false
var speed_it_up: bool = false

var raw_text: String
var displayed_text: String


var _letter_index: int = 0
var _current_line_index: int
var _monolog_spawn_timer: Timer
var _letter_show_timer: Timer = Timer.new()


func _ready() -> void:
	_letter_show_timer.one_shot = true
	add_child(_letter_show_timer)
	
	preview_line = ""
	
	#boko_pose_set.connect(func(is_pose: BokoPoses):
		#match is_pose:
			## TODO: Add more poses
			#
			#BokoPoses.NEUTRAL:
				## TODO: Play audio
				#top_hat_man.pose_neutral()
			#
			#BokoPoses.DEADPAN:
				#top_hat_man.pose_deadpan()
			#
			#BokoPoses.CONFUSED:
				#top_hat_man.pose_woke()
				#
			#BokoPoses.EXCITED:
				#top_hat_man.pose_happy()
		#)
	
	letter_showing_finished.connect(func() -> void:
		speed_it_up = false
		can_advance_line = true
		
		label.self_modulate = Color(Color.WHITE,1.0)
		)
	
	_letter_show_timer.timeout.connect(func() -> void:
		_show_letter()
		letter_showed.emit()
		)

func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("game_skip_monolog"):
		#pass
	
	if event.is_action_pressed("game_next_monolog"):
		goto_next_monolog()


func _has_dialog_spawned() -> bool:
	return _monolog_spawn_timer.time_left == 0.0


func goto_next_monolog() -> void:
	if !is_monolog_active:
		start()
		return
		
	if can_advance_line:
		#audio_click.play()
		
		_current_line_index += 1
		
		if _current_line_index < flow.monolog_flow.size():
			move_to_next_line()
		else:
			_monolog_spawn_timer.queue_free()
			stop()
			
	elif _has_dialog_spawned():
		speed_it_up = true


func move_to_next_line():
	var line: MillieMonologLine = flow.monolog_flow[_current_line_index]
	## The dialogue line spoken during this monolog entry.
	var monolog_line := line.monolog_line
	## List of emotions expressed while the monolog line is spoken.
## Each entry corresponds to an emotion state used during the line.
	var monolog_emotions := line.monolog_emotions
	## Automatically adjusts the monolog text size to fit its container.
## When enabled, manual font size settings may be ignored.
## Base font size used for the monolog text when auto sizing is disabled.
	if line.monolog_auto_adjust_size:
		pass
	else:
		pass
## Speed at which the monolog text is revealed (characters per second).
	var monolog_speed := line.monolog_speed
	
	show_text(monolog_line)
	
	monolog_line_entered.emit(_current_line_index)
	
	#character_emotion_set.emit(monolog_emotions)


func start() -> void:
	if !is_monolog_active:
		move_to_next_line()


func stop() -> void:
	if !is_monolog_active:
		return
	
	label.text = ""
	_current_line_index = 0
	is_monolog_active = false


func show_text(text_to_show: String) -> void:
	if _monolog_spawn_timer != null:
		_monolog_spawn_timer.queue_free()
	
	_monolog_spawn_timer = Timer.new()
	_monolog_spawn_timer.wait_time = 0.25
	_monolog_spawn_timer.one_shot = true
	add_child(_monolog_spawn_timer)
	
	is_monolog_active = true
	can_advance_line = false
	_letter_index = 0

	raw_text = text_to_show
	label.text = BBCODE_DEFAULT + text_to_show
	displayed_text = label.get_parsed_text()
	
	_show_letter()
	
	_monolog_spawn_timer.start()
	letter_showing_started.emit()


func _show_letter() -> void:
	label.visible_characters = _letter_index + 1
	
	_letter_index += 1
	
	if _letter_index < displayed_text.length():
		var current_letter := displayed_text[_letter_index]
		
		if speed_it_up:
			_letter_show_timer.start(speed_up_time)
			
		else:
			#play_speech(displayed_text[_letter_index])
			
			match current_letter:
				
				"!", ",", "?":
					_letter_show_timer.start(punctuation_time)
 					
				" ":
					_letter_show_timer.start(space_time)
				
				".":
					_letter_show_timer.start(letter_time)
				
				_:
					_letter_show_timer.start(letter_time)
					
	else:
		letter_showing_finished.emit()
