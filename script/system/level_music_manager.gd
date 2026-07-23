extends Node

var banks:= Array()
@export var music: FmodEventEmitter2D = null
@export var metronome: FmodEventEmitter2D = null

func _ready() -> void:
	
	print(FmodServer.get_system_dsp_buffer_length())
	TempoGlobal.beat_signal.connect(on_beat_called)

func on_beat_called():
	music.play()
	metronome.play()
