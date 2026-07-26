extends BaseEnemy

var returning_to_spawn := false
var disable_follow_movement := false
var path_increment := 1
var contengency := 0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var sprite_position: Vector2
var previous_position: Vector2
var sprite_up := false
var return_sprite_pos: Vector2 = Vector2(0.0, -8.0)

func _ready() -> void:
	tilemap = get_parent() as LevelTileMap
	animated_sprite_2d.position = return_sprite_pos
	super()

func _on_area_2d_body_entered(body: Node2D) -> void:
	super(body)
	$sound.set_parameter("squid action", "hit")
	$sound.play()
	returning_to_spawn = true
	$Area2D/CollisionShape2D.disabled = true

func perform_action() -> void:
	super()
	$sound.set_parameter("squid action", "move")
	$sound.play()
	#if animated_sprite_2d.position == Vector2(0.0, -8.0):
		#animated_sprite_2d.position = Vector2(0.0, -14.0)
	#else:
		#animated_sprite_2d.position = Vector2(0.0, -8.0)
	
	if !is_on_cooldown and !returning_to_spawn:
		update_current_path(coord_tracker.grid_coord, tilemap.player.coord_tracker.grid_coord)
		if current_path.size() > 1:
			previous_position = position
			position = coord_tracker.grid_coord_to_local_pos(current_path[1])
			print("previous pos: ", previous_position)
			print("pos: ", position)
			print("---------")
			sprite_position = previous_position - position
			animated_sprite_2d.position = sprite_position
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

func _process(delta: float) -> void:
	var return_sprite_pos: Vector2i
	if sprite_up:
		sprite_up = false
		return_sprite_pos = Vector2(0.0, -8.0)
		
	else:
		sprite_up = true
		return_sprite_pos = Vector2(0.0, -14.0)
	sprite_position = sprite_position.move_toward(Vector2.ZERO, delta * 100.0)
	var pos_ease := ease(1.5, 2)
	animated_sprite_2d.position = animated_sprite_2d.position.lerp(sprite_position, pos_ease)

func move_to_spawn(inc: int) -> void:
	if animated_sprite_2d.position == Vector2(0.0, -8.0):
		animated_sprite_2d.position = Vector2(0.0, -14.0)
	else:
		animated_sprite_2d.position = Vector2(0.0, -8.0)
	position = coord_tracker.grid_coord_to_local_pos(current_path[inc])
	coord_tracker.update_grid_coord()

func while_returning_to_spawn() -> void:
	
	move_to_spawn(path_increment)
	if coord_tracker.grid_coord != initial_coord and contengency < 100:
		path_increment = clampi(path_increment + 1, 1, current_path.size() - 1)
		contengency += 1
		await get_tree().create_timer(TempoGlobal.beat_inital_value / 4).timeout
		$sound.set_parameter("squid action", "run away")
		$sound.play()
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
