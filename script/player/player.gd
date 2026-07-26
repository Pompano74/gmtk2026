extends CharacterBody2D
class_name PlayerCharacter

@export var bullet_scene: PackedScene

const tile_size: Vector2 = Vector2(32, 32)
const MISS_PARTICLE_SCENE = preload("res://scenes/Particles/miss_particle.tscn")
const GOOD_PARTICLE_SCENE = preload("res://scenes/Particles/good_particle.tscn")
const PERFECT_PARTICLE_SCENE = preload("res://scenes/Particles/perfect_particle.tscn")


@onready var coord_tracker: GridCoordTracker = $GridCoordTracker
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera: Camera2D = $AnimatedSprite2D/Camera2D
@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shadow: Sprite2D = $Sprite2D
@onready var jump_manager: AnimationPlayer = $JumpManager
@onready var player_ui: Control = $AnimatedSprite2D/Camera2D/player_ui
var player_sprite_node_pos_tween: Tween

var camera_rect_global_pos : Rect2

#sounds
@export var player_action: FmodEventEmitter2D

#beat_system_for_player

var beat_1: bool = true
var buffer_value: float = 0.16 #Buffer value used to determine the window in which the player can press a button
var buffer_min: float
var buffer_max: float
var beat_inital_value
var timer
var countdown_value : int 
var beat_timer: float = 0.0
var beat_streak: int = 0
var check_next_beat_skipped: bool = false
var idle_check: bool = false:
	set(new_idle):
		if idle_check != new_idle:
			if new_idle:
				TempoGlobal.player_skipped_beat.emit()
		idle_check = new_idle

#player value
@onready var player_direction = $up


var action_check: bool = false:
	set(button_pressed):
		action_check = button_pressed
		if action_check and beat_timer >= buffer_max and beat_timer <= buffer_min:
			action_check = false
		if action_check:
			check_next_beat_skipped = false

func _ready() -> void:
	set_process_input(true)
	TempoGlobal.ui.global_position = global_position
	
	TempoGlobal.beat_signal.connect(on_beat_called)
	timer = TempoGlobal.timer
	
	buffer_min = TempoGlobal.beat_inital_value - buffer_value
	buffer_max = buffer_value

func on_beat_called() -> void:
	if TempoGlobal.beat_streak == 15:
		Input.start_joy_vibration(0,0,1,buffer_value)
		var perfect_particle: = PERFECT_PARTICLE_SCENE.instantiate()
		add_child(perfect_particle)
		var perfect_particle_node: CPUParticles2D = perfect_particle.get_child(0)
		await get_tree().create_timer(1.95).timeout
		perfect_particle.queue_free()
		perfect_particle_node.queue_free()
	elif TempoGlobal.beat_streak > 15:
		pass
	else:
		Input.start_joy_vibration(0,0.25,0,buffer_value)
	
	TempoGlobal.ui.global_position = global_position
	#should create a function to retrieve information (for instance current tile type)
	_getSurroundTileInfo()
	if check_next_beat_skipped and !action_check:
		idle_check = true
		idle_check = false
	check_next_beat_skipped = true
	
	if beat_1:
		beat_1 = false
	else:
		beat_1 = true
	
	if (countdown_value <= 25 and countdown_value >= 17):
		if beat_1:
			player_sprite.play("(1)Beat20-17")
		else:
			player_sprite.play("(2)Beat20-17")
	elif (countdown_value <= 16 and countdown_value >= 13):
		if beat_1:
			player_sprite.play("(1)Beat16-13")
		else:
			player_sprite.play("(2)Beat16-13")
	elif (countdown_value <= 12 and countdown_value >= 9):
		if beat_1:
			player_sprite.play("(1)Beat12-9")
		else:
			player_sprite.play("(2)Beat12-9")
	elif (countdown_value <= 8 and countdown_value >= 5):
		if beat_1:
			player_sprite.play("(1)Beat8-5")
		else:
			player_sprite.play("(2)Beat8-5")
	elif (countdown_value <= 4 and countdown_value >= 1):
		camera.shake(0.2, 1.5)
		if beat_1:
			player_sprite.play("(1)Beat4-1")
		else:
			player_sprite.play("(2)Beat4-1")
	elif (countdown_value <= 0):
		player_sprite.play("Death")


