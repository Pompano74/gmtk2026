extends CharacterBody2D
class_name PlayerCharacter

@export var bullet_scene: PackedScene

const tile_size: Vector2 = Vector2(32, 32)
const MISS_PARTICLE_SCENE = preload("res://scenes/Particles/miss_particle.tscn")
const GOOD_PARTICLE_SCENE = preload("res://scenes/Particles/good_particle.tscn")

@onready var coord_tracker: GridCoordTracker = $GridCoordTracker

#sounds
@export var player_action: FmodEventEmitter2D

#beat_system_for_player
var buffer_value: float = 0.14 #Buffer value used to determine the window in which the player can press a button
var buffer_min: float
var buffer_max: float
var beat_inital_value
var timer
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
	TempoGlobal.ui.global_position = global_position
	#should create a function to retrieve information (for instance current tile type)
	_getSurroundTileInfo()
	if check_next_beat_skipped and !action_check:
		idle_check = true
		idle_check = false
	check_next_beat_skipped = true

func _physics_process(delta: float) -> void:
	beat_timer = timer.get_time_left()
	
	#block spam in the buffer zone
	if action_check == true and beat_timer >= buffer_max and beat_timer <= buffer_min:
		action_check = false
		#print(beat_timer)

func _input(event: InputEvent) -> void:
	if TempoGlobal.level_is_restarting == false and TempoGlobal.level_is_switching == false:
		#MOVEMENT
		if event.is_action_pressed("move_up"):
			player_direction = $up
			_move(Vector2(0, -1))
		elif event.is_action_pressed("move_down"):
			player_direction = $down
			_move(Vector2(0, 1))
		elif event.is_action_pressed("move_left"):
			player_direction = $left
			_move(Vector2(-1, 0))
		elif event.is_action_pressed("move_right"):
			player_direction = $right
			_move(Vector2(1, 0))
		
		#SHOOT
		if Input.is_action_just_pressed("shoot_up"):
			player_direction = $right
			_shoot(Vector2(0, -1))
		if Input.is_action_just_pressed("shoot_down"):
			player_direction = $right
			_shoot(Vector2(0, 1))
		if Input.is_action_just_pressed("shoot_left"):
			player_direction = $right
			_shoot(Vector2(-1, 0))
		if Input.is_action_just_pressed("shoot_right"):
			player_direction = $right
			_shoot(Vector2(1, 0))

func _move(dir: Vector2):
	if !player_direction.is_colliding() and action_check == false:
		action_check = true
		if beat_timer > buffer_min or beat_timer < buffer_max:
			player_action.set_parameter("player action", "move")
			player_action.play()
			global_position += dir * tile_size
			await get_tree().create_timer(0.1).timeout
			TempoGlobal._beat_win()
			#Spawn particle when player good
			var good_particle: = GOOD_PARTICLE_SCENE.instantiate()
			add_child(good_particle)
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
			var miss_particle: = MISS_PARTICLE_SCENE.instantiate()
			add_child(miss_particle)
			var miss_particle_node: CPUParticles2D = miss_particle.get_child(0)
			await get_tree().create_timer(0.95).timeout
			miss_particle.queue_free()
			miss_particle_node.queue_free()
	
func _shoot(dir:Vector2):
	if !player_direction.is_colliding() and action_check == false:
		action_check = true
		if beat_timer > buffer_min or beat_timer < buffer_max:
			player_action.set_parameter("player action", "shoot")
			player_action.play()
			_shoot(dir)
			var bullet = bullet_scene.instantiate()
			bullet.dir = dir
			bullet.ray_dir = player_direction
			add_sibling(bullet)
			bullet.global_position = position + (dir * 32)
			bullet.add_to_group("bullets")
			await get_tree().create_timer(0.1).timeout
			TempoGlobal._beat_win()
			#Spawn particle when player good
			var good_particle: = GOOD_PARTICLE_SCENE.instantiate()
			add_child(good_particle)
			var good_particle_node: CPUParticles2D = good_particle.get_child(0)
			await get_tree().create_timer(0.95).timeout
			good_particle.queue_free()
			good_particle_node.queue_free()
		else:
			player_action.set_parameter("player action", "miss")
			await get_tree().create_timer(0.1).timeout
			TempoGlobal._beat_failed()
			#Spawn particle when player misses 
			var miss_particle: = MISS_PARTICLE_SCENE.instantiate()
			add_child(miss_particle)
			var miss_particle_node: CPUParticles2D = miss_particle.get_child(0)
			await get_tree().create_timer(0.95).timeout
			miss_particle.queue_free()
			miss_particle_node.queue_free()
	

func _getSurroundTileInfo():
	if player_direction.get_collider() !=null:
		print(player_direction.get_collider())
