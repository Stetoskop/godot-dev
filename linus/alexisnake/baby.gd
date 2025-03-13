extends Node2D

@export var spawn_area: Rect2  # The area in which the fruit will spawn

func _ready():
	randomize()  # Randomize the random number generator

	# Make sure the fruit spawns within the specified bounds
	var x = randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x)
	var y = randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
	position = Vector2(x, y)