func _physics_process(delta: float) -> void:
	beat_timer = timer.get_time_left()
	countdown_value = TempoGlobal.coutdown_value
	
	#block spam in the buffer zone
	if action_check == true and beat_timer >= buffer_max and beat_timer <= buffer_min:
		action_check = false
		#print(beat_timer)

func _process(delta: float) -> void:
	camera_rect_global_pos = Rect2(global_position, Vector2(285.0, 167.0))

func _input(event: InputEvent) -> void:
	
	if event.is_action_released("move_up"):
		player_ui.w.play("Up")
	elif event.is_action_released("move_down"):
		player_ui.s.play("Up")
	elif event.is_action_released("move_left"):
		player_ui.a.play("Up")
	elif event.is_action_released("move_right"):
		player_ui.d.play("Up")
	
	if event.is_action_released("shoot_up"):
		player_ui.arrow_up.play("Up")
	elif event.is_action_released("shoot_down"):
		player_ui.arrow_down.play("Up")
	elif event.is_action_released("shoot_left"):
		player_ui.arrow_left.play("Up")
	elif event.is_action_released("shoot_right"):
		player_ui.arrow_right.play("Up")
	
	if  event.is_action_pressed("pause_game"):
		player_ui.ui_pausing.play("Down")
		await get_tree().create_timer(0.1).timeout
		get_tree().change_scene_to_file(TempoGlobal.level_select_win)
	 
	
	if event.is_action_released("pause_game"):
		player_ui.ui_pausing.play("Up")
	
	if TempoGlobal.level_is_restarting == false and TempoGlobal.level_is_switching == false:
		#MOVEMENT
		if event.is_action_pressed("move_up"):
			player_direction = $up
			player_ui.w.play("Down")
			_move(Vector2(0, -1))
		elif event.is_action_pressed("move_down"):
			player_direction = $down
			player_ui.s.play("Down")
			_move(Vector2(0, 1))
		elif event.is_action_pressed("move_left"):
			player_direction = $left
			player_ui.a.play("Down")
			_move(Vector2(-1, 0))
		elif event.is_action_pressed("move_right"):
			player_direction = $right
			player_ui.d.play("Down")
			_move(Vector2(1, 0))
		
		#SHOOT
		if Input.is_action_just_pressed("shoot_up"):
			player_direction = $right
			player_ui.arrow_up.play("Down")
			_shoot(Vector2(0, -1))
		if Input.is_action_just_pressed("shoot_down"):
			player_direction = $right
			player_ui.arrow_down.play("Down")
			_shoot(Vector2(0, 1))
		if Input.is_action_just_pressed("shoot_left"):
			player_direction = $right
			player_ui.arrow_left.play("Down")
			_shoot(Vector2(-1, 0))
		if Input.is_action_just_pressed("shoot_right"):
			player_direction = $right
			player_ui.arrow_right.play("Down")
			_shoot(Vector2(1, 0))

