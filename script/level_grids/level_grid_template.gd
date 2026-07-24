extends TileMapLayer
class_name LevelTileMap

var astargrid = AStarGrid2D.new()
const is_solid = "is_solid"
var dynamic_objects: Array[GridCoordTracker]
var dynamic_blocked_coords: Dictionary[Vector2i, bool]

var player: PlayerCharacter


func _ready() -> void:
	TempoGlobal.beat_signal.connect(on_beat_called)
	setup_grid()

func on_beat_called() -> void:
	update_dynamic_coords()
	update_pathfinding()
	#print(dynamic_blocked_coords)

func setup_grid():
	astargrid.region = get_used_rect()
	astargrid.cell_size = Vector2i(32, 32)
	astargrid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astargrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astargrid.update()

#func show_path():
	#var path_taken = astargrid.get_id_path(Vector2i(0,0), Vector2i(6,1))
	#for cell in path_taken:
		#set_cell(cell, main_source, path_taken_atlas_coords)

func is_cell_solid(cell_to_check: Vector2i) -> bool:
	return get_cell_tile_data(cell_to_check).get_custom_data(is_solid)

func update_pathfinding() -> void:
	for cell in get_used_cells():
		if dynamic_blocked_coords.has(cell):
			astargrid.set_point_solid(cell, dynamic_blocked_coords[cell])
		else:
			astargrid.set_point_solid(cell, is_cell_solid(cell))

func update_dynamic_coords() -> void:
	pass
