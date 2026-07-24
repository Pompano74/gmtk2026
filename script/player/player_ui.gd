extends Control

@export var beat_left: Array[Sprite2D]
@export var beat_right: Array[Sprite2D]
@export var beat_middle: Sprite2D

@onready var coutdown: AnimatedSprite2D = $coutdown
@onready var beats: AnimatedSprite2D = $beats
var beat_int_loop: int = 0
@onready var target_count: Label = $target_count


func _ready() -> void:
	TempoGlobal.beat_signal.connect(on_beat_called)
	target_count.text = str(TempoGlobal.current_target) + "/" + str(TempoGlobal.total_target)
	beats.frame = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	target_count.text = str(TempoGlobal.current_target) + "/" + str(TempoGlobal.total_target)

func on_beat_called():
	coutdown.frame = TempoGlobal.coutdown_value
	
	if beat_int_loop == 0:
		beat_int_loop = 1
	elif beat_int_loop == 4:
		beat_int_loop = 1
	else:
		beat_int_loop += 1
	
	beats.frame = beat_int_loop