func _move(dir: Vector2):
	if !player_direction.is_colliding() and action_check == false:
		action_check = true
		if beat_timer > buffer_min or beat_timer < buffer_max:
			player_action.set_parameter("player action", "move")
			player_action.play()
			global_position += dir * tile_size
			player_sprite.global_position -= dir * tile_size
			if player_sprite_node_pos_tween:
				player_sprite_node_pos_tween.kill()
			player_sprite_node_pos_tween = create_tween()
			player_sprite_node_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
			player_sprite_node_pos_tween.tween_property(player_sprite, "global_position", global_position + Vector2(0, -8), 0.25).set_trans(Tween.TRANS_SINE)
			coord_tracker.update_grid_coord()
			if (dir == (Vector2(0, -1))):
				jump_manager.play("Jump_Up")
				print("up")
			if (dir == (Vector2(0, 1))):
				jump_manager.play("Jump_Up")
				print("down")
			if (dir == (Vector2(-1, 0))):
				jump_manager.play("Jump_Up")
				print("left")
			if (dir == (Vector2(1, 0))):
				jump_manager.play("Jump_Up")
				print("right")
			await get_tree().create_timer(0.1).timeout
			TempoGlobal._beat_win()
			#Spawn particle when player good
			var good_particle: = GOOD_PARTICLE_SCENE.instantiate()
			player_sprite.add_child(good_particle)
			var good_particle_node: CPUParticles2D = good_particle.get_child(0)
			await get_tree().create_timer(0.95).timeout
			good_particle.queue_free()
			good_particle_node.queue_free()
		else:
			player_action.set_parameter("player action", "miss")
			player_action.play()
			await get_tree().create_timer(0.1).timeout
			TempoGlobal._beat_failed()
			#Spawn particle when player misses 
			#camera.shake(0.2 , 0.5)
			animation_player.play("flash red")
			var miss_particle: = MISS_PARTICLE_SCENE.instantiate()
			player_sprite.add_child(miss_particle)
			var miss_particle_node: CPUParticles2D = miss_particle.get_child(0)
			await get_tree().create_timer(0.95).timeout
			miss_particle.queue_free()
			miss_particle_node.queue_free()
	
func _shoot(dir:Vector2):
	if action_check == false:
		action_check = true
		if beat_timer > buffer_min or beat_timer < buffer_max:
			player_action.set_parameter("player action", "shoot")
			player_action.play()
			_shoot(dir)
			var bullet = bullet_scene.instantiate()
			bullet.dir = dir
			bullet.ray_dir = player_direction
			add_sibling(bullet)
			if player_direction.is_colliding():
				print("COLLIDING")
				bullet.animated_sprite_2d.frame = 2
			#bullet sprite animation direction
			if (dir == (Vector2(0, -1))):
				var bullet_sprite: AnimatedSprite2D = bullet.get_child(2)
				bullet_sprite.play("Up")
				if player_direction.is_colliding():
					bullet.animated_sprite_2d.frame = 2
					bullet.near_wall = true
			if (dir == (Vector2(0, 1))):
				var bullet_sprite: AnimatedSprite2D = bullet.get_child(2)
				bullet_sprite.play("Down")
				if player_direction.is_colliding():
					bullet.animated_sprite_2d.frame = 2
					bullet.near_wall = true
			if (dir == (Vector2(-1, 0))):
				var bullet_sprite: AnimatedSprite2D = bullet.get_child(2)
				bullet_sprite.play("Left")
				if player_direction.is_colliding():
					bullet.animated_sprite_2d.frame = 2
					bullet.near_wall = true
			if (dir == (Vector2(1, 0))):
				var bullet_sprite: AnimatedSprite2D = bullet.get_child(2)
				bullet_sprite.play("Right")
				if player_direction.is_colliding():
					bullet.animated_sprite_2d.frame = 2
					bullet.near_wall = true
			bullet.global_position = position + (dir * 32)
			bullet.add_to_group("bullets")
			await get_tree().create_timer(0.1).timeout
			TempoGlobal._beat_win()
			#Spawn particle when player good
			var good_particle: = GOOD_PARTICLE_SCENE.instantiate()
			player_sprite.add_child(good_particle)
			var good_particle_node: CPUParticles2D = good_particle.get_child(0)
			await get_tree().create_timer(0.95).timeout
			good_particle.queue_free()
			good_particle_node.queue_free()
		else:
			animation_player.play("flash red")
			player_action.set_parameter("player action", "miss")
			await get_tree().create_timer(0.1).timeout
			TempoGlobal._beat_failed()
			#Spawn particle when player misses 
			var miss_particle: = MISS_PARTICLE_SCENE.instantiate()
			player_sprite.add_child(miss_particle)
			var miss_particle_node: CPUParticles2D = miss_particle.get_child(0)
			await get_tree().create_timer(0.95).timeout
			miss_particle.queue_free()
			miss_particle_node.queue_free()
	

func _getSurroundTileInfo():
	if player_direction.get_collider() !=null:
		print(player_direction.get_collider())
