extends CharacterBody2D
class_name PlayerCharacter

@export var bullet_scene: PackedScene

const tile_size: Vector2 = Vector2(32, 32)

@onready var coord_tracker: GridCoordTracker = $GridCoordTracker

#sounds
@export var player_action: FmodEventEmitter2D

#beat_system_for_player
var buffer_value: float = 0.1 #Buffer value used to determine the window in which the player can press a button
var buffer_min: float
var buffer_max: float
var beat_inital_value
var timer
var beat_timer
var beat_streak: int = 0

#player value
var action_check: bool = false:
	set(button_pressed):
		action_check = button_pressed
		if action_check and beat_timer >= buffer_max and beat_timer <= buffer_min:
			action_check = false

func _ready() -> void:
	TempoGlobal.beat_signal.connect(on_beat_called)
	timer = TempoGlobal.timer
	
	buffer_min = TempoGlobal.beat_inital_value - buffer_value
	buffer_max = buffer_value

func on_beat_called() -> void:
	#should create a function to retrieve information (for instance current tile type)
	_getSurroundTileInfo()

func _physics_process(delta: float) -> void:
	
	beat_timer = timer.get_time_left()
	
	#block spam in the buffer zone
	if action_check == true and beat_timer >= buffer_max and beat_timer <= buffer_min:
		action_check = false
		#print(beat_timer)
		
func _unhandled_input(event: InputEvent) -> void:
	
	#MOVEMENT
	if event.is_action_pressed("move_up"):
		_move(Vector2(0, -1))
	elif event.is_action_pressed("move_down"):
		_move(Vector2(0, 1))
	elif event.is_action_pressed("move_left"):
		_move(Vector2(-1, 0))
	elif event.is_action_pressed("move_right"):
		_move(Vector2(1, 0))
	
	#SHOOT
	if Input.is_action_just_pressed("shoot_up"):
		_shoot(Vector2(0, -1))
	if Input.is_action_just_pressed("shoot_down"):
		_shoot(Vector2(0, 1))
	if Input.is_action_just_pressed("shoot_left"):
		_shoot(Vector2(-1, 0))
	if Input.is_action_just_pressed("shoot_right"):
		_shoot(Vector2(1, 0))
	

func _move(dir: Vector2):
	if !$up.is_colliding() and action_check == false:
		action_check = true
		if beat_timer > buffer_min or beat_timer < buffer_max:
			player_action.set_parameter("player action", "move")
			player_action.play()
			global_position += dir * tile_size
			await get_tree().create_timer(0.1).timeout
			TempoGlobal._beat_win()
		else:
			player_action.set_parameter("player action", "miss")
			player_action.play()
			await get_tree().create_timer(0.1).timeout
			TempoGlobal._beat_failed()
	
func _shoot(dir:Vector2):
	if !$up.is_colliding() and action_check == false:
		action_check = true
		if beat_timer > buffer_min or beat_timer < buffer_max:
			player_action.set_parameter("player action", "shoot")
			player_action.play()
			_shoot(Vector2(0, -1))
			var bullet = bullet_scene.instantiate()
			add_sibling(bullet)
			bullet.global_position = position + (dir * 32)
			bullet.dir = dir
			bullet.add_to_group("bullets")
			await get_tree().create_timer(0.1).timeout
			TempoGlobal._beat_win()
		else:
			player_action.set_parameter("player action", "miss")
			await get_tree().create_timer(0.1).timeout
			TempoGlobal._beat_failed()
	

func _getSurroundTileInfo():
	$up.get_collider()
