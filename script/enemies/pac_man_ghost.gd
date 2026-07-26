extends BaseEnemy

var returning_to_spawn := false
var disable_follow_movement := false
var path_increment := 1
var contengency := 0

func _ready() -> void:
	tilemap = get_parent() as LevelTileMap
	super()

func _on_area_2d_body_entered(body: Node2D) -> void:
	super(body)
	returning_to_spawn = true
	$Area2D/CollisionShape2D.disabled = true

func perform_action() -> void:
	super()
	if !is_on_cooldown and !returning_to_spawn:
		update_current_path(coord_tracker.grid_coord, tilemap.player.coord_tracker.grid_coord)
		if current_path.size() > 1:
			position = coord_tracker.grid_coord_to_local_pos(current_path[1])
		coord_tracker.update_grid_coord()
	elif returning_to_spawn:
		if !disable_follow_movement:
			disable_follow_movement = true
			update_current_path(coord_tracker.grid_coord, initial_coord)
			
			while_returning_to_spawn()
			#if coord_tracker.grid_coord != initial_coord and contengency < 100:
				#path_increment += 1
				#contengency += 1
				#await get_tree().create_timer(0.1).timeout
				#move_to_spawn(path_increment)
			#elif coord_tracker.grid_coord == initial_coord:
				#disable_follow_movement = false
				#returning_to_spawn = false
				#$Area2D/CollisionShape2D.disabled = false
			#elif contengency > 100:
				#print("Ghost ", name, " failed to return to spawn, help them!!!")

func move_to_spawn(inc: int) -> void:
	position = coord_tracker.grid_coord_to_local_pos(current_path[inc])
	coord_tracker.update_grid_coord()

func while_returning_to_spawn() -> void:
	move_to_spawn(path_increment)
	if coord_tracker.grid_coord != initial_coord and contengency < 100:
		path_increment = clampi(path_increment + 1, 1, current_path.size() - 1)
		contengency += 1
		await get_tree().create_timer(0.1).timeout
		move_to_spawn(path_increment)
		while_returning_to_spawn()
	elif coord_tracker.grid_coord == initial_coord:
		disable_follow_movement = false
		returning_to_spawn = false
		$Area2D/CollisionShape2D.disabled = false
		path_increment = 1
		contengency = 0
		print("yipee")
	elif contengency > 100:
		print("Ghost ", name, " failed to return to spawn, help them!!!")
