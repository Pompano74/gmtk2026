extends Control

@export var beat_left: Array[Sprite2D]
@export var beat_right: Array[Sprite2D]
@export var beat_middle: Sprite2D

@onready var coutdown: AnimatedSprite2D = $coutdown
@onready var beats: AnimatedSprite2D = $beats
var beat_int_loop: int = 0


func _ready() -> void:
	TempoGlobal.beat_signal.connect(on_beat_called)
	beats.frame = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_beat_called():
	coutdown.frame = TempoGlobal.coutdown_value
	
	if beat_int_loop == 0:
		beat_int_loop = 1
	elif beat_int_loop == 4:
		beat_int_loop = 1
	else:
		beat_int_loop += 1
	
	beats.frame = beat_int_loop
