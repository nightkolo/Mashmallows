@tool
extends Resource
class_name MillieMonologLine

enum MillieEmotion {
	NEUTRAL = 0
}

## Speed at which the monolog text is revealed (characters per second).
@export var monolog_speed: float = 1.0
## List of emotions expressed while the monolog line is spoken.
## Each entry corresponds to an emotion state used during the line.
@export var monolog_emotions: Array[MillieEmotion] = [MillieEmotion.NEUTRAL]
## The dialogue line spoken during this monolog entry.
@export_multiline var monolog_line: String
