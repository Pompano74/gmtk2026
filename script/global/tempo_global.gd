extends Node


signal beat_signal

@export var bpm: float = 120.0
var beat_timer: float
var beat_inital_value: float
@onready var metronom: FmodEventEmitter2D = $metronom
@onready var timer: Timer = $Timer
var music_as_started: bool = false

#var music: FmodSound = null
@onready var music: FmodEventEmitter2D = $music
var instance: FmodPerformanceData

func _ready() -> void:
	#music.play()
	#metronom.play()
	
	#FmodServer.load_file_as_sound("res://projet_fmod/projet/Assets/track1/#1.wav")
	#music = FmodServer.create_sound_instance("res://projet_fmod/projet/Assets/track1/#1.wav")<
	
	
	beat_inital_value = 1.0 / (bpm / 60.0)
	beat_timer = beat_inital_value
	timer.wait_time = beat_inital_value

func _process(delta: float) -> void:
	pass
	
func _beat():
	beat_signal.emit()
	
	
func _on_timer_timeout() -> void:
	print("BEAT")
	_beat()
