extends TileMapLayer
class_name LevelTileMap

var astargrid = AStarGrid2D.new()
const is_solid = "is_solid"
var dynamic_objects: Array[GridCoordTracker]
var dynamic_blocked_coords: Dictionary[Vector2i, bool]
var constant_blocked_coords: Array[Vector2i]

@export var player: PlayerCharacter


func _ready() -> void:
	TempoGlobal.beat_signal.connect(on_beat_called)
	TempoGlobal.beat_win.connect(on_player_beat_win)
	TempoGlobal.player_skipped_beat.connect(on_player_skipped_beat)
	setup_grid()
	for o in dynamic_objects:
		if o.is_blocking_pathfinding:
			print(o.owner_node.name)
			print(o.grid_coord)
	print(dynamic_blocked_coords)


func on_beat_called() -> void:
	pass

func on_player_beat_win() -> void:
	update_dynamic_coords()
	update_pathfinding()
	#print(dynamic_blocked_coords)

func on_player_skipped_beat() -> void:
	update_dynamic_coords()
	update_pathfinding()
	#print(dynamic_blocked_coords)

func setup_grid():
	astargrid.region = get_used_rect()
	astargrid.cell_size = Vector2i(32, 32)
	astargrid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astargrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astargrid.update()
	
	# Set up constant blocked coords
	for cell in get_used_cells():
		if is_cell_solid(cell):
			constant_blocked_coords.append(cell)
			astargrid.set_point_solid(cell, is_cell_solid(cell))
	
	update_dynamic_coords()
	update_pathfinding()

#func show_path():
	#var path_taken = astargrid.get_id_path(Vector2i(0,0), Vector2i(6,1))
	#for cell in path_taken:
		#set_cell(cell, main_source, path_taken_atlas_coords)

func is_cell_solid(cell_to_check: Vector2i) -> bool:
	return get_cell_tile_data(cell_to_check).get_custom_data(is_solid)

func update_pathfinding() -> void:
	for dynamic_coord in dynamic_blocked_coords:
		if !constant_blocked_coords.has(dynamic_coord):
			astargrid.set_point_solid(dynamic_coord, dynamic_blocked_coords[dynamic_coord])

func update_dynamic_coords() -> void:
	for tracker in dynamic_objects:
		dynamic_blocked_coords[tracker.grid_coord] = tracker.is_blocking_pathfinding
