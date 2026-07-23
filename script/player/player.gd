extends CharacterBody2D

@export var bullet_scene: PackedScene

signal shoot_dir

const tile_size: Vector2 = Vector2(32, 32)

func _ready() -> void:
	TempoGlobal.beat_signal.connect(on_beat_called)

func on_beat_called() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	#movement
	if Input.is_action_just_pressed("move_up") and !$up.is_colliding():
		_move(Vector2(0, -1))
	elif Input.is_action_just_pressed("move_down") and !$down.is_colliding():
		_move(Vector2(0, 1))
	elif Input.is_action_just_pressed("move_left") and !$left.is_colliding():
		_move(Vector2(-1, 0))
	elif Input.is_action_just_pressed("move_right") and !$right.is_colliding():
		_move(Vector2(1, 0))
	
	#shooting
	if Input.is_action_just_pressed("shoot_up") and !$up.is_colliding():
		_shoot(Vector2(0, -1))
	elif Input.is_action_just_pressed("shoot_down") and !$up.is_colliding():
		_shoot(Vector2(0, 1))
	elif Input.is_action_just_pressed("shoot_left") and !$up.is_colliding():
		_shoot(Vector2(-1, 0))
	elif Input.is_action_just_pressed("shoot_right") and !$up.is_colliding():
		_shoot(Vector2(1, 0))

func _move(dir: Vector2):
	global_position += dir * tile_size

func _shoot(dir:Vector2):
	var bullet = bullet_scene.instantiate()
	add_sibling(bullet)
	bullet.global_position = position + (dir * 32)
	bullet.dir = dir
	bullet.add_to_group("bullets")
