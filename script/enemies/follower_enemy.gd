extends BaseEnemy

func _ready() -> void:
	tilemap = get_parent() as LevelTileMap
	super()

func perform_action() -> void:
	super()
	if !is_on_cooldown:
		update_current_path(coord_tracker.grid_coord, tilemap.player.coord_tracker.grid_coord)
		if current_path.size() > 1:
			position = coord_tracker.grid_coord_to_local_pos(current_path[1])
		coord_tracker.update_grid_coord()

func on_death() -> void:
	super()
	queue_free()
