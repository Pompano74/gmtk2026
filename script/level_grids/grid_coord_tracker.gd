extends Node

const grid_cell_size = 32
var owner_node : Node2D
var grid_coord : Vector2i

func _ready() -> void:
	owner_node = owner as Node2D
	update_grid_coord()

func update_grid_coord() -> void:
	grid_coord = Vector2i(snappedi(owner_node.position.x - (grid_cell_size / 2), grid_cell_size) / grid_cell_size,
	snappedi(owner_node.position.y - (grid_cell_size / 2), grid_cell_size) / grid_cell_size)
