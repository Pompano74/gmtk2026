extends Node2D

@export var layer1: TileMapLayer
@export var layer2: TileMapLayer

var beat_1: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TempoGlobal.beat_signal.connect(_on_beat)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_beat():
	if beat_1:
		beat_1 = false
		layer1.visible = true
		layer2.visible = false
	else:
		beat_1 = true
		layer1.visible = false
		layer2.visible = true
