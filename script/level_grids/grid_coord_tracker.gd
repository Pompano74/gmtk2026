class_name GridCoordTracker
extends Node

const grid_cell_size = 32
var tilemap: LevelTileMap
var owner_node: Node2D
var grid_coord: Vector2i
var is_blocking_pathfinding := false


func _ready() -> void:
	TempoGlobal.beat_signal.connect(on_beat_called)
	
	owner_node = owner as Node2D
	if not owner_node.is_class("CharacterBody2D") or not owner_node.is_class("PlayerCharacter"):
		tilemap = owner_node.get_parent() as LevelTileMap
		update_grid_coord()

func on_beat_called() -> void:
	update_grid_coord()

func update_grid_coord() -> void:
	@warning_ignore("integer_division")
	grid_coord = Vector2i(snappedi(owner_node.position.x - (grid_cell_size / 2), grid_cell_size) / grid_cell_size,
	snappedi(owner_node.position.y - (grid_cell_size / 2), grid_cell_size) / grid_cell_size)
	if tilemap != null:
		tilemap.dynamic_blocked_coords[grid_coord] = is_blocking_pathfinding

func grid_coord_to_local_pos() -> Vector2i:
	@warning_ignore("integer_division")
	return Vector2i(grid_coord.x * grid_cell_size + (grid_cell_size / 2), 
	grid_coord.y * grid_cell_size + (grid_cell_size / 2))
