extends CharacterBody3D

# Toggle debug to console, true = output, false = no output
@export var print_debug = false

# Movement variables
# Speed & Running
@export_category("Speed & Running")
@export var speed := 5.0 # 5.0
@export var speed_run := 8.0 # 8.0
var speed_default := 5.0 # 5.0
var running := false # false

# Gravity & Jump
@export_category("Jump")
const gravity := 9.8 # 9.8 - Gravity
@export var jump_force := 7.0 # 7 - Upwards force of jumps
@export var jump_force_exhausted :=  3.5 # 3.5 - Upwards force of (exhausted) jumps that don't meet the required amount of stamina
@export var jump_force_double := 4.0 # 4.0 - Upwards force of additional jumps
var jump_count := 0 # 0 - a count of how many jumps have already been done
@export var jump_count_max := 8 # 2 - how many jumps can be done before touching the floor again, starting from floor. -1 is 

# Stamina
@export_category("Stamina Settings")
@export var stamina_val := 100.0 # 100.0 - Current stamina
@export var stamina_min := 0.0 # 0.0 - Minimum stamina
@export var stamina_max := 100.0 # 100.0 - Maximum stamina

# Stamina - Gain & Drain values
@export_category("Stamina Gain & Drain")
@export var stamina_gain := 0.5 # 0.5 - Stamina gain while not running
@export var stamina_drain_run := 1.0 # 1.0 - Stamina drain while running
@export var stamina_drain_jump := 20.0 # 20.0 - Stamina required to jump from floor
@export var stamina_drain_jump_double := 25.0 # 25.0 - Stamina required for additional jumps

# Camera settings
@export var mouse_sensitivity := 0.1 # 0.1
@export var camera: Camera3D # Select Camera3D in inspector
var rotation_y := 0.0 # Used in camera rotation logic

# --------------------------------------------------------------------------------------------------------------------------------------------#
func _ready():
	
	# Capture mouse for input
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# --------------------------------------------------------------------------------------------------------------------------------------------#
func _physics_process(delta):
	
	# Gravity
	velocity.y -= gravity * delta if not is_on_floor() else 0
	
	# Jump
	# If space is pressed, player is on floor and stamina is above required amount
	if Input.is_action_just_pressed("char_move_jump") and is_on_floor() and stamina_val > stamina_drain_jump:
		# Apply force upwards
		velocity.y = jump_force
		# Remove required amount of stamina
		stamina_val -= stamina_drain_jump
		# Add 1 to count of jumps
		jump_count += 1
	
	# Exhausted Jump
	# Else if space is pressed, player is on floor and stamina is below required amount
	elif Input.is_action_just_pressed("char_move_jump") and is_on_floor():
		# Apply exhausted force upwards
		velocity.y = jump_force_exhausted
		jump_count += 1
	
	# Double Jump / Additional jumps
	# If space is pressed, player is not on floor, stamina is above what's required to jump and the jump count isn't larger than the max
	if Input.is_action_just_pressed("char_move_jump") and !is_on_floor() and stamina_val > stamina_drain_jump and jump_count < (jump_count_max): 
		velocity.y = jump_force_double
		# Remove required amount of stamina for additional jumps
		stamina_val -= stamina_drain_jump_double
		jump_count += 1
	
	# See jump count reset at bottom of _physics_process
	
	
	# Movement WASD
	var input_dir = Vector3(
		Input.get_axis("char_move_left", "char_move_right"),
		0,
		Input.get_axis("char_move_back", "char_move_forw")
		).normalized()
	var forward = -camera.global_transform.basis.z
	var right = camera.global_transform.basis.x
	velocity.x = (forward * input_dir.z + right * input_dir.x).x * speed
	velocity.z = (forward * input_dir.z + right * input_dir.x).z * speed
	
	# Run
	speed = speed_run if Input.is_action_pressed("char_move_run") and is_on_floor() and stamina_val > 0 else 5.0
	
	# Move and sliiide
	move_and_slide()
	
	# If player is on floor, reset jump count
	if is_on_floor() and jump_count > 0:
		jump_count = 0

# --------------------------------------------------------------------------------------------------------------------------------------------#
func _input(event):
	
	# Mouse rotation
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		rotation_y = clamp(rotation_y + deg_to_rad(-event.relative.y * mouse_sensitivity), deg_to_rad(-90), deg_to_rad(90))
		camera.rotation.x = rotation_y
		
	# Toggle mouse capture
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED)

# --------------------------------------------------------------------------------------------------------------------------------------------#
# Load stamina bar before using in _process
@onready var stamina_bar := $"../Stamina"

func _process(delta: float) -> void:
	
	print(jump_count)
	# Set stamina bar values from exports (see
	stamina_bar.min_value = stamina_min
	stamina_bar.max_value = stamina_max
	stamina_bar.value = stamina_val
	
	# If shift is held and player is on floor, drain stamina
	if Input.is_action_pressed("char_move_run") and is_on_floor():
		stamina_val -= stamina_drain_run
	
	# Else if stamina is smaller than max stamina, and shift isn't held, and the player is on the floor
	elif stamina_val < stamina_max and !Input.is_action_pressed("char_move_run") and is_on_floor():
		# Regain stamina
		stamina_val += stamina_gain
	
	# If stamina is smaller than minimum stamina (0) then
	if stamina_val < stamina_min:
		# Set stamina to 0 as to not allow values below minimum stamina (0)
		stamina_val = stamina_min
	
	# Debug
	if speed > speed_default:
		running = true
	if print_debug:
		print("Stamina: " + str(stamina_val) + " Speed: " + str(speed) + " Jump Count: " + str(jump_count) + " Jump: " + str(!is_on_floor()) + " J-Force: " + str(jump_force) + " Running: " + str(running))
