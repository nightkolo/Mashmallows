## Checks a single [MashBlock] in [Mashed] 
extends Area2D
class_name MashBlockChecker

@export var is_mash_type: Util.MashType
@export var is_build_type: Util.BuildType

var corresponding_mash_block_id: MashBlockCheckerID


func _ready() -> void:
	if get_parent() is OrderChecker:
		(get_parent() as OrderChecker).order_blocks.append(self)
	
	collision_layer = 4
	collision_mask = 4
	
	
# Called by parent OrderChecker
func check_satisfaction() -> bool: # Ok -> O(1), worst case -> O(n)
	var value: bool = false
	var areas: Array[Area2D] = get_overlapping_areas()

	#print("")
	#print_debug(self)
	#print_debug(is_mash_type)
	#print_debug(areas)

	if areas.size() == 1 && areas[0] is MashBlock:
		#print_debug((areas[0] as MashBlock).mash_type)
		
		value = (areas[0] as MashBlock).is_match(is_mash_type)
	
	#print_debug(value)
	if corresponding_mash_block_id:
		corresponding_mash_block_id.anim_satisfied(value)
	
	return value
