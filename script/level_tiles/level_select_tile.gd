extends InteractionTile

const OVERLAY_SCENE = preload("res://script/player/StartTransition.tscn")

var start_countdown: bool = false
@export var count_down_max: int = 3
var current_countdown_count: int = 3
var on_twos: bool = true
var player_ref: PlayerCharacter

func _ready() -> void:
	TempoGlobal.beat_signal.connect(_on_beat)

func _process(delta: float) -> void:
	pass

func _on_beat():
	if (start_countdown):
		if on_twos == true:
			if (current_countdown_count == 0):
				var transition_scene = OVERLAY_SCENE.instantiate()
				player_ref.add_child(transition_scene)
				start_countdown = false
			else:
				current_countdown_count -= 1
				print(current_countdown_count)
			on_twos = false
		elif on_twos == false:
			on_twos = true


func on_player_enters_tile(player: PlayerCharacter) -> void:
	start_countdown = true 
	player_ref = player





func _on_area_2d_body_exited(body: Node2D) -> void:
	var player = body as PlayerCharacter
	if is_instance_valid(player):
		print("IsCalled")
		current_countdown_count = count_down_max
		start_countdown = false
