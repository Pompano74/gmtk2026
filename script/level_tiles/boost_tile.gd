extends InteractionTile
@onready var boost_dir: RayCast2D = $up



var boost_pad_checked : bool = false
var is_wall: bool = false
var is_boost: bool = false
var is_floor: bool = false



# Called when the node enters the scene tree for the first time. 
func _ready() -> void:
	TempoGlobal.beat_signal.connect(_on_beat)
	


func on_player_enters_tile(player: PlayerCharacter) -> void:
	if is_wall:
		TempoGlobal.level_failed()
	elif is_boost:
		pass
	elif is_floor:
		player.global_position = boost_dir.to_global(boost_dir.target_position)
	else:
		print("ERROR BOOST TILE 危険")
	#super(player)

func _on_beat():
	if !boost_pad_checked :
		boost_pad_checked = true 
		#print("collider ", boost_dir.is_colliding())
		if boost_dir.is_colliding() and boost_dir.get_collider().name == "Area2D":
			is_boost = true 
		elif boost_dir.is_colliding() and boost_dir.get_collider().name == "TileMapLayer":
			is_wall = true
		else:
			is_floor = true 
		#print("is boost ", is_boost)
		#print("is wall ", is_wall)
		#print("is_floor ", is_floor)
