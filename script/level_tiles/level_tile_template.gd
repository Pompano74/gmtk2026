@tool
extends Node2D
class_name LevelTile

enum tile_layout_list { STRAIGHT, CORNER, T, CROSS }
@export var tile_sprite : Texture2D:
	set(sprite):
		tile_sprite = sprite
		var sprite_ref = $TileSprite
		if sprite_ref:
			$TileSprite.set_tile_sprite(sprite)
@export var tile_layout : tile_layout_list
