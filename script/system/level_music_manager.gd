extends Node

var banks:= Array()
@export var music: FmodEventEmitter2D = null
var music_playing: bool = false

func _ready() -> void:
	
	print(FmodServer.get_system_dsp_buffer_length())
	TempoGlobal.beat_signal.connect(on_beat_called)

func on_beat_called():
	music.set_parameter("combo chain", TempoGlobal.beat_streak)
	if music_playing == false:
		music.play()
		music_playing = true
		await get_tree().create_timer(TempoGlobal.beat_inital_value * 5).timeout
		music.set_parameter("bootup", 1)
	else:
		pass
