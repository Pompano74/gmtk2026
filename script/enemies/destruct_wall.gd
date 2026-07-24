extends Node2D

@export var wall_health = 2
@onready var static_body: StaticBody2D = $StaticBody2D

func _remove_health():
	wall_health -= 1
	print("removing health")
	if wall_health <= 0:
		static_body.disabled = true
		self.hide()
