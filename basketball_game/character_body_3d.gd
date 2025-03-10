extends CharacterBody3D

# Movement settings
# Speed & Running
var speed := 5.0
const speed_run := 8.0
const speed_default := 5.0
var running := false

# Gravity & Jump
const gravity := 9.8
const jump_force := 7.0

# Stamina
var stamina_val := 100.0
@export var stamina_min := 0.0
@export var stamina_max := 100.0
@export var stamina_drain := 1
@export var stamina_gain := 0.5
@export var stamina_required_jump := 25.0

# Camera settings
@export var mouse_sensitivity := 0.1
@export var camera: Camera3D
var rotation_y := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	velocity.y -= gravity * delta if not is_on_floor() else 0

	if Input.is_action_just_pressed("char_move_jump") and is_on_floor() and stamina_val > 25:
		velocity.y = jump_force
		stamina_val -= 20
	elif Input.is_action_just_pressed("char_move_jump") and is_on_floor():
		velocity.y = jump_force/4

	var input_dir = Vector3(
		Input.get_axis("char_move_left", "char_move_right"),
		0,
		Input.get_axis("char_move_back", "char_move_forw")  # Swapped for correct direction
	).normalized()

	speed = speed_run if Input.is_action_pressed("char_move_run") and is_on_floor() and stamina_val > 0 else 5.0

	var forward = -camera.global_transform.basis.z
	var right = camera.global_transform.basis.x
	velocity.x = (forward * input_dir.z + right * input_dir.x).x * speed
	velocity.z = (forward * input_dir.z + right * input_dir.x).z * speed
	
	move_and_slide()


func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		rotation_y = clamp(rotation_y + deg_to_rad(-event.relative.y * mouse_sensitivity), deg_to_rad(-90), deg_to_rad(90))
		camera.rotation.x = rotation_y

	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED)


@onready var stamina_bar := $"../ProgressBar"

func _process(delta: float) -> void:
	
	if speed > speed_default:
		running = true
	stamina_bar.min_value = stamina_min
	stamina_bar.max_value = stamina_max
	stamina_bar.value = stamina_val
	if Input.is_action_pressed("char_move_run") and is_on_floor():
		stamina_val -= stamina_drain
	if stamina_val < stamina_max and !Input.is_action_pressed("char_move_run") and is_on_floor():
		stamina_val += stamina_gain
	if stamina_val < stamina_min:
		stamina_val = stamina_min
	print("Stamina: " + str(stamina_val) + " Speed: " + str(speed) + " Jump: " + str(!is_on_floor()) + " Running: " + str(running))
