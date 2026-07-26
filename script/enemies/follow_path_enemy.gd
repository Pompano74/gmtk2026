extends BaseEnemy

func _ready() -> void:
	tilemap = get_parent() as LevelTileMap
	super()
