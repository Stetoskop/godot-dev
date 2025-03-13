extends Node2D

@export var move_speed: float = 16.0  # Grid size (adjust to match tiles)
@export var move_delay: float = 0.2   # Time between moves (adjust for speed)
@onready var fruit_scene = preload("res://Baby.tscn")  # Preload the fruit scene
var current_fruit: Node2D = null  # Reference to the current fruit

var direction := Vector2.RIGHT  # Initial direction
var move_timer := 0.0  # Timer for movement
var body_parts: Array[Node2D] = []  # Array to store body segments
var positions: Array[Vector2] = []  # Stores previous positions

@onready var segment_scene = preload("res://Segment.tscn")  # Load tail segment scene

func _ready():
	# Other initialization code
	spawn_fruit()

func _process(delta: float) -> void:
	move_timer += delta
	if move_timer >= move_delay:
		move_snake()
		move_timer = 0.0

func move_snake():
	positions.insert(0, position)  # Store current position before moving
	if positions.size() > body_parts.size() + 1:
		positions.pop_back()  # Keep only necessary positions
	
	position += direction * move_speed
	update_rotation()
	update_tail()

	# Check for collision with the fruit
	if current_fruit != null and position.distance_to(current_fruit.position) < move_speed:
		eat_fruit()
		spawn_fruit()  # Spawn a new fruit after eating the current one
		
func eat_fruit():
	# Grow the snake by adding a new segment
	grow_snake()

func spawn_fruit():
	# Destroy the old fruit if it exists
	if current_fruit != null:
		current_fruit.queue_free()

	# Create a new fruit at a random location
	current_fruit = fruit_scene.instantiate() as Node2D
	add_child(current_fruit)

	# Get random position inside the spawn area
	var x = randf_range(0, get_viewport().size.x)
	var y = randf_range(0, get_viewport().size.y)

	current_fruit.position = Vector2(x, y)

func update_rotation():
	if direction == Vector2.RIGHT:
		rotation_degrees = 0
	elif direction == Vector2.LEFT:
		rotation_degrees = 180
	elif direction == Vector2.UP:
		rotation_degrees = -90
	elif direction == Vector2.DOWN:
		rotation_degrees = 90

func update_tail():
	for i in range(body_parts.size()):
		body_parts[i].position = positions[i + 1]  # Move tail to follow the head

func grow_snake():
	var new_segment = segment_scene.instantiate() as Node2D  # Create new tail segment
	add_child(new_segment)
	body_parts.append(new_segment)
	if positions.size() > 0:
		new_segment.position = positions[-1]

func _input(event):
	if event.is_action_pressed("ui_up") and direction != Vector2.DOWN:
		direction = Vector2.UP
	elif event.is_action_pressed("ui_down") and direction != Vector2.UP:
		direction = Vector2.DOWN
	elif event.is_action_pressed("ui_left") and direction != Vector2.RIGHT:
		direction = Vector2.LEFT
	elif event.is_action_pressed("ui_right") and direction != Vector2.LEFT:
		direction = Vector2.RIGHT
