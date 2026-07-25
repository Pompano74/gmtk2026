extends InteractionTile

func _ready() -> void:
	coord_tracker.is_blocking_pathfinding = true

func on_player_bullet_enters_tile(bullet: Node2D) -> void:
	bullet.get_parent().bullet_hit()
	super(bullet)
