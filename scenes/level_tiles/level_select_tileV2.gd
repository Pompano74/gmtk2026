extends InteractionTile

@export var scene_to_go: String
var can_switch: bool = false
var player_var

func _ready() -> void:
	TempoGlobal.beat_signal.connect(on_beat_called)
	can_player_interact_by_landing_on_tile = true
	can_player_interact_by_shooting_tile = true

func on_player_enters_tile(player: PlayerCharacter) -> void:
	player_var = player
	if scene_to_go != null:
		player.set_process_input(false)
		can_switch = true
	else:
		print("NO SCENE TO LOAD:", scene_to_go, "MAKE SURE TO MAKE UNIQUE IN INSPECTOR")
	#super(player)

func on_player_bullet_enters_tile(bullet: Node2D) -> void:
	bullet.get_parent().bullet_death()

func on_beat_called():
	if can_switch:
		TempoGlobal.level_select_win = scene_to_go
		TempoGlobal.ui.global_position = player_var.global_position
		TempoGlobal.level_win()
	
