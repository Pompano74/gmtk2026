extends Node2D
class_name PlayerBullet

const tile_size: Vector2 = Vector2(32, 32)
var move_time: float = TempoGlobal.beat_inital_value
var dir: Vector2
var life_span: int = 5
var on_twos: bool = true


#bullet direction check next tile
@onready var up: RayCast2D = $up
@onready var down: RayCast2D = $down
@onready var left: RayCast2D = $left
@onready var right: RayCast2D = $right
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

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
	if dir != null and ray_dir != null:
		if ray_dir.is_colliding() and ray_dir.get_collider().name == "Area2D":
			#mettre comportement dans la tuile
			#call function of comportement dans la tuile, ICI
			print("bonjour")
		elif ray_dir.is_colliding() and ray_dir.get_collider().name != "Area2D":
			#hit wall
			bullet_death()
		else:
			pass
	
	_move(dir)
	bullet_sound.play()
		

func _move(bullet_dir: Vector2):
	global_position += bullet_dir * tile_size
	life_span = life_span - 1

func bullet_missed():
	print("miss")
	
	#behavior
	$Sprite2D.visible = false
	$Area2D.set_collision_layer_value(2, false)
	$Area2D.set_collision_mask_value(2, false)
	
	#destoyed after one beat
	await get_tree().create_timer(TempoGlobal.beat_inital_value).timeout
	queue_free()

func bullet_death():
	print("death")
	
	#behavior
	$Sprite2D.visible = false
	$Area2D.set_collision_layer_value(2, false)
	$Area2D.set_collision_mask_value(2, false)
	#destoyed after one beat
	await get_tree().create_timer(TempoGlobal.beat_inital_value).timeout
	queue_free()

func bullet_hit():
	print("hit")
	
	
	$Sprite2D.visible = false
	$Area2D.set_collision_layer_value(2, false)
	$Area2D.set_collision_mask_value(2, false)
	#destoyed after one beat
	await get_tree().create_timer(TempoGlobal.beat_inital_value).timeout
	queue_free()
