extends CharacterBody2D

@export var bullet_scene: PackedScene

signal shoot_dir

const tile_size: Vector2 = Vector2(32, 32)

#sounds
@onready var player_action: FmodEventEmitter2D = $player_action

#beat_system_for_player
var buffer_value: float = 0.18
var buffer_min: float
var buffer_max: float
var beat_inital_value
var timer
var beat_timer
var beat_streak: int = 0
var music

func _ready() -> void:
	TempoGlobal.beat_signal.connect(on_beat_called)
	timer = TempoGlobal.timer
	music = TempoGlobal.music

func on_beat_called() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	beat_timer = timer.get_time_left()
	music.set_parameter("combo chain", beat_streak)
	
	#movement
	if Input.is_action_just_pressed("move_up") and !$up.is_colliding():
		_move(Vector2(0, -1))
	elif Input.is_action_just_pressed("move_down") and !$up.is_colliding():
		_move(Vector2(0, 1))
	elif Input.is_action_just_pressed("move_left") and !$up.is_colliding():
		_move(Vector2(-1, 0))
	elif Input.is_action_just_pressed("move_right") and !$up.is_colliding():
		_move(Vector2(1, 0))
		buffer_min = TempoGlobal.beat_inital_value - buffer_value
		buffer_max = TempoGlobal.beat_inital_value + buffer_value
		if beat_timer > buffer_min and  beat_timer < buffer_max:
			player_action.set_parameter("Parameter 1", "move")
			player_action.play()
			_move(Vector2(0, -1))
			if beat_streak < 7:
				beat_streak += 1
			else:
				pass
		else:
			if beat_streak > 0:
				beat_streak -= 2
	elif Input.is_action_just_pressed("move_down") and !$down.is_colliding():
		buffer_min = TempoGlobal.beat_inital_value - buffer_value
		buffer_max = TempoGlobal.beat_inital_value + buffer_value
		if beat_timer > buffer_min and  beat_timer < buffer_max:
			player_action.set_parameter("Parameter 1", "move")
			player_action.play()
			_move(Vector2(0, 1))
			print(TempoGlobal.beat_timer)
			if beat_streak < 7:
				beat_streak += 1
			else:
				pass
		else:
			print(TempoGlobal.beat_timer)
			if beat_streak > 0:
				beat_streak -= 2
	elif Input.is_action_just_pressed("move_left") and !$left.is_colliding():
		buffer_min = TempoGlobal.beat_inital_value - buffer_value
		buffer_max = TempoGlobal.beat_inital_value + buffer_value
		if beat_timer > buffer_min and  beat_timer < buffer_max:
			player_action.set_parameter("Parameter 1", "move")
			player_action.play()
			_move(Vector2(-1, 0))
			if beat_streak < 7:
				beat_streak += 1
			else:
				pass
		else:
			if beat_streak > 0:
				beat_streak -= 2
	elif Input.is_action_just_pressed("move_right") and !$right.is_colliding():
		buffer_min = TempoGlobal.beat_inital_value - buffer_value
		buffer_max = TempoGlobal.beat_inital_value + buffer_value
		if beat_timer > buffer_min and  beat_timer < buffer_max:
			player_action.set_parameter("Parameter 1", "move")
			player_action.play()
			_move(Vector2(1, 0))
			if beat_streak < 7:
				beat_streak += 1
			else:
				pass
		else:
			if beat_streak > 0:
				beat_streak -= 2
	
	#shooting
	if Input.is_action_just_pressed("shoot_up") and !$up.is_colliding():
		buffer_min = TempoGlobal.beat_inital_value - buffer_value
		buffer_max = TempoGlobal.beat_inital_value + buffer_value
		if beat_timer > buffer_min and  beat_timer < buffer_max:
			player_action.set_parameter("Parameter 1", "shoot")
			player_action.play()
			if beat_streak < 7:
				beat_streak += 1
			else:
				pass
		else:
			if beat_streak > 0:
				beat_streak -= 2
	elif Input.is_action_just_pressed("shoot_down") and !$up.is_colliding():
		buffer_min = TempoGlobal.beat_inital_value - buffer_value
		buffer_max = TempoGlobal.beat_inital_value + buffer_value
		if beat_timer > buffer_min and  beat_timer < buffer_max:
			player_action.set_parameter("Parameter 1", "shoot")
			player_action.play()
			_shoot(Vector2(0, 1))
			if beat_streak < 7:
				beat_streak += 1
			else:
				pass
		else:
			if beat_streak > 0:
				beat_streak -= 2
	elif Input.is_action_just_pressed("shoot_left") and !$up.is_colliding():
		buffer_min = TempoGlobal.beat_inital_value - buffer_value
		buffer_max = TempoGlobal.beat_inital_value + buffer_value
		if beat_timer > buffer_min and  beat_timer < buffer_max:
			player_action.set_parameter("Parameter 1", "shoot")
			player_action.play()
			_shoot(Vector2(-1, 0))
			if beat_streak < 7:
				beat_streak += 1
			else:
				pass
		else:
			if beat_streak > 0:
				beat_streak -= 2
	elif Input.is_action_just_pressed("shoot_right") and !$up.is_colliding():
		buffer_min = TempoGlobal.beat_inital_value - buffer_value
		buffer_max = TempoGlobal.beat_inital_value + buffer_value
		if beat_timer > buffer_min and  beat_timer < buffer_max:
			player_action.set_parameter("Parameter 1", "shoot")
			player_action.play()
			_shoot(Vector2(1, 0))
			if beat_streak < 7:
				beat_streak += 1
			else:
				pass
		else:
			if beat_streak > 0:
				beat_streak -= 2

func _move(dir: Vector2):
	global_position += dir * tile_size

func _shoot(dir:Vector2):
	var bullet = bullet_scene.instantiate()
	add_sibling(bullet)
	bullet.global_position = position + (dir * 32)
	bullet.dir = dir
	bullet.add_to_group("bullets")
