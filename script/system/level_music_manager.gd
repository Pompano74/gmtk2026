extends Node

var banks := Array()
#@export var music: FmodEventEmitter2D = null
var music
@onready var metronom: FmodEventEmitter2D = $metronom
var music_started: bool = false

func _ready() -> void:
	banks.append(FmodServer.load_bank("res://assets/FMOD/banks/Desktop/Master.strings.bank", FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL))
	banks.append(FmodServer.load_bank("res://assets/FMOD/banks/Desktop/Master.bank", FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL))
	banks.append(FmodServer.load_bank("res://assets/FMOD/banks/Desktop/tracks.bank", FmodServer.FMOD_STUDIO_LOAD_BANK_DECOMPRESS_SAMPLES))
	banks.append(FmodServer.load_bank("res://assets/FMOD/banks/Desktop/metronome.bank", FmodServer.FMOD_STUDIO_LOAD_BANK_DECOMPRESS_SAMPLES))
	#music = FmodServer.create_event_instance("event:/track1")
	print(music)
	
	TempoGlobal.beat_signal.connect(on_beat_called)

func on_beat_called():
	
	metronom.play()
	if music_started == false:
		#music.play()
		music_started = true
