extends Node2D
class_name Order


var mash_block_checker_ids: Array[MashBlockCheckerID]

var order_checker: PackedScene = preload("res://scenes/game/order_checker.tscn")
var mash_block_checker: PackedScene = preload("res://scenes/game/mash_block_checker.tscn")


func _ready() -> void:
	scale = Vector2.ONE * 0.75
	
	await get_tree().create_timer(0.1).timeout
	
	var oc: OrderChecker = order_checker.instantiate()
	
	for id: MashBlockCheckerID in mash_block_checker_ids:
		var m: MashBlockChecker = mash_block_checker.instantiate()
		
		# TODO: ...change these questionable variable names
		m.position = id.position
		m.is_mash_type = id.is_mash_type
		m.is_build_type = id.is_build_type
		
		oc.add_child(m)
	
	GameMgr.current_level.add_child(oc)
	
