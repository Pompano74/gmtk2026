@tool
extends Node2D
class_name LevelTile

enum tile_layout_list { STRAIGHT, CORNER, T, CROSS, END }

@export var tile_sprite : Texture2D:
	set(sprite):
		tile_sprite = sprite
		var sprite_ref = $TileSprite
		if sprite_ref:
			$TileSprite.set_tile_sprite(sprite)

@export var rotate_tile : bool = false:
	set(button_pressed):
		rotate_tile = true
		increment_rotation_index()
		rotate_tile = false

@export var tile_layout : tile_layout_list:
	set(new_layout):
		tile_layout = new_layout
		update_available_directions()

@export var draw_direction_indicators := false:
	set(new_draw_indicators):
		draw_direction_indicators = new_draw_indicators
		update_available_direction_indicators()

var rotation_index := 0: # 0 = 0°, 1 = 90° , 2= 180°, 3 = 270°
	set(index):
		rotation_index = index
		var sprite_ref = $TileSprite
		if sprite_ref:
			$TileSprite.set_rotation_from_index(rotation_index)

var available_directions_indicators: Array[Sprite2D] = [
	$MovementArrows/UpIndicator, $MovementArrows/RightIndicator, 
	$MovementArrows/DownIndicator, $MovementArrows/LeftIndicator]

var available_directions: Array[bool]: # [0] = up, [1] = right, [2] = down, [3] = left
	set(directions):
		available_directions = directions
		update_available_direction_indicators()

func increment_rotation_index() -> void:
	rotation_index = (rotation_index + 1) % 4
	update_available_directions()

func decrement_rotation_index() -> void:
	rotation_index = (rotation_index - 1) % 4
	update_available_directions()

func update_available_directions() -> void:
	match tile_layout:
		tile_layout_list.CROSS:
			available_directions.resize(4)
			available_directions.fill(true)

func update_available_direction_indicators() -> void:
	available_directions_indicators = [
	$MovementArrows/UpIndicator, $MovementArrows/RightIndicator, 
	$MovementArrows/DownIndicator, $MovementArrows/LeftIndicator]
	print(available_directions_indicators)
	var index := 0
	for d in available_directions_indicators:
		if draw_direction_indicators:
			d.visible = available_directions[index]
		else:
			d.visible = false
		index += 1
