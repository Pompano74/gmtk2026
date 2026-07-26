extends BaseEnemy

@export var path: Array[Vector2i]
@export var path_increment: int = 0
@export var beats_to_wait_at_end: int = 0
@export var dir := true # true = positive

func _ready() -> void:
	tilemap = get_parent() as LevelTileMap
	current_path = path
	super()

func perform_action() -> void:
	tilemap.update_pathfinding()
	if !is_on_cooldown:
		if current_path.size() > 1:
			if dir:
				path_increment = clampi(path_increment + 1, 0, current_path.size() - 1)
			else:
				path_increment = clampi(path_increment - 1, 0, current_path.size() - 1)
			position = coord_tracker.grid_coord_to_local_pos(current_path[path_increment])
			coord_tracker.update_grid_coord()
			if path_increment <= 0:
				is_on_cooldown = true
				await get_tree().create_timer(TempoGlobal.beat_inital_value * beats_to_wait_at_end).timeout
				dir = true
				is_on_cooldown = false
			elif path_increment >= current_path.size() - 1:
				is_on_cooldown = true
				await get_tree().create_timer(TempoGlobal.beat_inital_value * beats_to_wait_at_end).timeout
				dir = false
				is_on_cooldown = false
		
