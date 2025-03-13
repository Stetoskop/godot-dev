extends Node2D

@export var beach_ball_scene: PackedScene
@export var spawn_count: int = 5  # Number of beach balls to spawn
@export var max_spawn_attempts: int = 10  # Max tries before skipping a ball

func _ready() -> void:
	for i in range(spawn_count):
		spawn_beach_ball()

func spawn_beach_ball():
	if beach_ball_scene:
		var spawn_position = get_valid_spawn_position()
		
		# Avoid spawning at (0, 0) if no valid position was found
		if spawn_position != Vector2.ZERO:
			var ball_instance = beach_ball_scene.instantiate() as RigidBody2D
			add_child(ball_instance)
			ball_instance.global_position = spawn_position

			# Apply a random initial impulse
			ball_instance.apply_impulse(Vector2(randf_range(-200, 200), randf_range(-200, 200)))

func get_valid_spawn_position() -> Vector2:
	var viewport_size = get_viewport_rect().size
	var space_state = get_world_2d().direct_space_state

	for _i in range(max_spawn_attempts):
		var test_position = Vector2(
			randf_range(50, viewport_size.x - 50),
			randf_range(50, viewport_size.y - 150)
		)

		# Set up a physics query to check if there's a StaticBody2D at this position
		var query = PhysicsPointQueryParameters2D.new()
		query.position = test_position
		query.collide_with_bodies = true
		var result = space_state.intersect_point(query)

		# If no StaticBody2D is in the way, return this position
		if result.is_empty():
			return test_position

	return Vector2.ZERO  # No valid spawn point found
