extends InteractionTile

@export var scene_to_go


func on_player_enters_tile(player: PlayerCharacter) -> void:
	on_tile_interacted()

func on_player_bullet_enters_tile(bullet: Node2D) -> void:
	on_tile_interacted()
