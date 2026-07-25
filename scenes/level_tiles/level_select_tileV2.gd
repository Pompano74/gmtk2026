extends InteractionTile

@export var scene_to_go: PackedScene

func _ready() -> void:
	can_enemy_interact_by_landing_on_tile = true

func on_player_enters_tile(player: PlayerCharacter) -> void:
	if scene_to_go != null:
		TempoGlobal.level_select = scene_to_go
		TempoGlobal.ui.global_position = player.global_position
		TempoGlobal.level_win()
		print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
	else:
		print("NO SCENE TO LOAD:", scene_to_go, "MAKE SURE TO MAKE UNIQUE IN INSPECTOR")
	super(player)
