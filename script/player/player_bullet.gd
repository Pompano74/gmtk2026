extends Node2D

const tile_size: Vector2 = Vector2(32, 32)
var move_time: float = TempoGlobal.beat_inital_value
var dir: Vector2
var life_span: int = 4
var on_twos: bool = true


#bullet direction check next tile
@onready var up: RayCast2D = $up
@onready var down: RayCast2D = $down
@onready var left: RayCast2D = $left
@onready var right: RayCast2D = $right
var ray_dir

#sound
@onready var bullet_sound: FmodEventEmitter2D = $bullet_sound


func _ready() -> void:
	#connect behavior to beat
	TempoGlobal.beat_signal.connect(on_beat_called)

func on_beat_called():
	
	#apply bullet direction
	if dir == Vector2(0 , -1):
		ray_dir = up
	if dir == Vector2(0 , 1):
		ray_dir = down
	if dir == Vector2(-1 , 0):
		ray_dir = left
	if dir == Vector2(1 , 0):
		ray_dir = right
	
	#check if bullet it wall
	if dir != null:
		if ray_dir.is_colliding() and ray_dir.get_collider().name == "Area2D":
			#mettre comportement dans la tuile
			#call function of comportement dans la tuile, ICI
			pass
		elif ray_dir.is_colliding() and ray_dir.get_collider().name != "Area2D":
			#hit wall
			bullet_death()
	else:
		pass
	
	#movement on twos
	if on_twos == true:
		_move(dir)
		bullet_sound.play()
		on_twos = false
	elif on_twos == false:
		on_twos = true
		

func _move(bullet_dir: Vector2):
	if life_span == 0:
		bullet_missed()
	else:
		global_position += bullet_dir * tile_size
		life_span = life_span - 1

func bullet_missed():
	print("miss")
	
	#behavior
	$Sprite2D.visible = false
	$Area2D.monitoring = false
	$Area2D.monitorable = false
	
	#destoyed after one beat
	await get_tree().create_timer(TempoGlobal.beat_inital_value).timeout
	queue_free()

func bullet_death():
	print("death")
	
	#behavior
	$Sprite2D.visible = false
	$Area2D.monitoring = false
	$Area2D.monitorable = false
	
	#destoyed after one beat
	await get_tree().create_timer(TempoGlobal.beat_inital_value).timeout
	queue_free()

func bullet_hit():
	print("hit")
	
	#behavior
	$Sprite2D.visible = false
	$Area2D.monitoring = false
	$Area2D.monitorable = false
	
	#destoyed after one beat
	await get_tree().create_timer(TempoGlobal.beat_inital_value).timeout
	queue_free()
