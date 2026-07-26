extends TileMapLayer
class_name LevelTileMap

var astargrid = AStarGrid2D.new()
const is_solid = "is_solid"
var dynamic_objects: Array[GridCoordTracker]
var dynamic_blocked_coords: Dictionary[Vector2i, bool]
var constant_blocked_coords: Array[Vector2i]
var enemy_path_blocked_coords: Dictionary[BaseEnemy, Vector2i]
var enemy_path_weighted_coords: Dictionary[BaseEnemy, Vector3i]

var tracked_objects: Array[Node2D]
var off_screen_indicators: Dictionary[Node2D, Sprite2D]

@export var player: PlayerCharacter


func _ready() -> void:
	TempoGlobal.beat_signal.connect(on_beat_called)
	TempoGlobal.beat_win.connect(on_player_beat_win)
	TempoGlobal.player_skipped_beat.connect(on_player_skipped_beat)
	setup_grid()
	
	for child in get_children():
		if child.is_in_group("track_off_screen"):
			tracked_objects.append(child)
	for o in tracked_objects:
		var arrow_sprite = Sprite2D.new()
		arrow_sprite.texture = load("res://assets/sprites_only_final/Effects/Enemy_Arrow_Up.png")
		arrow_sprite.z_index = 40
		player.camera.add_child(arrow_sprite)
		off_screen_indicators[o] = arrow_sprite
		arrow_sprite.hide()

func _process(delta: float) -> void:
	for o in tracked_objects:
		var screen_rect := player.camera_rect_global_pos
		var o_relative_to_cam := to_local(screen_rect.position)
		var sprite := off_screen_indicators[o]
		if o_relative_to_cam.x > screen_rect.size.x or o_relative_to_cam.y > screen_rect.size.y:
			var padding := 20
			sprite.show()
			#sprite.position = Vector2(
				#clampf(o_relative_to_cam.x, -screen_rect.size.x / 2, screen_rect.size.x / 2) + padding * signf(-o_relative_to_cam.x),
				#clampf(o_relative_to_cam.y, -screen_rect.size.y / 2, screen_rect.size.y / 2) + padding * signf(-o_relative_to_cam.y)
				#)
				
			print(o_relative_to_cam)
		else:
			sprite.hide()

func on_beat_called() -> void:
	pass

func on_player_beat_win() -> void:
	update_dynamic_coords()
	update_pathfinding()
	#print(enemy_path_blocked_coords)
	#print(dynamic_blocked_coords)

func on_player_skipped_beat() -> void:
	update_dynamic_coords()
	update_pathfinding()
	#print(enemy_path_blocked_coords)
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
	for enemy_block_coord in enemy_path_blocked_coords:
		var coord = enemy_path_blocked_coords[enemy_block_coord]
		if !constant_blocked_coords.has(coord):
			astargrid.set_point_solid(coord)
	for enemy_weight_coord in enemy_path_weighted_coords:
		var coord = Vector2i(enemy_path_weighted_coords[enemy_weight_coord].x,
			enemy_path_weighted_coords[enemy_weight_coord].y)
		var weight = enemy_path_weighted_coords[enemy_weight_coord].z
		if !constant_blocked_coords.has(coord):
			astargrid.set_point_weight_scale(coord, weight)

func update_dynamic_coords() -> void:
	for tracker in dynamic_objects:
		dynamic_blocked_coords[tracker.grid_coord] = tracker.is_blocking_pathfinding
