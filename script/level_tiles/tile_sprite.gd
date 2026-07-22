@tool
extends Sprite2D

func set_tile_sprite(sprite):
	texture = sprite

func set_rotation_from_index(index):
	rotation_degrees = index * 90.0
