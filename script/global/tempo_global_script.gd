extends Node

var tempo_value: int = 1
var tempo
var banks := Array()

func _ready() -> void:
	tempo = tempo_value
	banks.append(FmodServer.load_bank("bank:/Master.strings", FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL))
	banks.append(FmodServer.load_bank("bank:/Master", FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL))
	banks.append(FmodServer.load_bank("bank:/Master.strings", FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL))
	
func _process(delta: float) -> void:
	if tempo <= 0:
		tempo = tempo_value
	else:
		tempo = tempo - delta
