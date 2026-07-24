extends Node2D
@onready var animation_player: AnimationPlayer = $Node2D/AnimationPlayer


func _unhandled_input(event: InputEvent) -> void:
	print("load level here")
