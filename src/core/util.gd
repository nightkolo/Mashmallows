extends Node
class_name Util

enum MashType {
	WHITE = 0,
	STAR = 1,
	CHOCO = 2,
	HEART = 3,
	PLAYER = 99,
	CHERRY_BOMB = 100,
	AIR_CHERRY_BOMB = 101
}
enum BuildType {
	SQUARE = 0,
	RECTANGLE = 1
}

const MASH_WAIT_TIME = 0.5
const ORDER_COMPLETE_WAIT_TIME = 1.0

const LEVEL_FILE_BEGIN = "res://scenes/levels/level_"
const LEVEL_FILE_END = ".tscn"

const CHERRY_BOMB_WAITTIME = 0.125

const BLOCK_SIZE = 64.0
const GRAVITY_MULT = 4.0


static func round_to_dec(num: float, decimals: int) -> float:
	return roundf(num * pow(10.0, decimals)) / pow(10.0, decimals)


static func get_order_block_texture(type: MashType, build: BuildType, satisfied: bool = false) -> Texture2D:
	if type == MashType.PLAYER:
		return preload("res://assets/interface/order/order-player.png")

	var l_name := str(MashType.find_key(type)).to_lower()
	var build_str := "1x2" if build == BuildType.RECTANGLE else "1x1"
	var color_suffix := "" if satisfied else "-grey"

	var path := "res://assets/interface/order/order-%s-%s%s.png" % [
		l_name, build_str, color_suffix
	]

	return load(path)


# TODO Refactor file system and function
static func get_mash_type_texture(type: MashType, build: BuildType) -> Texture2D:
	var text: Texture2D
	
	match type:
		MashType.WHITE:
			if build ==	BuildType.RECTANGLE:
				text = preload("res://assets/objects/block-white-1x2-01.png")
			else:
				text = preload("res://assets/objects/block-white-01.png")
			
		MashType.STAR:
			if build ==	BuildType.RECTANGLE:
				text = preload("res://assets/objects/block-golden-1x2-01.png")
			else:
				text = preload("res://assets/objects/block-golden-01.png")
			
		MashType.CHOCO:
			if build ==	BuildType.RECTANGLE:
				text = preload("res://assets/objects/block-choco-1x2-01.png")
			else:
				text = preload("res://assets/objects/block-choco-01.png")
			
		MashType.HEART:
			if build ==	BuildType.RECTANGLE:
				text = preload("res://assets/objects/block-biscuit-03-1x2.png")
			else:
				text = preload("res://assets/objects/block-biscuit-03-1x1.png")
			
		MashType.PLAYER:
			text = preload("res://assets/objects/block-player-01.png")
			
		MashType.CHERRY_BOMB:
			text = preload("res://assets/objects/block-cherry-bomb-03.png")
			
		MashType.AIR_CHERRY_BOMB:
			text = preload("res://assets/objects/block-cherry-bomb-air-01.png")
			
	return text


## @deprecated
static func get_mash_type_color(type: Util.MashType, build: Util.BuildType) -> Color:
	var col: Color
	
	match type:
		Util.MashType.WHITE:
			col = Color.WHITE * 1.5
			
		Util.MashType.STAR:
			col = Color.YELLOW
			
		Util.MashType.CHOCO:
			col = Color.GRAY
			
		Util.MashType.HEART:
			col = Color.DARK_GREEN
			
		Util.MashType.PLAYER:
			col = Color.WHITE * 3
			
	return col
