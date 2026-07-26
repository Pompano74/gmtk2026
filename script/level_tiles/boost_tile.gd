extends InteractionTile

@onready var boost_dir: RayCast2D = $up
var ray_dir_vector
var ray_dir
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


var boost_pad_checked : bool = false
var is_wall: bool = false
var is_boost: bool = false
var is_floor: bool = false

var target: Vector2

# Called when the node enters the scene tree for the first time. 
func _ready() -> void:
	animated_sprite_2d.frame = 0
	coord_tracker.is_blocking_pathfinding = true
	TempoGlobal.beat_signal.connect(_on_beat)
	await get_tree().create_timer(0.1).timeout
	if boost_pad_checked == false:
		boost_pad_checked = true 
			#print("collider ", boost_dir.is_colliding())
		if boost_dir.is_colliding() and boost_dir.get_collider().name == "Area2D":
			target = boost_dir.to_global(boost_dir.target_position)
			ray_dir_vector = boost_dir.target_position
			is_boost = true 
		elif boost_dir.is_colliding() and boost_dir.get_collider().name == "TileMapLayer":
			target = boost_dir.to_global(boost_dir.target_position)
			ray_dir_vector = boost_dir.target_position
			is_wall = true
		else:
			target = boost_dir.to_global(boost_dir.target_position)
			ray_dir_vector = boost_dir.target_position
			is_floor = true 
	
	

func on_player_enters_tile(player: PlayerCharacter) -> void:
	$sound.play()
	animated_sprite_2d.frame = 1
	if is_wall:
		player.global_position = target
		TempoGlobal.level_failed()
	elif is_boost:
		player.player_sprite.global_position = player.global_position
		player.global_position = target
		if player.player_sprite_node_pos_tween:
				player.player_sprite_node_pos_tween.kill()
		player.player_sprite_node_pos_tween = create_tween()
		player.player_sprite_node_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		player.player_sprite_node_pos_tween.tween_property(player.player_sprite, "global_position", target + Vector2(0, -8), 0.4).set_trans(Tween.TRANS_SINE)
	elif is_floor:
		player.player_sprite.global_position = player.global_position
		player.global_position = target
		if player.player_sprite_node_pos_tween:
				player.player_sprite_node_pos_tween.kill()
		player.player_sprite_node_pos_tween = create_tween()
		player.player_sprite_node_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		player.player_sprite_node_pos_tween.tween_property(player.player_sprite, "global_position", target + Vector2(0, -8), 0.4).set_trans(Tween.TRANS_SINE)
	else:
		print("ERROR BOOST TILE player")
	super(player)
func on_player_bullet_enters_tile(bullet: Node2D) -> void:
	$sound.play()
	animated_sprite_2d.frame = 1
	print("before_dir:",bullet.get_parent().dir)
	print("tile_rotation:",round(global_rotation_degrees))
	if global_rotation_degrees == 0: #up
		bullet.get_parent().dir = Vector2(0 , -1)
		print("UP")
	
	elif global_rotation_degrees == -90: #left
		bullet.get_parent().dir = Vector2(-1 , 0)
		print("LEFT")
	elif global_rotation_degrees == 90: #right
		bullet.get_parent().dir = Vector2(1 , 0)
		print("RIGHT")
	else: #down
		bullet.get_parent().dir = Vector2(0 , 1)
		print("DOWN")
	print("new_dir:",bullet.get_parent().dir)
	if is_wall:
		bullet.get_parent().global_position = target
	elif is_boost:
		bullet.get_parent().global_position = target
	elif is_floor:
		bullet.get_parent().global_position = target
	else:
		print("ERROR BOOST TILE bullet")
	super(bullet)



func _on_beat():
	if animated_sprite_2d.frame == 1:
		animated_sprite_2d.frame = 0
	pass
	#if !boost_pad_checked :
		
		#print("is boost ", is_boost)
		#print("is wall ", is_wall)
		#print("is_floor ", is_floor)
