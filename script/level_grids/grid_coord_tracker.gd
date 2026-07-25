class_name GridCoordTracker
extends Node

const grid_cell_size = 32
var tilemap: LevelTileMap
var owner_node: Node2D
var grid_coord: Vector2i
var previous_grid_coord: Vector2i
var is_blocking_pathfinding := false

func _ready() -> void:
	owner_node = owner as Node2D
	tilemap = owner_node.get_parent() as LevelTileMap
	if tilemap == null:
		print (owner_node.name, "'s GridCoordTracker couldn't get a ref to tilemap")
	else:
		tilemap.dynamic_objects.insert(0, self)
	update_grid_coord()

func update_grid_coord() -> void:
	@warning_ignore("integer_division")
	previous_grid_coord = grid_coord
	grid_coord = Vector2i(snappedi(owner_node.position.x - (grid_cell_size / 2), grid_cell_size) / grid_cell_size,
	snappedi(owner_node.position.y - (grid_cell_size / 2), grid_cell_size) / grid_cell_size)
	#tilemap.dynamic_blocked_coords[grid_coord] = is_blocking_pathfinding

func grid_coord_to_local_pos() -> Vector2i:
	@warning_ignore("integer_division")
	return Vector2i(grid_coord.x * grid_cell_size + (grid_cell_size / 2), 
	grid_coord.y * grid_cell_size + (grid_cell_size / 2))

func pop_from_pathfinding_array() -> void:
	is_blocking_pathfinding = false
	if tilemap:
		tilemap.dynamic_blocked_coords[grid_coord] = is_blocking_pathfinding
		var index = tilemap.dynamic_objects.find(self)
		if index != -1:
			tilemap.dynamic_objects.pop_at(index)
